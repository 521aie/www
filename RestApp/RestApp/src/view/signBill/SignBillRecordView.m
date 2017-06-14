//
//  SeatListView.m
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "GridHead.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "SignBill.h"
#import "DateUtils.h"
#import "ObjectUtil.h"
#import "JsonHelper.h"
#import "HelpDialog.h"
#import "ViewFactory.h"
#import "RemoteEvent.h"
#import "XHAnimalUtil.h"
#import "RemoteResult.h"
#import "ServiceFactory.h"
#import "SignBillNoPayVO.h"
#import "SVPullToRefresh.h"
#import "SignBillItemCell.h"
#import "SignBillRecordView.h"
#import "SignBillPayTotalVO.h"
#import "TDFSignBillService.h"
#import "SignBillRecordItemCell.h"
#import "TDFMediator+SignBillModule.h"
#import "TDFRootViewController+FooterButton.h"

@implementation SignBillRecordView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigate];
    [self initMainGrid];
    [self initNotification];
    [self loadSignBillPayData];
}

#pragma navigateBar
-(void) initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"已还款挂账单", nil) backImg:Head_ICON_BACK moreImg:nil];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    self.title = NSLocalizedString(@"已还款挂账单", nil);
}

-(void)initMainGrid
{
    self.currPage = 1;
    self.mainGrid.opaque = NO;
    self.dataList = [[NSMutableArray alloc]init];
    self.detailMap = [[NSMutableDictionary alloc]init];
    UIView* view = [ViewFactory generateFooter:60];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    __weak SignBillRecordView *weakSelf = self;
    
    [self.mainGrid addPullToRefreshWithActionHandler:^{
        weakSelf.act=1;
        weakSelf.currPage=1;
        [weakSelf getSignBillPayData];
    }];
    
    [self.mainGrid addInfiniteScrollingWithActionHandler:^{
        weakSelf.act=2;
        if(weakSelf.currPage<weakSelf.pageNum){
            weakSelf.currPage+=1;
            [weakSelf getSignBillPayData];
        } else {
            [weakSelf.mainGrid.infiniteScrollingView stopAnimating];
        }
    }];
}

#pragma 通知相关.
-(void) initNotification
{

}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
       
    }
}

- (void)loadSignBillPayData
{
    self.act = 0;
    self.currPage = 1;
    [self getSignBillPayData];
}

- (void)getSignBillPayData
{

   [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
     [[TDFSignBillService new] listSignBillPayList:self.currPage sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
         [self.progressHud hideAnimated:YES];
         NSDictionary* map= data [@"data"];
         NSArray* signBillArr = [map objectForKey:@"signBillPaids"];
         
         self.signBillList = [SignBill convertToSignBillList:signBillArr];
         NSNumber* totalRecordNum=(NSNumber*)[map objectForKey:@"count"];
         int totalRecord=[totalRecordNum intValue];
         self.pageNum=(totalRecord-1)/20+1;
         
         self.hasData=([self.signBillList count]>0);
         if (self.act==0) {
             [self.dataList removeAllObjects];
             [self.detailMap removeAllObjects];
             [self prepareDataList];
             [self.mainGrid reloadData];
             
         } else if (self.act==1) {
             [self.dataList removeAllObjects];
             [self.detailMap removeAllObjects];
             [self prepareDataList];
             [self insertRowAtTop];
             
         } else {
             [self insertRowAtBottom];
         }
     } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         [self.progressHud hideAnimated:YES];
         [AlertBox show:error.localizedDescription];
     }];
    
}

-(void)loadFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self parseResult:result.content];
}

-(void)parseResult:(NSString*)result
{
    NSDictionary* map=[JsonHelper transMap:result];
    NSArray* signBillArr = [map objectForKey:@"signBills"];
    
    self.signBillList = [SignBill convertToSignBillList:signBillArr];
    NSNumber* totalRecordNum=(NSNumber*)[map objectForKey:@"count"];
    int totalRecord=[totalRecordNum intValue];
    self.pageNum=(totalRecord-1)/20+1;
    
    self.hasData=([self.signBillList count]>0);
    if (self.act==0) {
        [self.dataList removeAllObjects];
        [self.detailMap removeAllObjects];
        [self prepareDataList];
        [self.mainGrid reloadData];
        
    } else if (self.act==1) {
        [self.dataList removeAllObjects];
        [self.detailMap removeAllObjects];
        [self prepareDataList];
        [self insertRowAtTop];
        
    } else {
        [self insertRowAtBottom];
    }
}

- (void)prepareDataList
{
    if ([ObjectUtil isNotEmpty:self.signBillList]) {
        for (SignBill *signBill in self.signBillList) {
             NSString *signDateStr = [DateUtils formatTimeWithTimestamp:signBill.payTime type:TDFFormatTimeTypeChineseWithoutDay];
            if ([self.detailMap objectForKey:signDateStr]==nil) {
                [self.detailMap setObject:[[NSMutableArray alloc]init] forKey:signDateStr];
            }
            NSMutableArray *list = [self.detailMap objectForKey:signDateStr];
            [list addObject:signBill];
            if ([self.dataList containsObject:signDateStr]==NO) {
                [self.dataList addObject:signDateStr];
            }
        }
    }
}

- (void)insertRowAtTop
{
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.mainGrid reloadData];
        [self.mainGrid.pullToRefreshView stopAnimating];
    });
}

- (void)insertRowAtBottom
{
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self prepareDataList];
        [self.mainGrid reloadData];
        [self.mainGrid.infiniteScrollingView stopAnimating];
    });
}

#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *head = [self.dataList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *list = [self.detailMap objectForKey:head];
        SignBillRecordItemCell *detailItem = [tableView dequeueReusableCellWithIdentifier:SignBillRecordItemCellIndentifier];
        if (detailItem==nil) {
            detailItem = [[NSBundle mainBundle] loadNibNamed:@"SignBillRecordItemCell" owner:self options:nil].lastObject;
        }
        if ([ObjectUtil isNotEmpty:list]) {
            SignBill *data = [list objectAtIndex:indexPath.row];
            [detailItem initWithData:data target:self];
            detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
            return detailItem;
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *head = [self.dataList objectAtIndex:section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head];
        if ([ObjectUtil isNotEmpty:temps]) {
            return temps.count;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *head = [self.dataList objectAtIndex:section];
    GridHead *headItem = (GridHead *)[tableView dequeueReusableCellWithIdentifier:GridHeadIndentifier];
    
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridHead" owner:self options:nil].lastObject;
    }
    headItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [headItem initTitle:head];
    [headItem initOperateWithAdd:YES edit:NO];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([ObjectUtil isNotEmpty:self.dataList]?self.dataList.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *head = [self.dataList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *list = [self.detailMap objectForKey:head];
        if ([ObjectUtil isNotEmpty:list]) {
            SignBill *data = [list objectAtIndex:indexPath.row];
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_signBillPayDetailViewControllerWithData:(id)data andCallBack:^{
                [self loadSignBillPayData];
                if (self.callBack) {
                    self.callBack();
                }
            }];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"signBill"];
}

@end
