//
//  WaiterEvaluateView.m
//  RestApp
//
//  Created by Shaojianqing on 15/9/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ViewFactory.h"
#import "WaiterEvaluateView.h"
#import "WaiterDetailView.h"
#import "XHAnimalUtil.h"
#import "SystemUtil.h"
#import "ObjectUtil.h"
#import "TDFKabawService.h"
#import "ServiceFactory.h"
#import "WaitersEvaluateListCell.h"
#import "WaiterEvaluateData.h"
#import "TDFMediator+EvaluateModule.h"
#import "MJRefresh.h"
#import "UIHelper.h"

@implementation WaiterEvaluateView

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
    [self initMainView];
    [self initDataView];
    [self initMainGrid];
}

- (void)initNavigate
{
    self.title =NSLocalizedString(@"服务生评价", nil);
}

- (void)initMainView
{
    self.mainGrid.opaque = NO;
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:36];
    self.mainGrid.dataSource = self;
    self.mainGrid.delegate = self;
    UINib *waitersEvaluateListCell = [UINib nibWithNibName:NSStringFromClass([WaitersEvaluateListCell class]) bundle:nil];
    [self.mainGrid registerNib:waitersEvaluateListCell forCellReuseIdentifier:WaiterEvaluateCellIndentifier];
    self.contentTip.text = NSLocalizedString(@"顾客使用微信扫码点单时，结账后可对店家进行评价。评价数量越多，越能反映出本店的服务质量，菜肴质量等，可为经营者提供参考。评价汇总内容只能在“二维火掌柜”应用中进行浏览，顾客不会看到其他人的评价内容。\n服务生需要使用“二维火服务生”应用，对顾客加菜消息进行审核，才能获得评价。", nil);
}

- (void)initMainGrid
{
     __weak typeof (self)weakSelf = self;
    self.mainGrid.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page = weakSelf.page + 1;
        [self getWaiterEvaluateList:weakSelf.page];
    }];
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.mainGrid.mj_footer;
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
}

- (void)initDataView
{
    self.page = 1;
    isRefreshed = NO;
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFKabawService new] loadWaiterListForShop:self.page pageSize:20 sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud  hide:YES];
        [self remoteLoadData:data];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud  hide:YES];
        [AlertBox show:error.localizedDescription];
    }];

}


- (void)leftNavigationButtonAction:(id)sender
{
    [super leftNavigationButtonAction:sender];
}

- (void)getWaiterEvaluateList:(NSInteger)page
{

   [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFKabawService new] loadWaiterListForShop:page pageSize:20 sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hide:YES];
        [self remoteLoadData:data];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
    
}

- (void)loadFinish:(RemoteResult *)result
{
    [self.progressHud hide:YES];
    [self.mainGrid.mj_footer endRefreshing];
   
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        self.page = self.page - 1;
        return;
    }
    [self remoteLoadData:result.content];
}

- (void)remoteLoadData:(id)data
{
    [self.mainGrid.mj_footer endRefreshing];
    NSArray *list = [data objectForKey:@"data"];
    NSArray *evaluateList = [JsonHelper transList:list objName:@"WaiterEvaluateData"];
    
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

#pragma mark tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([ObjectUtil isNotEmpty:self.dataList]?self.dataList.count:0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaitersEvaluateListCell *cell = [tableView dequeueReusableCellWithIdentifier:WaiterEvaluateCellIndentifier];
    [cell initWithData:self.dataList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
       return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_waiterDetailViewControllerWithData:self.dataList[indexPath.row]];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

@end
