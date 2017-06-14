//
//  TDFShopCompareService.h
//  RestApp
//
//  Created by Cloud on 2017/3/30.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDFResponseModel.h"

@interface TDFShopCompareService : NSObject

//获取营业额对比值
+(void)checkShopBussinessCompareWithParam:(nullable NSMutableDictionary *)dic CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable res))callback;

@end
