//
//  TownsVo.m
//  RestApp
//
//  Created by 刘红琳 on 15/12/4.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "TownsVo.h"
#import "ObjectUtil.h"
#import "FormatUtil.h"
@implementation TownsVo
+ (NSMutableArray *)convertToTownArr:(NSArray *)array
{
    if ([ObjectUtil isNotEmpty:array]) {
        NSMutableArray *townsList = [[NSMutableArray alloc]initWithCapacity:array.count];
        for (NSDictionary *dictionary in array) {
            TownsVo *townsVo = [[TownsVo alloc]init];
            townsVo.cityId =[FormatUtil formatString2: [dictionary objectForKey:@"cityId"]];
            townsVo.townId =[FormatUtil formatString2: [dictionary objectForKey:@"townId"]];
            townsVo.townName = [FormatUtil formatString2:[dictionary objectForKey:@"townName"]];
            townsVo.latitude = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"latitude"]];
            townsVo.longtitude =[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"longtitude"]];
            townsVo.sortCode = [ObjectUtil getLonglongValue:dictionary key:@"sortCode"];
            townsVo.isValid = [ObjectUtil getShortValue:dictionary key:@"isValid"];
            townsVo.createTime = [ObjectUtil getLonglongValue:dictionary key:@"createTime"];
            townsVo.opTime = [ObjectUtil getLonglongValue:dictionary key:@"opTime"];
            townsVo.lastVer = [ObjectUtil getLonglongValue:dictionary key:@"lastVer"];
            [townsList addObject:townsVo];
        }
        return townsList;
    }
    return nil;
}

@end
