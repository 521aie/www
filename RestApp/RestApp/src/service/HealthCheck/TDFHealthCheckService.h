//
//  TDFHealthCheckService.h
//  RestApp
//
//  Created by xueyu on 2016/12/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFResponseModel.h"
@interface TDFHealthCheckService : NSObject
/**
 *  获取体检设置
 */
- (nullable NSURLSessionDataTask *)getHealthCheckSettingWithCallBack:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack;

/**
 *  保存体检设置
 */
- (nullable NSURLSessionDataTask *)saveHealthCheckSettingWithData:(nonnull NSString *)dataString
                                                         callback:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack;

/**
 *  获取体检项目详情
 */
- (nullable NSURLSessionDataTask *)getHealthCheckDetailWithResultId:(nonnull NSString *)resultId
                                                           itemCode:(nonnull NSString *)itemCode
                                                           callback:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack;

/**
 * 体检项目
 */
- (nullable NSURLSessionDataTask *)getHealthCheckSettingInfoSucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                             failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

/**
 * 体检历史数据
 */
- (nullable NSURLSessionDataTask *)getHealthCheckHistoryInfoWithResultID:(nonnull NSString *)resultID
                                                                 success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                                 failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;


- (nullable NSURLSessionDataTask *)getHealthCheckHistoryScoreSuccess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                             failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

@end
