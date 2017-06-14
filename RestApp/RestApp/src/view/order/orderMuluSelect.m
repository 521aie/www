//
//  orderMuluSelect.m
//  RestApp
//
//  Created by iOS香肠 on 16/4/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "orderMuluSelect.h"
#import "OrderDetailLblVoList.h"
#import "OrderDetailAdviseView.h"
#import "OrderDetailSpecialView.h"
#import "OrderDetailAcridView.h"
#import "UIView+Sizes.h"

@implementation orderMuluSelect

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"orderMuluSelect" owner:self options:nil];
    [self addSubview:self.view];
    self.headLine  =[[UILabel  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    self.headLine.backgroundColor  = [UIColor grayColor];
    self.headLine.alpha  =0.6;
    [self.view addSubview:self.headLine] ;
    self.detaiLbl =[[UILabel alloc]  initWithFrame:CGRectMake(0, 5, 85, 21)];
    self.detaiLbl.font = [UIFont systemFontOfSize:14];
    self.detaiLbl. textAlignment  =  NSTextAlignmentCenter ;
    self.detaiLbl.textColor = [UIColor blackColor];
    [self.view addSubview:self.detaiLbl];
    
}

- (void) MuluteDelegateTag:(CusButton *)target
{
    [self isHide:target.tag];
}

-(void)isHide:(NSInteger)index
{
    for (CusButton *button in self.subviews) {
        
        if (![button isKindOfClass:[CusButton class]]) continue;
        
        if (button.tag== index)
        {
            [self.delegate  changeIteam:self Button:button isHide:YES];
        }
        else
        {
            [self.delegate  changeIteam:self Button:button isHide:NO];
            
        }
        
    }
}

-(void)buildTheDelegate:(id <changeIteamImg >)delegate title:(NSString *)title
{
    self.delegate =delegate ;
    self.detaiLbl.text =title;
}

- (void)hideHeadTitle:(BOOL)hide
{
    self.headLine.hidden =hide;
    self.detaiLbl.hidden =hide;
    
}


- (void)HideCusButtons
{
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[CusButton class]]) {
            view.hidden = YES;
        }
        
    }
    
}


- (void)createViewWithArry:(NSArray *)dataArry imgcolor:(UIColor *)imgcolor Bgcolor:(UIColor *)color tag:(NSInteger)tag hideColor:(UIColor *)hideColor
{
    
    [self HideCusButtons];
    self.view.backgroundColor =[UIColor clearColor];
    NSInteger rowNumber = 4;
    NSUInteger buttonTagBaseNumber = 100000;
    
    for (NSUInteger index = 0; index < dataArry.count; index ++) {
        NSUInteger rowIndex = index / rowNumber;
        NSUInteger colIndex = index % rowNumber;
        NSInteger buttonTag = index + buttonTagBaseNumber;
        
        CusButton *button = [self viewWithTag:buttonTag];
        
        if (!button) {
            button = [[CusButton alloc]initWithFrame:CGRectMake(colIndex * ( 60 + 15 ) + 20, rowIndex * ( 60 + 10 ) + 31, 70, 70)];
            [self addSubview:button];
            
            [button initDelegate:self];
            
            button.tag = buttonTag;
        }
        button.hidden =NO;
        [self fillPicInButton:button WithData:dataArry Tag:tag Index:index Imgcolor:imgcolor Bgcolor:color hideColor:hideColor];
        
        
        if (index == dataArry.count - 1) {
            CGRect frame =self.frame;
            frame.size.height = button.frame.size.height + button.frame.origin.y;
            self.frame =frame;
        }
        
    }
}


- (void) fillPicInButton:(CusButton *)button WithData :(NSArray *)dataArry Tag:(NSInteger)tag Index:(NSInteger)index Imgcolor:(UIColor *)imgcolor Bgcolor:(UIColor *)color hideColor :(UIColor*)hideColor
{
    switch (tag) {
        case 0:
        {
            OrderDetailLblVoList *vo =dataArry[index];
            [button changeImg:vo.picUrl name:vo.labelName imgcolor:imgcolor Bgcolor:color select:vo.isSelected hidecolor:hideColor];
        }
            break;
        case 1:
        {
            OrderDetailAcridView *vo =dataArry[index];
            [button changeImg:vo.picUrl name:vo.acridLevelString imgcolor:imgcolor Bgcolor:color select:vo.isSelected hidecolor:hideColor];
        }
            break;
            
        case 2:
        {
            OrderDetailSpecialView *vo=dataArry[index];
            [button changeImg:vo.picUrl name:vo.specialTagString imgcolor:imgcolor Bgcolor:color  select:vo.isSelected hidecolor:hideColor ] ;
        }
            break;
        case 3:
        {
            OrderDetailAcridView *vo=dataArry[index];
            [button changeImg:vo.picUrl name:vo.acridLevelString imgcolor:imgcolor Bgcolor:color select:vo.isSelected hidecolor:hideColor];
        }
            break;
        default:
            break;
    }
}




@end
