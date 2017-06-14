//
//  RefreshDataController.m
//  CardApp
//
//  Created by 邵建青 on 14-2-14.
//  Copyright (c) 2014年 ZMSOFT. All rights reserved.
//

#import "RefreshDataController.h"

@implementation RefreshDataController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isRefreshAble = YES;
    }
    return self;
}

- (void)initScrollView
{
    refreshDataHeader = [[[NSBundle mainBundle]loadNibNamed:@"RefreshDataHeader" owner:self options:nil]lastObject];
    [refreshDataHeader initView];
    [self.scrollContainer setDelegate:self];
    [self.scrollContainer addSubview:refreshDataHeader];
}

- (void)showRefreshHeader
{
    isRefreshAble = YES;
    [refreshDataHeader show];
}

- (void)hideRefreshHeader
{
    isRefreshAble = NO;
    [refreshDataHeader hide];
}

- (CGFloat)headerRefreshHeight
{
    if (refreshDataHeader != nil) {
        return refreshDataHeader.frame.size.height;
    } else {
        return 44;
    }
}

- (void)pinHeaderView
{
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.scrollContainer.contentInset = UIEdgeInsetsMake([self headerRefreshHeight], 0, 0, 0);
    }];
}

- (void)unpinHeaderView
{
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.scrollContainer.contentInset = UIEdgeInsetsZero;
    }];
}

- (void)refreshCompleted
{
    isRefreshing = NO;
    [self unpinHeaderView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    isDragging = NO;
    CGPoint point = scrollView.contentOffset;
    if (0 - point.y >= [self headerRefreshHeight]) {
        if (isRefreshing == NO) {
            [self refresh];
        }
    }
}

- (void)willBeginRefresh
{
    [self pinHeaderView];
}

- (BOOL)refresh
{
    if(isRefreshing) {
        return NO;
    }
    [self willBeginRefresh];
    isRefreshing = YES;
    return YES;
}

@end
