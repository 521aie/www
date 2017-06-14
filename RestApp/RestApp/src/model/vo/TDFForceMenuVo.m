//
//  TDFForceMenuVo.m
//  RestApp
//
//  Created by hulatang on 16/7/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFForceMenuVo.h"

@implementation TDFForceMenuVo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"makeList":[TDFForceMakeVo class],
             @"specList":[TDFForceSpecificationVo class]
             };
}

@end
