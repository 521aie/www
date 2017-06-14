//
//  MakeRender.h
//  RestApp
//
//  Created by zxh on 14-5-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MenuMake,Make;
@interface MakeRender : NSObject

+(NSMutableArray*) listMakePriceMode;

+(MenuMake*) convertMake:(Make*)make;

@end
