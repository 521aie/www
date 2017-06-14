//
//  GridNVCell2.m
//  RestApp
//
//  Created by zxh on 14-8-2.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "DicItem.h"
#import "UIHelper.h"
#import "FormatUtil.h"
#import "ColorHelper.h"
#import "GridNVCell2.h"
#import "ColorHelper.h"
#import "GlobalRender.h"
#import "UIView+Sizes.h"
#import "KindPayRender.h"

@implementation GridNVCell2

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)objTemp title:(NSString*)title event:(NSString*)event
{
    self.delegate=temp;
    self.obj=objTemp;
    self.title=title;
    self.event=event;
    [self loadItem:self.obj];
}

//删除确认.
-(IBAction) btnDelClick:(id)sender
{
    [self.delegate delObjEvent:self.event obj:self.obj];
}

-(void) loadItem:(id<INameValueItem>)item
{
    self.lblName.text= [item obtainItemName];
    self.lblVal.text= [item obtainItemValue];
}

@end
