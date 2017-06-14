//
//  ActionTableHead.m
//  RestApp
//
//  Created by zxh on 14-10-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ActionTableHead.h"

@implementation ActionTableHead

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)objTemp event:(NSString*)event
{
    self.delegate=temp;
    self.obj=objTemp;
    self.event=event;
    [self.panel.layer setMasksToBounds:YES];
    self.panel.layer.cornerRadius = CELL_HEADER_RADIUS;
    self.lblName.text=[objTemp obtainItemName];
}


@end
