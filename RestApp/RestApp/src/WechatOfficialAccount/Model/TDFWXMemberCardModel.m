//
//  TDFWXMemberCardModel.m
//  RestApp
//
//  Created by 黄河 on 2017/3/29.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXMemberCardModel.h"

@implementation TDFWXMemberCardModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cardID" : @"id"};
}

- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
@end
