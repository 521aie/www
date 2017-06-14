//
//  KindPayDayStatMainVO.m
//  RestApp
//
//  Created by zxh on 14-11-13.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindPayDayStatMainVO.h"

@implementation KindPayDayStatMainVO

+(id) payList_class{
    return NSClassFromString(@"KindPayDayStatVO");
}

@end
