//
//  orderRdDetailCell.m
//  RestApp
//
//  Created by iOS香肠 on 16/4/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "orderRdDetailCell.h"
#import "orderSegementView.h"
#import "UIView+Sizes.h"

@implementation orderRdDetailCell

-(void)initView:(id<IEditItemRadioEvent>)delegate  indexpatch:(NSIndexPath *)indexpatch  segementdelegate:(id<AddOrDeletNum>)sedelegate iteam:(OrderRdData *)iteam;
{
    [self.frSwitch initLabel:NSLocalizedString(@"点菜少于最小份数时建议", nil) withHit:@"" delegate:delegate];
    self.frSwitch .orderpath =indexpatch.row;
    self.frSwitch.tag =0;
    [self.frSwitch initData:[NSString stringWithFormat:@"%ld",iteam.minSwitch]];
    [self.seSwitch initLabel:NSLocalizedString(@"点菜多余最大建议份数", nil) withHit:@"" delegate:delegate];
    [self.seSwitch initData:[NSString stringWithFormat:@"%ld",iteam.maxSwitch]];
    self.seSwitch.orderpath =indexpatch.row;
    self.seSwitch.tag =1;
    [self.smSegView loadTitle:NSLocalizedString(@"最小建议份数", nil) withNum:iteam.minNumber indexpatch:indexpatch];
    [self.smSegView initdelegate:sedelegate];
    self.smSegView.tag=0;
    [self.bgSegView loadTitle:NSLocalizedString(@"最大建议份数", nil) withNum:iteam.maxNumber indexpatch:indexpatch];
    [self.bgSegView initdelegate:sedelegate];
    self.bgSegView.tag=1;
   
   
}

-(void)change:(NSInteger)num isFrist:(BOOL)isFrist
{
    if (isFrist) {
        [self.smSegView change:num];
    }
    else
    {
        [self.bgSegView change:num];
    }
}

-(void)changestatus:(NSInteger)tag
{
    if (tag ==0) {
        NSString* val=@"1";
        if ([self.frSwitch.currentVal isEqualToString:@"1"]) {
            val=@"0";
        }
        [self.frSwitch changeData:val];
    }
    if (tag==1) {
        NSString* val=@"1";
        if ([self.seSwitch.currentVal isEqualToString:@"1"]) {
            val=@"0";
        }
        [self.seSwitch changeData:val];
    }
}


-(void)loadLeftTitle:(NSString *)title
{
    
    [self.headTitle leftTitle:title];
    
}

-(void)loadAllTitle:(NSString *)title rightTitle:(NSString *)title1 delegate:(id<IteamDetaiTitleEvent>)delegate
{
    [self.headTitle loadleftTitle:title rightTitle:title1 delegate:delegate];
}

-(void)initTitlte:(NSString *)title
{
    self.Titlelbl.text =[NSString stringWithFormat:@"%@",title];
    self.Titlelbl.layer.cornerRadius=8;
    self.Titlelbl.layer.masksToBounds=YES;
    self.Titlelbl.layer.borderWidth=1;
    self.Titlelbl.layer.borderColor=[[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3] CGColor];
}


@end
