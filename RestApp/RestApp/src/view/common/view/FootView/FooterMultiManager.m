//
//  FooterMultiManager.m
//  RestApp
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "FooterMultiManager.h"

@implementation FooterMultiManager

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"FooterMultiManager" owner:self options:nil];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    [self addSubview:self.view];
    self.btnManager.titleLabel.numberOfLines=0;
}

-(void) initDelegate:(id<FooterMultiHeadEvent>) delegateTemp managerName:(NSString*)managerName
{
    self.delegate=delegateTemp;
    
    [self.btnManager setTitle:managerName forState:UIControlStateNormal];
    self.btnManager.titleLabel.numberOfLines=0;
    self.btnManager.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
}

- (IBAction) onCheckAllClickEvent:(id)sender
{
    [self.delegate checkAllEvent];
}

- (IBAction) onNotCheckAllClickEvent:(id)sender
{
    [self.delegate notCheckAllEvent];
}

- (IBAction) onManagerEvent:(id)sender
{
    [self.delegate managerEvent];
}

- (IBAction) onHelpClickEvent:(id)sender
{
    [self.delegate showHelpEvent];
}

@end
