//
//  NavigateMenuCellView.m
//  RestApp
//
//  Created by iOS香肠 on 15/12/15.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "NavigateMenuCellView.h"

@implementation NavigateMenuCellView
-(id)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"NavigateMenuCellView" owner:self options:nil];
    [self addSubview:self.view];
}


@end
