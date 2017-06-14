//
//  TDFOrderReminderService.h
//  RestApp
//
//  Created by happyo on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHTTPClient.h"

@interface TDFOrderReminderService : NSObject

// 获取点餐重复提醒页详情
+ (void)fetchOrderReminderDetailWithCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 商品点重提醒开关
+ (void)modifyReminderSwithWithIsOn:(BOOL)isOn completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 删除重复提醒的商品
+ (void)deleteReminderFoodWithFoodId:(NSString * _Nonnull)foodId completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 获取商品选择列表
+ (void)fetchFoodSelectedListWithCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 批量保存重复提醒商品
+ (void)saveReminderFoodListWithIds:(NSString * _Nonnull)idsString completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

@end
