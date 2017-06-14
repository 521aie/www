//
//  TDFURLMenuDetailViewController.m
//  RestApp
//
//  Created by Octree on 7/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFURLMenuDetailViewController.h"
#import "TDFOAMenuModel.h"
#import "UIColor+Hex.h"
#import "BackgroundHelper.h"
#import "WXOAConst.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFLabelFactory.h"
#import "TDFButtonFactory.h"
#import "Platform.h"
#import <Masonry/Masonry.h>
#import "TDFWechatMarketingService.h"
#import "TDFOfficialAccountView.h"
#import "TDFForm.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+HUD.h"
#import "BranchShopVo.h"
#import "TDFLimitedShopSelectViewController.h"
#import "TDFWXOptionModel.h"
#import "DicSysItem+Extension.h"
#import "TDFEditViewHelper.h"

@interface TDFURLMenuDetailViewController ()<TDFLimitedShopSelectViewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UILabel *promptLabel;
@property (strong, nonatomic) UIButton *linkButton;
@property (strong, nonatomic) UILabel *commentLabel;
@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) DHTTableViewManager *manager;
@property (strong, nonatomic) TDFPickerItem *shopItem;
@property (strong, nonatomic) TDFCustomStrategy *shopStrategy;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) UIImageView *badgeImageView;

@property (strong, nonatomic) NSArray *branchShops;

///    筛选范围
@property (strong, nonatomic) TDFShowPickerStrategy *scopeStrategy;
@property (strong, nonatomic) TDFPickerItem *scopeItem;
@property (copy, nonatomic) NSArray *scopeList;

///    选择品牌
@property (strong, nonatomic) TDFShowPickerStrategy *plateStrategy;
@property (strong, nonatomic) TDFPickerItem *plateItem;
@property (copy, nonatomic) NSArray *plateList;

@end

@implementation TDFURLMenuDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    
    if ([Platform Instance].isChain) {
        [self fetchData];
    }
    [self.manager reloadData];
}

#pragma mark - Method

#pragma mark Config Views

- (void)configViews {

    [self configBackground];
    [self configNavigation];
    [self configContentViews];
    [self configFooterView];
}

- (void)configBackground {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    UIView *view = [[UIView alloc] initWithFrame:imageView.bounds];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [imageView addSubview:view];
    [self.view addSubview:imageView];
}


- (void)configNavigation {
    
    self.title = self.model.name;
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


- (void)configContentViews {

    [self.view addSubview:self.tableView];
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.edges.equalTo(self.view);
    }];
}


- (void)configFooterView {

    [self.footerView addSubview:self.promptLabel];
    @weakify(self);
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footerView.mas_top).with.offset(15);
        make.left.equalTo(self.footerView.mas_left).with.offset(10);
        make.right.equalTo(self.footerView.mas_right).with.offset(-10);
    }];
    
    [self.footerView addSubview:self.linkButton];
    [self.linkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.footerView).with.offset(10);
        make.right.equalTo(self.footerView).with.offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [self.footerView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.footerView.mas_left).with.offset(10);
        make.right.equalTo(self.footerView.mas_right).with.offset(-10);
        make.top.equalTo(self.linkButton.mas_bottom).with.offset(20);
    }];
    
    [self.footerView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentLabel.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.footerView);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(352);
    }];
    
    [self.footerView addSubview:self.badgeImageView];
    [self.badgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_top).with.offset(-18);
        make.right.equalTo(self.imageView.mas_right).with.offset(18);
        make.width.mas_equalTo(76);
        make.height.mas_equalTo(76);
    }];
    self.tableView.tableFooterView = self.footerView;
    [self.imageView sd_setImageWithURL:self.model.urlDetail.demoImageURL placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self);
        self.badgeImageView.hidden = image == nil;
    }];
}



#pragma mark Network

- (void)fetchData {

    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFWechatMarketingService service] fetchMenuOptionsWithOAId:@"" callback:^(id responseObj, NSError *error) {
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return ;
        }
        
        //  Shops
        NSArray *branchShops = [[responseObj objectForKey:@"data"] objectForKey:@"branchShops"];
        self.branchShops = [NSArray yy_modelArrayWithClass:[BranchShopVo class] json:branchShops];
        if (self.model.shopId.length > 0) {
            
            for (BranchShopVo *brach in self.branchShops) {
                
                for (ShopVO *shop in brach.shopVoList) {
                    
                    shop.isSelected = [shop.entityId isEqualToString:self.model.shopId];
                }
            }
        }
        //  Plates
        NSArray *plates = [[responseObj objectForKey:@"data"] objectForKey:@"plates"];
        self.plateList = [NSArray yy_modelArrayWithClass:[TDFWXOptionModel class] json:plates];
        self.plateStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.plateList];
        [self updateItems];
        [self.manager reloadData];
    }];
}

