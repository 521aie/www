//
//  TDFExpanableLabel.m
//  TDFMessage
//
//  Created by Octree on 9/1/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "TDFExpanableLabel.h"

@implementation TDFExpanableLabel

- (CGSize)sizeThatFits:(CGSize)size {

    if (self.numberOfLines == 0) {
        size.width -= self.horizontalExpan;
        CGSize fitSize = [super sizeThatFits:size];
        fitSize.height += self.verticalExpan;
        fitSize.width += self.horizontalExpan;
        return fitSize;
    }
    CGSize fitSize = [super sizeThatFits:size];
    fitSize.height += self.verticalExpan;
    fitSize.width += self.horizontalExpan;
    return fitSize;
}

/// Expand When Use AutoLayout
- (CGSize)intrinsicContentSize {

    CGSize fitSize = [super intrinsicContentSize];
    
    if (self.numberOfLines == 0) {
        fitSize = [self sizeThatFits:fitSize];
        return fitSize;
    }
    
    fitSize.height += self.verticalExpan;
    fitSize.width += self.horizontalExpan;
    return fitSize;
}



- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {self.verticalExpan / 2, self.horizontalExpan / 2, self.verticalExpan / 2, self.horizontalExpan / 2};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


@end
