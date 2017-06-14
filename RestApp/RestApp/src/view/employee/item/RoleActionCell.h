//
//  RoleActionCell.h
//  RestApp
//
//  Created by zxh on 14-5-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeNode;
@interface RoleActionCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UILabel *lblVal;
@property (nonatomic, retain) IBOutlet UITextView *lblDetail;
@property (nonatomic, retain) IBOutlet UIView *txtView;

@property (nonatomic) int count;

- (void)fillData:(TreeNode*)node;

- (int)getHeight;

@end
