//
//  TDFHealthChechDetailModel.m
//  RestApp
//
//  Created by xueyu on 2016/12/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckDetailModel.h"
#import "TDFHealthCheckItemBodyModel.h"
#import "YYModel.h"
@implementation TDFHealthCheckDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"components" : [TDFHealthCheckItemBodyModel class]
        };
}
@end
