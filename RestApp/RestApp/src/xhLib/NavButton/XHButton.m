//
//  NavButton.m
//  RestApp
//
//  Created by zxh on 14-6-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "XHButton.h"
#import "UIView+Sizes.h"

@implementation XHButton

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    self.adjustsImageWhenHighlighted = NO;
    beginPoint = [touch locationInView:self];
    originPosition = self.frame.origin;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint nowPoint = [touch locationInView:self];
    CGFloat offsetX = nowPoint.x - beginPoint.x;
    CGFloat offsetY = nowPoint.y - beginPoint.y;
    CGFloat left = self.center.x+offsetX;
    CGFloat height = self.center.y + offsetY;
    height = height<104?104:height;
    
    CGFloat sh = (SCREEN_HEIGHT-40);
    height=(height>sh?sh:height);
    self.height = height;
    self.center = CGPointMake(left, height);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint currPoint = self.frame.origin;
    
    CGFloat dx = currPoint.x - originPosition.x;
    CGFloat dy = currPoint.y - originPosition.y;
    CGFloat area = dx*dx+dy*dy;
    CGFloat height = (self.height==0?224:self.height);
    self.center = CGPointMake(27, height);
    
    if (area<400) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_SHOW_NOTIFICATION object:nil] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:LODATA object:nil];

    }
}

@end
