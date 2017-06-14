//
//  TDFHealthCheckHistoryResultModel.m
//  RestApp
//
//  Created by 黄河 on 2016/12/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckHistoryResultModel.h"

@implementation TDFHealthCheckHistoryResultModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"levels" : [TDFHealthCheckLevelModel class]
             };
}

@end
