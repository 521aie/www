//
//  OptionSelectView.h
//  RestApp
//
//  Created by xueyu on 16/3/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INameItem.h"
#import "JsonHelper.h"
#import "MemberSearchBar.h"
#import "EditItemBase.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "INavigateEvent.h"
#import "NavigateTitle2.h"
#import "OptionSelectItemCell.h"
#import "PopupBoxViewController.h"
#import "OptionSelectBox.h"

@class AppController,MemberSearchBar;
@interface OptionSelectView : PopupBoxViewController<INavigateEvent, UITableViewDataSource, UITableViewDelegate,MemberSearchBarEvent>

{
    UIView *bgView;
}

@property (nonatomic,strong)NSMutableArray *searchDatas;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;
@property (weak, nonatomic) IBOutlet MemberSearchBar *searchBar;

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) id<INameItem> selectData;
@property (nonatomic, strong) id<OptionSelectClient> target;
@property (nonatomic, strong) OptionSelectItemCell *currentSelectItem;
@property (nonatomic, strong) id editItem;
@property (nonatomic, assign) int event;
@property (nonatomic, assign) BOOL  isSearchMode;
@property (nonatomic, assign) BOOL  isSearch;
@property (nonatomic, strong) NSString *tipStr;

- (void)selectItem:(OptionSelectItemCell *)item;
+ (void)show:(NSString *)title list:(NSArray *)list  selectData:(id<INameItem>)data  target:(id<OptionSelectClient>)target editItem:(id)editItem  Placeholder:(NSString *)placeholder event:(int)event isPresentMode:(BOOL)isPresentMode;
@end
