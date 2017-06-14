//
//  TDFTakeMealService.h
//  RestApp
//
//  Created by happyo on 16/10/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHTTPClient.h"

@interface TDFTakeMealService : NSObject

/**
 店内屏幕广告接口
 */
+ (void)fetchAdImageListWithCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

+ (void)saveAdImageWithImagePath:(NSString * _Nonnull)imagePath completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

+ (void)deleteAdImageWithFileResId:(NSString * _Nonnull)fileResId completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

/**
 叫号语音设置接口
 */
+ (void)fetchCallVoiceSettingWithCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

+ (void)updateCallVoiceSettingWithSex:(NSString * _Nonnull)sexId repeateTime:(NSString * _Nonnull)repeatTime completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

/**
 广播语音设置接口
 */
+ (void)fetchNotificationVoiceSettingWithCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

+ (void)updateNotificationVoiceSettingWithSex:(NSString * _Nonnull)sexId intervalTime:(NSString * _Nonnull)intervalTime completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

@end
