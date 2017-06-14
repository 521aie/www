//
//  TDFBusinessFlowHeaderView.h
//  RestApp
//
//  Created by happyo on 2016/11/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TDFPayInfoModel;
@class TDFBusinessFlowHeaderView;

@interface TDFPayInfoView : UIView

- (void)configureViewWithModel:(TDFPayInfoModel *)model;

@end

@protocol TDFBusinessFlowHeaderViewDelegate <NSObject>

- (void)businessFlowHeaderView:(TDFBusinessFlowHeaderView *)headerView didSelectedModel:(TDFPayInfoModel *)model;

@end

@interface TDFBusinessFlowHeaderView : UIView

@property (nonatomic, weak) id<TDFBusinessFlowHeaderViewDelegate> delegate;

- (void)configureViewWithPayInfoList:(NSArray<TDFPayInfoModel *> *)payInfoList;

@end
