//
//  ItemTitle.m
//  RestApp
//
//  Created by zxh on 14-4-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "DataBarItem.h"
#import "DataBarChart.h"
#import "UIView+Sizes.h"

@implementation DataBarChart

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"DataBarChart" owner:self options:nil];
    [self setHeight:60];
}

- (void)initWithAppearance:(UIColor *)color
{
    self.backgroundColor = color;
}

- (void)buildBarChart:(NSArray *)barItemList
{
    [self resetBarChart];
    if (barItemList!=nil && barItemList.count>0) {
        DataBarItem *refDataBarItem = [barItemList objectAtIndex:0];
        double reference = refDataBarItem.quantity;
        NSUInteger limit = (barItemList.count<=4?barItemList.count:4);
        NSUInteger span = 320/limit;
        for (NSUInteger i=0;i<limit;++i) {
            DataBarItem *dataBarItem = [barItemList objectAtIndex:i];
            CGFloat width = dataBarItem.quantity/reference*300;
            UIView *dataBar = [[UIView alloc]initWithFrame:CGRectMake(10, 5, width, 30)];
            [dataBar setBackgroundColor:dataBarItem.barColor];
            
            UIView *dataIco = [[UIView alloc]initWithFrame:CGRectMake(i*span+10, 42, 10, 10)];
            [dataIco setBackgroundColor:dataBarItem.barColor];
            
            UILabel *dataLbl = [[UILabel alloc]initWithFrame:CGRectMake(i*span+25, 42, span, 10)];
            dataLbl.textColor = [UIColor blackColor];
            dataLbl.font = [UIFont systemFontOfSize:12];
            dataLbl.text = dataBarItem.label;
            
            [self addSubview:dataBar];
            [self addSubview:dataIco];
            [self addSubview:dataLbl];
        }
    }
}

- (void)resetBarChart
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
}

@end
