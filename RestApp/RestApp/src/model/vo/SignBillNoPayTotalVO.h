//
//  SignBillNoPayTotalVO.h
//  RestApp
//
//  Created by Shaojianqing on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignBillNoPayTotalVO : NSObject
/**
 * 统计项总数量.
 */
@property (nonatomic) NSUInteger count;
/**
 * 综合挂账列表.
 */
@property (nonatomic, strong) NSMutableArray *signBillNoPayVOs;

+ (SignBillNoPayTotalVO *)convertToSignBillNoPayTotalVO:(NSDictionary *)dictionary;

+ (NSMutableArray *)convertToSignBillNoPayTotalList:(NSArray *)list;

@end
