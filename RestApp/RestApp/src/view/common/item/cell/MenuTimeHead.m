//
//  MenuTimeHead.m
//  RestApp
//
//  Created by zxh on 14-6-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuTimeHead.h"
#import "ISampleListEvent.h"

@implementation MenuTimeHead

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(MenuTime*)objTemp
{
    self.delegate=temp;
    self.obj=objTemp;
    self.panel.layer.cornerRadius = CELL_HEADER_RADIUS;
    self.lblName.text=self.obj.name;
    
}


-(IBAction) btnEditClick:(id)sender
{
    [self.delegate showEditNVItemEvent:@"menutime" withObj:self.obj];
}

@end
