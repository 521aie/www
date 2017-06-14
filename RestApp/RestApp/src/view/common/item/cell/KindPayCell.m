//
//  KindPayCell.m
//  RestApp
//
//  Created by zxh on 14-7-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindPayCell.h"
#import "UIHelper.h"
#import "GlobalRender.h"
#import "ColorHelper.h"
#import "KindPayRender.h"
#import "UIView+Sizes.h"
#import "KindPay.h"
#import "KindPayVO.h"
#import "ColorHelper.h"
#import "FormatUtil.h"

@implementation KindPayCell

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(KindPay*)objTemp
{
    self.delegate=temp;
    self.obj=objTemp;
    [self loadItem:self.obj];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSMutableArray* ids=[NSMutableArray array];
        [ids addObject:[self.obj obtainItemId]];
        [self.delegate delEvent:@"kindpay" ids:ids];
    }
}

-(IBAction) btnDelClick:(id)sender
{
    [UIHelper alert:self andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]付款方式吗？", nil),[self.obj obtainItemName]]];
}

-(void) loadItem:(KindPay*)item
{
     self.lblName.text= [item obtainItemName];
    if (item.kind == 11) {
        item.kind = 7;
    }

     KindPayVO* kindVO=[KindPayRender obtainKindPayType:item.kind];
//     self.lblKind.text=kindVO.name;

     self.lblKind.text= item.thirdType?NSLocalizedString(@"网络支付", nil):kindVO.name;

    
    [self.lblKind setTextColor:[ColorHelper getTipColor6]];
//    [self.nextImg setHidden:item.thirdType];
//    self.userInteractionEnabled = !item.thirdType;
    self.lblIsInclude.text=item.isInclude==1?NSLocalizedString(@"收入计入销售额", nil):NSLocalizedString(@"收入不计入销售额", nil);
    [self.lblIsInclude setTextColor:item.isInclude==1?[ColorHelper getGreenColor]:[ColorHelper getTipColor6]];
}

@end
