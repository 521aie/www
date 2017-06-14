//
//  SelectMenuItem.m
//  RestApp
//
//  Created by zxh on 14-5-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectMultiMenuItem.h"
#import "SampleMenuVO.h"
#import "chainEmployeeData.h"

@implementation SelectMultiMenuItem

-(void) loadItem:(SampleMenuVO*)data
{
    self.line.hidden = YES;
    self.item=data;
    self.lblName.text= [data obtainItemName];
    self.isChainLbl.hidden = YES;
}

- (void) loadChainItem:(chainEmployeeData *)data
{
    self.lblName.text =[NSString stringWithFormat:@"%@",data.name];
    [self IsHide:data.isSelected];
    self.isChainLbl.hidden = YES;
}

- (void)IsHide:(BOOL)hide
{
    if (hide) {
        self.imgCheck.hidden =NO;
        self.imgUnCheck.hidden =YES;
    }
    else
    {
        self.imgCheck.hidden =YES;
        self.imgUnCheck.hidden =NO;
    }
    self.isChainLbl.hidden = YES;
   
}

-(void)loadMemberIteam:(SampleMenuVO *)menu
{
    [self loadItem:menu];
    self.isChainLbl.hidden = YES;
    
}
@end
