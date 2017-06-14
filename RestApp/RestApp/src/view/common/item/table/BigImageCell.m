//
//  BigImageCell.m
//  RestApp
//
//  Created by zxh on 14-5-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BigImageCell.h"

@implementation BigImageCell

- (IBAction)btnDelEvent:(id)sender
{
    [self.delegate delImg:self.obj];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //获取点击按钮的标题
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString(@"确认", nil)]) {
        [self.delegate delImg:self.obj];
    }
}

@end
