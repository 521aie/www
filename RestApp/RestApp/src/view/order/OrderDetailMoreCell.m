//
//  OrderDetailMoreCell.m
//  RestApp
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderDetailMoreCell.h"
#import "ObjectUtil.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
@implementation OrderDetailMoreCell

- (IBAction)btnClick:(id)sender {
    
    [self.delegat onIrdeItemListClick:self];
}

-(void)initarry:(OrderDetailWeight *)iteam delegate:(id<OnITeamListView>)delegate tag:(NSInteger)tag  iteamTag:(NSInteger)row
{
    [self initMainView];
    self.row =row;
    NSString *str ;
    if (iteam.specWeight ==1) {
        str =NSLocalizedString(@"标准菜量", nil);
      }
     if (iteam.specWeight ==0) {
        str =NSLocalizedString(@"极小份", nil);
     }
     if (iteam.specWeight >1) {
        str =NSLocalizedString(@"特大量", nil);
        self.isMore =YES;
     }
//    if ([str  isEqualToString:NSLocalizedString(@"标准菜量", nil) ]) {
//        self.detail.textColor  =[ColorHelper getBlueColor];
//    }
//    else
//    {
//        self.detail.textColor = [UIColor blackColor];
//    }
    self.detail.textColor  =[ColorHelper getBlueColor]; //统一修改
    self.rowindex =[NSString stringWithFormat:@"%ld",row];
    self.detail.text =str;
    self.delegat =delegate;
    

}

-(void)initmorearry:(OrderDetailWeight *)iteam delegate:(id<OnITeamListView>)delegate tag:(NSInteger)tag  iteamTag:(NSInteger)row
{
    [self initMainView];
    self.row =1000+row;
     self.rowindex =[NSString stringWithFormat:@"%ld",row+1000];
    self.lablname.text =NSLocalizedString(@"*菜量相当于普通的几份", nil);
    self.delegat =delegate;
    self.detail.text =[NSString stringWithFormat:NSLocalizedString(@"%ld份", nil),iteam.specWeight];
    self.detail.textColor =[UIColor colorWithRed:0.0/255.0 green:136.0/255.0 blue:204.0/255.0 alpha:1];
    
}

- (void)initMainView
{
    [self setWidth:SCREEN_WIDTH];
    [self.line setWidth:SCREEN_WIDTH -10];
    [self.btnImg  setRight:SCREEN_WIDTH -10];
    [self.detail setRight: self.btnImg.left -3];
    [self.btnCLick setRight:SCREEN_WIDTH -10];
}

-(NSString *)getstr
{
    return self.detail.text;
}

@end
