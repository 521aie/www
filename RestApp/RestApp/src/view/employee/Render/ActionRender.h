//
//  ActionRender.h
//  RestApp
//
//  Created by zxh on 14-5-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TreeNode;
@interface ActionRender : NSObject

+ (NSString*)obtainActionDetailName:(TreeNode*)node;

@end
