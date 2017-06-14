//
//  DicSysItem.h
//  RestApp
//
//  Created by zxh on 14-5-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "INameItem.h"
#import "INameValueItem.h"
#import "BaseDicSysItem.h"
#import "IMultiNameValueItem.h"

#define SYSTEM_TYPE_CARD @"4"

@interface DicSysItem : BaseDicSysItem<INameItem,INameValueItem,IMultiNameValueItem>

/** 做法加价 */
@property int state;

+ (instancetype)itemWithId:(NSString *)itemId name:(NSString *)name;

@end
