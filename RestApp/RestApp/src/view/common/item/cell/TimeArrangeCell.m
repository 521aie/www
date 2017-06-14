//
//  TimeArrangeCell.m
//  RestApp
//
//  Created by zxh on 14-7-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TimeArrangeCell.h"
#import "UIHelper.h"
#import "GlobalRender.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"
#import "FormatUtil.h"

@implementation TimeArrangeCell

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)objTemp
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
        [self.delegate delEvent:@"timearrange" ids:ids];
    }
}

-(IBAction) btnDelClick:(id)sender
{
    [UIHelper alert:self andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),[self.obj obtainItemName]]];
}

-(void) loadItem:(id<INameValueItem>)item
{
    self.lblName.text= [item obtainItemName];
    
    self.lblVal.text=[item obtainItemValue];
}
@end
