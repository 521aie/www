//
//  OrderPayDetailView.m
//  RestApp
//
//  Created by zxh on 14-11-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderPayDetailView.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "MBProgressHUD.h"
#import "BusinessService.h"
#import "PaymentModule.h"
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
#import "TDFMediator+PaymentModule.h"
#import "DateUtils.h"
#import "ObjectUtil.h"
#import "UIView+Sizes.h"
#import "FormatUtil.h"
#import "TDFOrderDetailListViewViewController.h"
@implementation OrderPayDetailView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(PaymentModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = YES;
}
//查询数据.
- (void)loadData
{
    self.recordBtn.hidden = NO;
    [self.scrollView setContentOffset:CGPointMake(0,0)];
    
    [self startLoadDataView];
}

- (IBAction)btnBackClick:(id)sender
{
    if ([self backViewController]) {
        [self.navigationController popToViewController:[self backViewController] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(UIViewController *)backViewController
{  
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[TDFOrderDetailListViewViewController class]]) {
            return vc;
        }
    }
    return nil;
}

- (IBAction)showOrderListView:(id)sender
{
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.name forKey:@"name"];
    [params setValue:self.defaultame forKey:@"defaultName"];
     [params setValue:self.mobile forKey:@"mobile"];
    [params setValue:self.customerRegistId forKey:@"customerRegistId"];
    [params setValue:@(self.type) forKey:@"type"];
    [self.navigationController pushViewController:[[TDFMediator sharedInstance] TDFMediator_payOrderListViewWithParams:params] animated:YES];
}

@end
