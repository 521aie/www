//
//  ShopEvaluateView.m
//  RestApp
//
//  Created by Shaojianqing on 15/9/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#import "JSONKit.h"
#import "MJRefresh.h"
#import "SystemUtil.h"
#import "ObjectUtil.h"
#import "ViewFactory.h"
#import "HeadNameItem.h"
#import "ServiceFactory.h"
#import "TDFKabawService.h"
#import "ShopEvaluateView.h"
#import "ShopEvaluateHeader.h"
#import "ShopEvaluateViewData.h"
#import "ShopEvaluateCellData.h"
#import "MJRefreshStateHeader.h"
#import "ShopCustomEvaluateCell.h"
#import "JSONKit.h"

@implementation ShopEvaluateView

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
    self.title =NSLocalizedString(@"店铺评价", nil);
}

- (void)initMainView
{
    self.mainGrid.opaque = NO;
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:36];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.delegate = self;
    self.mainGrid .dataSource =self;
    UINib *customEvalutaeCellNib = [UINib nibWithNibName:NSStringFromClass([ShopCustomEvaluateCell class]) bundle:nil];
    [self.mainGrid registerNib:customEvalutaeCellNib forCellReuseIdentifier:ShopCustomEvaluateCellIndentifier];
    self.contentTip.text = NSLocalizedString(@"顾客使用微信扫码点单时，结账后可对店家进行评价。评价数量越多，越能反映出本店的服务质量，菜肴质量等，可为经营者提供参考。评价汇总内容只能在“二维火掌柜”应用中进行浏览，顾客不会看到其他人的评价内容。", nil);
}

- (void)initMainGrid
{
    __weak ShopEvaluateView *weakSelf = self;
    self.mainGrid.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page = weakSelf.page + 1;
        [weakSelf getShopEvaluateList:weakSelf.page];
    }];
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.mainGrid.footer;
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
}

- (void)initHeaderView
{
    self.evaluateHeader = [ShopEvaluateHeader createShopEvaluateHeader:self ];
    self.headerView = self.evaluateHeader;
    [self.mainGrid setTableHeaderView:self.headerView];
}


-(void)leftNavigationButtonAction:(id)sender
{
    [super leftNavigationButtonAction:sender];
}

- (void)initDataView
{
    self.page = 1;
    isRefreshed = NO;
    [self.evaluateHeader collapseHeader];
    [self.mainGrid setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];

  ///  [service loadShopinfoForShop:self callback:@selector(loadFinish:)];
    
    //[service loadCommentListShopForShop:self.page target:self callback:@selector(loadListFinish:)];
    [self loadShopInfo];
    [self loadCommentList:self.page];
    
}

- (void)loadShopInfo
{
      [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
      [[TDFKabawService new] loadShopinfoForShopSucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull dataSource) {
          [self.progressHud hide:YES];
          NSDictionary *data = [dataSource objectForKey:@"data"];
          ShopEvaluateViewData *shopEvaluateViewData = [ShopEvaluateViewData convertToShopEvaluateViewData:data];
          [self.evaluateHeader initWithData:shopEvaluateViewData];
          
      } failure:^(NSURLSessionDataTask * _Nonnull task , NSError * _Nonnull error) {
          [self.progressHud hide:YES];
          [AlertBox show:error.localizedDescription];
      }];
    
}

- (void)loadCommentList:(NSInteger)page
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFKabawService new] loadCommentListShopForShop:page sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hide:YES];
        [self.mainGrid.mj_footer endRefreshing];
     
        NSArray *list = [data objectForKey:@"data"];
        NSArray *evaluateList = [JsonHelper transList:list objName:@"ShopEvaluateCellData"];
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
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)getShopEvaluateList:(NSInteger)page
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];

//    [service loadCommentListShopForShop:page target:self callback:@selector(loadListFinish:)];
    [self loadCommentList:page];
}

- (void)loadListFinish:(RemoteResult *)result
{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadListData:result.content];
}

- (void)remoteLoadListData:(NSString *)result
{
    [self.mainGrid.footer endRefreshing];
    NSDictionary *map = [JsonHelper transMap:result];
    NSArray *list = [map objectForKey:@"data"];
    NSArray *evaluateList = [JsonHelper transList:list objName:@"ShopEvaluateCellData"];
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

- (void)loadFinish:(RemoteResult *)result
{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadData:result.content];
}

- (void)remoteLoadData:(NSString *)responseStr
{
    NSDictionary *map = [JsonHelper transMap:responseStr];
    NSDictionary *data = [map objectForKey:@"data"];
    ShopEvaluateViewData *shopEvaluateViewData = [ShopEvaluateViewData convertToShopEvaluateViewData:data];
    [self.evaluateHeader initWithData:shopEvaluateViewData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   ShopCustomEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopCustomEvaluateCellIndentifier];
   ShopEvaluateCellData *data = self.dataList[indexPath.row];
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
    ShopEvaluateCellData *data = self.dataList[indexPath.row];
    return [ShopCustomEvaluateCell totalHeight:data];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
