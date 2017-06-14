//
//  TDFMenuEditViewController.m
//  RestApp
//
//  Created by Octree on 8/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFMenuEditViewController.h"
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
#import "STTweetLabel.h"
#import "TDFOAMenuModel.h"
#import "TDFForm.h"
#import "DicSysItem.h"
#import <TDFAsync/TDFAsync.h>
#import "TDFBaseEditView.h"
#import "TDFEditViewHelper.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+HUD.h"
#import "TDFLimitedShopSelectViewController.h"
#import "BranchShopVo.h"
#import "UIViewController+HUD.h"
#import "UIViewController+Task.h"
#import "NSString+Sino.h"
#import "RestConstants.h"
#import "UIViewController+Task.h"
#import "DicSysItem+Extension.h"
#import "TDFWXOptionModel.h"

@interface TDFMenuEditViewController ()<TDFLimitedShopSelectViewControllerDelegate>

@property (strong, nonatomic) TDFOAMenuModel *model;
@property (nonatomic) BOOL isSubMenu;
@property (nonatomic) TDFMenuEditType editType;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) DHTTableViewManager *manager;

@property (strong, nonatomic) TDFTextfieldItem *nameItem;

@property (strong, nonatomic) TDFShowPickerStrategy *typeStrategy;
@property (strong, nonatomic) TDFPickerItem *typeItem;
@property (copy, nonatomic) NSArray *typeItems;

@property (strong, nonatomic) TDFCustomStrategy *shopStrategy;
@property (strong, nonatomic) TDFPickerItem *shopItem;
@property (copy, nonatomic) NSArray *branchShops;

@property (strong, nonatomic) TDFShowPickerStrategy *urlStrategy;
@property (strong, nonatomic) TDFPickerItem *urlItem;
@property (copy, nonatomic) NSArray *urlItems;

@property (strong, nonatomic) TDFTextfieldItem *customURLItem;

///    选择自动回复的消息
@property (strong, nonatomic) TDFShowPickerStrategy *messageStrategy;
@property (strong, nonatomic) TDFPickerItem *messageItem;
@property (copy, nonatomic) NSArray *messageList;

///    筛选范围
@property (strong, nonatomic) TDFShowPickerStrategy *scopeStrategy;
@property (strong, nonatomic) TDFPickerItem *scopeItem;
@property (copy, nonatomic) NSArray *scopeList;

///    选择品牌
@property (strong, nonatomic) TDFShowPickerStrategy *plateStrategy;
@property (strong, nonatomic) TDFPickerItem *plateItem;
@property (copy, nonatomic) NSArray *plateList;

@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UILabel *promptLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *badgeImageView;
@property (copy, nonatomic) NSArray *urlDetails;

@end

@implementation TDFMenuEditViewController

#pragma mark - Life Cycle

+ (instancetype)menuEditViewControllerWithModel:(TDFOAMenuModel *)model editType:(TDFMenuEditType)editType isSubMenu:(BOOL)isSubMenu {

    TDFMenuEditViewController *vc = [[TDFMenuEditViewController alloc] init];
    vc.model = model;
    vc.isSubMenu = isSubMenu;
    vc.editType = editType;
    return vc;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [self configBackground];
    [self updateNavigationBar];
    [self fetchData];
    self.title = NSLocalizedString(@"店家公众号菜单自定义", nil);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNavigationBar) name:kTDFEditViewIsShowTipNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTDFEditViewIsShowTipNotification object:nil];
}

#pragma mark - Methods


#pragma mark Config Views


- (void)configViews {
    
    [self configContentViews];
    [self configFooterView];
}



- (void)configBackground {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    UIView *view =[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor =  [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [imageView addSubview:view];
    [self.view addSubview:imageView];
}

- (void)configContentViews {
    
    DHTTableViewSection *section = [DHTTableViewSection section];
    [section addItems:@[self.nameItem, self.typeItem, self.urlItem, self.shopItem, self.customURLItem, self.scopeItem, self.plateItem, self.messageItem]];
    [self.manager addSection:section];
    
    [self.view addSubview:self.tableView];
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view);
    }];
    
}


