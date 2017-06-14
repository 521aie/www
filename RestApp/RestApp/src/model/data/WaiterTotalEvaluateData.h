//
//  WaiterTotalEvaluateData.h
//  RestApp
//
//  Created by xueyu on 15/9/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"
@interface WaiterTotalEvaluateData : Jastor
@property(nonatomic, assign) int goodStatus;
@property(nonatomic, assign) int badStatus;
@property(nonatomic, assign) int serviceStatus;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *goodPercent;
@property(nonatomic, assign) double perServiceQuality;
@property(nonatomic, assign) int goodCount;
@property(nonatomic, assign) int badCount;
@property(nonatomic, assign) int experience;
@property(nonatomic, strong) NSArray *experienceList;
@end
