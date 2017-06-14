//
//  RNNativeActionManager.m
//  RestApp
//
//  Created by QiYa on 16/9/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "RNNativeActionManager.h"

#import "RCTBridgeModule.h"
#import "RCTLog.h"

@interface RNNativeActionManager()
<
RCTBridgeModule
>
@end

@implementation RNNativeActionManager
# pragma mark - React Native

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(RNTransformMajorMaterialItem:(NSDictionary *)item)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RNTransformLabelIdNotification object:item];
}

RCT_EXPORT_METHOD(RNPopVC:(id)params)
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RNPopVCNotification object:params];
    
}

RCT_EXPORT_METHOD(RNPushMajorMaterialVC)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RNPushMajorMaterialNotification object:nil];
}

RCT_EXPORT_METHOD(RNHelpActionWithKey:(NSString *)key)
{
    
    NSDictionary * param = @{@"helpAction": key};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RNHelpActionNotification object:param];
    
}

RCT_EXPORT_METHOD(RNDidMountWithKey:(NSString *)key)
{
    NSLog(@"%@",key);
    
    NSDictionary * param = @{@"mountComponent": key};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RNDidMountNotification object:param];
    
}

#pragma mark 添加图片
RCT_EXPORT_METHOD(RNAddImageWithCallBack:(RCTResponseSenderBlock)callback)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RNAddImageNotification object:callback];
}

RCT_EXPORT_METHOD(RNRemoveImageWithCallBack:(RCTResponseSenderBlock)callback)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RNRemoveImageNotification object:callback];
}

@end
