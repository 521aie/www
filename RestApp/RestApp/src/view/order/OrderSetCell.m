//
//  OrderSetCell.m
//  RestApp
//
//  Created by iOS香肠 on 16/3/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderSetCell.h"
#import "NSString+Estimate.h"

@implementation OrderSetCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.setLbl.textColor =[UIColor colorWithRed:0.0/255.0 green:136.0/255.0 blue:204.0/255.0 alpha:1];
    
}

- (IBAction)btnClick:(id)sender {
    [self.delegate btnClick:self andFlag:0];
}

-(void)setTheGoodsName:(NSString *)name
{
    self.gLbl.text =[NSString stringWithFormat:@"%@",name];
}

-(void)setTheLblName:(NSString *)name
{
    if ([NSString isNotBlank:name]) {
       self.setLbl.textColor =[UIColor colorWithRed:0.0/255.0 green:136.0/255.0 blue:204.0/255.0 alpha:1];
       self.setLbl.text = name;
    }
    else
    {
        self.setLbl.textColor =[UIColor redColor];
        self.setLbl.text = NSLocalizedString(@"未设置", nil);
    }
}
-(void)setTheSetLabel:(NSNumber *)tag
{
    if ([tag  isEqual:@1]) {
        self.setLbl.textColor =[UIColor colorWithRed:0.0/255.0 green:136.0/255.0 blue:204.0/255.0 alpha:1];
        self.setLbl.text = NSLocalizedString(@"自定义", nil);
    }
    else
    {
        self.setLbl.textColor =[UIColor grayColor];
        self.setLbl.text = NSLocalizedString(@"默认", nil);
    }
}

- (void)initDelegate:(id<FuctionViewCellDelegate>)delegeta
{
    self.delegate  =delegeta;
}


@end
