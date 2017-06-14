//
//  BackupPrinterCell.m
//  RestApp
//
//  Created by SHAOJIANQING-MAC on 14-11-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BackupPrinterCell.h"
#import "UIView+Sizes.h"

@implementation BackupPrinterCell

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
