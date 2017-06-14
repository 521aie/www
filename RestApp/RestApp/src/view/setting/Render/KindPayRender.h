//
//  KindPayRender.h
//  RestApp
//
//  Created by zxh on 14-4-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KindPayVO.h"

@interface KindPayRender : NSObject

+(NSMutableArray*) listType;

+(KindPayVO*) obtainKindPayType:(int)kind;
+(KindPayVO *)getThridPayType:(int)kind;
+ (NSString *)obtainKindPayKindName:(int)kind;

@end
