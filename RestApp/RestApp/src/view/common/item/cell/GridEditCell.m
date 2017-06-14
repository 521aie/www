//
//  GridEditCell.m
//  RestApp
//
//  Created by zxh on 14-7-12.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "GridEditCell.h"
#import "UIHelper.h"
#import "GlobalRender.h"
#import "ColorHelper.h"
#import "KindPayRender.h"
#import "UIView+Sizes.h"
#import "DicItem.h"
#import "ColorHelper.h"
#import "FormatUtil.h"

@implementation GridEditCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)objTemp title:(NSString*)title event:(NSString*)event
{
    self.delegate=temp;
    self.obj=objTemp;
    self.title=title;
    self.event=event;
    [self loadItem:self.obj];
}

-(IBAction) btnDelClick:(id)sender
{
    [self.delegate delObjEvent:self.event obj:self.obj];
}

-(void) loadItem:(id<INameValueItem>)item
{
    self.lblName.text= [item obtainItemName];
}

@end

