//
//  orderHideMuluSelect.m
//  RestApp
//
//  Created by iOS香肠 on 16/4/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "orderHideMuluSelect.h"
#import "OrderDetailAdviseView.h"
#import "OrderDetailSpecialView.h"
#import "OrderDetailAcridView.h"
#import "OrderDetailLblVoList.h"
#import "UIView+Sizes.h"

@implementation orderHideMuluSelect

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"orderHideMuluSelect" owner:self options:nil];
    [self addSubview:self.view];
    [self initDelegate];
}

-(void)initDelegate
{
    [self.FrButton  initDelegate:self];
    [self.SeButton  initDelegate:self];
    [self.ThButton  initDelegate:self];
    [self.FoButton  initDelegate:self];
    [self.FvButton  initDelegate:self];
    [self.SixButton initDelegate:self];
    [self.SevenButton initDelegate:self];
    [self.EiButton  initDelegate:self];
}


-(void)MuluteDelegateTag:(CusButton *)target
{
    [self isHide:target.tag];
}

-(void)isHide:(NSInteger)index
{
    for (NSInteger i=1; i<=8; i++) {
        CusButton *button =[self.view viewWithTag:i];
       
        if (i== index)
        {
            [self.delegate  changeIteam:self Button:button isHide:YES];
            
        }
        else
        {
            [self.delegate  changeIteam:self Button:button isHide:NO];
            
        }
        
    }
}

-(void)initMuluSelectBox:(NSArray *)dataArry imgcolor:(UIColor *)imgcolor Bgcolor:(UIColor *)color tag:(NSInteger)tag
{
    [self initImplicit:dataArry.count];
    for (NSInteger i=1; i<=dataArry.count; i++) {
        
         CusButton *button =[self.view viewWithTag:i];
         button.hidden=NO;
        switch (tag) {
            case 0:
            {
               OrderDetailLblVoList *vo =dataArry[i-1];
               [button changeImg:vo.picUrl name:vo.labelName imgcolor:imgcolor Bgcolor:color select:vo.isSelected hidecolor:RGBA(255, 153, 0, 1) ];
            }
                break;
             case 1:
            {
                OrderDetailAdviseView *vo =dataArry[i-1];
                [button changeImg:vo.picUrl name:vo.recommendLevelString imgcolor:imgcolor Bgcolor:color select:vo.isSelected hidecolor:RGBA(255, 153, 0, 1) ];
            
            }
                break;
                
            case 2:
            {
                OrderDetailSpecialView *vo=dataArry[i-1];
                [button changeImg:vo.picUrl name:vo.specialTagString imgcolor:imgcolor Bgcolor:color select:vo.isSelected hidecolor:RGBA(255, 153, 0, 1) ];
                
            }
           break;
            case 3:
            {
                OrderDetailAcridView *vo=dataArry[i-1];
                [button changeImg:vo.picUrl name:vo.acridLevelString imgcolor:imgcolor Bgcolor:color select:vo.isSelected hidecolor:RGBA(255, 153, 0, 1) ];
                            }
                break;
            default:
                break;
        }
       
    }
}


-(void)initMuluSelectBox:(NSArray *)dataArry imgcolor:(UIColor *)imgcolor Bgcolor:(UIColor *)color title:(NSString *)title
{
    [self initImplicit:dataArry.count];
    for (NSInteger i=1; i<=dataArry.count; i++) {
        
        CusButton *button =[self.view viewWithTag:i];
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


- (void)initImplicit:(NSInteger)tag
{
    [self hideView];
    if (tag>4) {
        [self restView:NO];
    }
    else
    {
        [self restView:YES];
    }
}

- (void)hideView
{
    for (NSInteger i=1; i<=8; i++) {
        CusButton *button =[self.view viewWithTag:i];
        button.hidden=YES;
    }
}
-(void)restView:(BOOL)ishide
{
    CGRect frameSize = self.frame;
    if (ishide) {
        frameSize.size.height =71;
    }
    else
    {
        frameSize.size.height=140;
    }
    self.frame =frameSize;
}




-(float)getHeight
{
    return self.footView.top+self.footView.height;
}

@end
