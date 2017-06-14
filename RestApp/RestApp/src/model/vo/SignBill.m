//
//  SignBill.m
//  RestApp
//
//  Created by Shaojianqing on 15/7/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignBill.h"
#import "ObjectUtil.h"

@implementation SignBill

+ (SignBill *)convertToSignBill:(NSDictionary *)dictionary
{
    if ([ObjectUtil isNotNull:dictionary]) {
        SignBill *signBill = [[SignBill alloc]init];
        signBill.signBillId = [dictionary objectForKey:@"signBillId"];
        signBill.kindPayDetailOptionId = [dictionary objectForKey:@"kindPayDetailOptionId"];
        signBill.company = [dictionary objectForKey:@"signBillPerson"];//服务端接口改变统一为signBillPerson
        signBill.fee = [ObjectUtil getDoubleValue:dictionary key:@"fee"];
        signBill.realFee = [ObjectUtil getDoubleValue:dictionary key:@"realFee"];
        signBill.operatorName = [dictionary objectForKey:@"payee"];
        signBill.payTime = [ObjectUtil getLonglongValue:dictionary key:@"payTime"];
        signBill.payName = [dictionary objectForKey:@"payWay"];
        signBill.memo = [dictionary objectForKey:@"memo"];
        signBill.payModeId = [dictionary objectForKey:@"payModeId"];
        signBill.entityId = [dictionary objectForKey:@"entityId"];
//        signBill.displayCreateTime = [dictionary objectForKey:@"payTime"];//服务端接口改变统一为payTime
        signBill.signBillPerson = [dictionary objectForKey:@"signBillPerson"];
        return signBill;
    }
    return  nil;
}

+ (NSMutableArray *)convertToSignBillList:(NSArray *)list
{
    if ([ObjectUtil isNotEmpty:list]) {
        NSMutableArray *resultList = [[NSMutableArray alloc]initWithCapacity:list.count];
        for (NSDictionary *dictionary in list) {
            [resultList addObject:[SignBill convertToSignBill:dictionary]];
        }
        return resultList;
    }
    return nil;
}

@end