- (void)configFooterView {
    
    @weakify(self);
    MASViewAttribute *attr = self.editType == TDFMenuEditTypeAdd ? self.footerView.mas_top : self.deleteButton.mas_bottom;
    
    if (self.editType == TDFMenuEditTypeEdit) {
        [self.footerView addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.footerView.mas_top).with.offset(20);
            make.left.equalTo(self.footerView).with.offset(10);
            make.right.equalTo(self.footerView).with.offset(-10);
            make.height.mas_equalTo(40);
        }];
    }
    
    [self.footerView addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(attr).with.offset(20);
        make.left.equalTo(self.footerView.mas_left).with.offset(10);
        make.right.equalTo(self.footerView.mas_right).with.offset(-10);
    }];
    
    [self.footerView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.promptLabel.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.footerView);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(352);
    }];
    
    [self.footerView addSubview:self.badgeImageView];
    [self.badgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.imageView.mas_top).with.offset(-18);
        make.right.equalTo(self.imageView.mas_right).with.offset(18);
        make.width.mas_equalTo(76);
        make.height.mas_equalTo(76);
    }];
    self.tableView.tableFooterView = self.footerView;
}

- (void)updateNavigationBar {
    
    if (![self contentChanged]) {
        
        self.navigationItem.rightBarButtonItem = nil;
        UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
        [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        return;
    }
    
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationClose];
    [button addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationSave];
    [button addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (BOOL)contentChanged {

    return [TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections];
}


- (void)setSelectedURLType {
    
    if (!self.urlItem.requestValue) {
        return;
    }

    for (TDFOAMenuURLModel *model in self.urlDetails) {
        
        if (model.urlType == [self.urlItem.requestValue integerValue]) {
            self.urlStrategy.selectedItem = model;
            [self.imageView sd_setImageWithURL:model.demoImageURL placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                self.badgeImageView.hidden = image == nil;
            }];
        }
    }
}


- (void)setSelectedPlate {

    if (!self.plateItem.requestValue) {
        return;
    }
    
    for (TDFWXOptionModel *model in self.plateList) {
        if ([model._id isEqualToString:self.plateItem.requestValue]) {
            self.plateStrategy.selectedItem = model;
            return;
        }
    }
}

- (void)updateItems {
    
    TDFOAMenuType menuType = [self.typeItem.requestValue integerValue];
    BOOL urlSelected = self.urlItem.requestValue != nil;
    TDFOAMenuURLModel *model = [self urlDetailWithURLType:[self.urlItem.requestValue integerValue]];
    TDFOAMenuURLScopeType scopeType = [self.scopeItem.requestValue integerValue];
    BOOL isChain = [self isChain];
    
//    self.shopItem：url 类型 - 需要商店 连锁
    BOOL flag = menuType == TDFOAMenuTypeURL && isChain && urlSelected && model.menuType & TDFOAMenuURLMenuTypeRequiredShop;
    self.shopItem.tdf_isRequired(flag).tdf_shouldShow(flag);
    
//    self.urlItem：url 类型
    flag = menuType == TDFOAMenuTypeURL;
    self.urlItem.tdf_isRequired(flag).tdf_shouldShow(flag);
    
    if (flag && urlSelected) {
        TDFOAMenuURLModel *model = [self urlDetailWithURLType:[self.urlItem.requestValue integerValue]];
        @weakify(self);
        [self.imageView sd_setImageWithURL:model.demoImageURL placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            @strongify(self);
            self.badgeImageView.hidden = image == nil;
        }];
        self.promptLabel.text = model.detail;
    }
    
//    self.scopeItem：url 类型，需要范围 连锁
    flag = menuType == TDFOAMenuTypeURL &&  isChain &&  urlSelected && model.menuType & TDFOAMenuURLMenuTypeRequiredScope;
    self.scopeItem.tdf_isRequired(flag).tdf_shouldShow(flag);
    
//    self.plateItem：url 类型， 需要范围， 范围为品牌 连锁
    flag = flag && scopeType == TDFOAMenuURLScopeTypePlate;
    self.plateItem.tdf_isRequired(flag).tdf_shouldShow(flag);
    
//    self.messageItem：message 类型
    flag = menuType == TDFOAMenuTypeMessage;
    self.messageItem.tdf_isRequired(flag).tdf_shouldShow(flag);
    if (flag) {
    
        TDFOAMenuMessageModel *model = [self messageModelForId:self.messageItem.requestValue];
        @weakify(self);
        [self.imageView sd_setImageWithURL:model.demoImageURL placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            @strongify(self);
            self.badgeImageView.hidden = image == nil;
        }];
        self.promptLabel.text = nil;
    }
    
//    self.customURLItem：url 类型，自定义
    flag = menuType == TDFOAMenuTypeURL && urlSelected && model.urlType == TDFOAMenuURLTypeCustom;
    self.customURLItem.tdf_isRequired(flag).tdf_shouldShow(flag);
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

