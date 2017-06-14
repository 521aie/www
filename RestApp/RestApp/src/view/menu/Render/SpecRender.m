//
//  SpecRender.m
//  RestApp
//
//  Created by zxh on 14-5-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SpecRender.h"

@implementation SpecRender

+(MenuSpecDetail*) convertSpec:(SpecDetail*)spec
{
    MenuSpecDetail* detail=[MenuSpecDetail new];
    detail.specItemId=spec._id;
    detail.specDetailName=spec.name;
    detail.rawScale=spec.rawScale;
    detail.priceScale=0;
    return detail;
}

@end
