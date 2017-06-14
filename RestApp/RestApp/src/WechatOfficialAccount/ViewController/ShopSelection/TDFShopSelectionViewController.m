//
//  TDFShopSelectionViewController.m
//  RestApp
//
//  Created by Octree on 13/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopSelectionViewController.h"
#import "BranchShopVo.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "TDFShopSelectionSectionView.h"
#import "TDFShopSelectionTableViewCell.h"
#import "ShopVO.h"
#import "TDFButtonFactory.h"
#import "BackgroundHelper.h"
#import "TDFForm.h"
#import "MemberSearchBar.h"
#import "UIViewController+HUD.h"
#import "YYModel.h"
#import "TDFShopSelectionSectionView.h"
#import "Platform.h"
#import "TDFFunctionVo.h"
#import "TDFIsOpen.h"
#import "TDFMarketingStore.h"
#import "HelpDialog.h"
#import "TDFFunctionKindVo.h"
#import "TDFMediator.h"
#import "TDFMediator+AccountRechargeModule.h"

@interface TDFShopSelectionViewController ()<MemberSearchBarEvent>

@property (strong, nonatomic) NSArray *shopBranches;
@property (strong, nonatomic) UIButton *selectButton;
@property (strong, nonatomic) UIButton *deselectButton;
@property (strong, nonatomic) MemberSearchBar *searchBar;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DHTTableViewManager *manager;
@property (strong, nonatomic) NSArray *sections;

@property (strong, nonatomic) UIButton *helpButton;

@end

@implementation TDFShopSelectionViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    
    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    self.loadAsync.execute(^void(NSArray *branches, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return;
        }
        self.shopBranches = branches;
        [self configSections];
    });
}

#pragma mark - Method

- (void)configViews {
    
    [self configBackground];
    [self updateNavigationBar];
    [self configContentViews];
}

- (void)configBackground {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    [self.view addSubview:imageView];
}

- (void)configContentViews {
    
    @weakify(self);
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.height.mas_equalTo(48);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.searchBar.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:self.deselectButton];
    [self.deselectButton mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.right.equalTo(self.view).with.offset(-10);
        make.bottom.equalTo(self.view).with.offset(-10);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    
    [self.view addSubview:self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.right.equalTo(self.deselectButton.mas_left).with.offset(-10);
        make.bottom.equalTo(self.view).with.offset(-10);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    
    [self.view addSubview:self.helpButton];
    [self.helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.bottom.equalTo(self.view).with.offset(-20);
        make.width.mas_equalTo(34);
        make.height.mas_equalTo(34);
    }];
}

- (void)configSections {

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.shopBranches.count];
    for (BranchShopVo *branch in self.shopBranches) {
        DHTTableViewSection *section = [DHTTableViewSection section];
        BOOL isAllSelected = YES;
        NSInteger selectedCount = 0;
        for (ShopVO *shop in branch.shopVoList) {
            
            if (!shop.isSelected && shop.status == TDFShopStatusPurchased) {
                isAllSelected = NO;
            } else if(shop.isSelected && shop.status == TDFShopStatusPurchased) {
                selectedCount++;
            }
            [section addItem:[self itemForShop:shop withSection:section]];
        }
        
        isAllSelected = isAllSelected && selectedCount > 0;
        [self.manager addSection:section];
        [self generateSectionViewForSection:section withBranch:branch isAllSelected:isAllSelected];
        [array addObject:section];
    }
    self.sections = array;
    [self.manager reloadData];
}

