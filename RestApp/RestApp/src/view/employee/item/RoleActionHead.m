//
//  RoleActionHead.m
//  RestApp
//
//  Created by zxh on 14-5-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "RoleActionHead.h"

@implementation RoleActionHead

- (void)initWithData:(TreeNode *)nodeTemp
{
    self->node=nodeTemp;
    self.lblName.text=nodeTemp.itemName;
}

@end
