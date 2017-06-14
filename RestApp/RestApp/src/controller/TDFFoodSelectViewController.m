//
//  TDFFoodSelectViewController.m
//  RestApp
//
//  Created by happyo on 2016/11/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFFoodSelectViewController.h"
#import "TDFRootViewController+TableViewManager.h"
#import "TDFRootViewController+FooterButton.h"
#import "DHTTableViewManager.h"
#import "DHTTableViewSection.h"
#import "TDFFoodSelectItem.h"
#import "TDFFoodSelectHeaderView.h"
#import "TDFFoodCategorySelectedModel.h"
#import "SelectKindMenuPanel.h"
#import "SystemUtil.h"
#import "KindMenuListView.h"
#import "TDFSearchBarNew.h"

@interface TDFFoodSelectViewController () <SingleCheckHandle, TDFSearchBarNewDelegate>

@property (nonatomic, strong) SelectKindMenuPanel *selectKindMenuPanel;

@property (nonatomic, strong) UIButton *btnMenu;

@property (nonatomic, strong) NSMutableArray<TDFFoodCategorySelectedModel *> *foodCategorySelectedListTemp; // 存储初始化的list

@end

@implementation TDFFoodSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = self.navTitle;
    
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    
    [self configDefaultManager];
    
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAllCheck|TDFFooterButtonTypeNotAllCheck];
    
    [self.manager registerCell:@"TDFFoodSelectCell" withItem:@"TDFFoodSelectItem"];
    
    [self configureSections];
    
    TDFSearchBarNew *searchBar = [[TDFSearchBarNew alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    searchBar.delegate = self;
    
    self.tbvBase.tableHeaderView = searchBar;
    self.tbvBase.contentInset = UIEdgeInsetsMake(0, 0, 76 + 64, 0);
    
    self.foodCategorySelectedListTemp = [self getMutableCopyList:self.foodCategorySelectedList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureRightMenu];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.btnMenu removeFromSuperview];
    [self.selectKindMenuPanel.view removeFromSuperview];
}

- (void)configureSections
{
    [self.manager removeAllSections];
    NSMutableArray *menuList = [NSMutableArray array];
    for (TDFFoodCategorySelectedModel *foodCategorySelected in self.foodCategorySelectedList) {
        DHTTableViewSection *section = [DHTTableViewSection section];
        TDFFoodSelectHeaderView *sectionHeader = [[TDFFoodSelectHeaderView alloc] initWithTitle:foodCategorySelected.kindMenuName isSelected:foodCategorySelected.isSelected];
        @weakify(self);
        sectionHeader.selectedBlock = ^ (BOOL isSelected) {
            @strongify(self);
            foodCategorySelected.isSelected = isSelected;
            
            for (TDFFoodSelectedModel *foodSelected in foodCategorySelected.menuVos) {
                foodSelected.isSelected = isSelected;
            }
            
            [self configureSections];
            [self.manager reloadData];
        };
        
        section.headerView = sectionHeader;
        section.headerHeight = [TDFFoodSelectHeaderView heightForView];

        
        for (TDFFoodSelectedModel *foodSelected in foodCategorySelected.menuVos) {
            TDFFoodSelectItem *item = [[TDFFoodSelectItem alloc] init];
            item.title = foodSelected.menuName;
            item.selected = foodSelected.isSelected;
            item.value = [NSString stringWithFormat:NSLocalizedString(@"¥%0.2f元／份", nil), foodSelected.menuPrice];
            item.selectedBlock = ^ (BOOL isSelected) {
                foodSelected.isSelected = isSelected;
                
                BOOL isSectionSelected = YES;
                
                for (TDFFoodSelectedModel *foodSelected in foodCategorySelected.menuVos) {
                    isSectionSelected = isSectionSelected && foodSelected.isSelected;
                }
                
                [sectionHeader changeSelected:isSectionSelected];
            };

            [section addItem:item];
        }
        [self.manager addSection:section];
        
        TreeNode *node = [[TreeNode alloc] init];
        node.itemId = foodCategorySelected.kindMenuId;
        node.itemName = foodCategorySelected.kindMenuName;
        node.itemOrignName = foodCategorySelected.kindMenuName;
        [menuList addObject:node];
    }
    
    [self.selectKindMenuPanel loadData:nil nodes:nil endNodes:[NSMutableArray arrayWithArray:menuList]];
    [self.manager reloadData];
}

- (void)configureRightMenu
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self.selectKindMenuPanel.view];
    [self.selectKindMenuPanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(keyWindow);
        make.height.equalTo(keyWindow);
        make.top.equalTo(keyWindow);
        make.leading.equalTo(keyWindow.mas_trailing);
    }];
    
    [keyWindow addSubview:self.btnMenu];
    [self.btnMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.selectKindMenuPanel.view.mas_leading);
        make.centerY.equalTo(self.selectKindMenuPanel.view);
        make.height.equalTo(@(70));
        make.width.equalTo(@(40));
    }];
}

- (void)showMenuList:(UIButton *)button
{
    button.selected = !button.isSelected;
    
    [self updateMenuShow:button.isSelected];
}

