//
//  SignBillPayTotalVO.m
//  RestApp
//
//  Created by Shaojianqing on 15/7/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ObjectUtil.h"
#import "SignBillNoPayVO.h"
#import "SignBillPayTotalVO.h"
#import "SignBillPayNoPayOptionOrKindPayTotalVO.h"

@implementation SignBillPayTotalVO

+ (SignBillPayTotalVO *)convertToSignBillPayTotalVO:(NSDictionary *)dictionary
{
    if ([ObjectUtil isNotNull:dictionary]) {
        SignBillPayTotalVO *signBillPayTotalVO = [[SignBillPayTotalVO alloc]init];
        signBillPayTotalVO.count = [ObjectUtil getIntegerValue:dictionary key:@"count"];
        signBillPayTotalVO.fee = [ObjectUtil getDoubleValue:dictionary key:@"fee"];
        NSMutableArray *noPaylist = [dictionary objectForKey:@"signBillKindPays"];
        NSMutableArray *signBillNoPayVOList = [dictionary objectForKey:@"signBillPersonDetailVos"];
        signBillPayTotalVO.noPaylist = [SignBillPayNoPayOptionOrKindPayTotalVO convertToSignBillPayNoPayOptionOrKindPayTotalList:noPaylist];
        signBillPayTotalVO.signBillNoPayVOList = [SignBillNoPayVO convertToSignBillNoPayList:signBillNoPayVOList];
        return signBillPayTotalVO;
    }
    return  nil;
}

+ (NSMutableArray *)convertToSignBillPayTotalList:(NSArray *)list
{
    if ([ObjectUtil isNotEmpty:list]) {
        NSMutableArray *resultList = [[NSMutableArray alloc]initWithCapacity:list.count];
        for (NSDictionary *dictionary in list) {
            [resultList addObject:[SignBillPayTotalVO convertToSignBillPayTotalVO:dictionary]];
        }
        return resultList;
    }
    return nil;
}

@end
