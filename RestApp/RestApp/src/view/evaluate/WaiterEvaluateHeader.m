//
//  WaiterEvaluateHeader.m
//  RestApp
//
//  Created by xueyu on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ItemFactory.h"
#import "WaiterEvaluateHeader.h"
#import "WaiterTotalEvaluateItem.h"
#import "UIImageView+WebCache.h"
#import "StarRatingView.h"

@implementation WaiterEvaluateHeader

+ (WaiterEvaluateHeader *)createWaiterEvaluateHeader:(WaiterDetailView *)waiterDetailView
{
    WaiterEvaluateHeader *evaluateHeader = [[[NSBundle mainBundle]loadNibNamed:@"WaiterEvaluateHeader" owner:self options:nil]lastObject];
    return evaluateHeader;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addSubview:self.listContainer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    frame.size.height = 330;
    self.frame = frame;
}

- (UIView *)listContainer {
    if(!_listContainer) {
        _listContainer = [[UIView alloc] init];
        _listContainer.frame = CGRectMake(0, 80, SCREEN_WIDTH, 250);
        _listContainer.layer.masksToBounds = YES;
    }
    return _listContainer;
}

-(void)renderDetailView
{   
    for (int i =0 ; i < 3; i++) {
        WaiterTotalEvaluateItem *waiterTotalEvaluateItem = [ItemFactory getWaiterTotalEvaluateItem];
        WaiterTotalEvaluateData *monthData = self.totalData[i];
        waiterTotalEvaluateItem.month.text = monthData.title;
        waiterTotalEvaluateItem.goodCount.text = [self intToString:monthData.goodCount];
        waiterTotalEvaluateItem.goodStatus.image = [self imageStatusForWaiter:monthData.goodStatus];
        waiterTotalEvaluateItem.badCount.text = [self intToString:monthData.badCount];
        waiterTotalEvaluateItem.badStatus.image = [self imageStatusForWaiter:monthData.badStatus];
        waiterTotalEvaluateItem.serviceScore.text = [self doubleToString:monthData.perServiceQuality];
        waiterTotalEvaluateItem.serviceStatus.image = [self imageStatusForWaiter:monthData.serviceStatus];
        waiterTotalEvaluateItem.frame = CGRectMake(0,80*i, SCREEN_WIDTH, 80);
        [self.listContainer addSubview:waiterTotalEvaluateItem];
    }
}

- (void)resetDetailView
{
    for (WaiterTotalEvaluateItem *item in self.listContainer.subviews) {
        [item removeFromSuperview];
        [ItemFactory restoreWaiterTotalEvaluateItem:item];
    }
}

- (void)initWithData:(NSMutableArray *)totalData andEvaluateData:(WaiterEvaluateData *)evaluateData
{
    self.totalData = totalData;
    self.waiterName.text =  evaluateData.userName;
    [self.waiterIcon sd_setImageWithURL:[NSURL URLWithString:evaluateData.userAvatar] placeholderImage:[UIImage imageNamed:@"img_pj_waiter"]];
    
    if (self.starRatingView!=nil) {
        [self.starRatingView removeFromSuperview];
    }
    
    CGRect rect = self.starCount.frame;
    self.starRatingView = [[StarRatingView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) starLevel:evaluateData.perServiceQuality];
    [self.starCount addSubview:self.starRatingView];
    self.evaluateCount.text = [NSString stringWithFormat:NSLocalizedString(@"(%d个评价)", nil),evaluateData.totalComment];
    self.evaluateScore.text = [NSString stringWithFormat:NSLocalizedString(@"%.1f分", nil),evaluateData.perServiceQuality];

    [self resetDetailView];
    [self renderDetailView];
    [self renderStarSignView:evaluateData];
}

- (void)renderStarSignView:(WaiterEvaluateData *)evaluateData
{
    CGRect experienceRect = self.exprienceView.frame;
    experienceRect.size.width = 16*evaluateData.experienceCount;
    self.exprienceView.frame = experienceRect;
    
    self.goodPrecent.text = [NSString stringWithFormat:NSLocalizedString(@"好评率%@", nil),evaluateData.goodPercent];
    CGRect rectGoodPercent = self.goodPrecent.frame;
    rectGoodPercent.origin.x = experienceRect.size.width + experienceRect.origin.x;
    self.goodPrecent.frame = rectGoodPercent;
    
    for (UIView *view in self.exprienceView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i=0;i<evaluateData.experienceCount; i++) {
        UIImageView *image =[[UIImageView alloc]initWithFrame:CGRectMake(i*16 , 0, 16, 16)];
        image.image = [UIImage imageNamed:@"ico_lvl_1.png"];
        [self.exprienceView addSubview:image];
    }
}

- (UIImage *)imageStatusForWaiter:(int)status
{
    if (status == STATUS_UP) {
        return [UIImage imageNamed:@"ico_lvl_up"];
    } else if (status == STATUS_DOWN) {
        return [UIImage imageNamed:@"ico_lvl_down"];
    } else if (status == STATUS_SAME){
        return [UIImage imageNamed:@"ico_lvl_unchange"];
    }
    
    return nil;
}

- (UIImage *)imageStatusForWaiterLevel:(NSString *)experienceType
{
    if ([experienceType isEqualToString:LEVEL2]) {
        return [UIImage imageNamed:@"ico_lvl_2"];
    } else if ([experienceType isEqualToString:LEVEL3]){
        return [UIImage imageNamed:@"ico_lvl_3"];
    }
    return [UIImage imageNamed:@"ico_lvl_1"];
}

- (NSString *)intToString:(int)number
{
    return [NSString stringWithFormat:@"%d",number];
}

- (NSString *)doubleToString:(double) number
{
    return [NSString stringWithFormat:@"%.1f",number];
}

@end
