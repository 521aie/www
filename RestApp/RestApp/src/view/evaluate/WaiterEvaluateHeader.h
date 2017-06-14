//
//  WaiterEvaluateHeader.h
//  RestApp
//
//  Created by xueyu on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarRatingView.H"
#import "WaiterEvaluateData.h"
#import "WaiterTotalEvaluateData.h"

#define STATUS_NO_SHOW 0
#define STATUS_UP 1
#define STATUS_DOWN 2
#define STATUS_SAME 3
#define LEVEL1 @"red"
#define LEVEL2 @"blue"
#define LEVEL3 @"yellow"

@class WaiterDetailView;
@interface WaiterEvaluateHeader : UIView
{
    WaiterDetailView *evaluateView;
}
@property (nonatomic, strong) IBOutlet UIImageView *waiterIcon;
@property (nonatomic, strong) UIView *listContainer;
@property (nonatomic, strong) IBOutlet UILabel *goodPrecent;
@property (nonatomic, strong) IBOutlet UILabel *evaluateScore;
@property (nonatomic, strong) IBOutlet UILabel *evaluateCount;
@property (nonatomic, strong) IBOutlet UILabel *waiterName;
@property (nonatomic, strong) IBOutlet UIView *starCount;
@property (nonatomic, strong) IBOutlet UIView *exprienceView;
@property (nonatomic, strong) StarRatingView *starRatingView;
@property (nonatomic, strong) NSMutableArray *totalData;
@property (nonatomic, strong) WaiterEvaluateData *evaluateData;

+ (WaiterEvaluateHeader *)createWaiterEvaluateHeader:(WaiterDetailView *)waiterDetailView;

- (void)initWithData:(NSMutableArray *)totalData andEvaluateData:(WaiterEvaluateData *)evaluateData;

@end
