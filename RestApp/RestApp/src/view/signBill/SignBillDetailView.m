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
#import "DateUtils.h"
#import "ObjectUtil.h"
#import "JsonHelper.h"
#import "HelpDialog.h"
#import "RemoteEvent.h"
#import "ViewFactory.h"
#import "XHAnimalUtil.h"
#import "RemoteResult.h"
#import "ServiceFactory.h"
#import "SVPullToRefresh.h"
#import "SignBillNoPayVO.h"
#import "TDFSignBillService.h"
#import "SignBillItemCell.h"
#import "SignBillDetailView.h"
#import "SignBillPayTotalVO.h"
#import "SignBillNoPayItemCell.h"
#import "SignBillPayNoPayOptionOrKindPayTotalVO.h"
#import "TDFMediator+SignBillModule.h"
#import "TDFMediator+HomeModule.h"
@implementation SignBillDetailView

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
    [self loadSignBillData:self.signBillPayNoPayOptionTotalVO];
}

#pragma navigateBar
-(void) initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"挂账处理", nil) backImg:Head_ICON_BACK moreImg:nil];
    self.title = NSLocalizedString(@"挂账处理", nil);
}

-(void)initMainGrid
{
    self.currPage=1;
    self.mainGrid.opaque = NO;
    self.dataList = [[NSMutableArray alloc]init];
    self.detailMap = [[NSMutableDictionary alloc]init];
    self.payIdSet = [[NSMutableArray alloc]init];
    UIView* view = [ViewFactory generateFooter:60];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    __weak SignBillDetailView *weakSelf = self;
    
    [self.mainGrid addPullToRefreshWithActionHandler:^{
        weakSelf.act=1;
        weakSelf.currPage=1;
        [weakSelf getSignBillData];
    }];
    
    [self.mainGrid addInfiniteScrollingWithActionHandler:^{
        weakSelf.act=2;
        if(weakSelf.currPage<weakSelf.pageNum){
            weakSelf.currPage+=1;
            [weakSelf getSignBillData];
        } else {
            [weakSelf.mainGrid.infiniteScrollingView stopAnimating];
        }
    }];
}

#pragma 通知相关.
-(void) initNotification
{

}

- (void)loadSignBillData:(SignBillPayNoPayOptionTotalVO *)signBillPayNoPayOptionTotalVO
{
    if ([ObjectUtil isNotNull:signBillPayNoPayOptionTotalVO]) {
        self.startDate = nil;
        self.endDate = nil;
        self.act = 0;
        self.currPage = 1;
        self.queryDateLbl.text = NSLocalizedString(@"全部", nil);
        [self.payIdSet removeAllObjects];
        NSString *title = [NSString stringWithFormat:NSLocalizedString(@"挂账人-%@", nil), signBillPayNoPayOptionTotalVO.name];
        self.title = title;
        [self getSignBillData];
    }
}

- (void)getSignBillData
{

   [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFSignBillService new] listSignBillPeopleNoPayList:self.signBillPayNoPayOptionTotalVO page:self.currPage startDate:self.startDate endDate:self.endDate sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hide:YES];
        NSDictionary* map= data [@"data"];
        NSArray* signBillNoPayArr = [map objectForKey:@"signBillDetails"];
        self.signBillNoPayList = [SignBillNoPayVO convertToSignBillNoPayList:signBillNoPayArr];
        NSNumber* totalRecordNum=(NSNumber*)[map objectForKey:@"count"];
        int totalRecord=[totalRecordNum intValue];
        self.pageNum=(totalRecord-1)/20+1;
        
        self.hasData=([self.signBillNoPayList count]>0);
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
         [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];

    
}

- (void)querySignBillList:(NSDate *)startDate endDate:(NSDate *)endDate
{
    if ([ObjectUtil isNotNull:self.signBillPayNoPayOptionTotalVO]) {
        self.startDate = startDate;
        self.endDate = endDate;
        self.currPage = 1;
        self.act = 0;
        self.queryDateLbl.text = [NSString stringWithFormat:NSLocalizedString(@"%@至%@", nil), [DateUtils formatTimeWithDate:self.startDate type:TDFFormatTimeTypeYearMonthDay],[DateUtils formatTimeWithDate:self.endDate type:TDFFormatTimeTypeYearMonthDay]];
        [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
        [[TDFSignBillService new] listSignBillPeopleNoPayList:self.signBillPayNoPayOptionTotalVO page:self.currPage startDate:self.startDate endDate:self.endDate sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hide:YES];
            NSDictionary* map=   data [@"data"];
            NSArray* signBillNoPayArr = [map objectForKey:@"signBillDetails"];
            self.signBillNoPayList = [SignBillNoPayVO convertToSignBillNoPayList:signBillNoPayArr];
            NSNumber* totalRecordNum=(NSNumber*)[map objectForKey:@"count"];
            int totalRecord=[totalRecordNum intValue];
            self.pageNum=(totalRecord-1)/20+1;
            
            self.hasData=([self.signBillNoPayList count]>0);
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
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];

    }
}

