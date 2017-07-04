//
//  TDFTableDataOptimizeViewModel.h
//  RestApp
//
//  Created by LSArlen on 2017/6/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDFTableDataOptimizeController,BillOptimizationTaskVo,TDFPickerItem;

@interface TDFTableDataOptimizeViewModel : NSObject


- (instancetype)initWith:(TDFTableDataOptimizeController *)controller;

- (void)changeOptimizeMethod;           //更改优化类型的操作
- (void)changeMamualOptimizeBillType;   //更改手动优化账单类型操作
- (void)changeAutoOptimizeBillType;     //更改自动优化账单类型操作


- (void)loadData;


- (void)saveMamualData;
- (void)clearMamualData;
- (void)mamualOptimizeStatus:(BOOL)optimized;
- (void)mamualClearTime:(long)time;



- (void)autoClearData;
- (void)saveAutoData;

@end
