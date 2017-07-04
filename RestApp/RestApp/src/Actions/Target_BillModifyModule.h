//
//  Target_BillModifyModule.h
//  RestApp
//
//  Created by 栀子花 on 16/8/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_BillModifyModule : NSObject
///账单优化
-(UIViewController *)Action_nativeBillModifyViewController:(NSDictionary *)params;

///手工优化
- (UIViewController *)Action_nativeHandleModifyViewController:(NSDictionary *)params;

///自动优化
-(UIViewController *)Action_nativeAutoModifyViewController:(NSDictionary *)params;

//收银数据优化
- (UIViewController *)Action_nativeCashierDataOptimizeController:(NSDictionary *)params;

//报表数据优化
- (UIViewController *)Action_nativeTableDataOptimizeController:(NSDictionary *)params;

@end
