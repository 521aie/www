//
//  OrderPayDetailView.h
//  RestApp
//
//  Created by zxh on 14-11-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessService.h"
#import "InstanceBoxView.h"
#import "AbstractOrderView.h"

@class PaymentModule;
@interface OrderPayDetailView : AbstractOrderView
{
    PaymentModule *parent;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(PaymentModule *)parentTemp;

- (IBAction)btnBackClick:(id)sender;

- (IBAction)showOrderListView:(id)sender;

@end
