//
//  OrderDetailView.m
//  RestApp
//
//  Created by zxh on 14-11-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderDetailView.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "MBProgressHUD.h"
#import "BusinessService.h"
#import "MainModule.h"
#import "JsonHelper.h"
#import "NameItemVO.h"
#import "NumberUtil.h"
#import "InfoDetailView.h"
#import "CardBoxView.h"
#import "InstanceBoxView.h"
#import "RemoteEvent.h"
#import "RemoteResult.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "ServiceBillVO.h"
#import "CardSampleVO.h"
#import "OrderSampleVO.h"
#import "TotalpaySampleVO.h"
#import "KindPayDayVO.h"
#import "NSString+Estimate.h"
#import "UIImageView+WebCache.h"
#import "DateUtils.h"
#import "ObjectUtil.h"
#import "UIView+Sizes.h"
#import "FormatUtil.h"
#import "BusinesssOrderView.h"
#import "TDFMediator+HomeModule.h"
@implementation OrderDetailView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData:self.orderId totalPayId:self.totalPayId EvenType:self.type];
}

//查询数据.
- (void)loadData:(NSString *)orderId totalPayId:(NSString *)totalPayId EvenType:(NSInteger)type
{
    self.recordBtn.hidden = NO;
    [self.scrollView setContentOffset:CGPointMake(0,0)];
    
    [self startLoadDataView];
}

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark button事件
- (IBAction)showOrderListView:(id)sender
{
    
    for (UIViewController *viewController in [self.navigationController viewControllers]) {
        if ([viewController isKindOfClass:[BusinesssOrderView class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_businesssOrderViewControllerWithName:self.name extraPoJoName:self.defaultame mobile:self.mobile customerRegisterId:self.customerRegistId eventType:self.type];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
