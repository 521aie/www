//
//  TDFHealthCheckConfigViewModel.h
//  RestApp
//
//  Created by xueyu on 2016/12/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, TDFHealthCheckLevel){
    TDFHealthCheckStatusNormal = 0,
    TDFHealthCheckStatusImprove,
    HealthCheckStatusUrgency,

};

typedef NS_ENUM(NSUInteger, TDFHealthCheckAccountStatus){
    TDFHealthCheckAccountUnOpen = 0,
    TDFHealthCheckAccountOpen,
    TDFHealthCheckAccountUnbinding,
    TDFHealthCheckAccountBinding,
    TDFHealthCheckFunctionIsUnUsed,
    TDFHealthCheckFunctionIsUsed,
    TDFHealthCheckFunctionUnUpdated,
    TDFHealthCheckFunctionUpdated
};


@interface TDFHealthCheckConfigViewModel : NSObject
+(UIImage *)statusImage:(TDFHealthCheckLevel)level;

+(UIColor *)statusColor:(TDFHealthCheckLevel)level;

+(UIImage *)accountStatusImage:(NSInteger )status;
@end
