//
//  MultiCheckDetailCell.m
//  RestApp
//
//  Created by zxh on 14-7-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MultiCheckMasterCell.h"

@implementation MultiCheckMasterCell

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)obj event:(NSString*)event
{
    self.delegate=temp;
    self.obj=obj;
    self.event=event;
}

-(IBAction) btnEditClick:(id)sender
{
    [self.delegate showEditNVItemEvent:self.event withObj:self.obj];
}

@end
