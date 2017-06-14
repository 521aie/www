//
//  TDFLimitedShopSelectViewController.m
//  RestApp
//
//  Created by happyo on 2017/2/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFLimitedShopSelectViewController.h"
#import "TDFRootViewController+TableViewManager.h"
#import "BranchShopVo.h"
#import "DHTTableViewSection.h"
#import "TDFFoodSelectItem.h"
#import "DHTTableViewManager.h"
#import "TDFFoodSelectHeaderView.h"
#import "TDFSearchBarNew.h"
#import "SelectKindMenuPanel.h"
#import "SystemUtil.h"
#import "ShopVO.h"


@interface TDFLimitedShopSelectViewController () <TDFSearchBarNewDelegate>

@property (nonatomic, strong) TDFFoodSelectItem *selectedItem;

@end

@implementation TDFLimitedShopSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configDefaultManager];
    
    [self.manager registerCell:@"TDFFoodSelectCell" withItem:@"TDFFoodSelectItem"];
    
    [self configureSections];
    
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];

    TDFSearchBarNew *searchBar = [[TDFSearchBarNew alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    searchBar.delegate = self;
    
    self.tbvBase.tableHeaderView = searchBar;
    self.tbvBase.contentInset = UIEdgeInsetsMake(0, 0, 76 + 64, 0);
    self.title = NSLocalizedString(@"选择门店", nil);
    
}


- (void)configureSections {
    
    [self.manager removeAllSections];
    for (BranchShopVo *vo in self.shopList) {
        
        DHTTableViewSection *headerSection = [DHTTableViewSection section];
        TDFFoodSelectHeaderView *headerView = [[TDFFoodSelectHeaderView alloc] initWithTitle:vo.branchName];
        headerSection.headerView = headerView;
        headerSection.headerHeight = [TDFFoodSelectHeaderView heightForView];
        
        [self.manager addSection:headerSection];
        
        for (ShopVO *shopVo in vo.shopVoList) {
            TDFFoodSelectItem *item = [[TDFFoodSelectItem alloc] init];
            item.selected = shopVo.isSelected;
            if (item.isSelected) {
                self.selectedItem = item;
            }
            item.title = shopVo.name;
            @weakify(self);
            @weakify(item);
            item.selectedBlock = ^ (BOOL isSelected) {
                @strongify(self);
                @strongify(item);
                if (isSelected) { // 如果选中，则判断是否有别的选中
                    if (self.selectedItem) { // 有的话，将上一次的不勾选
                        self.selectedItem.selected = NO;
                        item.selected = YES;
                    } 
                    self.selectedItem = item;
                }
                [self.manager reloadData];
            };
            
            [headerSection addItem:item];
        }
        
    }
    
    [self.manager reloadData];
}

- (void)deselectAllShops {

    for (BranchShopVo *vo in self.shopList)  {
    
        [vo.shopVoList makeObjectsPerformSelector:@selector(setIsSelected:) withObject:@(NO)];
    }
}

- (void)filterListWithSearchString:(NSString *)searchString
{
    for (DHTTableViewSection *section in self.manager.sections) {
        BOOL isSectionShow = NO;

        for (DHTTableViewItem *item in section.items) {
            if ([item isKindOfClass:[TDFFoodSelectItem class]]) {
                TDFFoodSelectItem *selectItem = (TDFFoodSelectItem *)item;
                selectItem.shouldShow = [searchString isEqualToString:@""] ? YES : [selectItem.title containsString:searchString];
                
                isSectionShow = isSectionShow | selectItem.shouldShow;
            }
        }
        
        section.headerHeight = isSectionShow ? [TDFFoodSelectHeaderView heightForView] : 0;
        section.headerView.hidden = !isSectionShow;
    }
    
    [self.manager reloadData];
}

- (ShopVO *)queryShopVo
{
    if (self.selectedItem) {
        NSInteger section = self.selectedItem.indexPath.section;
        NSInteger row = self.selectedItem.indexPath.row;
        
        BranchShopVo *branchShopVo = self.shopList[section];
        ShopVO *shopVo = branchShopVo.shopVoList[row];
        return shopVo;
    } else {
        return nil;
    }
}

#pragma mark -- Actions --

- (void)rightNavigationButtonAction:(id)sender
{
    if (self.delegate) {
        ShopVO *vo = [self queryShopVo];
        [self deselectAllShops];
        vo.isSelected = YES;
        [self.delegate viewController:self didSelectedShop:vo];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    [self filterListWithSearchString:@""];
}



@end
