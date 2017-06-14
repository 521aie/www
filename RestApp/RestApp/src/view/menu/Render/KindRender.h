//
//  KindRender.h
//  RestApp
//
//  Created by zxh on 14-5-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KindMenu;
@interface KindRender : NSObject
+(BOOL) isSecond:(KindMenu*)kindMenu;
+(BOOL) isGroupOther:(KindMenu*)kindMenu;

+(NSString*) getKindName:(NSMutableArray*)treeNodes kindId:(NSString*)kindId;

@end
