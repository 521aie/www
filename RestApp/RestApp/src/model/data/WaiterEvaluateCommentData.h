//
//  WaiterEvaluateCommentData.h
//  RestApp
//
//  Created by xueyu on 15/9/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import <Foundation/Foundation.h>

@interface WaiterEvaluateCommentData : Jastor

@property (nonatomic, strong) NSString *customerName;
@property (nonatomic, assign) Byte commentStatus;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, assign) long long  createdAt;

@end
