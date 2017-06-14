//
//  KindRender.m
//  RestApp
//
//  Created by zxh on 14-5-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindRender.h"
#import "KindMenu.h"
#import "TreeNode.h"
#import "NSString+Estimate.h"

@implementation KindRender

+ (BOOL)isSecond:(KindMenu *)kindMenu
{
    return !([NSString isBlank:kindMenu.parentId] || [kindMenu.parentId isEqualToString:@"0"]);
}

+ (BOOL)isGroupOther:(KindMenu *)kindMenu
{
    if ([NSString isNotBlank:kindMenu.groupKindId]) {
        if ([@"0" isEqualToString:kindMenu.groupKindId]==NO) {
            if ([kindMenu.groupKindId isEqualToString:kindMenu._id]==NO) {
                return YES;
            }
        }
    }
    return NO;
}

+ (NSString *)getKindName:(NSMutableArray*)treeNodes kindId:(NSString*)kindId
{
    if (treeNodes==nil || treeNodes.count==0) {
        return @"";
    }
    for (TreeNode*  node in treeNodes) {
        if ([kindId isEqualToString:node.itemId]) {
            return node.itemOrignName;
        }
        NSString* kname=[self getKindName:node.children kindId:kindId];
        if ([NSString isNotBlank:kname]) {
            return kname;
        }
    }
    return @"";
}

@end
