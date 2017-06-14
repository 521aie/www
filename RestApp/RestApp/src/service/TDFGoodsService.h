//
//  TDFGoodsService.h
//  RestApp
//
//  Created by happyo on 16/9/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHTTPClient.h"

@interface TDFGoodsService : NSObject

+ (void)fetchFoodUnitWithCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

+ (void)addFoodUnitWithName:(NSString * _Nonnull)foodUnitStr completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

+ (void)deleteFoodUnitWithName:(NSString * _Nonnull)foodUnitStr completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;


@end
