//
//  CountriesVO.m
//  RestApp
//
//  Created by 刘红琳 on 15/12/4.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CountriesVO.h"
#import "ObjectUtil.h"
#import "FormatUtil.h"
@implementation CountriesVO

+ (NSMutableArray *)convertToCountriesArr:(NSArray *)array
{
    if ([ObjectUtil isNotEmpty:array]) {
        NSMutableArray *countriesList = [[NSMutableArray alloc]initWithCapacity:array.count];
        for (NSDictionary *dictionary in array) {
        CountriesVO *countriesVO = [[CountriesVO alloc]init];
        countriesVO.contryId =[FormatUtil formatString2: [dictionary objectForKey:@"countryId"]];
        countriesVO.contryName = [FormatUtil formatString2:[dictionary objectForKey:@"countryName"]];
        countriesVO.latitude = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"latitude"]];
        countriesVO.longtitude =[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"longtitude"]];
        countriesVO.countryCode = [FormatUtil formatString2:[dictionary objectForKey:@"code"]];
        countriesVO.isValid = [ObjectUtil getShortValue:dictionary key:@"isValid"];
        countriesVO.createTime = [ObjectUtil getLonglongValue:dictionary key:@"createTime"];
        countriesVO.opTime = [ObjectUtil getLonglongValue:dictionary key:@"opTime"];
        countriesVO.lastVer = [ObjectUtil getLonglongValue:dictionary key:@"lastVer"];
        [countriesList addObject:countriesVO];
        }
        return countriesList;
    }
    return nil;
}
@end
