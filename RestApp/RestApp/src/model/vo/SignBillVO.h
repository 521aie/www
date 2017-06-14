//
//  SignBillVO.h
//  RestApp
//
//  Created by Shaojianqing on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignBillVO : NSObject
/**
 * 挂账金额.
 */
@property (nonatomic) double fee;
/**
 * 实收额.
 */
@property (nonatomic) double realFee;
/**
 * 还款类型.
 */
@property (nonatomic, strong) NSString *payModeId;
/**
 * 挂账人（配合原来的需合，所要传的值）.
 */
@property (nonatomic, strong) NSString *company;
/**
 * 备注.
 */
@property (nonatomic, strong) NSString *memo;

- (NSDictionary *)dictionaryData;

@end
