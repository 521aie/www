//
//  UIHeadView.m
//  RestApp
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIHeadView.h"

@implementation UIHeadView

-(id)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        
        self.label.textColor =[UIColor colorWithRed:0.0/255.0 green:136.0/255.0 blue:204.0/255.0 alpha:1];
        [[NSBundle mainBundle] loadNibNamed:@"UIHeadView" owner:self options:nil];
        
        CGRect frame = self.view.frame;
        frame.size.width = SCREEN_WIDTH;
        self.view.frame = frame;
        [self addSubview:self.view];
    }
    return self;
}

-(void)initdelegate:(id<TitleClickButton>)delgate
{
    self.delegate = delgate;
}

- (IBAction)btnClick:(UIButton *)sender {
    
     [self.delegate click:sender.selected];
    
}
@end
