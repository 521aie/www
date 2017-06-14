//
//  TDFTimePlanService.h
//  RestApp
//
//  Created by happyo on 2016/12/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHTTPClient.h"

@interface TDFTimePlanService : NSObject

// 获取营业时间
+ (void)fetchOpenTimeWithCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

@end
