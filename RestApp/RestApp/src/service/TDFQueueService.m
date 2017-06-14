//
//  TDFQueueService.m
//  RestApp
//
//  Created by Octree on 7/12/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFQueueService.h"
#import "TDFHTTPClient.h"
#import "TDFDataCenter.h"
#import "RestConstants.h"
#import "TDFResponseModel.h"
#import "TDFNetworkingConstants.h"
#import "Platform.h"

@implementation TDFQueueService


#pragma mark - Public Methods

/// 更新排队单备注
- (nullable NSURLSessionDataTask *)updateQueueRemarkWithRemark:(NSString * _Nonnull )remark
                                                      remarkId:(NSString * _Nonnull )remarkId
                                                    success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                                   failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock {
    
    return [self postBossAPIWithPath:@"shop/v1/update_queue_remark"
                               param:@{
                                       @"queue_remark": remark,
                                       @"queue_remark_id": (remarkId == nil)?@"":remarkId
                                       }
                             success:successBlock
                             failure:failureBlock];
}

/// 获取排队单备注
- (nullable NSURLSessionDataTask *)queueRemarkWithSuccess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                                  failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock {

    return [self postBossAPIWithPath:@"shop/v1/query_queue_remark"
                               param:@{ }
                             success:successBlock
                             failure:failureBlock];
}

/// 更新文字广告
- (nullable NSURLSessionDataTask *)updateAdTextWithText:(NSString * _Nonnull )adText
                                                    success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                                   failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock {

    return [self postBossAPIWithPath:@"advertisement/v1/update_text"
                               param:@{
                                       @"text": adText,
                                       }
                             success:successBlock
                             failure:failureBlock];
}

/// 获取文字广告
- (nullable NSURLSessionDataTask *)adTextWithSuccess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                             failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock {

    return [self postBossAPIWithPath:@"advertisement/v1/query_text"
                               param:@{ }
                             success:successBlock
                             failure:failureBlock];
}


/// 保存该类型绑定的桌位

- (nullable NSURLSessionDataTask *)saveBindSeatsWithIds:(NSString *_Nonnull)ids
                                           seatTypeCode:(NSString *_Nonnull)code
                                                 success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                                failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock {

    return [self postBossAPIWithPath:@"seat/v1/save_seat_mapping"
                               param:@{
                                       @"seat_id_list" : ids,
                                       @"seat_type_code" : code
                                       }
                             success:successBlock
                             failure:failureBlock];
}

/// 删除已经绑定的桌位
- (nullable NSURLSessionDataTask *)removeBindSeatWithId:(NSString *_Nonnull)seatId
                                           seatTypeCode:(NSString *_Nonnull)code
                                                 success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                                failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock {

    return [self postBossAPIWithPath:@"seat/v1/remove_seat_mapping"
                               param:@{
                                       @"seat_mapping_id" : seatId,
                                       @"seat_type_code" : code
                                       }
                             success:successBlock
                             failure:failureBlock];
}

/// 获取所有未绑定的桌位
- (nullable NSURLSessionDataTask *)unbindedSeatsWithSuccess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                                    failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock {

    
    return [self postBossAPIWithPath:@"seat/v1/query_unmapped_seat"
                               param:@{  }
                             success:successBlock
                             failure:failureBlock];
}

/// 根据类型查询绑定的桌位列表
- (nullable NSURLSessionDataTask *)bindedSeatsWithTypeCode:(NSString *_Nonnull)code
                                                    success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock
                                                   failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock {

    return [self postBossAPIWithPath:@"seat/v1/query_mapped_seat"
                               param:@{
                                       @"seat_type_code" : code
                                       }
                             success:successBlock
                             failure:failureBlock];
}

#pragma mark - Private Methods


- (TDFRequestModel *)getRequestModelWithPath:(NSString *)path params:(NSDictionary *)params{
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = path;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.timeout = 15;
    
    NSMutableDictionary *mutableParams = params? [params mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:1];
    mutableParams[@"session_key"] = [TDFDataCenter sharedInstance].sessionKey;
    mutableParams[@"plate_entity_id"] = [TDFDataCenter sharedInstance].plateEntityId;
    
    requestModel.parameters = [mutableParams copy];
    
    return requestModel;
}

- (NSURLSessionDataTask *)postBossAPIWithPath:(NSString *)path
                                        param:(NSDictionary *)param
                                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))successBlock
                                      failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:path params:param];
    
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}


@end
