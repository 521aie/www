//
//  OrderDetailView.h
//  RestApp
//
//  Created by zxh on 14-11-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuModule.h"
#import <UIKit/UIKit.h>
#import "AbstractOrderView.h"

@interface OrderDetailView : AbstractOrderView

- (void)loadData:(NSString *)orderId totalPayId:(NSString*)totalPayId EvenType:(NSInteger)type;

- (IBAction)btnBackClick:(id)sender;

- (IBAction)showOrderListView:(id)sender;

@end
