//
//  MenuListPanel.h
//  RestApp
//
//  Created by zxh on 14-5-6.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFDHListPanel.h"
#import "MenuItemTopCell.h"
#import "MenuItemCell.h"

@class TreeNode;
@interface MenuListPanel :TDFDHListPanel

-(void)scrocll:(TreeNode *)kind;

- (MenuItemCell *)renderMenuItemCell:(MenuItemCell *)detailItem menu:(SampleMenuVO *)menu;
- (MenuItemTopCell *)renderMenuItemTopCell:(MenuItemTopCell *)detailItem menu:(SampleMenuVO *)menu;

@end
