//
//  EditItemText.m
//  RestApp
//
//  Created by zxh on 14-4-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemInfo.h"
#import "UIView+Sizes.h"

@implementation EditItemInfo
@synthesize view;

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemInfo" owner:self options:nil];
    [self addSubview:self.view];
}

- (float) getHeight
{
    return self.line.top+self.line.height+1;
}

- (void) initData:(NSString*)data
{
    self.lblInfo.text=data;
}

@end