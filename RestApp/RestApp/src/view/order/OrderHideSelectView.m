//
//  orderrview.m
//  duoxuan Button
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 XC. All rights reserved.
//

#import "OrderHideSelectView.h"
#import "CusButton.h"
#import "UIView+Sizes.h"
#import "OrderDetailSpecialView.h"
#import "OrderDetailLblVoList.h"
#import "OrderDetailAcridView.h"
#import "OrderDetailAdviseView.h"

@implementation OrderHideSelectView 

//-(void)awakeFromNib
//{
   // [super awakeFromNib];
    //[[NSBundle mainBundle] loadNibNamed:@"OrderHideSelectView" owner:self options:nil];
    //[self addSubview:self.view];
    
//}

//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//    [[NSBundle mainBundle] loadNibNamed:@"OrderHideSelectView" owner:self options:nil];
//    [self addSubview:self.view];
//   
//    
//}

-(void)HideCusButtons
{
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[CusButton class]]) {
            view.hidden = YES;
        }
        
    }

}


- (void) createViewWithArry:(NSArray *)dataArry Imgcolor:(UIColor *)imgcolor Bgcolor:(UIColor *)color tag:(NSInteger)tag hideColor :(UIColor*)hideColor

{
    [self HideCusButtons];
    self.backgroundColor =[UIColor clearColor];
    NSInteger rowNumber = 4;
    NSUInteger buttonTagBaseNumber = 100000;
    
    for (NSUInteger index = 0; index < dataArry.count; index ++) {
        NSUInteger rowIndex = index / rowNumber;
        NSUInteger colIndex = index % rowNumber;
        NSInteger buttonTag = index + buttonTagBaseNumber;
        
        CusButton *button = [self viewWithTag:buttonTag];
        
        if (!button) {
            button = [[CusButton alloc]initWithFrame:CGRectMake(colIndex * ( 60 + 15 +(SCREEN_WIDTH -300)/4 ) + 20 , rowIndex * ( 60 + 10 ) + 10, 70, 70)];
            [self addSubview:button];
            
            [button initDelegate:self];
            
            button.tag = buttonTag;
        }
        button.hidden =NO;

      [self  fillPicInButton:button WithData:dataArry Tag:tag Index:index Imgcolor:imgcolor Bgcolor:color hideColor:hideColor];

//        OrderDetailSpecialView *vo;
//        vo = dataArry[index];
//        
//        [button changeImg:vo.picUrl name:vo.specialTagString imgcolor:imgcolor Bgcolor:color select:vo.isSelected hidecolor:RGBA(255, 153, 0, 1)];
        
        if (index == dataArry.count - 1) {
            CGRect frame =self.frame;
            frame.size.height = button.frame.size.height + button.frame.origin.y;
            self.frame =frame;
        }
        
    }
    
}

-(void)createTypeViewWithCount:(NSArray *)dataArry imgcolor:(UIColor *)imgcolor Bgcolor:(UIColor *)color tag:(NSInteger)tag
{
    [self HideCusButtons];
    self.backgroundColor =[UIColor clearColor];
    [self setWidth:SCREEN_WIDTH];
    NSInteger rowNumber = 4;
    NSUInteger buttonTagBaseNumber = 1;
    
    for (NSUInteger index = 0; index < dataArry.count; index ++) {
        NSUInteger rowIndex = index / rowNumber;
        NSUInteger colIndex = index % rowNumber;
        NSInteger buttonTag = index + buttonTagBaseNumber;
        
        CusButton *button = [self viewWithTag:buttonTag];
        
        if (!button) {
            button = [[CusButton alloc]initWithFrame:CGRectMake(colIndex * ( 60 + (SCREEN_WIDTH - 320)/4 +15) + 20 , rowIndex * ( 60 + 10 ) + 10, 70, 70)];
            [self addSubview:button];
            
            [button initDelegate:self];
            
            button.tag = buttonTag;
        }
        button.hidden =NO;
        OrderDetailLblVoList *vo = dataArry[index];
        [button changeImg:vo.picUrl name:vo.labelName imgcolor:imgcolor Bgcolor:color select:vo.isSelected hidecolor:RGBA(255, 153, 0, 1)];
        
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
            OrderDetailAdviseView *vo=dataArry[index];
            [button changeImg:vo.picUrl name:vo.recommendLevelString imgcolor:imgcolor Bgcolor:color select:vo.isSelected hidecolor:hideColor];
        }
            break;
        default:
            break;
    }
}




-(void)MuluteDelegateTag:(CusButton *)target
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


-(void)initMuluSelectBox:(NSArray *)dataArry imgcolor:(UIColor *)imgcolor Bgcolor:(UIColor *)color title:(NSString *)title
{
    
    for (NSInteger i=1; i<=dataArry.count; i++) {
        
        CusButton *button =[[CusButton alloc] init];
        for (CusButton *view  in self.subviews) {
            if (view.tag ==i) {
                button =(CusButton*)view;
            }
        }
        button.hidden=NO;
        OrderDetailSpecialView *vo=dataArry[i-1];
        vo.isSelected =0;
        if ([vo.specialTagString  isEqualToString:title] ) {
            vo.isSelected =1;
            [button changeImg:vo.picUrl name:vo.specialTagString imgcolor:imgcolor Bgcolor:color select:vo.isSelected hidecolor:RGBA(255, 153, 0, 1) ];
        }
    }
    
}


-(void)initDelegate:(id <changeIteamImg >)delegate
{
    self.delegate =delegate ;
    
}

@end
