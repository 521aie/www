//
//  Target_business.h
//  RestApp
//
//  Created by happyo on 2017/4/22.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_business : NSObject

/**
 营业流水
 */
- (UIViewController *)Action_dayReportFlow:(NSDictionary *)params;

/**
 门店营业额对比
 */
- (UIViewController *)Action_shopTurnoverComparison:(NSDictionary *)params;

/**
 老的营业汇总
 */
- (UIViewController *)Action_summary:(NSString *)params;

@end
