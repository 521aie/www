//
//  ActionRender.m
//  RestApp
//
//  Created by zxh on 14-5-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ActionRender.h"
#import "TreeNode.h"
#import "Action.h"

@implementation ActionRender

+ (NSString*)obtainActionDetailName:(TreeNode*)node
{
    NSMutableArray* nodes=node.children;
    NSMutableString* result=[NSMutableString string];
    [result appendString:@""];
    Action* action=nil;
    int count=0;
    if (nodes!=nil && nodes.count>0) {
        for (TreeNode* second in nodes) {
            action=(Action*)second.orign;
            /*if ([action obtainCheckVal]) {
                if (result.length>0) {
                    [result appendString:@","];
                }
                count=count+1;
                [result appendString:second.itemName];
            }*/
        }
    }
    NSString* str=[NSString stringWithFormat:@"%d|%@",count,[NSString stringWithString:result]];
    return str;
}

@end
