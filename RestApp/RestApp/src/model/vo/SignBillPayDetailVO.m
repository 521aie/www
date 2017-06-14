//
//  SignBillPayDetailVO.m
//  RestApp
//
//  Created by Shaojianqing on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ObjectUtil.h"
#import "SignBillPayDetailVO.h"

@implementation SignBillPayDetailVO

+ (SignBillPayDetailVO *)convertToSignBillPayDetailVO:(NSDictionary *)dictionary
{
    if ([ObjectUtil isNotNull:dictionary]) {
        SignBillPayDetailVO *signBillPayDetailVO = [[SignBillPayDetailVO alloc]init];
        signBillPayDetailVO.payId = [dictionary objectForKey:@"payId"];
        signBillPayDetailVO.pay = [ObjectUtil getDoubleValue:dictionary key:@"pay"];
        signBillPayDetailVO.payTime = [ObjectUtil getLonglongValue:dictionary key:@"signDate"];
        signBillPayDetailVO.code = [dictionary objectForKey:@"code"];
        signBillPayDetailVO.userName = [dictionary objectForKey:@"userName"];
        signBillPayDetailVO.kindPayName = [dictionary objectForKey:@"kindPayName"];
        signBillPayDetailVO.displaySignDate = [dictionary objectForKey:@"displaySignDate"];
        signBillPayDetailVO.signMemo = [dictionary objectForKey:@"signMemo"];
        signBillPayDetailVO.flowNo  = [dictionary objectForKey:@"flowNo"];
        signBillPayDetailVO.fee  = [ObjectUtil getDoubleValue:dictionary key:@"fee"];
        return signBillPayDetailVO;
    }
    return  nil;
}

+ (NSMutableArray *)convertToSignBillPayDetailList:(NSArray *)list
{
    if ([ObjectUtil isNotEmpty:list]) {
        NSMutableArray *resultList = [[NSMutableArray alloc]initWithCapacity:list.count];
        for (NSDictionary *dictionary in list) {
            [resultList addObject:[SignBillPayDetailVO convertToSignBillPayDetailVO:dictionary]];
        }
        return resultList;
    }
    return nil;
}

@end
