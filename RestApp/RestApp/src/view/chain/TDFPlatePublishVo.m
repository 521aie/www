//
//  TDFPlatePublishVo.m
//  RestApp
//
//  Created by iOS香肠 on 2016/10/22.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFPlatePublishVo.h"
#import "ColorHelper.h"
@implementation TDFPlatePublishVo


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"ChainPublishHistoryVo" : [ChainPublishHistoryVo class]};
}
/**
 * 发布状态(0:待发布，1:发布中，2:发布失败，3:重试待发布)
 */
+(NSString *)getPublishStatusString:(NSInteger)status
{
    NSString *str ;
    if (status  == 0 ) {
        str  = NSLocalizedString(@"等待发布", nil);
    }
    else if (status ==1)
    {
        str = @" ";
    }
    else if (status  ==2)
    {
        str = NSLocalizedString(@"发布失败", nil);
    }
    else if (status == 3)
    {
      str = @" ";
    }
    return  str ;
}

+ (UIColor *)getPublishStatusColor:(NSInteger)status
{
    UIColor *color ;
    if (status  == 0) {
        color = RGBA(236, 111, 35, 1);
    }
    else if (status ==1)
    {
        color = [UIColor clearColor];
    }
    else if (status  ==2)
    {
        color = [ColorHelper getRedColor];
    }
    else if (status == 3)
    {
        color = [UIColor clearColor];
    }
    return color;
}


+ (BOOL) isHideWithPublishStatus:(NSInteger)status
{
    BOOL str ;
    if (status  == 0) {
        str  = NO;
    }
    else if (status ==1)
    {
        str =YES;
    }
    else if (status  ==2)
    {
        str = NO;
    }
    else {
        str =YES;
    }
    return  str ;
}

+ (BOOL)isWaitWithStatus:(NSInteger)status
{
    BOOL isWait ;
    if (status == 0) {
        isWait = NO;
    }
    else
    {
        isWait = YES;
    }
    return  isWait;
}

+ (NSInteger)getFialureStatus:(NSInteger)status
{
    NSInteger   failureStatus=  0 ;
    if (status == 2) {
        failureStatus  = 2;
    }
    return status ;
}
@end
