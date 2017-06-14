//
//  TDFQueueService.h
//  RestApp
//
//  Created by Octree on 7/12/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFQueueService : NSObject

/// 更新排队单备注
- (nullable NSURLSessionDataTask *)updateQueueRemarkWithRemark:(NSString * _Nonnull )remark
                                                      remarkId:(NSString * _Nonnull )remarkId
                                                    success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                                   failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

/// 获取排队单备注
- (nullable NSURLSessionDataTask *)queueRemarkWithSuccess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                                 failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

/// 更新文字广告
- (nullable NSURLSessionDataTask *)updateAdTextWithText:(NSString * _Nonnull )adText
                                                    success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                                   failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

/// 获取文字广告
- (nullable NSURLSessionDataTask *)adTextWithSuccess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                            failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;


/// 保存该类型绑定的桌位

- (nullable NSURLSessionDataTask *)saveBindSeatsWithIds:(NSString *_Nonnull)ids
                                           seatTypeCode:(NSString *_Nonnull)code
                                                 success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                                failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

/// 删除已经绑定的桌位
- (nullable NSURLSessionDataTask *)removeBindSeatWithId:(NSString *_Nonnull)seatId
                                           seatTypeCode:(NSString *_Nonnull)code
                                                 success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                                failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

/// 获取所有未绑定的桌位
- (nullable NSURLSessionDataTask *)unbindedSeatsWithSuccess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                                   failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

/// 根据类型查询绑定的桌位列表
- (nullable NSURLSessionDataTask *)bindedSeatsWithTypeCode:(NSString *_Nonnull)code
                                                    success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                                   failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

@end
