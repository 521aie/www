//
//  MultiNameValueCell.m
//  RestApp
//
//  Created by zxh on 14-5-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MultiNameValueCell.h"
#import "IMultiNameValueItem.h"
#import "ISampleListEvent.h"

@implementation MultiNameValueCell

-(void) fillObj:(id<IMultiNameValueItem>)tempObj delegate:(id<ISampleListEvent>) delegate
{
    self.item=tempObj;
    self.delegate=delegate;
    self.imgCheck.hidden=![self.item obtainCheckVal];
    self.imgUnCheck.hidden=[self.item obtainCheckVal];

    self.lblName.text=[self.item obtainItemName];
    self.lblVal.text=[self.item obtainItemValue];
}

- (IBAction)btnMultiClick:(id)sender
{
    [self.item mCheckVal:![self.item obtainCheckVal]];
    self.imgCheck.hidden=![self.item obtainCheckVal];
    self.imgUnCheck.hidden=[self.item obtainCheckVal];
}

-(void) showBtnEdit
{
    self.btnEdit.hidden=NO;
    self.lblVal.hidden=YES;
    self.timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(stopShow) userInfo:nil repeats:NO];
}

-(void)stopShow
{
    [self.timer invalidate];
    self.timer=nil;
    self.btnEdit.hidden=YES;
    self.lblVal.hidden=NO;
}

- (IBAction)btnEditClick:(id)sender
{
    [self.delegate showEditNVItemEvent:@"" withObj:self.item];
    [self stopShow];
}

@end
