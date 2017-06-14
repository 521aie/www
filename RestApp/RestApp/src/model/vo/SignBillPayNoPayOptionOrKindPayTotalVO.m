//
//  SignBillPayNoPayOptionOrKindPayTotalVO.m
//  RestApp
//
//  Created by Shaojianqing on 15/7/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ObjectUtil.h"
#import "SignBillPayNoPayOptionTotalVO.h"
#import "SignBillPayNoPayOptionOrKindPayTotalVO.h"

@implementation SignBillPayNoPayOptionOrKindPayTotalVO

+ (SignBillPayNoPayOptionOrKindPayTotalVO *)convertToSignBillPayNoPayOptionOrKindPayTotalVO:(NSDictionary *)dictionary
{
    if ([ObjectUtil isNotNull:dictionary]) {
        SignBillPayNoPayOptionOrKindPayTotalVO *signBillPayNoPayOptionOrKindPayTotalVO = [[SignBillPayNoPayOptionOrKindPayTotalVO alloc]init];
        signBillPayNoPayOptionOrKindPayTotalVO.kindPayId = [dictionary objectForKey:@"kindPayId"];
        signBillPayNoPayOptionOrKindPayTotalVO.kindPayName = [dictionary objectForKey:@"kindPayName"];
        NSMutableArray *dataList = [dictionary objectForKey:@"signBillPersons"];
        signBillPayNoPayOptionOrKindPayTotalVO.signBillPayNoPayOptionTotalVOList = [SignBillPayNoPayOptionTotalVO convertToSignBillPayNoPayOptionTotalList:dataList];
        return signBillPayNoPayOptionOrKindPayTotalVO;
    }
    return  nil;
}

+ (NSMutableArray *)convertToSignBillPayNoPayOptionOrKindPayTotalList:(NSArray *)list
{
    if ([ObjectUtil isNotEmpty:list]) {
        NSMutableArray *resultList = [[NSMutableArray alloc]initWithCapacity:list.count];
        for (NSDictionary *dictionary in list) {
            [resultList addObject:[SignBillPayNoPayOptionOrKindPayTotalVO convertToSignBillPayNoPayOptionOrKindPayTotalVO:dictionary]];
        }
        return resultList;
    }
    return nil;
}

-(NSString*) obtainItemId
{
    return self.kindPayId;
}

-(NSString*) obtainItemName
{
    return self.kindPayName;
}

-(NSString*) obtainOrignName
{
    return self.kindPayName;
}

-(NSString*) obtainItemValue
{
    return self.kindPayId;
}

@end
