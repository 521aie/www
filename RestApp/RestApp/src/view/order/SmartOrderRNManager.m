//
//  SmartOrderRNManager.m
//  RestApp
//
//  Created by QiYa on 16/9/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SmartOrderRNManager.h"
#import "SmartOrderRNService.h"

#import "RemoteResult.h"
#import "JsonHelper.h"

#import "RCTBridgeModule.h"
#import "RCTLog.h"

@interface SmartOrderRNManager ()
<
RCTBridgeModule
>

@property (nonatomic, strong) SmartOrderRNService * service;
@property (nonatomic, copy) RCTResponseSenderBlock rnCallBack;
@end

@implementation SmartOrderRNManager

# pragma mark - React Native

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(addEvent:(NSString *)name)
{
    RCTLogInfo(@"%@", name);
}

RCT_EXPORT_METHOD(RNNetworkWithApi:(NSString *)api Url:(NSString *)url Params:(NSDictionary *)params  Callback:(RCTResponseSenderBlock)callback)
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RNShowHubNotification object:nil];
//    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    self.rnCallBack = callback;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.service RNNetwork:self Api:api Url:url Params:params Callback:@selector(RNCallBack:)];
    });

    
}

# pragma mark - Lazy init
- (SmartOrderRNService *)service {
    
    if (!_service) {
        _service = [[SmartOrderRNService alloc] init];
    }
    
    return _service;
    
}

# pragma mark - CallBack
- (void)RNCallBack:(RemoteResult *)result {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RNHideHubNotification object:nil];
//    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        if (result.errorStr) {
            self.rnCallBack(@[result.errorStr,[NSNull null]]);
        } else {
            self.rnCallBack(@[NSLocalizedString(@"请求失败", nil),[NSNull null]]);
        }
        
        return;
    }
    
    self.rnCallBack(@[[NSNull null],[self parse:result.content]]);
    
}

#pragma mark - Tool
/**
 *  解析JSON数据
 *
 *  @param content <#content description#>
 *
 *  @return <#return value description#>
 */
- (id)parse:(NSString *)content {
    
    NSDictionary *dict = [JsonHelper transMap:content];
    NSDictionary *tempDIc = dict[@"data"];
    if (![tempDIc isKindOfClass:[NSDictionary class]] && ![tempDIc isKindOfClass:[NSArray class]]) {
        return NSLocalizedString(@"请求成功,无数据", nil);
    }

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tempDIc options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //react-native统一接受json字符串
    return jsonString;
   
}

@end
