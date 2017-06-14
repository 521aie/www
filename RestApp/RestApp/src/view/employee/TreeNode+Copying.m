//
//  TreeNode+Copying.m
//  RestApp
//
//  Created by Octree on 12/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TreeNode+Copying.h"

@implementation TreeNode (Copying)

- (id)copyWithZone:(nullable NSZone *)zone {
    
    TreeNode *node = [[TreeNode allocWithZone:zone] init];
    node.itemId = self.itemId;
    node.itemName = self.itemName;
    node.itemOrignName = self.itemOrignName;
    node.parentId = self.parentId;
    node.isInclude = self.isInclude;
    node.orign = self.orign;
    node.children = [self.children mutableCopy];
    node.select = self.select;
    node.sortCode = self.sortCode;
    return node;
}

@end
