//
//  ConfigRender.m
//  RestApp
//  配置项渲染类.
//
//  Created by zxh on 14-4-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ConfigVO.h"
#import "ObjectUtil.h"
#import "ConfigRender.h"
#import "EditItemRadio.h"
#import "ConfigItemOption.h"
#import "AlertBox.h"
#import "NSString+Estimate.h"

@implementation ConfigRender

+(NSMutableDictionary*) transDic:(NSMutableArray *) arrs
{
    NSMutableDictionary *map=[NSMutableDictionary dictionary];
    if ([ObjectUtil isEmpty:arrs]) {
        return map;
    }
    for (ConfigVO* vo in arrs) {
        [map setObject:vo forKey:vo.code];
    }
    return map;
}

+(ConfigVO*)fillConfig:(NSString*) key withControler:(EditItemRadio*) rdo withMap:(NSMutableDictionary*) map
{
    ConfigVO* vo=[map objectForKey:key];
    NSString* result=@"0";
    if ((NSNull*)vo!= [NSNull null]) {
        result=vo.val;
    }
    [rdo initData:result];
    return vo;
}

+(void)fillSystemConfig:(NSString*) key withControler:(EditItemRadio*) rdo withMap:(NSDictionary*) map
{
    if (![[map allKeys] containsObject:key]) {
//        [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"%@参数配置错误", nil),key]];
        return;
    }
    NSString *result=[map objectForKey:key];
    [rdo initData:result];
}

+(NSString*) getOptionName:(ConfigVO*) vo
{
    NSMutableArray* list=vo.options;
    if ([ObjectUtil isEmpty:list]) {
        return @"";
    }
    ConfigItemOption* temp=nil;
    for (ConfigItemOption* option in vo.options) {
        if ([option.value isEqual:vo.val]) {
            temp=option;
            break;
        }
    }
    if ([ObjectUtil isNull:temp] || [NSString isBlank:temp.memo]) {
        return @"";
    }
    return temp.memo;
}

@end
