//
//  MemberSingleInfoView.m
//  RestApp
//
//  Created by iOS香肠 on 15/10/31.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "BusinesssOrderView.h"
#import "MemberSingleOrderCell.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "HeadNameItem.h"
#import "XHAnimalUtil.h"
#import "ViewFactory.h"
#import "ObjectUtil.h"
#import "MJRefresh.h"
#import "DateUtils.h"
#import "OrderDetailView.h"
#import "TDFMediator+HomeModule.h"
#define MemberSingleOrderCellIndentifier @"MemberSingleOrderCellIndentifier"

@implementation BusinesssOrderView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        service = [ServiceFactory Instance].memberService;
        self.groupDic = [NSMutableDictionary dictionaryWithCapacity:20];
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
    [self initDataView:self.name extraPoJoName:self.extraPoJoName AndMobile:self.mobile AndCustomerRegisterId:self.customerRegisterId EventType:self.eventType];
}
- (void)initMainView
{
    self.tableView.opaque = NO;
    self.tableView.tableFooterView = [ViewFactory generateFooter:36];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UINib *memberOrderCell = [UINib nibWithNibName:NSStringFromClass([MemberSingleOrderCell class]) bundle:nil];
    [self.tableView registerNib:memberOrderCell forCellReuseIdentifier:MemberSingleOrderCellIndentifier];
}

- (void)initMainGrid
{
    __weak typeof (self)weakSelf = self;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        isRefresh = NO;
        [service loadMemberOrderRecordByMemberWithCustomerRegisterId:self.customerRegisterId page:weakSelf.page target:self callback:@selector(loadMemberOrderDataFinish:)];
       
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        isRefresh = YES;
        weakSelf.page = weakSelf.page + 1;
        [service loadMemberOrderRecordByMemberWithCustomerRegisterId:self.customerRegisterId page:weakSelf.page target:self callback:@selector(loadMemberOrderDataFinish:)]; 
        
    }];
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.footer;
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
}
- (IBAction)onNavigateEventClick:(id)sender {
    [self endAnimation];
//    [parent showOrderDetail];
//    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromRight];
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self endAnimation];
    [super leftNavigationButtonAction:sender];
    
}

-(void)initDataView:(NSString *)name extraPoJoName:(NSString *)exTroName AndMobile:(NSString *)mobile AndCustomerRegisterId:(NSString *)customerRegisterId EventType:(NSInteger)type{
    [bgView removeFromSuperview];
    self.tableView.hidden = NO;
    [self.groupDic removeAllObjects];
    [self.groupKeys removeAllObjects];
    if ([NSString isBlank:exTroName]) {
        self.title = [NSString stringWithFormat:@"%@-%@",name,mobile];
    }else{
        self.title = [NSString stringWithFormat:@"%@-%@",exTroName,mobile];
    }
    self.page = 1;
    [self startAnimation];
    [self initMainGrid];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [service loadMemberOrderRecordByMemberWithCustomerRegisterId:customerRegisterId page:1 target:self callback:@selector(loadMemberOrderDataFinish:)];
}

- (void)loadNoDataView
{
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.tableView.frame.size.height-60)];
    bgView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:bgView];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(100,120, 120, 120)];
    imageView.image=[UIImage imageNamed:@"img_nobill"];
    [bgView addSubview:imageView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(90, 250, 280, 40)];
    label.text=NSLocalizedString(@"此会员没有在本店消费", nil);
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    label.numberOfLines=0;
    [bgView addSubview:label];
}

-(void)loadMemberOrderDataFinish:(RemoteResult *)result{
    
    [self.progressHud hide:YES];
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        self.page = self.page - 1;
        return;
    }
    if (isRefresh == NO) {
        [self.groupDic removeAllObjects];
        [self.groupKeys removeAllObjects];
    }
 
    NSDictionary *map = [NSJSONSerialization JSONObjectWithData:[result.content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
  //  NSDictionary *data = [map objectForKey:@"data"];
    NSArray *list = [map objectForKey:@"data"];
    if ([ObjectUtil isNotEmpty:list])
    {
      for (NSDictionary *dict in list)
    {
        MemberOrderRecordData *orderData = [[MemberOrderRecordData alloc]initWithDictionary:dict];
        NSString *groupKey = [DateUtils formatTimeWithTimestamp:orderData.createTime type:TDFFormatTimeTypeChineseWithoutDay];
        NSMutableArray *tempArr = self.groupDic[groupKey];
        
        if (tempArr == nil ) {
            tempArr = [[NSMutableArray alloc] init];
           [tempArr addObject:orderData];
        }else{
            [tempArr addObject:orderData];
        }

         [self.groupDic setObject:tempArr forKey:groupKey];
    }
        self.groupKeys = [[NSMutableArray alloc]initWithArray:[self.groupDic allKeys]];
    }
    if (self.groupKeys.count == 0) {
        self.tableView.hidden = YES;
        [self loadNoDataView];
    }
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    [self.groupKeys sortUsingDescriptors:descriptors];
 
       [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([ObjectUtil isNotEmpty:self.groupKeys]?self.groupKeys.count:0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.groupDic objectForKey:self.groupKeys[self.groupKeys.count-1-section]];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberSingleOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:MemberSingleOrderCellIndentifier ];
    if (self.groupKeys.count-1-indexPath.section < self.groupKeys.count) {
        NSArray *array = [self.groupDic objectForKey:self.groupKeys[self.groupKeys.count-1-indexPath.section]];
        MemberOrderRecordData *orderData = array[indexPath.row];
        [cell initMemberSingleOrderData:orderData];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadNameItem *headNameItem = [[HeadNameItem alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];

    if (self.groupKeys.count > self.groupKeys.count-1-section) {
        NSString *keyStr = self.groupKeys[self.groupKeys.count-1-section];
        [headNameItem initWithName:keyStr panelRect:CGRectMake(0, 0,300, 24)];
    }
    return headNameItem;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray *array = [self.groupDic objectForKey:self.groupKeys[self.groupKeys.count-1-indexPath.section]];
    MemberOrderRecordData *orderData = array[indexPath.row];
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_orderDetailViewControllerWithOrderID:orderData.orderId andTotalPayID:orderData.totalpayId eventType:self.eventType];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)startAnimation{
    
    self.titleLabel.frame = CGRectMake(0, 0, 215, 32);
    self.titleView.clipsToBounds = YES;
    if ([self labelWidth:self.titleLabel.text] >= 210)
    {
        CGRect rect = self.titleLabel.frame;
        [self.titleLabel sizeToFit];
        CGRect frame = self.titleLabel.frame;
        frame.origin.x =  rect.origin.x + rect.size.width;
        self.titleLabel.frame = frame;
        [UIView beginAnimations:@"testAnimation" context:NULL];
        [UIView setAnimationDuration:8.8f];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationRepeatCount:999999];
        
        frame = self.titleLabel.frame;
        frame.origin.x = rect.origin.x-frame.size.width;
        self.titleLabel.frame = frame;
        [UIView commitAnimations];
        NSLog(@"%f",[self labelWidth:self.titleLabel.text]);
    }
}

-(void)endAnimation{
    
    [self.titleLabel.layer removeAllAnimations];
    
}
-(CGFloat)labelWidth:(NSString *)string
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(1000,32) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width+5;
}
@end