- (IBAction)signDateBtnClick:(id)sender
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_signBillDateViewControllerWithStartDate:self.startDate endDate:self.endDate andCallBack:^(NSDate *startDate, NSDate *endDate) {
        [self querySignBillList:startDate endDate:endDate];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)isSelectItem:(NSString *)payId
{
    if ([ObjectUtil isNotEmpty:self.payIdSet] && [self.payIdSet containsObject:payId]) {
        return YES;
    }
    return NO;
}

- (void)deSelectItem:(NSString *)payId
{
    if ([ObjectUtil isNotEmpty:self.payIdSet] && [self.payIdSet containsObject:payId]) {
        [self.payIdSet removeObject:payId];
    }
}

- (void)selectItem:(NSString *)payId
{
    if ([ObjectUtil isNotNull:self.payIdSet] && [self.payIdSet containsObject:payId]==NO) {
        [self.payIdSet addObject:payId];
    }
}

- (void)selectSignBill:(SignBillNoPayVO *)signBillNoPay
{
    if (signBillNoPay!=nil) {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_orderDetailViewControllerWithOrderID:signBillNoPay.orderId andTotalPayID:signBillNoPay.totalPayId eventType:3];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

-(IBAction)helpBtnClick:(id)sender
{
    [HelpDialog show:@"signBill"];
}

-(IBAction)checkAllBtnClick:(id)sender
{
    if (self.signBillNoPayList!=nil && self.payIdSet!=nil) {
        for (SignBillNoPayVO *signBillNoPay in self.signBillNoPayList) {
            if ([self.payIdSet containsObject:signBillNoPay.payId]==NO) {
                [self.payIdSet addObject:signBillNoPay.payId];
            }
        }
        [self.mainGrid reloadData];
    }
}

-(IBAction)unCheckAllBtnClick:(id)sender
{
    if (self.payIdSet!=nil) {
        [self.payIdSet removeAllObjects];
        [self.mainGrid reloadData];
    }
}

-(IBAction)payBackBtnClick:(id)sender
{
    if ([ObjectUtil isNotEmpty:self.payIdSet]) {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_signBillConfirmViewControllerWithData:self.signBillPayNoPayOptionTotalVO andPayIdSet:self.payIdSet];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else {
        [AlertBox show:NSLocalizedString(@"请先选择账单", nil)];
    }
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
    NSArray* signBillNoPayArr = [map objectForKey:@"signBillNoPayVOs"];
    
    self.signBillNoPayList = [SignBillNoPayVO convertToSignBillNoPayList:signBillNoPayArr];
    NSNumber* totalRecordNum=(NSNumber*)[map objectForKey:@"count"];
    int totalRecord=[totalRecordNum intValue];
    self.pageNum=(totalRecord-1)/20+1;

    self.hasData=([self.signBillNoPayList count]>0);
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
    if ([ObjectUtil isNotEmpty:self.signBillNoPayList]) {
        for (SignBillNoPayVO *signBillNoPayVO in self.signBillNoPayList) {
            NSString *signDateStr = [DateUtils formatTimeWithTimestamp:signBillNoPayVO.signDate type:TDFFormatTimeTypeChineseWithoutDay];
            if ([self.detailMap objectForKey:signDateStr]==nil) {
                [self.detailMap setObject:[[NSMutableArray alloc]init] forKey:signDateStr];
            }
            NSMutableArray *list = [self.detailMap objectForKey:signDateStr];
            [list addObject:signBillNoPayVO];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *head = [self.dataList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *list = [self.detailMap objectForKey:head];
        SignBillNoPayItemCell *detailItem = [tableView dequeueReusableCellWithIdentifier:SignBillNoPayItemCellIndentifier];
        if (detailItem==nil) {
            detailItem = [[NSBundle mainBundle] loadNibNamed:@"SignBillNoPayItemCell" owner:self options:nil].lastObject;
        }
        if (indexPath.row < list.count) {
            SignBillNoPayVO *data = [list objectAtIndex:indexPath.row];
            [detailItem initWithData:data payIdSet:self.payIdSet target:self];
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
    NSString *head = nil;
    if (self.dataList.count > section) {
        head = [self.dataList objectAtIndex:section];
    }
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

@end
