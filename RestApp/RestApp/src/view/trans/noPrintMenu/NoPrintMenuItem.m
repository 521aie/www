//
//  NoPrintMenuItemTableViewCell.m
//  RestApp
//
//  Created by zxh on 14-5-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SampleMenuVO.h"
#import "NoPrintMenuItem.h"
#import "DHListSelectHandle.h"

@implementation NoPrintMenuItem

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) loadItem:(SampleMenuVO*)data delegate:(id<DHListSelectHandle>)delegate
{
    self.item=data;
    self.delegate=delegate;
    self.lblName.text=[data obtainItemName];
}

-(IBAction)btnChange:(id)sender
{
    [self.delegate selectObj:self.item];
}

@end
