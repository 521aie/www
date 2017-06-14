//
//  RoleActionHead.h
//  RestApp
//
//  Created by zxh on 14-5-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeNode.h"

@interface RoleActionHead : UIView
{
    TreeNode *node;
}

@property (nonatomic, retain) IBOutlet UILabel *lblName;

- (void)initWithData:(TreeNode *)node;
@end
