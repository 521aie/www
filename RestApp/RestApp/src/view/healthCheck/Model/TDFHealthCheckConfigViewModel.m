//
//  TDFHealthCheckConfigViewModel.m
//  RestApp
//
//  Created by xueyu on 2016/12/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckConfigViewModel.h"
#import "UIColor+Hex.h"
#import <UIKit/UIKit.h>

@implementation TDFHealthCheckConfigViewModel
+(UIColor *)statusColor:(TDFHealthCheckLevel)level{
    UIColor *color;
    switch (level) {
            
        case TDFHealthCheckStatusNormal:
            color = [UIColor colorWithHexString:@"#07AD1F" alpha:0.9];
            break;
        case TDFHealthCheckStatusImprove:
            color = [UIColor colorWithHexString:@"#FF8800"];
            break;
        case HealthCheckStatusUrgency:
            color = [UIColor colorWithHexString:@"#E02200"];
            break;
        default:
            color = [UIColor clearColor];
            break;
    }
    return color;
}

+(UIImage *)statusImage:(TDFHealthCheckLevel)level{
    UIImage *image;
    switch (level) {
            
        case TDFHealthCheckStatusNormal:
            image = [UIImage imageNamed:@"ico_checkresultok"];
            break;
        case TDFHealthCheckStatusImprove:
            image = [UIImage imageNamed:@"ico_checkyellow"];
            break;
        case HealthCheckStatusUrgency:
            image = [UIImage imageNamed:@"ico_checkred"];
            break;
        default:
            image = nil;
            break;
    }
    return image;
}

/**
 * 状态（0:未开通 / 1:已开通 / 2:未绑定 / 3:已绑定 / 4:未使用 / 5:已使用 6:未更新 / 7:已更新）
 */

+(UIImage *)accountStatusImage:(NSInteger )status{
    UIImage *img;
    switch (status) {
        case TDFHealthCheckAccountUnOpen:
            img = [UIImage imageNamed:@"ico_account_unopen"];
        break;
        case TDFHealthCheckAccountOpen:
            img = [UIImage imageNamed:@"ico_account_open"];
         break;
        case TDFHealthCheckAccountUnbinding:
            img = [UIImage imageNamed:@"ico_account_unbinding"];
         break;
         case TDFHealthCheckAccountBinding:
            img = [UIImage imageNamed:@"ico_account_binding"];
         break;
        case TDFHealthCheckFunctionIsUnUsed:
            img = [UIImage imageNamed:@"ico_function_unused"];
            break;
        case TDFHealthCheckFunctionIsUsed:
            img = [UIImage imageNamed:@"ico_function_used"];
            break;
        case TDFHealthCheckFunctionUnUpdated:
            img = [UIImage imageNamed:@"health_unUpdated_icon"];
            break;
        case TDFHealthCheckFunctionUpdated:
            img = [UIImage imageNamed:@"health_updated_icon"];
            break;

         
    }
    return img;
}
@end