- (void)updateMenuShow:(BOOL)isShow
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];

    if (isShow) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.selectKindMenuPanel.view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(keyWindow.mas_trailing).with.offset(-250);
            }];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            [self.selectKindMenuPanel.view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(keyWindow.mas_trailing);
            }];
        }];
    }
}

- (void)updateAllSelected:(BOOL)isSelected
{
    for (TDFFoodCategorySelectedModel *foodCategorySelected in self.foodCategorySelectedList) {
        foodCategorySelected.isSelected = isSelected;
        
        for (TDFFoodSelectedModel *foodSelected in foodCategorySelected.menuVos) {
            foodSelected.isSelected = isSelected;
        }
    }
    
    [self configureSections];
}

- (void)filterListWithSearchString:(NSString *)searchString
{
    self.foodCategorySelectedList = [self getMutableCopyList:self.foodCategorySelectedListTemp];
    for (NSInteger i = (self.foodCategorySelectedList.count - 1); i >= 0; i--) {
        TDFFoodCategorySelectedModel *foodCategorySelected = self.foodCategorySelectedList[i];
        
        for (NSInteger j = (foodCategorySelected.menuVos.count - 1); j >= 0; j--) {
            TDFFoodSelectedModel *foodSelected = foodCategorySelected.menuVos[j];
            
            if (![foodSelected.menuName containsString:searchString]) { // 如果搜索不匹配，删除商品
                [foodCategorySelected.menuVos removeObject:foodSelected];
            }
        }
        
        if (foodCategorySelected.menuVos.count == 0) { // 如果分类下没有商品，则删除分类
            [self.foodCategorySelectedList removeObject:foodCategorySelected];
        }
    }
    
    [self configureSections];
}

- (NSMutableArray<TDFFoodCategorySelectedModel *> *)getMutableCopyList:(NSMutableArray<TDFFoodCategorySelectedModel *> *)dataList
{
    NSMutableArray *copyList = [NSMutableArray array];
    
    for (TDFFoodCategorySelectedModel *model in dataList) {
        [copyList addObject:[model mutableCopy]];
    }
    
    return copyList;
}

#pragma mark -- SingleCheckHandle --

- (void)singleCheck:(NSInteger)event item:(id<INameItem>) item
{
    self.btnMenu.selected = NO;
    [self updateMenuShow:NO];
    
    NSInteger index = 0;
    for (int i = 0; i < self.foodCategorySelectedList.count; i++) {
        TDFFoodCategorySelectedModel *foodCategorySelected = self.foodCategorySelectedList[i];
        if ([foodCategorySelected.kindMenuId isEqualToString:[item obtainItemId]]) {
            index = i;
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];

    [self.tbvBase scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)closeSingleView:(NSInteger)event
{
    self.btnMenu.selected = NO;
    [self updateMenuShow:NO];
    
//    KindMenuListView *vc = [[KindMenuListView alloc] initWithNibName:@"SampleListView"bundle:nil parent:nil];
//    [vc loadKindMenuData];
//    [vc initBackView:MENU_LIST_VIEW];
//    vc.needHideOldNavigationBar = YES;
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- TDFSearchBarNewDelegate --

- (void)searchBarSearchButtonClicked:(TDFSearchBarNew *)searchBar
{
    [self.view endEditing:YES];
    [self filterListWithSearchString:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(TDFSearchBarNew *)searchBar
{
    [self.view endEditing:YES];
    searchBar.text = @"";
    self.foodCategorySelectedList = [self getMutableCopyList:self.foodCategorySelectedListTemp];
    [self configureSections];
}

#pragma mark -- Actions --

- (void)rightNavigationButtonAction:(id)sender
{
    if (self.delegate) {
        [self.delegate viewController:self changedFoodCategoryList:self.foodCategorySelectedList];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)footerAllCheckButtonAction:(UIButton *)sender
{
    [self updateAllSelected:YES];
}

- (void)footerNotAllCheckButtonAction:(UIButton *)sender
{
    [self updateAllSelected:NO];
}

#pragma mark -- Getters && Setters --

- (SelectKindMenuPanel *)selectKindMenuPanel
{
    if (!_selectKindMenuPanel) {
        _selectKindMenuPanel = [[SelectKindMenuPanel alloc] initWithNibName:@"SelectKindMenuPanel" bundle:nil];
        [_selectKindMenuPanel initDelegate:self event:11];
        _selectKindMenuPanel.shouldHiddenButton = YES;
    }
    
    return _selectKindMenuPanel;
}

- (UIButton *)btnMenu
{
    if (!_btnMenu) {
        _btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnMenu setImage:[UIImage imageNamed:@"Ico_Kind_Menu.png"] forState:UIControlStateNormal];
        [_btnMenu setBackgroundImage:[UIImage imageNamed:@"Ico_Crile.png"] forState:UIControlStateNormal];
        [_btnMenu setTitleEdgeInsets:UIEdgeInsetsMake(25, -25, 0, -12)];
        _btnMenu.imageEdgeInsets = UIEdgeInsetsMake(-14, 0, 0, -32);
        _btnMenu.titleLabel.font = [UIFont systemFontOfSize:10];
        [_btnMenu setTitle:NSLocalizedString(@"分类", nil) forState:UIControlStateNormal];
        [_btnMenu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_btnMenu addTarget:self action:@selector(showMenuList:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnMenu;
}

@end
