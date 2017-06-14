//
//  CouponItemCell.h
//  RestApp
//
//  Created by 邵建青 on 15-1-13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SysNotification.h"

#define LIFE_INFO_TOP_MARGIN 20
#define LIFE_INFO_BTM_MARGIN 20
#define LIFE_INFO_HEAD_HEIGHT 40

#define NOTIFICATION_INFO_ITEM @"NOTIFICATION_INFO_ITEM"
#define NOTIFICATION_HEAD_HEIGHT 40

#define NOTIFICATION_ITEM_CELL @"NOTIFICATION_ITEM_CELL"

@class LifeInfoListView;
@interface NotificationItemCell : UITableViewCell
{
    LifeInfoListView *parent;
    
    NSArray *subViews;
    
    CGFloat height;
    
    CGFloat minLabelHeight;
}

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *hotLbl;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *separateLine;
@property (nonatomic, strong) UIView *containerBg;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIImageView *infoImg;
@property (nonatomic, strong) UIImageView *hotImg;

//+ (id)getInstance;

+ (CGFloat)calculateItemHeight:(SysNotification *)note;

- (void)initWithData:(SysNotification *)notification;

@end