- (void)generateSectionViewForSection:(DHTTableViewSection *)section withBranch:(BranchShopVo *)branch isAllSelected:(BOOL)isAllSelected {

    TDFShopSelectionSectionView *sectionView = [[TDFShopSelectionSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    sectionView.titleLabel.text = branch.branchName;
    sectionView.selectionButton.selected = isAllSelected;
    __weak __typeof(sectionView) wsectionView = sectionView;
    @weakify(self);
    sectionView.selectionBlock = ^void() {
        @strongify(self);
        
        BOOL flag = !wsectionView.selectionButton.isSelected;
        wsectionView.selectionButton.selected = flag;
        for (ShopVO *shop in branch.shopVoList) {
            
            if (shop.status == TDFShopStatusPurchased) {
                shop.isSelected = flag;
            }
        }
        
        for (TDFShopSelectionItem *item in section.items) {
            
            if (item.canSelected) {
                item.requestValue = @(flag);
                item.state = flag ? TDFShopSelectionStateSelected : TDFShopSelectionStateNormal;
            }
        }
        
        [self.manager reloadData];
        [self updateNavigationBar];
    };
    section.headerView = sectionView;
    section.headerHeight = 40;
}

- (void)updateSection:(DHTTableViewSection *)section {

    BOOL isAllSelected = YES;
    NSInteger count = 0;
    for (TDFShopSelectionItem *item in section.items) {
        
        if (item.canSelected && [item.requestValue boolValue] == NO) {
            
            isAllSelected = NO;
        } else if (item.canSelected && [item.requestValue boolValue] == YES) {
        
            count++;
        }
    }
    isAllSelected = isAllSelected && count > 0;
    ((TDFShopSelectionSectionView *)section.headerView).selectionButton.selected = isAllSelected;
    [self.manager reloadData];
}

- (TDFShopSelectionItem *)itemForShop:(ShopVO *)shop withSection:(DHTTableViewSection *)section {
    
    TDFShopSelectionItem *item = [[TDFShopSelectionItem alloc] init];
    item.title = shop.name;
    item.subTitle = shop.plateName ? [NSString stringWithFormat:NSLocalizedString(@"品牌：%@", nil), shop.plateName] : NSLocalizedString(@"无品牌", nil);
    
    switch (shop.status) {
        case TDFShopStatusSelected:
            
            item.state = TDFShopSelectionStateNormal;
            item.prompt = NSLocalizedString(@"已被绑定", nil);
            item.canSelected = NO;
            item.style = TDFShopSelectionStyleDisable;
            break;
        case TDFShopStatusPurchased: {
            
            item.canSelected = YES;
            if (shop.isSelected) {
                item.state = TDFShopSelectionStateSelected;
            } else {
                item.state = TDFShopSelectionStateNormal;
            }
            item.style = TDFShopSelectionStyleNormal;
            item.tdf_preValue(@(shop.isSelected)).tdf_requestValue(@(shop.isSelected));
            
            @weakify(self);
            item.selectionChangedBlock = ^void(BOOL selected) {
                @strongify(self);
                shop.isSelected = selected;
                [self updateSection:section];
                [self updateNavigationBar];
            };
        }
            break;
        case TDFShopStatusNotPurchase:
            
            {
                item.state = TDFShopSelectionStateNormal;
                item.style = TDFShopSelectionStyleNormal;
                item.canSelected = NO;
                item.prompt = NSLocalizedString(@"未购买", nil);
                item.promptBlock = ^ {
                    
                    [self showChargeViewController];
                };
            }
            break;
            
        case TDFShopStatusPermissionDeny:
            item.canSelected = NO;
            if (shop.isSelected) {
                item.state = TDFShopSelectionStateSelected;
            } else {
                item.state = TDFShopSelectionStateNormal;
            }
            item.prompt = NSLocalizedString(@"没有权限", nil);
            item.style = TDFShopSelectionStyleDisable;
        default:
            break;
    }
    
    return item;
}

- (void)updateNavigationBar {
    
    if (![self contentChanged]) {
        
        self.navigationItem.rightBarButtonItem = nil;
        UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
        [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    } else {
    
        UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationClose];
        [button addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationSave];
    [button setTitle:self.commitTitle ?: NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (BOOL)contentChanged {
    
    for (DHTTableViewSection *section in self.manager.sections) {
        
        for (TDFShopSelectionItem *item in section.items) {
            
            if (item.isShowTip) {
                return YES;
            }
        }
    }
    
    return NO;
}


#pragma mark Action

- (void)helpButtonTapped:(id)sender {
    
    [HelpDialog show:@"chainhdbrad"];
}

- (void)showChargeViewController {

    UIAlertController *avc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"该门店尚未开通微信公众号营销功能，或开通了此功能但由于点券账户余额不足已停用，无法进行绑定。", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    @weakify(self);
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:nil]];
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"去开通", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self.navigationController pushViewController:[[[TDFMediator alloc] init] TDFMediator_TDFMainAccountRechgeViewController] animated:YES];
    }]];
    [self presentViewController:avc animated:YES completion:nil];
}

