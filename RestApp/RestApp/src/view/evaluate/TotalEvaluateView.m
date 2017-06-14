//
//  TotalEvaluateView.m
//  RestApp
//
//  Created by Shaojianqing on 15/9/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MJRefresh.h"
#import "SystemUtil.h"
#import "ObjectUtil.h"
#import "ViewFactory.h"
#import "GridColHead.h"
#import "HeadNameItem.h"
#import "TDFKabawService.h"
#import "ServiceFactory.h"
#import "TotalEvaluateView.h"
#import "TotalEvaluateCell.h"
#import "TotalEvaluateData.h"
#import "TotalEvaluateCellData.h"

@implementation TotalEvaluateView

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
    [self  initDataView];
    [self initMainView];
    [self initMainGrid];
}

- (void)initNavigate
{
    self.title = NSLocalizedString(@"综合评价", nil);
}

- (void)initHeaderView
{
    self.evaluateHeader = [TotalEvaluateHeader createTotalEvaluateHeader:self];
    self.headerView = self.evaluateHeader;
    [self.mainGrid setTableHeaderView:self.headerView];
}

- (void)initMainView
{
    self.mainGrid.opaque = NO;
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:36];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *totalEvaluateCellNib = [UINib nibWithNibName:NSStringFromClass([TotalEvaluateCell class]) bundle:nil];
    [self.mainGrid registerNib:totalEvaluateCellNib forCellReuseIdentifier:TotalEvaluateCellIndentifier];
    self.contentTip.text = NSLocalizedString(@"顾客使用微信扫码点单时，结账后可对店家进行评价。评价数量越多，越能反映出本店的服务质量，菜肴质量等，可为经营者提供参考。评价汇总内容只能在“二维火掌柜”应用中进行浏览，顾客不会看到其他人的评价内容。", nil);
}

- (void)initMainGrid
{
    __weak TotalEvaluateView *weakSelf = self;
    self.mainGrid.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page = weakSelf.page + 1;
        [weakSelf getTotalEvaluateList:weakSelf.page];
    }];
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.mainGrid.mj_footer;
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
//        [parent showView:EVALUATE_NAVIGATE_VIEW];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)leftNavigationButtonAction:(id)sender
{
  [super leftNavigationButtonAction:sender];
}

- (void)initDataView
{
    self.page = 1;
    isRefreshed = NO;
    [self.evaluateHeader collapseHeader];
    [self.mainGrid setContentOffset:CGPointMake(0, 0) animated:YES];
    [self loadCommentList];
}



- (void)loadCommentList
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    
    [[TDFKabawService new] loadShopReportForShopSucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [hud hide: YES];
        
        NSArray *list = [data objectForKey:@"data"];
        NSMutableArray *totalEvaluateDataList = [JsonHelper transList:list objName:@"TotalEvaluateData"];
        [self.evaluateHeader initWithData:totalEvaluateDataList];

    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [hud  hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
    
    [[TDFKabawService new] loadCommentListWaiterShopForShop:self.page sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.mainGrid.mj_footer endRefreshing];
        NSArray *list = [data objectForKey:@"data"];
        NSArray *evaluateList = [JsonHelper transList:list objName:@"TotalEvaluateCellData"];
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

    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud  hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)getTotalEvaluateList:(NSInteger)page
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    [[TDFKabawService new]  loadCommentListWaiterShopForShop:page sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data){
        [self.progressHud  hide: YES];
        [self.mainGrid.mj_footer endRefreshing];
        
        NSArray *list = [data objectForKey:@"data"];
        NSArray *evaluateList = [JsonHelper transList:list objName:@"TotalEvaluateCellData"];
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
 
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         [self.progressHud  hide: YES];
        [AlertBox show:error.localizedDescription];
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

- (void)loadCommitFinish:(RemoteResult *)result
{
    [hud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadCommitData:result.content];
}

- (void)remoteLoadData:(NSString *)responseStr
{
    NSDictionary *map = [JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"data"];
    NSMutableArray *totalEvaluateDataList = [JsonHelper transList:list objName:@"TotalEvaluateData"];
    [self.evaluateHeader initWithData:totalEvaluateDataList];
}

- (void)remoteLoadCommitData:(NSString *)responseStr
{
    [self.mainGrid.footer endRefreshing];
    NSDictionary *map = [JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"data"];
    NSArray *evaluateList = [JsonHelper transList:list objName:@"TotalEvaluateCellData"];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TotalEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:TotalEvaluateCellIndentifier];
    TotalEvaluateCellData *data = self.dataList[indexPath.row];
    [cell initWithData:data];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadNameItem *headNameItem = [[HeadNameItem alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [headNameItem initWithName:NSLocalizedString(@"顾客对本店的评价", nil)];
    return headNameItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TotalEvaluateCellData *data = self.dataList[indexPath.row];
    return [TotalEvaluateCell totalHeight:data];
   
}



@end
