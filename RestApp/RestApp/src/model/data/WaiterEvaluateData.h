//
//  WaiterEvaluateData.h
//  RestApp
//
//  Created by xueyu on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"
@interface WaiterEvaluateData : Jastor
@property (nonatomic, strong) NSString *userAvatar;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *job;
@property (nonatomic, assign) double perServiceQuality;
@property (nonatomic, strong) NSString *goodPercent;
@property (nonatomic, assign) int totalComment;
@property (nonatomic, strong) NSString *experienceType;
@property (nonatomic, assign) int experienceCount;
@property (nonatomic, strong) NSString *employeeId;
@property (nonatomic, strong) NSString *waiterId;

@end
