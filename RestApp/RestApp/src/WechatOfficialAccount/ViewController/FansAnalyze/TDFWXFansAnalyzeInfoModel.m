//
//	TDFWXFansAnalyzeInfoModel.m
//
//	Create by 瑞旺 宋 on 17/5/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport
#import <YYModel/YYModel.h>
#import "TDFWXFansAnalyzeInfoModel.h"

@implementation TDFWXFansAnalyzeInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"couponsChart" : [TDFWXChartModel class],
             @"fansAnalyze" : [TDFFansAnalyzeModel class],
             @"fansChart" : [TDFWXChartModel class] };
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"freshFansCount" : @"newFansCount"};
}
@end