- (void)fetchURLWithShopEntityId:(NSString *)entityId scopeType:(NSInteger)scopeType plateId:(NSString *)plateId {

    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFWechatMarketingService service] fetchURLDetailWithType:self.model.urlDetail.urlType shopEntityId:entityId scopeType:scopeType plateId:plateId callback:^(id responseObj, NSError *error) {
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return;
        }
        [UIPasteboard generalPasteboard].string = [responseObj objectForKey:@"data"];
        [self showErrorMessage:NSLocalizedString(@"链接复制成功，请前往您的微信公众号后台设置！", nil)];
    }];
}

#pragma mark Action

- (void)backButtonTapped {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)linkButtonTapped {

    if (![self isChain]) {
        [UIPasteboard generalPasteboard].string = self.url;
        [self showErrorMessage:NSLocalizedString(@"链接复制成功，请前往您的微信公众号后台设置！", nil)];
        return;
    }
    
    NSString *msg = [TDFEditViewHelper messageForCheckingItemEmptyInSections:self.manager.sections withIgnoredCharator:@" "];
    if (msg) {
        
        [self showErrorMessage:msg];
        return;
    }
    
    NSString *entityId = self.shopItem.shouldShow ? self.shopItem.requestValue : @"";
    NSInteger scopeType = [self.scopeItem.requestValue integerValue];
    NSString *plateId = [self.plateItem requestValue];
    
    [self fetchURLWithShopEntityId:entityId scopeType:scopeType plateId:plateId];
}

#pragma mark - TDFLimitedShopSelectViewControllerDelegate

- (void)viewController:(TDFLimitedShopSelectViewController *)viewController didSelectedShop:(ShopVO *)selectedShop {

    if (!selectedShop) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.shopItem.tdf_textValue(selectedShop.name).tdf_requestValue(selectedShop.entityId).tdf_preValue(selectedShop.name);
        [self.manager reloadData];
    });
}


#pragma mark - Accessor

- (void)updateItems {
    
    TDFOAMenuType menuType = self.model.type;
    TDFOAMenuURLModel *model = self.model.urlDetail;
    TDFOAMenuURLScopeType scopeType = [self.scopeItem.requestValue integerValue];
    BOOL isChain = [self isChain];
    
    //    self.shopItem：url 类型 - 需要商店 连锁
    BOOL flag = menuType == TDFOAMenuTypeURL && isChain && model.menuType & TDFOAMenuURLMenuTypeRequiredShop;
    self.shopItem.tdf_isRequired(flag).tdf_shouldShow(flag);
    //    self.scopeItem：url 类型，需要范围 连锁
    flag = menuType == TDFOAMenuTypeURL &&  isChain && model.menuType & TDFOAMenuURLMenuTypeRequiredScope;
    self.scopeItem.tdf_isRequired(flag).tdf_shouldShow(flag);
    
    //    self.plateItem：url 类型， 需要范围， 范围为品牌 连锁
    flag = flag && scopeType == TDFOAMenuURLScopeTypePlate;
    self.plateItem.tdf_isRequired(flag).tdf_shouldShow(flag);
}

- (TDFWXOptionModel *)plateForId:(NSString *)plateId {
    
    if (!plateId) {
        return nil;
    }
    for (TDFWXOptionModel *plate in self.plateList) {
        if ([plate._id isEqualToString:plateId]) {
            return plate;
        }
    }
    return nil;
}


- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 640)];
        _footerView.backgroundColor = [UIColor clearColor];
    }
    return _footerView;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        
        _promptLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeContent];
        _promptLabel.text = self.model.urlDetail.detail;
        _promptLabel.numberOfLines = 0;
    }
    return _promptLabel;
}

- (UIButton *)linkButton {
    if (!_linkButton) {
        
        _linkButton = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeSave];
        [_linkButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"复制链接（%@）", nil), self.model.name] forState:UIControlStateNormal];
        [_linkButton addTarget:self action:@selector(linkButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _linkButton;
}

- (UILabel *)commentLabel {
    if (!_commentLabel) {
        
        _commentLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeSubTitle];
        _commentLabel.textColor = [UIColor colorWithHeX:0xCC0000];
        _commentLabel.numberOfLines = 0;
        _commentLabel.font = [UIFont systemFontOfSize:13];
        _commentLabel.text = NSLocalizedString(@"复制链接后请在您的微信公众号后台对菜单进行设置", nil);
    }
    return _commentLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}


