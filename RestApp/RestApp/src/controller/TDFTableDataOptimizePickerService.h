//
//  TDFTableDataOptimizePickerService.h
//  RestApp
//
//  Created by LSArlen on 2017/6/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDFPickerItem;

#define OPTIMIZE_METHOD_MANUAL  @"OPTIMIZE_METHOD_MANUAL"       //手动优化
#define OPTIMIZE_METHOD_AUTO    @"OPTIMIZE_METHOD_AUTO"         //自动优化


typedef enum : NSUInteger {
    TDFTableDataOptimizePickerTypeOptimizeMethod,
    TDFTableDataOptimizePickerTypeBillType,
    TDFTableDataOptimizePickerTypeStartDate,
    TDFTableDataOptimizePickerTypeEndDate,
    TDFTableDataOptimizePickerTypeNumDay,
    TDFTableDataOptimizePickerTypePer,
} TDFTableDataOptimizePickerType;

@interface TDFTableDataOptimizePickerService : NSObject

@property (nonatomic, assign) TDFTableDataOptimizePickerType pickerType;

@property (nonatomic, assign) int defaultIndex;

- (instancetype)initWith:(TDFPickerItem *)pickerItem;


@end
