//
//  TDFPublishInfoVo.m
//  RestApp
//
//  Created by iOS香肠 on 2016/10/22.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFPublishInfoVo.h"
#import "NameItemVO.h"
#import "ObjectUtil.h"
@implementation TDFPublishInfoVo


+ (NSMutableArray *)getTimeIntervalListWithArry:(NSArray *)timeList
{
    NSMutableArray *timeArr  = [[NSMutableArray  alloc] init];
    if ([ObjectUtil  isNotEmpty:timeList]) {
        for (NSInteger  i=0; i<timeList.count; i++) {
            NameItemVO *valueVO = [[NameItemVO alloc] init];
            valueVO.itemId = timeList[i];
            valueVO.itemName =  timeList[i];
            valueVO.itemValue = [NSString stringWithFormat:@"%ld",i];
            [timeArr  addObject:valueVO];
        }
    }
    return timeArr;
}

+(NameItemVO *)getCurrentData:(NSMutableArray *)discountTypeList  IteamId:(NSString *)iteamId
{
    for (NameItemVO *iteamVo in discountTypeList ) {
        if ([iteamVo .itemId   isEqualToString:iteamId]) {
            return iteamVo;
        }
    }
    return  nil;
}

@end
