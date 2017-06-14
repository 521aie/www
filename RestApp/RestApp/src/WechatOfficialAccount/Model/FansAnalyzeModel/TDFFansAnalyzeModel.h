//
//  TDFFansAnalyzeModel.h
//  RestApp
//
//  Created by Octree on 20/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBaseModel.h"
#import "TDFOAFanPieChartView.h"

@interface TDFFansAnalyzeItemModel : TDFBaseModel<TDFOAFanPieChartItemPresentable>

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *detail;
@property (assign, nonatomic) double ratio;
@property (assign, nonatomic) NSInteger count;

#pragma mark - Pie Presenter

@property (strong, nonatomic) UIColor *pieColor;
@property (copy, nonatomic, readonly) NSString *pieDescription;
@property (copy, nonatomic, readonly) NSString *highlightDescription;
@property (copy, nonatomic, readonly) NSString *commentTitle;
@property (copy, nonatomic, readonly) NSString *commentDescription;
@property (copy, nonatomic, readonly) NSString *commentRatioDescription;

@end

@interface TDFFansAnalyzeModel : TDFBaseModel<INameItem>

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger count;
@property (copy, nonatomic) NSArray *parts;

@end


