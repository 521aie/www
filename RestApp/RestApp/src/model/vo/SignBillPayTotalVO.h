//
//  SignBillPayTotalVO.h
//  RestApp
//
//  Created by Shaojianqing on 15/7/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignBillPayTotalVO : NSObject

/**
 * 统计项总数量.
 */
@property (nonatomic) NSUInteger count;
/**
 * 统计项总金额.
 */
@property (nonatomic) double fee;
/**
 * 综合挂账列表.
 */
@property (nonatomic, strong) NSMutableArray *noPaylist;
/**
 * 未还款挂账列表.
 */
@property (nonatomic, strong) NSMutableArray *signBillNoPayVOList;

+ (SignBillPayTotalVO *)convertToSignBillPayTotalVO:(NSDictionary *)dictionary;

+ (NSMutableArray *)convertToSignBillPayTotalList:(NSArray *)list;

@end
