//
//  SignBillNoPayTotalVO.m
//  RestApp
//
//  Created by Shaojianqing on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ObjectUtil.h"
#import "SignBillNoPayVO.h"
#import "SignBillNoPayTotalVO.h"

@implementation SignBillNoPayTotalVO

+ (SignBillNoPayTotalVO *)convertToSignBillNoPayTotalVO:(NSDictionary *)dictionary
{
    if ([ObjectUtil isNotNull:dictionary]) {
        SignBillNoPayTotalVO *signBillNoPayTotalVO = [[SignBillNoPayTotalVO alloc]init];
        signBillNoPayTotalVO.count = [ObjectUtil getIntegerValue:dictionary key:@"count"];
        NSMutableArray *dataList = [dictionary objectForKey:@"signBillNoPayVOs"];
        signBillNoPayTotalVO.signBillNoPayVOs = [SignBillNoPayVO convertToSignBillNoPayList:dataList];
        return signBillNoPayTotalVO;
    }
    return  nil;
}

+ (NSMutableArray *)convertToSignBillNoPayTotalList:(NSArray *)list
{
    if ([ObjectUtil isNotEmpty:list]) {
        NSMutableArray *resultList = [[NSMutableArray alloc]initWithCapacity:list.count];
        for (NSDictionary *dictionary in list) {
            [resultList addObject:[SignBillNoPayTotalVO convertToSignBillNoPayTotalVO:dictionary]];
        }
        return resultList;
    }
    return nil;
}


@end