- (TDFOAMenuMessageModel *)messageModelForId:(NSString *)messageId {

    if (!messageId) {
        return nil;
    }
    
    for (TDFOAMenuMessageModel *model in self.messageList) {
    
        if ([model._id isEqualToString:messageId]) {
            return model;
        }
    }
    return nil;
}

#pragma mark Network

- (void)fetchData {

    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFWechatMarketingService service] fetchMenuOptionsWithOAId:self.officialAccountId callback:^(id responseObj, NSError *error) {
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return ;
        }
        // URL Details
        
        NSArray *details = [[responseObj objectForKey:@"data"] objectForKey:@"urlDetails"];
        self.urlDetails = [NSArray yy_modelArrayWithClass:[TDFOAMenuURLModel class] json:details];
        self.urlStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.urlDetails];
        [self setSelectedURLType];
        
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
        
        NSArray *messages = [[responseObj objectForKey:@"data"] objectForKey:@"messages"];
        self.messageList = [NSArray yy_modelArrayWithClass:[TDFOAMenuMessageModel class] json:messages];
        [self setSelectedPlate];
        
        [self configViews];
        
        [self updateItems];
        [self.manager reloadData];
    }];
}

#pragma mark Action


- (void)deleteButtonTapped {
    
    !self.completionBlock ?: self.completionBlock(self.model, TDFMenuEditActionDelete);
    [self.navigationController popViewControllerAnimated:YES];
}

- (TDFOAMenuURLModel *)urlDetailWithURLType:(NSInteger)type {

    for (TDFOAMenuURLModel *model in self.urlDetails) {
        
        if (model.urlType == type) {
            return model;
        }
    }
    return nil;
}
- (TDFOAMenuModel *)editedModel {

    if (!self.model) {
        self.model = [[TDFOAMenuModel alloc] init];
    }
    
    //
    
    TDFOAMenuType menuType = [self.typeItem.requestValue integerValue];
    BOOL urlSelected = self.urlItem.requestValue != nil;
    TDFOAMenuURLModel *model = [self urlDetailWithURLType:[self.urlItem.requestValue integerValue]];
    TDFOAMenuURLScopeType scopeType = [self.scopeItem.requestValue integerValue];
    BOOL isChain = [self isChain];
    
    //    self.shopItem：url 类型 - 需要商店 连锁
    BOOL flag = menuType == TDFOAMenuTypeURL && isChain && urlSelected && model.menuType & TDFOAMenuURLMenuTypeRequiredShop;
    self.model.shopName = flag ? self.shopItem.textValue : nil;
    self.model.shopId = flag ? self.shopItem.requestValue : nil;
    
    //    self.urlItem：url 类型
    flag = menuType == TDFOAMenuTypeURL;
    self.model.urlDetail = flag ? [self urlDetailWithURLType:[self.urlItem.requestValue integerValue]] : nil;
    
    //    self.scopeItem：url 类型，需要范围 连锁
    flag = menuType == TDFOAMenuTypeURL &&  isChain &&  urlSelected && model.menuType & TDFOAMenuURLMenuTypeRequiredScope;
    self.model.scopeType = flag ? [self.scopeItem.requestValue integerValue] : 0;
    
    //    self.plateItem：url 类型， 需要范围， 范围为品牌 连锁
    flag = flag && scopeType == TDFOAMenuURLScopeTypePlate;
    self.model.plateId = flag ? self.plateItem.requestValue : nil;
    self.model.plateName = flag ? self.plateItem.textValue : nil;
    
    //    self.messageItem：message 类型
    flag = menuType == TDFOAMenuTypeMessage;
    self.model.messageDetail = flag ? [self messageModelForId:self.messageItem.requestValue] : nil;
    
    //    self.customURLItem：url 类型，自定义
    flag = menuType == TDFOAMenuTypeURL && urlSelected && model.urlType == TDFOAMenuURLTypeCustom;
    if (flag) {
        self.model.urlDetail.url = self.customURLItem.textValue;
    }

    self.model.name = self.nameItem.textValue;
    self.model.type = [[self.typeItem requestValue] integerValue];
    
    if (menuType != TDFOAMenuTypeNormal) {
        self.model.subMenus = nil;
    }
    
    return self.model;
}

