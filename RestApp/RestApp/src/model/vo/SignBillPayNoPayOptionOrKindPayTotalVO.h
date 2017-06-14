//
//  SignBillPayNoPayOptionOrKindPayTotalVO.h
//  RestApp
//
//  Created by Shaojianqing on 15/7/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "INameValueItem.h"
#import <Foundation/Foundation.h>

@interface SignBillPayNoPayOptionOrKindPayTotalVO : NSObject<INameValueItem>

/**
 * 支付方式Id.
 */
@property (nonatomic, strong) NSString *kindPayId;
/**
 * 支付方式名称.
 */
@property (nonatomic, strong) NSString *kindPayName;
/**
 * 支付数据列表.
 */
@property (nonatomic, strong) NSMutableArray *signBillPayNoPayOptionTotalVOList;

+ (SignBillPayNoPayOptionOrKindPayTotalVO *)convertToSignBillPayNoPayOptionOrKindPayTotalVO:(NSDictionary *)dictionary;

+ (NSMutableArray *)convertToSignBillPayNoPayOptionOrKindPayTotalList:(NSArray *)list;

@end
