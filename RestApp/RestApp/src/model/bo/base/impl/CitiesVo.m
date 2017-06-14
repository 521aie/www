//
//  CitiesVo.m
//  RestApp
//
//  Created by 刘红琳 on 15/12/4.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CitiesVo.h"
#import "ObjectUtil.h"
#import "FormatUtil.h"

@implementation CitiesVo

+ (NSMutableArray *)convertToCityArr:(NSArray *)array
{
    if ([ObjectUtil isNotEmpty:array]) {
        NSMutableArray *citiesList = [[NSMutableArray alloc]initWithCapacity:array.count];
        for (NSDictionary *dictionary in array) {
            CitiesVo *citiesVo = [[CitiesVo alloc]init];
            citiesVo.cityId =[FormatUtil formatString2: [dictionary objectForKey:@"cityId"]];
            citiesVo.provinceId =[FormatUtil formatString2: [dictionary objectForKey:@"provinceId"]];
            citiesVo.cityName =[FormatUtil formatString2: [dictionary objectForKey:@"cityName"]];
            citiesVo.latitude = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"latitude"]];
            citiesVo.longtitude =[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"longtitude"]];
            citiesVo.sortCode = [ObjectUtil getLonglongValue:dictionary key:@"sortCode"];
            citiesVo.isValid = [ObjectUtil getShortValue:dictionary key:@"isValid"];
            citiesVo.createTime = [ObjectUtil getLonglongValue:dictionary key:@"createTime"];
            citiesVo.opTime = [ObjectUtil getLonglongValue:dictionary key:@"opTime"];
            citiesVo.lastVer = [ObjectUtil getLonglongValue:dictionary key:@"lastVer"];
            [citiesList addObject:citiesVo];
        }
        return citiesList;
    }
    return nil;
}
@end
