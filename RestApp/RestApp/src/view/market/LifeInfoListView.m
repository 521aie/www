//
//  CustomerListView.m
//  RestApp
//
//  Created by zxh on 14-7-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertBox.h"
#import "UIHelper.h"
#import "DateUtils.h"
#import "MessageBox.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "SystemEvent.h"
#import "ViewFactory.h"
#import "RemoteEvent.h"
#import "RemoteResult.h"
#import "XHAnimalUtil.h"
#import "MarketModule.h"
#import "TableEditView.h"
#import "NavigateTitle2.h"
#import "ServiceFactory.h"
#import "EventConstants.h"
#import "LifeInfoItemCell.h"
#import "LifeInfoListView.h"
#import "MJRefresh.h"
#import "MJRefreshStateHeader.h"
#import "TDFMediator+MemberModule.h"
@implementation LifeInfoListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MarketModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        self.datas = [[NSMutableArray alloc]initWithCapacity:16];
        service = [ServiceFactory Instance].lifeInfoService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initHead];
    [self initGrid];
    [self initTableView];
    [self initDelegate:self];
    [self initNotification];
    self.title = NSLocalizedString(@"\"火小二\"生活圈", nil);
    [self loadDatas];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
    [self configRightNavigationBar:nil rightButtonName:nil];
}

- (void)initHead
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"\"火小二\"生活圈", nil) backImg:Head_ICON_BACK moreImg:nil];
    [self.titleBox btnVisibal:NO direct:DIRECT_RIGHT];
}

- (void)initGrid
{
    self.mainGrid.opaque=NO;
    UIView* view=[ViewFactory generateFooter:60];
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)initDelegate:(id<ISampleListEvent>)delegateTemp
{
    self.delegate=delegateTemp;
    self.event=@"lifeInfo";
    self.titleName=NSLocalizedString(@"\"火小二\"生活圈", nil);
    self.titleBox.lblTitle.text=NSLocalizedString(@"\"火小二\"生活圈", nil);
    NSArray* array=[[NSArray alloc] initWithObjects:@"publish", nil];
    [self.footView initDelegate:self btnArrs:array];
    self.footView.hidden=NO;
}

- (void)initTableView
{
    __weak LifeInfoListView *weakSelf = self;
    self.mainGrid.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getLifeInfoListData:weakSelf.page];
    }];
    self.mainGrid.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page = weakSelf.page + 1;
        [weakSelf getLifeInfoListData:weakSelf.page];
    }];
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.mainGrid.mj_footer;
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
}

- (void)loadDatas
{
    self.page = 1;
    [self getLifeInfoListData:self.page];
}

-(void)loadEvent:(NSInteger)event
{
    self.eventType =event;
}
- (void)getLifeInfoListData:(NSInteger)page
{
  [self showProgressHudWithText: NSLocalizedString(@"正在加载", nil) ];
   [service listLifeInfoData:page pageSize:10 target:self callback:@selector(loadFinish:)];
}

- (void)onNavigateEvent:(NSInteger)event
{
//    if (event==DIRECT_LEFT) {
//        if (self.eventType == 1) {
//            [parent backToMemberViewView];
//        }else
//        {
//        [parent backToMain];
//        }
//    }
}

#pragma 消息处理部分.
- (void)initNotification
{

}

- (void)loadFinish:(RemoteResult *)result
{
    [self.progressHud hide:YES];
    [self.mainGrid.mj_header endRefreshing];
    [self.mainGrid.mj_footer endRefreshing];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        self.page = self.page - 1;
        return;
    }
    NSDictionary *map = [JsonHelper transMap:result.content];
    NSDictionary *data = [JsonHelper transMap:[map objectForKey:@"data"]];
    NSArray *list = [data objectForKey:@"records"];
    NSArray *dataList = [Notification convertToNotificationsByArr:list];
    if ([ObjectUtil isEmpty:dataList]) {
        if (self.page==1) {
            self.noDataTip.hidden = NO;
            [self.datas removeAllObjects];
            [self.datas addObjectsFromArray:dataList];
            [self.mainGrid reloadData];
        }
        self.page = self.page - 1;
        return;
    }
    
    if (self.page == 1) {
        [self.datas removeAllObjects];
    }
    [self.datas addObjectsFromArray:dataList];
     self.noDataTip.hidden = YES;
    [self.mainGrid reloadData];
}

- (void)removeFinish:(RemoteResult *) result
{
    [self.progressHud hide:YES];
    self.noDataTip.hidden = YES;
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self loadDatas];
}

- (void)checkFinish:(RemoteResult *) result
{
    [self.progressHud hide:YES];
    self.noDataTip.hidden = YES;
  
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    __weak typeof (self)wSelf = self;
    UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_lifeInfoEditViewControllerWithCallBack:^{
        [wSelf loadDatas];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showAddEvent
{
      [self showProgressHudWithText: @"" ];
     [service checkNotificationCount:self callback:@selector(checkFinish:)];
}

-(void) showHelpEvent:(NSString *)event
{
    [HelpDialog show:@"lifeInfo"];
}

- (void)removeLifeInfo:(Notification *)notification
{
    currentNotification = notification;
    NSString *publishTip = [NSString stringWithFormat:NSLocalizedString(@"确定要删除[%@]这条消息吗?", nil), notification.name];
    [MessageBox show:publishTip client:self];
}

#pragma table部分.
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LifeInfoItemCell *lifeInfoItemCell = (LifeInfoItemCell *)[tableView dequeueReusableCellWithIdentifier:LIFEINFO_ITEM_CELL];
    if (lifeInfoItemCell == nil) {
        lifeInfoItemCell = [LifeInfoItemCell getInstance:self];
        lifeInfoItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Notification *notificaton = [self.datas objectAtIndex:indexPath.row];
    [lifeInfoItemCell initWithData:notificaton];
    return lifeInfoItemCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([ObjectUtil isNotEmpty:self.datas]?[self.datas count]:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Notification *notificaton = [self.datas objectAtIndex:indexPath.row];
    return [LifeInfoItemCell calculateItemHeight:notificaton];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)closeListEvent:(NSString *)event
{
}

- (void)confirm
{
    [self showProgressHudWithText: NSLocalizedString(@"正在删除", nil) ];
    [service removeNotification:currentNotification._id target:self callback:@selector(removeFinish:)];
}

@end
