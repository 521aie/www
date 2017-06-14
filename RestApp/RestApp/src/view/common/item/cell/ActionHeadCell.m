//
//  ActionHeadCell.m
//  RestApp
//
//  Created by zxh on 14-10-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Action.h"
#import "AlertBox.h"
#import "ActionHeadCell.h"

@implementation ActionHeadCell

- (void)loadData:(TreeNode*)item delegate:(id<HeadCheckHandle>)delegate
{
    self.line.hidden = YES;
    self.delegate=delegate;
    self.item=item;
    self.panel.layer.cornerRadius = CELL_HEADER_RADIUS;
    self.lblName.text=[item obtainItemName];
}

- (void)checked:(BOOL)check
{
    self.checkFlag=check;
    [self.imgUnCheck setHidden:self.checkFlag];
    [self.imgCheck setHidden:!self.checkFlag];
}

- (IBAction)btnCheckClick:(id)sender
{
    if (!self.isResponseClick) {
        [AlertBox  show:self.alterTitle];
        return;
    }
    BOOL result=!self.checkFlag;
    [self checked:result];
    if (self.delegate) {
        [self.delegate checkHead:result head:self.item];
    }
}

-(void)ishide:(BOOL)ishide
{
    [self.imgUnCheck setHidden:ishide];
    [self.imgCheck setHidden:!ishide];

}

//新增
- (void)setIsResponseClick:(BOOL) isClick  AlterTitle:(NSString *)title
{
    self.alterTitle  = [NSString stringWithFormat:@"%@",title];
    self.isResponseClick = isClick;
}
@end
