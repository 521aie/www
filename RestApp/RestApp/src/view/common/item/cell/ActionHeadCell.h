//
//  ActionHeadCell.h
//  RestApp
//
//  Created by zxh on 14-10-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TreeNode.h"
#import <UIKit/UIKit.h>
#import "HeadCheckHandle.h"

@interface ActionHeadCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UIView *panel;
@property (nonatomic, strong) IBOutlet UIImageView *imgCheck;
@property (nonatomic, strong) IBOutlet UIImageView *imgUnCheck;
@property (strong, nonatomic) IBOutlet UIButton *clickButton;

@property (nonatomic, strong) id<HeadCheckHandle> delegate;
@property (nonatomic, strong) TreeNode* item;
@property (nonatomic) BOOL checkFlag;
@property (nonatomic, assign)BOOL isResponseClick;
@property (nonatomic, strong) NSString * alterTitle;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UIView *line;

-(void)loadData:(TreeNode*)item delegate:(id<HeadCheckHandle>)delegate;

-(IBAction)btnCheckClick:(id)sender;
- (void)checked:(BOOL)check;
-(void)ishide:(BOOL)ishide;
- (void)setIsResponseClick:(BOOL) isClick  AlterTitle:(NSString *)title;//添加提醒框
@end
