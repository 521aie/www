//
//  TDFForceConfigVo.m
//  RestApp
//
//  Created by hulatang on 16/7/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFForceConfigVo.h"
#import "NameItemVO.h"

@implementation TDFForceConfigVo
+ (NSArray *)forceTypeArray
{
    static NSArray *forceTypeArray;
    static dispatch_once_t once_time;
    dispatch_once(&once_time, ^{
        NSMutableArray *array = [NSMutableArray array];
        NameItemVO *vo = [[NameItemVO alloc] initWithVal:NSLocalizedString(@"指定数量", nil) andId:@"0"];
        [array addObject:vo];
        vo = [[NameItemVO alloc] initWithVal:NSLocalizedString(@"与用餐人数相同", nil) andId:@"1"];
        [array addObject:vo];
        forceTypeArray = [NSArray arrayWithArray:array];
    });
    return forceTypeArray;
}

+ (NSArray *)forceNumArray
{
    static NSArray *forceNumArray;
    static dispatch_once_t once_time;
    dispatch_once(&once_time, ^{
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 1; i < 100; i ++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            NameItemVO *vo = [[NameItemVO alloc] initWithVal:str andId:str];
            [array addObject:vo];
        }
        forceNumArray = [NSArray arrayWithArray:array];
    });
    return forceNumArray;
}

- (TDFForceMakeVo *)make
{
    if (!_make) {
        _make = [[TDFForceMakeVo alloc] init];
    }
    return _make;
}

- (TDFForceSpecificationVo *)spec
{
    if (!_spec) {
        _spec = [[TDFForceSpecificationVo alloc] init];
    }
    return _spec;
}

- (id)copyWithZone:(NSZone *)zone
{
    TDFForceConfigVo *forceConfig = [[[self class] allocWithZone:zone] init];
    forceConfig.configId = [self.configId copyWithZone:zone];
    forceConfig.entityId = [self.entityId copyWithZone:zone];
    forceConfig.menuId = [self.menuId copyWithZone:zone];
    forceConfig.menuType = self.menuType;
    forceConfig.forceType = self.forceType;
    forceConfig.forceNum = self.forceNum;
    forceConfig.make = [self.make copyWithZone:zone];
    forceConfig.spec = [self.spec copyWithZone:zone];
    return forceConfig;
}

@end
