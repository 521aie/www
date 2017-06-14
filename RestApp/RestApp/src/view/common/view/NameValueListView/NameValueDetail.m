//
//  NameValueDetail.m
//  RestApp
//
//  Created by 刘红琳 on 16/1/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "NameValueDetail.h"
#import "UIView+Sizes.h"
@implementation NameValueDetail

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
}
@end
