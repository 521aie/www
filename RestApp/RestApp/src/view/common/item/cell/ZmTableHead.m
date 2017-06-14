//
//  ZmTableHead.m
//  RestApp
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ZmTableHead.h"

@implementation ZmTableHead

-(void)loadData:(NSString*)kindName obj:(id<INameValueItem>)obj delegate:(id<ISampleListEvent>)delegate event:(NSString*)event
{
    self.panel.layer.cornerRadius = CELL_HEADER_RADIUS;
    self.obj=obj;
    self.delegate=delegate;
    self.lblKind.text=kindName;
    self.eventType=event;
    self.lblName.text=[obj obtainItemName];
}

-(IBAction)btnDelClick:(id)sender
{
    [self.delegate delObjEvent:self.eventType obj:self.obj];
}

@end
