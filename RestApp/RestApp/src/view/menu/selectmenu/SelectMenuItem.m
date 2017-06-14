//
//  SelectMenuItem.m
//  RestApp
//
//  Created by zxh on 14-5-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectMenuItem.h"
#import "SampleMenuVO.h"

@implementation SelectMenuItem

-(void) loadItem:(SampleMenuVO*)data
{
    self.item=data;
    self.lblName.text= [data obtainItemName];
}

-(void)loadData:(id<INameValueItem>)data
{
    self.lblName.text= [data obtainItemName];
}
@end
