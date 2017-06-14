//
//  CustomEvalutaeCell.h
//  RestApp
//
//  Created by iOS香肠 on 15/9/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TotalEvaluateCellData.h"

#define  TotalEvaluateCellIndentifier @"TotalEvaluateCellIndentifier"

@interface TotalEvaluateCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *createdAt;
@property (nonatomic, strong) IBOutlet UIView *background;
@property (nonatomic, strong) IBOutlet UILabel *customNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *waiterNamelabel;
@property (nonatomic, strong) IBOutlet UILabel *commentForWaiterlabel;
@property (nonatomic, strong) IBOutlet UILabel *commentForShoplabel;
@property (nonatomic, strong) IBOutlet UIView *commentForShopView;
@property (nonatomic, strong) IBOutlet UIView *commentForWaiterView;
@property (nonatomic, strong) IBOutlet UIImageView *commentShopIco;
@property (nonatomic, strong) IBOutlet UIImageView *commentWaiterIco;

- (void)initWithData:(TotalEvaluateCellData *)data;

+ (CGFloat)totalHeight:(TotalEvaluateCellData *)commentData;

@end
