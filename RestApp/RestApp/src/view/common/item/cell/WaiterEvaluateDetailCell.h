//
//  WaiterEvaluateDetailCell.h
//  RestApp
//
//  Created by xueyu on 15/9/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaiterEvaluateCommentData.h"

#define STATUS_GOOD 1
#define STATUS_BAD 0

#define WaiterEvaluateDetailCellIndentifier @"WaiterEvaluateDetailCellIndentifier"

@interface WaiterEvaluateDetailCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *background;
@property (nonatomic, strong) IBOutlet UIImageView *customerIcon;
@property (nonatomic, strong) IBOutlet UILabel *customerName;
@property (nonatomic, strong) IBOutlet UILabel *evaluateDate;
@property (nonatomic, strong) IBOutlet UILabel *evaluateComment;
@property (nonatomic, strong) IBOutlet UIView *seperateLine;

+ (CGFloat)totalHeight:(WaiterEvaluateCommentData *)commentData;

- (void)initWithData:(WaiterEvaluateCommentData *)commentData;

@end
