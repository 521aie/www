//
//  TDFDHListPanel.h
//  RestApp
//
//  Created by zxh on 14-4-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHListSelectHandle.h"
#import "DHSearchBar.h"

#define DH_HEAD_HEIGHT 40
#define DH_SEARCHBAR_HEIGHT 40
#define DH_IMAGE_CELL_ITEM_HEIGHT 88
#define DH_BIG_IMAGE_CELL_ITEM_HEIGHT 230

@class SeatListView;
@interface TDFDHListPanel : UIView<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    SeatListView *satListView;
}
@property (nonatomic, strong) UITableView *mainGrid;  //表格
@property (nonatomic, strong) NSMutableArray *headList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) NSMutableArray *backHeadList;
@property (nonatomic, strong) NSMutableDictionary *backDetailMap;
@property (nonatomic, strong) NSMutableArray *headerItems;
@property (nonatomic, strong) NSMutableArray *detailItems;
@property (nonatomic, strong) DHSearchBar *dhSearchBar;
@property (nonatomic, strong) id<DHListSelectHandle> delegate;
@property (nonatomic, strong) NSString* headChangeEvent;
@property (nonatomic, strong) NSString* detailChangeEvent;
@property (nonatomic, assign) BOOL  isSearchMode;
@property (nonatomic, assign) BOOL isSearchList;

- (void)initDelegate:(id<DHListSelectHandle>)delegate headChange:(NSString*)headChangeEvent detailChange:(NSString*)detailChangeEvent;

- (void)initData:(NSMutableArray*)headList map:(NSMutableDictionary*)detailMap;

- (void)initWithKeyword:(NSString *)keyword;

- (void)showDHSearchBar;

- (void)hideDHSearchBar;

- (void)startSearchMode;

- (void)cancelSearchMode;

@end
