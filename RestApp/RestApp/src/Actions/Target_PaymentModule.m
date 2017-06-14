//
//  Target_PaymentModule.m
//  RestApp
//
//  Created by xueyu on 16/8/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_PaymentModule.h"
#import "PayOrderListView.h"
#import "PaymentNoteView.h"
#import "TDFPaymentEditViewController.h"
#import "PaymentTypeView.h"
#import "OrderDetailView.h"
#import "TDFOrderDetailListViewViewController.h"
#import "TDFPaymentStatusViewController.h"
#import "SystemUtil.h"

@implementation Target_PaymentModule

-(UIViewController *)Action_nativePaymentNoteViewController:(NSDictionary *)params{
    
    PaymentNoteView *paymentNoteView = [[PaymentNoteView alloc] initWithNibName:@"PaymentNoteView" bundle:nil parent:nil];
    paymentNoteView.needHideOldNavigationBar = YES;
    return paymentNoteView;
}

-(UIViewController *)Action_nativePaymentEditViewController:(NSDictionary *)params{

      TDFPaymentEditViewController *paymentStatusViewController = [[TDFPaymentEditViewController alloc] init];
        return paymentStatusViewController;
}

/**
 *   收款账户的状态
 */
-(UIViewController *)Action_nativePaymentStatusViewController:(NSDictionary *)params{
     TDFPaymentStatusViewController *paymentStatusViewController = [[TDFPaymentStatusViewController alloc] init];
    paymentStatusViewController.status= [params[@"status"] integerValue];
    paymentStatusViewController.menus = params[@"menus"];
    return paymentStatusViewController;
}

-(UIViewController *)Action_nativePaymentTypeViewController:(NSDictionary *)params{
    PaymentTypeView *paymentTypeView = [[PaymentTypeView alloc] init];
    paymentTypeView.menus = params[@"menus"];
    paymentTypeView.codeArray = params[@"codeArray"];
    paymentTypeView.needHideOldNavigationBar = YES;
    return paymentTypeView;
}

-(UIViewController *)Action_nativeOrderPayListViewController:(NSDictionary *)params{
    OrderPayListView *orderPayListView = [[OrderPayListView alloc] init];
    orderPayListView.isBackMenu = [params[@"isAccount"] boolValue];
    orderPayListView.payment = params[@"action"];
    orderPayListView.codeArray = params[@"codeArray"];
    orderPayListView.needHideOldNavigationBar = YES;
    return orderPayListView;
}

-(UIViewController *)Action_nativeOrderDetailListViewController:(NSDictionary *)params{

    TDFOrderDetailListViewViewController *orderDetailListView = [[TDFOrderDetailListViewViewController alloc]init];
    orderDetailListView.str = params[@"dateStr"];
    orderDetailListView.payment = params[@"action"];
    orderDetailListView.isShow = [params[@"isAccount"] boolValue];
    return orderDetailListView;

}

-(UIViewController *)Action_nativeOrderPayDetailViewController:(NSDictionary *)params{
    OrderPayDetailView *orderPayDetailView = [[OrderPayDetailView alloc] initWithNibName:@"OrderPayDetailView" bundle:nil parent:nil];
    orderPayDetailView.orderId = params[@"orderId"];
    orderPayDetailView.totalPayId = params[@"totalPayId"];
    orderPayDetailView.type = [params[@"type"] integerValue];
    orderPayDetailView.needHideOldNavigationBar = NO;
    return orderPayDetailView;
  
}

-(UIViewController *)Action_nativePayOrderListViewController:(NSDictionary *)params{
    PayOrderListView *payOrderListView = [[PayOrderListView alloc] initWithNibName:@"PayOrderListView" bundle:nil parent:nil];
    payOrderListView.params = params;
    payOrderListView.needHideOldNavigationBar = NO;
    return payOrderListView;
}
@end
