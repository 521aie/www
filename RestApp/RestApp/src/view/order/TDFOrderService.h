//
//  TDFOrderService.h
//  RestApp
//
//  Created by iOS香肠 on 16/9/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFResponseModel.h"
@interface TDFOrderService : NSObject

+ (void)orderGetplanPlantId:(NSString *_Nullable)idStr CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;
+ (void)orderPlantSave:(NSString *_Nullable)plantStr CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;
+ (void)getPlantId:(NSString *_Nullable)plantId mealtcount:(NSString*_Nullable)mealstcount   CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;
//根据ID获取商品标签设置
+ (void)getOrderMenuId:(NSString *_Nullable)menuId   CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;
+ (void)getOrderWithoutMenuId:(NSString *_Nullable)menuId   CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

@end