- (void)saveButtonTapped {
    NSString *msg = [TDFEditViewHelper messageForCheckingItemEmptyInSections:self.manager.sections withIgnoredCharator:@" "];
    if (msg) {
        
        [self showErrorMessage:msg];
        return;
    }
    
    !self.completionBlock ?: self.completionBlock([self editedModel], TDFMenuEditActionEdit);
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeButtonTapped {
    
    UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"内容有变更尚未保存,确定要退出吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    __weak __typeof(self) wself = self;
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [wself.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:avc animated:YES completion:nil];
}

#pragma mark - TDFLimitedShopSelectViewControllerDelegate

- (void)viewController:(TDFLimitedShopSelectViewController *)viewController didSelectedShop:(ShopVO *)selectedShop {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.shopItem.tdf_textValue(selectedShop.name).tdf_requestValue(selectedShop.entityId);
        [self.manager reloadData];
        [self updateNavigationBar];
    });
}


#pragma mark - Accessor

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
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 560)];
        _footerView.backgroundColor = [UIColor clearColor];
    }
    return _footerView;
}


- (UIButton *)deleteButton {
    if (!_deleteButton) {
        
        _deleteButton = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeSave];
        [_deleteButton setTitle:NSLocalizedString(@"删除此菜单", nil) forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        
        _promptLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeContent];
        _promptLabel.text = self.model.urlDetail.detail;
        _promptLabel.numberOfLines = 0;
    }
    return _promptLabel;
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
        [_manager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
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
            vc.title = NSLocalizedString(@"选择对应门店", nil);
            vc.shopList = self.branchShops;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _shopStrategy;
}

- (TDFPickerItem *)shopItem {
    
    if (!_shopItem) {
        
        BOOL shouldShow = [self isChain] && (self.model.type == TDFOAMenuTypeURL || self.isSubMenu)
                        && self.model.urlDetail && self.model.urlDetail.menuType | TDFOAMenuURLMenuTypeRequiredShop;
        _shopItem = [TDFPickerItem item];
        _shopItem.tdf_title(NSLocalizedString(@"选择对应门店", nil))
        .tdf_requestKey(@"officialAccount")
        .tdf_strategy(self.shopStrategy)
        .tdf_isRequired(shouldShow)
        .tdf_shouldShow(shouldShow)
        .tdf_strategy(self.shopStrategy)
        .tdf_requestValue(self.model.shopId)
        .tdf_textValue(self.model.shopName)
        .tdf_preValue(self.model.shopName);
    }
    return _shopItem;
}

- (TDFTextfieldItem *)nameItem {
    
    if (!_nameItem) {
        
        _nameItem = [TDFTextfieldItem item];
        @weakify(self);
        NSInteger limition = self.isSubMenu ? 14 : 8;
        _nameItem.tdf_title(self.isSubMenu ? NSLocalizedString(@"子菜单名称", nil) : NSLocalizedString(@"菜单名称", nil))
        .tdf_isRequired(YES)
        .tdf_requestKey(@"name")
        .tdf_preValue(self.model.name)
        .tdf_requestValue(self.model.name)
        .tdf_textValue(self.model.name)
        .tdf_filterBlock(^BOOL(NSString *text) {
            @strongify(self);
            if (text.tdf_byteLength > limition) {
                
                self.nameItem.textValue = [text tdf_substringWithByteLength:limition];
                return NO;
            }
            
            return text.tdf_byteLength <= limition;
        });
    }
    return _nameItem;
}


- (TDFShowPickerStrategy *)typeStrategy {
    
    if (!_typeStrategy) {
        
        _typeStrategy = [[TDFShowPickerStrategy alloc] init];
        _typeStrategy.pickerName = NSLocalizedString(@"菜单模式", nil);
        _typeStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.typeItems];
        if (self.model) {
            NSInteger index = self.model.type - 1 - self.isSubMenu;
            _typeStrategy.selectedItem = self.typeItems[index];
        }
    }
    
    return _typeStrategy;
}

- (TDFPickerItem *)typeItem {
    
    if (!_typeItem) {
        
        _typeItem = [TDFPickerItem item];
        @weakify(self);
        _typeItem.tdf_title(NSLocalizedString(@"菜单模式", nil))
        .tdf_isRequired(YES)
        .tdf_shouldShow(YES)
        .tdf_strategy(self.typeStrategy)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            @strongify(self);

            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateItems];
                [self.manager reloadData];
            });
            return YES;
        });
        
        if (self.model) {
            NSInteger index = self.model.type - 1 - self.isSubMenu;
            DicSysItem *item = self.typeItems[index];
            _typeItem.tdf_requestValue(item.obtainItemId)
                     .tdf_textValue(item.name)
                     .tdf_preValue(item.name);
        }
        
    }
    return _typeItem;
}

