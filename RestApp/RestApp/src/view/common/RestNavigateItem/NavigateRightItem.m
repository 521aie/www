//
//  RestNavigateItem.m
//  RestApp
//
//  Created by zxh on 14-3-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "NavigateRightItem.h"
#import "RestNavigateAction.h"

@implementation NavigateRightItem

+(NavigateRightItem *)Instance;
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"NavigateRightItem" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

-(void)initWithDelegate:(id<RestNavigateAction>)delegate
{
    self.delegate=delegate;
}

- (IBAction)onClick:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    btn.tag=2;
    [self.delegate onNavigateItemEvent:btn];
}

@end
