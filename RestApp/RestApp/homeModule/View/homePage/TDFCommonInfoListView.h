//
//  TDFCommonInfoListView.h
//  RestApp
//
//  Created by happyo on 2017/4/19.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TDFHomeReportListCellModel;

@interface TDFCommonInfoListView : UIView

@property (nonatomic, assign) CGFloat heightForView;

- (void)configureViewWithModelList:(NSArray<TDFHomeReportListCellModel *> *)modelList;

@end
