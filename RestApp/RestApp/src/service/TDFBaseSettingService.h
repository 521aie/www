//
//  TDFBaseSettingService.h
//  RestApp
//
//  Created by happyo on 2016/11/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHTTPClient.h"

@interface TDFBaseSettingService : NSObject

// 获取基础设置列表
+ (void)fetchBaseSettingListWithKindConfigCode:(NSString * _Nonnull )kindConfigCode completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 获取基础设置列表
+ (void)saveBaseSettingListWithIdString:(NSString * _Nonnull )idString completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

@end
