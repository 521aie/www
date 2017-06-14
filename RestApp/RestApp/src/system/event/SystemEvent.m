//
//  SystemEvent.m
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-25.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventConstants.h"
#import "IEventListener.h"
#import "SystemEvent.h"
#import "ObjectUtil.h"

static NSMutableDictionary *eventDic;

@implementation SystemEvent

+ (void)dispatch:(NSString *)eventType
{
    if ([ObjectUtil isNotNull:eventDic]) {
        if ([[eventDic allKeys] containsObject:eventType]) {
            NSMutableArray *targets = [eventDic objectForKey:eventType];
            if ([ObjectUtil isNotEmpty:targets]) {
                for (id<IEventListener> target in targets) {
                    [target onEvent:eventType];
                }
            }
        }
    }
}

+ (void)dispatch:(NSString *)eventType object:(id)object
{
    if ([ObjectUtil isNotNull:eventDic]) {
        if ([[eventDic allKeys] containsObject:eventType]) {
            NSMutableArray *targets = [eventDic objectForKey:eventType];
            if ([ObjectUtil isNotEmpty:targets]) {
                for (id<IEventListener> target in targets) {
                    [target onEvent:eventType object:object];
                }
            }
        }
    }
}

+ (void)registe:(NSString *)eventType target:(id<IEventListener>)target
{
    if ([ObjectUtil isNull:eventDic]) {
        eventDic = [[NSMutableDictionary alloc]init];
    }
    
    if ([[eventDic allKeys] containsObject:eventType]) {
        NSMutableArray *targets = [eventDic objectForKey:eventType];
        if ([ObjectUtil isNotEmpty:targets]) {
            [targets addObject:target];
        }
    } else {
        NSMutableArray *targets = [[NSMutableArray alloc]init];
        [targets addObject:target];
        [eventDic setObject:targets forKey:eventType];
    }
}

@end
