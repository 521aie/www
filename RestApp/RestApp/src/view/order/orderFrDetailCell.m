//
//  orderFrDetailCell.m
//  RestApp
//
//  Created by iOS香肠 on 16/4/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "orderFrDetailCell.h"

@implementation orderFrDetailCell

- (void)awakeFromNib {
  
}

-(void)initView
{
    [self.frSwitch initLabel:NSLocalizedString(@"点菜少于最小份数时建议", nil) withHit:@"" delegate:self];
    [self.frSwitch initData:@"0"];
    [self.seSwitch initLabel:NSLocalizedString(@"点菜多余最大建议份数", nil) withHit:@"" delegate:self];
    [self.seSwitch initData:@"0"];
    [self.smSegView initLabel:NSLocalizedString(@"建议份数", nil) withHit:@"" delegate:self];
    
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
