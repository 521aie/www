//
//  MenuTimePriceCell.m
//  RestApp
//
//  Created by zxh on 14-6-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuTimePriceCell.h"
#import "MenuTimePrice.h"
#import "UIHelper.h"
#import "GlobalRender.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"
#import "FormatUtil.h"

@implementation MenuTimePriceCell

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(MenuTimePrice*)objTemp meuTime:(MenuTime *)menuTime
{
    self.delegate=temp;
    self.obj=objTemp;
    self.menuTime = menuTime;
    [self loadItem:self.obj meuTime:self.menuTime];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        NSMutableArray* ids=[NSMutableArray array];
        [ids addObject:self.obj._id];
        [self.delegate delEvent:@"menutimeprice" ids:ids];
    }
}

- (IBAction) btnDelClick:(id)sender
{
   [UIHelper alert:self andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]促销吗？", nil),self.obj.menuName]];
}

- (void) loadItem:(MenuTimePrice*)item meuTime:(MenuTime *)menuTime
{
    self.lblName.text= item.menuName;
    
    if (self.menuTime.mode==1) {
        self.perferentialView.hidden = NO;
        self.discountView.hidden = YES;
        NSString* menuPriceStr=[NSString stringWithFormat:NSLocalizedString(@"原价:%@", nil),[FormatUtil formatDouble3:item.menuPrice]];
        self.lblOrign.text=menuPriceStr;
        NSString* priceStr=[NSString stringWithFormat:NSLocalizedString(@"促销价:%@", nil),[FormatUtil formatDouble3:item.price]];
        self.lblPrice.text=priceStr;
        self.lblRatio.text=(self.obj.isRatio==0)?NSLocalizedString(@"不允许参加其他打折活动", nil):NSLocalizedString(@"允许参加其他打折活动", nil);
        [self.lblRatio setTextColor:(self.obj.isRatio==0)?[ColorHelper getTipColor9]:[ColorHelper getGreenColor]];
        UIImage *ratioPic=[UIImage imageNamed:((self.obj.isRatio==0)?@"ico_discount_b.png":@"ico_discount_small.png")];
        self.imgRatio.image=ratioPic;
    } else if (self.menuTime.mode==2){
        self.perferentialView.hidden = YES;
        self.discountView.hidden = NO;
        NSString* menuPriceStr=[NSString stringWithFormat:NSLocalizedString(@"原价:%@", nil),[FormatUtil formatDouble3:item.menuPrice]];
        self.lblOrign.text=menuPriceStr;
        
        NSString* priceStr=[NSString stringWithFormat:NSLocalizedString(@"折后价:%@", nil),[FormatUtil formatDouble3:item.price]];
        self.lblPrice.text=priceStr;
        self.lblDiscountRatio.text=(self.obj.isRatio==0)?NSLocalizedString(@"不允许参加其他打折活动", nil):NSLocalizedString(@"允许参加其他打折活动", nil);
        [self.lblDiscountRatio setTextColor:(self.obj.isRatio==0)?[ColorHelper getTipColor9]:[ColorHelper getGreenColor]];
        self.lblDiscount.text = [NSString stringWithFormat:NSLocalizedString(@"折扣率:%@%%", nil),[FormatUtil formatDouble3:self.menuTime.ratio]];
        [self.lblDiscount setTextColor:[ColorHelper getGreenColor]];
        UIImage *ratioPic=[UIImage imageNamed:@"ico_discount_small.png"];
        self.imgDiscountRatio.image=ratioPic;
    } else {
        self.perferentialView.hidden = NO;
        self.discountView.hidden = YES;
        
        NSString *menuPriceStr=[NSString stringWithFormat:NSLocalizedString(@"原价:%@", nil),[FormatUtil formatDouble3:item.menuPrice]];
        self.lblOrign.text=menuPriceStr;
        
        NSString *priceStr=[NSString stringWithFormat:NSLocalizedString(@"促销价:%@", nil),[FormatUtil formatDouble3:item.price]];
        self.lblPrice.text=priceStr;
        self.lblRatio.text=(item.isRatio==0)?NSLocalizedString(@"不允许参加其他打折活动", nil):NSLocalizedString(@"允许参加其他打折活动", nil);
        [self.lblRatio setTextColor:(item.isRatio==0)?[ColorHelper getTipColor9]:[ColorHelper getGreenColor]];
        
        UIImage *ratioPic=[UIImage imageNamed:((item.isRatio==0)?@"ico_discount_b.png":@"ico_discount_small.png")];
        self.imgRatio.image=ratioPic;
    }
}

@end
