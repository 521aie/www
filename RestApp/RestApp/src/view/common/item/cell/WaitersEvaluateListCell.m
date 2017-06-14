//
//  WaitersEvaluateListCell.m
//  RestApp
//
//  Created by xueyu on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WaitersEvaluateListCell.h"
#import "UIImageView+TDFRequest.h"
#import "StarRatingView.h"

#define LEVEL1 @"red"
#define LEVEL2 @"blue"
#define LEVEL3 @"yellow"

@implementation WaitersEvaluateListCell

- (void)awakeFromNib
{
    self.rect =  self.experienceView.bounds;
}

- (void)initWithData:(WaiterEvaluateData *)waiter
{
    self.waiter = waiter;
    [self.waiterIcon tdf_imageRequstWithPath:waiter.userAvatar placeholderImage:[UIImage imageNamed:@"img_pj_waiter"] urlModel:ImageUrlCapture];
    self.waiterName.text = waiter.userName;
    self.roleLbl.text = waiter.job;
    self.goodPercent.text = [NSString stringWithFormat:NSLocalizedString(@"好评率%@", nil), self.waiter.goodPercent];
    self.score.text = [NSString stringWithFormat:NSLocalizedString(@"%.1f分", nil), waiter.perServiceQuality];
    
    CGRect expeerienceRect = self.experienceView.frame;
    expeerienceRect.size.width = 16*waiter.experienceCount;
    self.experienceView.frame = expeerienceRect;
    
    for (UIView *view in self.experienceView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i=0;i<waiter.experienceCount; i++) {
        UIImageView *image =[[UIImageView alloc]initWithFrame:CGRectMake(i*16 , 0, 16, 16)];
        image.image = [UIImage imageNamed:@"ico_lvl_1.png"];
        [self.experienceView addSubview:image];
    }
    
    CGRect rectGoodPercent = self.goodPercent.frame;
    rectGoodPercent.origin.x = expeerienceRect.size.width + expeerienceRect.origin.x;
    self.goodPercent.frame = rectGoodPercent;
    
    if (self.starRateImg != nil) {
        [self.starRateImg removeFromSuperview];
    }
    
    CGRect rect = self.starRatingView.frame;
    self.starRateImg = [[StarRatingView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) starLevel:waiter.perServiceQuality];
    [self.starRatingView addSubview:self.starRateImg];
     self.evaluateCount.text = [NSString stringWithFormat:NSLocalizedString(@"(%d个评价)", nil),waiter.totalComment];
}

@end
