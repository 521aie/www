//
//  RefreshDataBanner.m
//  CardApp
//
//  Created by 邵建青 on 14-2-12.
//  Copyright (c) 2014年 ZMSOFT. All rights reserved.
//

#import "RefreshDataHeader.h"

@implementation RefreshDataHeader

- (void)initView
{
    if(self) {
        CGRect frame = self.frame;
        frame.origin.y = -44;
        self.frame = frame;
        self.indicator.hidden = YES;
        [self.indicator stopAnimating];
    }
}

- (void)startAnimating
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
}

- (void)stopAnimating
{
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
}

- (void)show
{
    self.indicator.hidden = NO;
    self.suggestLbl.hidden = NO;
}

- (void)hide
{
    self.indicator.hidden = YES;
    self.suggestLbl.hidden = YES;
}

@end
