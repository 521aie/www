//
//  OrderHeadTitle.m
//  RestApp
//
//  Created by apple on 16/5/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderHeadTitle.h"
#import "UIView+Sizes.h"
#import "NSString+Estimate.h"

@implementation OrderHeadTitle

-(id)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        [self addSubview:self.view];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self.lblname setBackgroundColor:[UIColor clearColor]];
        [self.detailname setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"OrderHeadTitle" owner:self options:nil];
    [self addSubview:self.view];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.lblname setBackgroundColor:[UIColor clearColor]];
    [self.detailname setBackgroundColor:[UIColor clearColor]];

}

- (IBAction)btnClick:(UIButton *)sender {
    
    sender.selected =!sender.selected;
    
    [self.delegate click:sender.selected];
}

-(void)initdelegate:(id<TitleClickButton>)delgate
{
    self.delegate =delgate;
}

- (float)getHeight
{
    return self.line.top+self.line.height;
}

- (void) initLabel:(NSString *)label withVal:(NSString*)data{
    self.oldVal=([NSString isBlank:data]) ? @"" :data;
    [self changeLabel:label withVal:data];
}

- (void) changeLabel:(NSString*)label withVal:(NSString*)data
{
    
    self.detailname.text=([NSString isBlank:label]) ? @"" :label;
    [self changeData:data];
}
- (void) changeData:(NSString*)data
{
    
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    [self changeStatus];
}

-(void)changeStatus
{
    [super isChange];
}

@end
