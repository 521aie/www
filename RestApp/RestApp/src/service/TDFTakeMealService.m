//
//  TDFTakeMealService.m
//  RestApp
//
//  Created by happyo on 16/10/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTakeMealService.h"
#import "TDFTakeMealModel.h"
#import "TDFVoiceSettingModel.h"

@implementation TDFTakeMealService

+ (void)fetchAdImageListWithCompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFTakeMealModel *requestModel = [[TDFTakeMealModel alloc] init];
    requestModel.actionPath = @"picture_list";
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)saveAdImageWithImagePath:(NSString * _Nonnull)imagePath completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFTakeMealModel *requestModel = [[TDFTakeMealModel alloc] init];
    requestModel.actionPath = @"save_picture";
    requestModel.parameters = @{@"pic_url" : imagePath};
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)deleteAdImageWithFileResId:(NSString * _Nonnull)fileResId completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback
{
    TDFTakeMealModel *requestModel = [[TDFTakeMealModel alloc] init];
    requestModel.actionPath = @"delete_picture";
    requestModel.parameters = @{@"file_res_id" : fileResId};
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)fetchCallVoiceSettingWithCompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFVoiceSettingModel *requestModel = [[TDFVoiceSettingModel alloc] init];
    requestModel.actionPath = @"get_voice_setting";
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)updateCallVoiceSettingWithSex:(NSString *)sexId repeateTime:(NSString *)repeatTime completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFVoiceSettingModel *requestModel = [[TDFVoiceSettingModel alloc] init];
    requestModel.actionPath = @"update_voice_setting";
    requestModel.parameters = @{@"sex" : sexId ?: @"", @"num" : repeatTime ?: @""};
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)fetchNotificationVoiceSettingWithCompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFVoiceSettingModel *requestModel = [[TDFVoiceSettingModel alloc] init];
    requestModel.actionPath = @"get_broadcast_setting";
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+ (void)updateNotificationVoiceSettingWithSex:(NSString *)sexId intervalTime:(NSString *)intervalTime completeBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFVoiceSettingModel *requestModel = [[TDFVoiceSettingModel alloc] init];
    requestModel.actionPath = @"update_broadcast_setting";
    requestModel.parameters = @{@"sex" : sexId ?: @"", @"num" : intervalTime ?: @""};
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

@end
