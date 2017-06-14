//
//  RefreshDataController.h
//  CardApp
//
//  Created by 邵建青 on 14-2-14.
//  Copyright (c) 2014年 ZMSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshDataHeader.h"

@interface RefreshDataController : UIViewController<UIScrollViewDelegate>
{
    BOOL isDragging;
    
    BOOL isRefreshing;
    
    BOOL isRefreshAble;
    
    RefreshDataHeader *refreshDataHeader;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollContainer;

- (void)initScrollView;

- (void)pinHeaderView;

- (void)unpinHeaderView;

- (void)showRefreshHeader;

- (void)hideRefreshHeader;

- (BOOL)refresh;

- (void)refreshCompleted;

@end