- (void)selectButtonTapped {

    for (DHTTableViewSection *section in self.sections) {
        
        ((TDFShopSelectionSectionView *)section.headerView).selectionButton.selected = YES;
        for (TDFShopSelectionItem *item in section.items) {
            
            if (item.canSelected) {
                
                item.requestValue = @(YES);
                item.state = TDFShopSelectionStateSelected;
            }
        }
    }
    
    for (BranchShopVo *branch in self.shopBranches) {
        
        branch.isSelected = YES;
        for (ShopVO *shop in branch.shopVoList) {
            shop.isSelected = YES;
        }
    }
    [self.manager reloadData];
    [self updateNavigationBar];
}

- (void)deselectButtonTapped {

    for (DHTTableViewSection *section in self.sections) {
        
        ((TDFShopSelectionSectionView *)section.headerView).selectionButton.selected = NO;
        for (TDFShopSelectionItem *item in section.items) {
            
            if (item.canSelected) {
                
                item.requestValue = @(NO);
                item.state = TDFShopSelectionStateNormal;
            }
        }
    }
    
    for (BranchShopVo *branch in self.shopBranches) {
        
        branch.isSelected = NO;
        for (ShopVO *shop in branch.shopVoList) {
            shop.isSelected = NO;
        }
    }
    
    [self.manager reloadData];
    [self updateNavigationBar];
}

- (void)saveButtonTapped {
    
    NSMutableArray *array = [NSMutableArray array];
    for (BranchShopVo *branch in self.shopBranches) {
        
        for (ShopVO *shop in branch.shopVoList) {
            
            if (shop.isSelected == YES) {
                
                [array addObject:shop];
            }
        }
    }
    
    !self.confirmBlock ?: self.confirmBlock(array);
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



#pragma mark Network


#pragma mark MemberSearchBarEvent

-(void)searchBarEventClick:(NSString*)keyWord sender:(id)sender {

    [self searchByKeyword:[keyWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

- (void)searchByKeyword:(NSString *)keyword {

    [self.manager removeAllSections];
    for (DHTTableViewSection *section in self.sections) {
        
        BOOL isAnyShow = NO;
        for (TDFShopSelectionItem *item in section.items) {
            
            if (keyword.length == 0 || [item.title.lowercaseString containsString:keyword.lowercaseString]) {
            
                isAnyShow = YES;
                item.shouldShow = YES;
            } else {
            
                item.shouldShow = NO;
            }
        }
        if (isAnyShow) {
        
            [self.manager addSection:section];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - Accessor

- (UIButton *)selectButton {
    if (!_selectButton) {
        
        _selectButton = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeBottomAdd];
        _selectButton.backgroundColor = [UIColor colorWithHeX:0xCC0000];
        [_selectButton setImage:[UIImage imageNamed:@"wxoa_selection_all"] forState:UIControlStateNormal];
        [_selectButton setTitle:NSLocalizedString(@"全选", nil) forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (UIButton *)deselectButton {
    if (!_deselectButton) {
        
        _deselectButton = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeBottomAdd];
        _deselectButton.backgroundColor = [UIColor colorWithHeX:0xCC0000];
        [_deselectButton setImage:[UIImage imageNamed:@"wxoa_unselection_all"] forState:UIControlStateNormal];
        [_deselectButton setTitle:NSLocalizedString(@"全不选", nil) forState:UIControlStateNormal];
        _deselectButton.imageEdgeInsets = UIEdgeInsetsMake(-18, 15, 0.0f, - 20);
        [_deselectButton addTarget:self action:@selector(deselectButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deselectButton;
}

- (MemberSearchBar *)searchBar {
    
    if (!_searchBar) {
    
        _searchBar = [[MemberSearchBar alloc] init];
        [_searchBar setSearchBarPlaceholder:NSLocalizedString(@"输入名称", nil)];
        _searchBar.delegateTmp = self;
    }
    
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _tableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 60)];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
    }
    return _tableView;
}

- (DHTTableViewManager *)manager {
    if (!_manager) {
        
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
        [_manager registerCell:@"TDFShopSelectionTableViewCell" withItem:@"TDFShopSelectionItem"];
    }
    return _manager;
}

- (UIButton *)helpButton {

    if (!_helpButton) {
        
        _helpButton = [[UIButton alloc] init];
        [_helpButton setImage:[UIImage imageNamed:@"ico_help"] forState:UIControlStateNormal];
        [_helpButton addTarget:self action:@selector(helpButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpButton;
}

@end
