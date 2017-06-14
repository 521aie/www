//
//  Target_EvaluateModule.h
//  RestApp
//
//  Created by iOS香肠 on 16/8/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_EvaluateModule : NSObject
///评价功能列表
- (UIViewController *)Action_nativeTDFEvaluateListViewController:(NSDictionary *)params;
//顾客评价
- (UIViewController *)Action_nativeTotalEvaluateViewController:(NSDictionary *)params;
//店铺评价
- (UIViewController *)Action_nativeShopEvaluateViewController:(NSDictionary *)params;
//服务生评价页
- (UIViewController *)Action_nativeWaiterEvaluateViewController:(NSDictionary *)params;
//服务生评价详情页
- (UIViewController *)Action_nativeWaiterDetailViewController:(NSDictionary *)params;
@end
