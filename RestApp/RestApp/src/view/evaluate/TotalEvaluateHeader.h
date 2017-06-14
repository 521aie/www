//
//  TotalEvaluateHeader.h
//  RestApp
//
//  Created by Shaojianqing on 15/9/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OPERATE_BTN_HEIGHT 40

@class TotalEvaluateView;
@interface TotalEvaluateHeader : UIView
{
    TotalEvaluateView *evaluateView;
    
    CGFloat collapseHeight;
    
    CGFloat expandedHeight;
    
    BOOL isExpanded;
}

@property (nonatomic, strong) UIView *listContainer;
@property (nonatomic, strong) UIView *operContainer;
@property (nonatomic, strong) NSArray *totalEvaluateDataList;

+ (TotalEvaluateHeader *)createTotalEvaluateHeader:(TotalEvaluateView *)evaluateView;

- (void)initWithData:(NSArray *)list;

- (IBAction)operateBtnClick:(id)sender;

- (void)collapseHeader;

- (void)expandeHeader;

@end
