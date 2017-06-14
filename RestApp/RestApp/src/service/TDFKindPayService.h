//
//  TDFKindPayService.h
//  RestApp
//
//  Created by chaiweiwei on 2017/2/22.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFKindPayService : NSObject

//连锁付款方式列表
- (nullable NSURLSessionDataTask *)getlistKindPayWithSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                             failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;
//同步门店：获取门店列表 单个 还是 批量
- (nullable NSURLSessionDataTask *)getShopSyncListWithParam:(nonnull NSDictionary *)param isBatch:(BOOL)isBatch sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                        failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;
//付款方式同步到门店 单个 还是 批量
- (nullable NSURLSessionDataTask *)setSyncToShopWithParam:(nonnull NSDictionary *)param isBatch:(BOOL)isBatch sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                    failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//门店权限：获取门店列表
- (nullable NSURLSessionDataTask *)getListChainConfigSwitchWithParam:(nonnull NSDictionary *)param sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                  failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//门店权限保存
- (nullable NSURLSessionDataTask *)saveChainConfigSwitchWithParam:(nonnull NSDictionary *)param sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                             failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//从总部获取可copy的付款方式列表
- (nullable NSURLSessionDataTask *)getListKindPayFromChainWithSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                          failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//从总部copy付款方式
- (nullable NSURLSessionDataTask *)copyKindPayToShopWithParam:(nonnull NSDictionary *)param sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                          failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//获取分公司列表、品牌列表、门店类型列表(获取筛选条件)
- (nullable NSURLSessionDataTask *)getShopFilterWithSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                                  failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;
@end