- (NSArray *)typeItems {
    
    if (self.isSubMenu) {
        return @[
              [DicSysItem itemWithId:@"2" name:NSLocalizedString(@"点击跳转链接", nil)],
              [DicSysItem itemWithId:@"3" name:NSLocalizedString(@"自动回复消息", nil)]
              ];
    } else {
    
        return @[
                 [DicSysItem itemWithId:@"1" name:NSLocalizedString(@"有子菜单模式", nil)],
                 [DicSysItem itemWithId:@"2" name:NSLocalizedString(@"无子菜单，链接模式", nil)],
                 [DicSysItem itemWithId:@"3" name:NSLocalizedString(@"无子菜单、自动回复消息", nil)]
                 ];
    }
}

- (TDFShowPickerStrategy *)urlStrategy {
    
    if (!_urlStrategy) {
        
        _urlStrategy = [[TDFShowPickerStrategy alloc] init];
        _urlStrategy.pickerName = NSLocalizedString(@"设置菜单链接", nil);
    }
    return _urlStrategy;
}

- (TDFPickerItem *)urlItem {
    
    if (!_urlItem) {
        
        _urlItem = [TDFPickerItem item];
        @weakify(self);
        _urlItem.tdf_title(NSLocalizedString(@"点击此菜单跳到以下页面", nil))
        .tdf_isRequired(self.model.type == TDFOAMenuTypeURL || self.isSubMenu)
        .tdf_shouldShow(self.model.type == TDFOAMenuTypeURL || self.isSubMenu)
        .tdf_strategy(self.urlStrategy)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            @strongify(self);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateItems];
                [self.manager reloadData];
            });
            return YES;
        });
        
        if (self.model.urlDetail) {
            _urlItem.tdf_requestValue(self.model.urlDetail.obtainItemId)
                    .tdf_textValue(self.model.urlDetail.obtainItemName)
                    .tdf_preValue(self.model.urlDetail.obtainItemName);
        }
    }
    return _urlItem;
}


- (TDFTextfieldItem *)customURLItem {
    
    if (!_customURLItem) {
        
        //   自定义类型
         BOOL isCustom = [self.typeItem.requestValue integerValue] == TDFOAMenuTypeURL && self.model.urlDetail.urlType == TDFOAMenuURLTypeCustom;
        _customURLItem = [TDFTextfieldItem item];
        _customURLItem.tdf_title(NSLocalizedString(@"自定义链接", nil))
        .tdf_isRequired(isCustom)
        .tdf_shouldShow(isCustom)
        .tdf_textValue(isCustom ? self.model.urlDetail.url : nil)
        .tdf_preValue(isCustom ? self.model.urlDetail.url : nil)
        .tdf_requestValue(isCustom ? self.model.urlDetail.url : nil)
        .tdf_keyboardType(UIKeyboardTypeURL);
    }
    return _customURLItem;
}

///    选择自动回复的消息
- (TDFShowPickerStrategy *)messageStrategy {
    
    if (!_messageStrategy) {
        
        _messageStrategy = [[TDFShowPickerStrategy alloc] init];
        _messageStrategy.pickerName = @"选择自动回复的内容";
        _messageStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.messageList];
        _messageStrategy.selectedItem = [self messageModelForId:self.model.messageDetail._id];
    }
    
    return _messageStrategy ;
}

- (TDFPickerItem *)messageItem {
    
    if (!_messageItem) {
        
        _messageItem = [TDFPickerItem item];
        @weakify(self);
        _messageItem.tdf_title(@"选择自动回复的内容")
                    .tdf_isRequired(YES)
                    .tdf_shouldShow(self.model.type == TDFOAMenuTypeMessage)
                    .tdf_strategy(self.messageStrategy)
                    .tdf_textValue(self.model.messageDetail.name)
                    .tdf_requestValue(self.model.messageDetail._id)
                    .tdf_preValue(self.model.messageDetail.name)
                    .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
                        @strongify(self);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self updateItems];
                        });
                        return YES;
                    });
    }
    
    return _messageItem;
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
                  .tdf_strategy(self.scopeStrategy)
                  .tdf_textValue(item.name)
                  .tdf_requestValue(item._id)
                  .tdf_preValue(item.name)
                  .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
                      @strongify(self);
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
        
        _plateItem = [TDFPickerItem item];
        _plateItem.tdf_title(@"请选择对应品牌")
        .tdf_isRequired(YES)
        .tdf_strategy(self.plateStrategy)
        .tdf_textValue(self.model.plateName)
        .tdf_requestValue(self.model.plateId)
        .tdf_preValue(self.model.plateName);
    }
    return _plateItem;
    
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

@end
