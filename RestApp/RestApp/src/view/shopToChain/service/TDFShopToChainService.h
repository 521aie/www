//
//  TDFShopToChainService.h
//  RestApp
//
//  Created by 刘红琳 on 2017/3/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHTTPClient.h"
#import "TDFResponseModel.h"
#import "TDFDataCenter.h"
#import "RestConstants.h"
@interface TDFShopToChainService : NSObject
//开通连锁
- (nullable NSURLSessionDataTask *)createBrandWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//创建新门店
- (nullable NSURLSessionDataTask *)activeCodeWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//保存修改信息
- (nullable NSURLSessionDataTask *)amodifyShopInfoWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                               failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//发送邀请门店验证码
- (nullable NSURLSessionDataTask *)sendInviteShopVerCodeWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//邀请门店加入
- (nullable NSURLSessionDataTask *)inviteShopWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

@end
