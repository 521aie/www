//
//  BgView.m
//  RestApp
//
//  Created by zxh on 14-7-18.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BgView.h"
#import "BackgroundHelper.h"
#import "UIView+Sizes.h"

@implementation BgView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"BgView" owner:self options:nil];
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self addSubview:self.view];
    [self initNotifaction];

    [self.view setHeight:SCREEN_HEIGHT];
    [self.imgBg setHeight:SCREEN_HEIGHT];
    [self setHeight:SCREEN_HEIGHT];
    
    [BackgroundHelper initWithMain:self.imgBg];
}

- (void)initNotifaction
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBgFinish:) name:Notification_BgImage__Change object:nil];
}

- (void)loadBgFinish:(NSNotification*) notification
{
    [self.imgBg setImage:[UIImage imageNamed:notification.object]];
}

@end
