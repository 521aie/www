//
//  SignerCell.m
//  RestApp
//
//  Created by zxh on 14-7-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignerCell.h"
#import "UIHelper.h"

@implementation SignerCell

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(KindPayDetailOption*)objTemp type:(NSString*)type
{
    self.delegate=temp;
    self.obj=objTemp;
    self.type=type;
    [self loadItem:self.obj];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSMutableArray* ids=[NSMutableArray array];
        [ids addObject:[self.obj obtainItemId]];
        [self.delegate delEvent:@"kindpayoption" ids:ids];
    }
}

-(IBAction) btnDelClick:(id)sender
{
    [UIHelper alert:self andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]挂账人吗？", nil),[self.obj obtainItemName]]];
}

-(void) loadItem:(KindPayDetailOption*)item
{
    self.lblName.text=[item obtainItemName];
    self.lblType.text=self.type;
}

@end
