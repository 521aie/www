//
//  NameValueCell44.m
//  RestApp
//
//  Created by zxh on 14-7-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "NameValueCell44.h"
#import "UIView+Sizes.h"

@implementation NameValueCell44
-(void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        UIView* scrollView=self.subviews[0];
        for (UIView* view in scrollView.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString:@"Reorder"].location!=NSNotFound) {
                for (UIView* subView in view.subviews) {
                    if ([subView isKindOfClass:[UIImageView class]]) {
                        UIImageView* imgSort=(UIImageView*)subView;
                        imgSort.image=[UIImage imageNamed:@"ico_sort_table.png"];
                        [imgSort setHeight:22];
                    }
                }
            }
        }
    }
    
    for( UIView* subview in self.subviews ) {
        if( [NSStringFromClass(subview.class) isEqualToString:@"UITableViewCellEditControl"] ) {
            subview.hidden = YES;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for(UIView* subview in self.subviews) {

        if( [NSStringFromClass(subview.class) isEqualToString:@"UITableViewCellContentView"] ) {
            CGRect frame = subview.frame;
            frame.size.width += frame.origin.x;
            frame.origin.x = 0;
            subview.frame = frame;
        }
    }
}

@end
