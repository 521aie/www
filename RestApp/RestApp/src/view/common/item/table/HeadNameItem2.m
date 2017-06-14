//
//  HeadNameItem2.m
//  RestApp
//
//  Created by xueyu on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "HeadNameItem2.h"

@implementation HeadNameItem2
- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"HeadNameItem2" owner:self options:nil];
    [self addSubview:self.view];
    [self.panel.layer setMasksToBounds:YES];
    self.panel.layer.cornerRadius = 12;
    self.panel.alpha = 0.7;
    self.lblName.text = @"";
}
- (void)initWithName:(NSString *)name{
    self.lblName.text = name;
}

@end
