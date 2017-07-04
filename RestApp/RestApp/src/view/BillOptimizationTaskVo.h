//
//  BillOptimizationTaskVo.h
//  RestApp
//
//  Created by 栀子花 on 16/5/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface BillOptimizationTaskVo : Jastor
@property (nonatomic, assign) double taskType;//任务类型
@property (nonatomic, strong) NSString *taskId;//账单优化任务id
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, assign) int turnoverPercent;//营业额的百分比
@property (nonatomic, strong) NSString *entityId;
@property (nonatomic, assign) BOOL onOff;//自动隐藏账单开关
@property (nonatomic, assign) int billOptimizationType;
@property (nonatomic, assign) int billQuantityPercent;//账单数量百分比
@property (nonatomic, assign) long createTime;
@property (nonatomic, assign) int dateOffSet;//自动隐藏的日期偏移




@end
