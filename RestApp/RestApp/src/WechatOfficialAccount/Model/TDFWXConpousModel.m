//
//  TDFWXConpousModel.m
//  RestApp
//
//  Created by 黄河 on 2017/3/29.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXConpousModel.h"

@implementation TDFWXConpousModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"conpousID" : @"id"};
}

- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
@end
