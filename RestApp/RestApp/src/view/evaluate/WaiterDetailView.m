//
//  WaiterDetailView.m
//  RestApp
//
//  Created by Shaojianqing on 15/9/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#import "JSONKit.h"
#import "MJRefresh.h"
#import "SystemUtil.h"
#import "ObjectUtil.h"
#import "HeadNameItem.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "WaiterDetailView.h"
#import "TDFKabawService.h"
#import "WaiterEvaluateHeader.h"
#import "WaiterEvaluateDetailCell.h"
#import "WaiterEvaluateCommentData.h"

@implementation WaiterDetailView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataList = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigate];
//    [self initNotification];
    
    [self initMainView];
    [self initMainGrid];
}

- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    self.title = NSLocalizedString(@"服务生评价", nil);
}

#pragma 消息处理部分.
//- (void)initNotification
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFinish:) name:REMOTE_WAITER_REPORT_FOR_SHOP object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCommentDataFinish:) name:REMOTE_COMMENT_LIST_WAITER_FOR_SHOP object:nil];
//}

- (void)initHeaderView
{
    self.evaluateHeader = [WaiterEvaluateHeader createWaiterEvaluateHeader:self];
    [self.mainGrid setTableHeaderView:self.evaluateHeader];
}

- (void)initMainView
{
    self.mainGrid.opaque = NO;
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:36];
    self.mainGrid.dataSource = self;
    self.mainGrid.delegate = self;
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *waiterEvalutesCellNib = [UINib nibWithNibName:NSStringFromClass([WaiterEvaluateDetailCell class]) bundle:nil];
    [self.mainGrid registerNib:waiterEvalutesCellNib forCellReuseIdentifier:WaiterEvaluateDetailCellIndentifier];
}

- (void)initMainGrid
{
    __weak WaiterDetailView *weakSelf = self;
    self.mainGrid.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page = weakSelf.page + 1;
        [weakSelf getWaiterEvaluateList:weakSelf.page];
    }];
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.mainGrid.footer;
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
}

- (void)initWithData:(WaiterEvaluateData *)waiterData
{
    self.page = 1;
    isRefreshed = NO;
    self.evaluateData = waiterData;
    [self.titleBox initWithName:self.evaluateData.userName backImg:Head_ICON_BACK moreImg:nil];
    self.title =self.evaluateData.userName;
    [self.mainGrid setContentOffset:CGPointMake(0, 0) animated:YES];
    [self loadWaiterReprotForShop:waiterData];
     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
   [[TDFKabawService new] loadCommentListWaiterForShop:waiterData.waiterId waiterEmployId:waiterData.employeeId page:self.page sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
       [self.progressHud hide:YES];
       [self remoteLoadCommentData:data];
   } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
       [self.progressHud  hide:YES];
       [AlertBox  show:error.localizedDescription];
   }];
}

- (void)loadWaiterReprotForShop:(WaiterEvaluateData *)waiterData
{
     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
     [[TDFKabawService new] loadWaiterReportsForShop:waiterData.waiterId waiterEmployId:waiterData.employeeId sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
         [self.progressHud hide:YES];
         NSArray *list = [data  objectForKey:@"data"];
         NSMutableArray *totalEvaluateDataList = [JsonHelper transList:list objName:@"WaiterTotalEvaluateData"];
         [self.evaluateHeader initWithData:totalEvaluateDataList andEvaluateData:self.evaluateData];

     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         [self.progressHud hide:YES];
         [AlertBox show:error.localizedDescription];
     }];
    

}


- (void)getWaiterEvaluateList:(NSInteger)page
{

    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFKabawService new] loadCommentListWaiterForShop:self.evaluateData.waiterId waiterEmployId:self.evaluateData.employeeId page:self.page sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hide:YES];
        [self remoteLoadCommentData:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud  hide:YES];
        [AlertBox  show:error.localizedDescription];
    }];

}

- (void)loadFinish:(RemoteResult *)result
{

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadData:result.content];
}

- (void)loadCommentDataFinish:(RemoteResult *)result
{
    [self.progressHud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadCommentData:result.content];
}

- (void)remoteLoadData:(NSString *)responseStr
{
    NSDictionary *map = [JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"data"];
    NSMutableArray *totalEvaluateDataList = [JsonHelper transList:list objName:@"WaiterTotalEvaluateData"];
    [self.evaluateHeader initWithData:totalEvaluateDataList andEvaluateData:self.evaluateData];
}

- (void)remoteLoadCommentData:( id )data
{
    [self.mainGrid.footer endRefreshing];
    NSArray *list = [data objectForKey:@"data"];
    NSArray *evaluateList = [JsonHelper transList:list objName:@"WaiterEvaluateCommentData"];
    if (isRefreshed==NO) {
        isRefreshed = YES;
        [self.dataList removeAllObjects];
    }
    [self.dataList addObjectsFromArray:evaluateList];

    if ([ObjectUtil isNotEmpty:self.dataList]) {
        self.mainGrid.hidden = NO;
        self.noDataTip.hidden = YES;
        [self.mainGrid reloadData];
    } else {
        self.mainGrid.hidden = YES;
        self.noDataTip.hidden = NO;
    }
}

#pragma mark tableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadNameItem *headNameItem = [[HeadNameItem alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [headNameItem initWithName:NSLocalizedString(@"顾客对他的评价", nil)];
    return headNameItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([ObjectUtil isNotEmpty:self.dataList]?self.dataList.count:0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaiterEvaluateDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:WaiterEvaluateDetailCellIndentifier];
    [cell initWithData:self.dataList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaiterEvaluateCommentData *commentData = self.dataList[indexPath.row];
    return [WaiterEvaluateDetailCell totalHeight:commentData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WaiterEvaluateData *data  = self.param[@"data"];

    [self initWithData:data];
}
@end
