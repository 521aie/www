//
//  SignBillNoPayVO.m
//  RestApp
//
//  Created by Shaojianqing on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ObjectUtil.h"
#import "SignBillNoPayVO.h"

@implementation SignBillNoPayVO

+ (SignBillNoPayVO *)convertToSignBillNoPayVO:(NSDictionary *)dictionary
{
    if ([ObjectUtil isNotNull:dictionary]) {
        SignBillNoPayVO *signBillNoPayVO = [[SignBillNoPayVO alloc]init];
        signBillNoPayVO.payId = [dictionary objectForKey:@"payId"];
        signBillNoPayVO.kindPayDetailOptionId = [dictionary objectForKey:@"kindPayDetailOptionId"];
        signBillNoPayVO.memo = [dictionary objectForKey:@"memo"];
        signBillNoPayVO.fee = [ObjectUtil getDoubleValue:dictionary key:@"fee"];
        signBillNoPayVO.signDate = [ObjectUtil getLonglongValue:dictionary key:@"signDate"];
        signBillNoPayVO.flowno = [dictionary objectForKey:@"flowNo"];
        signBillNoPayVO.orderId = [dictionary objectForKey:@"orderId"];
        signBillNoPayVO.totalPayId = [dictionary objectForKey:@"totalPayId"];
        signBillNoPayVO.displaySignDate = [dictionary objectForKey:@"displaySignDate"];
        signBillNoPayVO.time = [dictionary objectForKey:@"time"];
        signBillNoPayVO.signMemo = [dictionary objectForKey:@"signMemo"];
        return signBillNoPayVO;
    }
    return  nil;
}

+ (NSMutableArray *)convertToSignBillNoPayList:(NSArray *)list
{
    if ([ObjectUtil isNotEmpty:list]) {
        NSMutableArray *resultList = [[NSMutableArray alloc]initWithCapacity:list.count];
        for (NSDictionary *dictionary in list) {
            [resultList addObject:[SignBillNoPayVO convertToSignBillNoPayVO:dictionary]];
        }
        return resultList;
    }
    return nil;
}

@end
