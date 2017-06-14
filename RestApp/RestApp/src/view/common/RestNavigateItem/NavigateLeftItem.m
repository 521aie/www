//
//  RestNavigateItem.m
//  RestApp
//
//  Created by zxh on 14-3-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "NavigateRightItem.h"
#import "NavigateLeftItem.h"

@implementation NavigateLeftItem

+ (NavigateLeftItem *)Instance;
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"NavigateLeftItem" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)initWithDelegate:(id<RestNavigateAction>)delegateTemp
{
    self.delegate=delegateTemp;
}

- (IBAction)onClick:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    btn.tag=1;
    [self.delegate onNavigateItemEvent:btn];
}

@end