- (DHTTableViewManager *)manager {
    if (!_manager) {
        
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
        [_manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
        DHTTableViewSection *section = [DHTTableViewSection section];
        [section addItem:self.shopItem];
        [section addItem:self.scopeItem];
        [section addItem:self.plateItem];
        [_manager addSection:section];
    }
    return _manager;
}

- (TDFCustomStrategy *)shopStrategy {
    
    if (!_shopStrategy) {
        
        _shopStrategy = [[TDFCustomStrategy alloc] init];
        @weakify(self);
        _shopStrategy.btnClickedBlock = ^ {
            @strongify(self);
            TDFLimitedShopSelectViewController *vc = [[TDFLimitedShopSelectViewController alloc] init];
            vc.shopList = self.branchShops;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
    }
    return _shopStrategy;
}

- (TDFPickerItem *)shopItem {
    
    if (!_shopItem) {
        
        BOOL flag = [self isChain]
                && self.model.urlDetail.menuType | TDFOAMenuURLMenuTypeRequiredShop;
        _shopItem = [TDFPickerItem item];
        _shopItem.tdf_title(NSLocalizedString(@"选择对应门店", nil))
        .tdf_requestKey(@"officialAccount")
        .tdf_requestValue(self.model.shopId)
        .tdf_strategy(self.shopStrategy)
        .tdf_preValue(self.model.shopName)
        .tdf_textValue(self.model.shopName)
        .tdf_isRequired(flag)
        .tdf_shouldShow(flag);
    }
    return _shopItem;
}

- (UIImageView *)badgeImageView {

    if (!_badgeImageView) {
        
        _badgeImageView = [[UIImageView alloc] init];
        _badgeImageView.image = [UIImage imageNamed:@"wxoa_sample_badge"];
        _badgeImageView.hidden = YES;
    }
    
    return _badgeImageView;
}

- (BOOL)isChain {
    
    return [Platform Instance].isChain;
}


- (NSString *)url {

    if (!_url) {
        return self.model.urlDetail.url;
    }
    return _url;
}

///    筛选范围
- (TDFShowPickerStrategy *)scopeStrategy {
    if (!_scopeStrategy) {
        
        _scopeStrategy = [[TDFShowPickerStrategy alloc] init];
        _scopeStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.scopeList];
        _scopeStrategy.pickerName = @"选择此链接的适用范围";
        _scopeStrategy.selectedItem = _scopeStrategy.pickerItemList[self.model.scopeType];
    }
    return _scopeStrategy ;
}


- (TDFPickerItem *)scopeItem {
    if (!_scopeItem) {
        
        DicSysItem *item = (DicSysItem *)self.scopeStrategy.pickerItemList[self.model.scopeType];
        @weakify(self);
        _scopeItem = [TDFPickerItem item];
        _scopeItem.tdf_title(@"选择此链接的适用范围")
        .tdf_isRequired(YES)
        //                  .tdf_shouldShow([self urlDetailWithURLType:[self.urlItem.requestValue integerValue]].menuType & TDFOAMenuURLMenuTypeRequiredScope)
        .tdf_shouldShow(NO)
        .tdf_strategy(self.scopeStrategy)
        .tdf_textValue(item.name)
        .tdf_requestValue(item._id)
        .tdf_preValue(item.name)
        .tdf_isShowTip(NO)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            @strongify(self);
            self.scopeItem.tdf_preValue(textValue);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateItems];
                [self.manager reloadData];
            });
            return YES;
        });
    }
    return _scopeItem;
    
}

- (NSArray *)scopeList {
    if (!_scopeList) {
        
        _scopeList = @[
                       [DicSysItem itemWithId:@"0" name:@"按品牌筛选"],
                       [DicSysItem itemWithId:@"1" name:@"按连锁筛选"]
                       ];
    }
    
    return _scopeList;
}


///    选择品牌
- (TDFShowPickerStrategy *)plateStrategy {
    if (!_plateStrategy) {
        
        _plateStrategy = [[TDFShowPickerStrategy alloc] init];
        _plateStrategy.pickerName = @"请选择对应品牌";
        _plateStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.plateList];
        _plateStrategy.selectedItem = [self plateForId:self.model.plateId];
    }
    return _plateStrategy ;
}

- (TDFPickerItem *)plateItem {
    if (!_plateItem) {
        @weakify(self);
        _plateItem = [TDFPickerItem item];
        _plateItem.tdf_title(@"请选择对应品牌")
        .tdf_isRequired(YES)
        .tdf_shouldShow(NO)
        .tdf_strategy(self.plateStrategy)
        .tdf_textValue(self.model.plateName)
        .tdf_requestValue(self.model.plateId)
        .tdf_preValue(self.model.plateName)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            @strongify(self);
            self.plateItem.tdf_preValue(textValue);
            return YES;
        });
    }
    return _plateItem;
    
}
@end
