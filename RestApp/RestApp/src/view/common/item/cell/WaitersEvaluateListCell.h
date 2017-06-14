//
//  WaitersEvaluateListCell.h
//  RestApp
//
//  Created by xueyu on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarRatingView.h"
#import "WaiterEvaluateData.h"

#define WaiterEvaluateCellIndentifier @"WaiterEvaluateCellIndentifier"

@interface WaitersEvaluateListCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *background;
@property (nonatomic, strong) IBOutlet UIImageView *waiterIcon;
@property (nonatomic, strong) IBOutlet UILabel *waiterName;
@property (nonatomic, strong) IBOutlet UILabel *goodPercent;
@property (nonatomic, strong) IBOutlet UILabel *score;
@property (nonatomic, strong) IBOutlet UILabel *roleLbl;
@property (nonatomic, strong) IBOutlet UILabel *evaluateCount;
@property (nonatomic, strong) IBOutlet UIView *starRatingView;
@property (nonatomic, strong) IBOutlet UIView *experienceView;
@property (nonatomic, strong) StarRatingView *starRateImg;
@property (nonatomic, strong) WaiterEvaluateData *waiter;
@property (nonatomic, assign) CGRect rect;

-(void)initWithData:(WaiterEvaluateData *)waiter;

@end
