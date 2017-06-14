//
//  TailDealCell.m
//  RestApp
//
//  Created by zxh on 14-7-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TailDealCell.h"
#import "UIHelper.h"
#import "GlobalRender.h"
#import "ColorHelper.h"
#import "KindPayRender.h"
#import "UIView+Sizes.h"
#import "TailDeal.h"
#import "ColorHelper.h"
#import "FormatUtil.h"

@implementation TailDealCell

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(TailDeal*)objTemp
{
    self.delegate=temp;
    self.obj=objTemp;
    [self loadItem:self.obj];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        NSMutableArray* ids=[NSMutableArray array];
        [ids addObject:[self.obj obtainItemId]];
        [self.delegate delEvent:@"taildeal" ids:ids];
    }
}

-(IBAction) btnDelClick:(id)sender
{
    [UIHelper alert:self andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除尾数[%@]吗？", nil),[self.obj obtainItemName]]];
}

-(void) loadItem:(TailDeal*)item
{
    self.lblName.text=[item obtainItemName];
    self.lblVal.text=[item obtainItemValue];
}

@end
