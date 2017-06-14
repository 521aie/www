//
//  ItemDetaiTitle.m
//  RestApp
//
//  Created by iOS香肠 on 16/4/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ItemDetaiTitle.h"

@implementation ItemDetaiTitle

-(void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle]loadNibNamed:@"ItemDetaiTitle" owner:self options:nil];
    [self addSubview:self.view];
    self.lblname.text =@" ";
    self.detailLbl.text =@" ";
}

-(void)leftTitle:(NSString *)title
{
    
    self.lblname.text=[NSString stringWithFormat:@"%@",title];
    self.detailLbl.text =@"";
    self.img.hidden =YES;
    self.btn.hidden=YES;
}

-(void)loadleftTitle:(NSString *)title rightTitle:(NSString *)btnTitle delegate:(id<IteamDetaiTitleEvent>)delegate
{
    self.btn.hidden =NO;
    self.img.hidden =NO;
    self.lblname.text=[NSString stringWithFormat:@"%@",title];
    self.detailLbl.text =[NSString stringWithFormat:@"%@",btnTitle];
    self.delegate =delegate;
}

- (IBAction)btnClick:(UIButton *)sender {
    
    [self.delegate passEvents];
}
@end
