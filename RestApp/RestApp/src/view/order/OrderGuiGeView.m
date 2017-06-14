//
//  OrderGuiGeView.m
//  RestApp
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderGuiGeView.h"
#import "UIView+Sizes.h"
#import "IEditItemListEvent.h"
@implementation OrderGuiGeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderGuiGeView" owner:self options:nil];
        [self addSubview:self.view];
        
        self.TittleLbl.layer.cornerRadius=8;
        self.TittleLbl.layer.masksToBounds=YES;
        self.TittleLbl.layer.borderWidth=1;
        self.TittleLbl.layer.borderColor=[[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3] CGColor];
    }
    return self;
}




- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"OrderGuiGeView" owner:self options:nil];
    [self addSubview:self.view];
    
    self.TittleLbl.layer.cornerRadius=8;
    self.TittleLbl.layer.masksToBounds=YES;
    self.TittleLbl.layer.borderWidth=1;
    self.TittleLbl.layer.borderColor=[[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3] CGColor];
}


-(void)visible:(BOOL)hide
{
    if (hide) {
        [self.HideList setHeight:0];
        [self.HideList setHidden:YES];
        [self setHeight:self.HideList.bottom];
    }
    else
    {
        [self.HideList setHeight:48];
        [self.HideList setHidden:NO];
        [self setHeight:self.HideList.bottom];
    }
}

-(void)initarry:(NSArray *)arry delegate:(id<IEditItemListEvent>)delegate tag:(NSInteger)tag
{
     self.selectList.IsOrderSelect =tag;
      [self.selectList initLabel:NSLocalizedString(@"菜肴份量", nil) withHit:@"" delegate:delegate];
      [self.selectList initData:@"" withVal:@""];
     self.HideList.IsOrderSelect =tag;
      [self.HideList initLabel:NSLocalizedString(@"* 菜量相当于普通菜的几分", nil) withHit:@"" delegate:delegate];
      [self.HideList initData:NSLocalizedString(@"5份", nil) withVal:@""];
    
}

- (void)changedata:(NSString *)data withVal:(NSString *)val
{
    [self.selectList changeData:data withVal:val];
}

-(CGFloat )getHeight
{
    return self.view.frame.size.height;
}

-(NSString *)getstr{
    NSString *str =[self.selectList getStrVal];
    return str;
}

@end
