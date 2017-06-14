//
//  ProvincesVo.m
//  RestApp
//
//  Created by 刘红琳 on 15/12/4.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ProvincesVo.h"
#import "ObjectUtil.h"
#import "FormatUtil.h"
@implementation ProvincesVo

+ (NSMutableArray *)convertToProvincesArr:(NSArray *)array
{
    if ([ObjectUtil isNotEmpty:array]) {
        NSMutableArray *provincesList = [[NSMutableArray alloc]initWithCapacity:array.count];
        for (NSDictionary *dictionary in array) {
            ProvincesVo *provincesVo = [[ProvincesVo alloc]init];
            provincesVo.contryId =[FormatUtil formatString2: [dictionary objectForKey:@"contryId"]];
            provincesVo.provinceId =[FormatUtil formatString2: [dictionary objectForKey:@"provinceId"]];
            provincesVo.provinceName = [FormatUtil formatString2:[dictionary objectForKey:@"provinceName"]];
            provincesVo.latitude = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"latitude"]];
            provincesVo.longtitude =[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"longtitude"]];
            provincesVo.sortCode = [ObjectUtil getLonglongValue:dictionary key:@"sortCode"];
            provincesVo.isValid = [ObjectUtil getShortValue:dictionary key:@"isValid"];
            provincesVo.createTime = [ObjectUtil getLonglongValue:dictionary key:@"createTime"];
            provincesVo.opTime = [ObjectUtil getLonglongValue:dictionary key:@"opTime"];
            provincesVo.lastVer = [ObjectUtil getLonglongValue:dictionary key:@"lastVer"];
            [provincesList addObject:provincesVo];
        }
        return provincesList;
    }
    return nil;
}
@end
