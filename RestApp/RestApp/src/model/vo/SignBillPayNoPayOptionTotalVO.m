//
//  SignBillPayNoPayOptionTotalVO.m
//  RestApp
//
//  Created by Shaojianqing on 15/7/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ObjectUtil.h"
#import "SignBillPayNoPayOptionTotalVO.h"

@implementation SignBillPayNoPayOptionTotalVO

+ (SignBillPayNoPayOptionTotalVO *)convertToSignBillPayNoPayOptionTotalVO:(NSDictionary *)dictionary
{
    if ([ObjectUtil isNotNull:dictionary]) {
        SignBillPayNoPayOptionTotalVO *signBillPayNoPayOptionTotalVO = [[SignBillPayNoPayOptionTotalVO alloc]init];
        signBillPayNoPayOptionTotalVO.kindPayDetailOptionId = [dictionary objectForKey:@"kindPayDetailOptionId"];
        signBillPayNoPayOptionTotalVO.name = [dictionary objectForKey:@"name"];
        signBillPayNoPayOptionTotalVO.payCount = [ObjectUtil getIntegerValue:dictionary key:@"count"];
        signBillPayNoPayOptionTotalVO.fee = [ObjectUtil getDoubleValue:dictionary key:@"fee"];
        signBillPayNoPayOptionTotalVO.kindPayId = [dictionary objectForKey:@"kindPayId"];
        signBillPayNoPayOptionTotalVO.payIdsStr = [dictionary objectForKey:@"payIds"];
        return signBillPayNoPayOptionTotalVO;
    }
    return  nil;
}

+ (NSMutableArray *)convertToSignBillPayNoPayOptionTotalList:(NSArray *)list
{
    if ([ObjectUtil isNotEmpty:list]) {
        NSMutableArray *resultList = [[NSMutableArray alloc]initWithCapacity:list.count];
        for (NSDictionary *dictionary in list) {
            [resultList addObject:[SignBillPayNoPayOptionTotalVO convertToSignBillPayNoPayOptionTotalVO:dictionary]];
        }
        return resultList;
    }
    return nil;
}

@end
