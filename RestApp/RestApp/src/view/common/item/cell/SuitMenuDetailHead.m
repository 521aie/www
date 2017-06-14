//
//  SuitMenuDetailHead.m
//  RestApp
//
//  Created by zxh on 14-8-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SuitMenuDetailHead.h"

@implementation SuitMenuDetailHead

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)objTemp event:(NSString*)event
{
    self.delegate=temp;
    self.obj=objTemp;
    self.event=event;
    self.panel.layer.cornerRadius = CELL_HEADER_RADIUS;
    self.lblName.text=[objTemp obtainItemName];
    self.lblValue.text=[objTemp obtainItemValue];
}
//
//  添加按钮原来是根据不同需要，来控制显示与否的.
//  新需求，需要隐藏掉添加.
//
-(void) initOperateWithAdd:(BOOL)addEnable edit:(BOOL)editEnable
{
    [self.imgAdd setHidden:YES];
    [self.btnAdd setHidden:YES];
    [self.imgEdit setHidden:!editEnable];
    [self.btnEdit setHidden:!editEnable];
}

-(IBAction) btnAddClick:(id)sender
{
    [self.delegate showAddEvent:self.event obj:self.obj];
}

-(IBAction) btnEditClick:(id)sender
{
    [self.delegate showEditNVItemEvent:self.event withObj:self.obj];
}


@end
