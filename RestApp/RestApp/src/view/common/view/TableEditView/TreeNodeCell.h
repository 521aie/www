//
//  TreeNodeCell.h
//  RestApp
//
//  Created by zxh on 14-5-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeNode.h"

@interface TreeNodeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIButton *btnChild;
@property (strong, nonatomic) IBOutlet UIImageView *img;

@property (strong) TreeNode* currNode;

-(void) fillModel:(TreeNode*)node;
-(IBAction) showChild:(id)sender;

@end
