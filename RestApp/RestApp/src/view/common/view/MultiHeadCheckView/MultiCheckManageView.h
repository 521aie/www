//
//  MultiCheckManageView.h
//  RestApp
//
//  Created by zxh on 14-7-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "NavigateTitle2.h"
#import "IMultiManagerEvent.h"
#import "FooterMultiManager.h"
#import "TDFRootViewController.h"
@interface MultiCheckManageView : TDFRootViewController<UITableViewDataSource,UITableViewDelegate,INavigateEvent,FooterMultiHeadEvent>

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格
@property (nonatomic, strong) IBOutlet FooterMultiManager *footView;

@property (nonatomic, strong) id<IMultiManagerEvent> delegate;
@property (nonatomic, strong) NSString* val;  //选中的值.
@property (nonatomic, strong) NSMutableArray *dataList;    //商品.
@property (nonatomic, strong) NSMutableArray *selectList ;
@property (nonatomic) int event;
@property (nonatomic, strong) NSDictionary *dic;

- (void)initDelegate:(id<IMultiManagerEvent>)_delegate event:(int)_event title:(NSString*)titleName managerName:(NSString*)managerName;

- (void)loadData:(NSMutableArray *) dataList selectList:(NSMutableArray *) selectList;

- (void)reLoadData:(NSMutableArray*) dataList;

@end
