//
//  TDFChainMenuService.h
//  RestApp
//
//  Created by zishu on 16/10/8.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFDataCenter.h"
#import "TDFHTTPClient.h"
#import "Platform.h"
#import "RestConstants.h"
#import "TDFResponseModel.h"

@interface TDFChainMenuService : NSObject
//获取连锁品牌列表
- (nullable NSURLSessionDataTask *)getPlatesWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                             failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//获取连锁的商品列表（选中品牌关联商品）
- (nullable NSURLSessionDataTask *)getPlateMenusWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;


//保存品牌关联商品
- (nullable NSURLSessionDataTask *)savePlateMenusWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//获取发布品牌列表
- (nullable NSURLSessionDataTask *)listPublishPlateWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                               failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//获取发布的内容包含获取品牌关联商品列表和品牌关联门店列表(品牌关联的门店)
- (nullable NSURLSessionDataTask *)listPublishInfoWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;


//保存发布计划
- (nullable NSURLSessionDataTask *)saveChainPublishPlanWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                    failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;


//选择发布商品----选择发布门店（传参不一样）
- (nullable NSURLSessionDataTask *)updateChainPublishPlanWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                         failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//发布
- (nullable NSURLSessionDataTask *)publishToShopWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                           failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//取消发布
- (nullable NSURLSessionDataTask *)cancelPublishWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//重新发布
- (nullable NSURLSessionDataTask *)retryPublishWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                  failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//查看发布记录
- (nullable NSURLSessionDataTask *)listPublishHistoryWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//查询当前连锁的价格方案列表
- (nullable NSURLSessionDataTask *)queryMenuPricePlanWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//查询当前连锁的价格方案列表.结果不带 使用价格方案的店铺.新建商品的时候,查询价格方案时使用
- (nullable NSURLSessionDataTask *)querySimpleMenuPricePlanWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                       failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;


//查询指定价格方案详情,包括使用此价格方案的门店列表(门店列表要有层级结构,体现门店属于哪个上级组织)
- (nullable NSURLSessionDataTask *)getMenuPricePlanWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                       failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//新建,更新 价格方案,返回新建的价格方案.如果 id为空,认为是新建.如果id不为空,认为更新.
- (nullable NSURLSessionDataTask *)saveMenuPricePlanWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//删除 价格方案.
- (nullable NSURLSessionDataTask *)deleteMenuPricePlanWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                        failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//保存 使用价格方案的门店
- (nullable NSURLSessionDataTask *)saveMenuPricePlanShopsWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                        failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//单个 删除 使用价格方案的门店
- (nullable NSURLSessionDataTask *)deleteMenuPricePlanShopWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                           failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//查询 连锁下的所有门店列表.(门店列表要有层级结构,体现门店属于哪个上级组织)
- (nullable NSURLSessionDataTask *)queryAllShopWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                        failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//查询连锁的所有品牌
- (nullable NSURLSessionDataTask *)queryAllPlateListWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//查询 连锁下的门店列表,权限配置,加盟或直营.(门店列表要有层级结构,体现门店属于哪个上级组织)
- (nullable NSURLSessionDataTask *)queryChainShopPowerWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                      failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//修改保存 某个门店的权限配置
- (nullable NSURLSessionDataTask *)saveChainShopPowerWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//查询商品列表 (套餐,普通商品共用)
- (nullable NSURLSessionDataTask *)listAllMenuSampleWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                       failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

// 获取套餐属性
- (nullable NSURLSessionDataTask *)getSuitMenuInfoWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//保存更新套餐信息
- (nullable NSURLSessionDataTask *)saveSuitMenuInfoWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                    failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//新建商品时,获取默认的套餐扩展属性
- (nullable NSURLSessionDataTask *)getDefaultSuitMenuPropWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//加载 不同类型的 商品分类
- (nullable NSURLSessionDataTask *)listKindMenuForTypesWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                           failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//选择品牌列表
- (nullable NSURLSessionDataTask *)chainShopReleaseList:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                         failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//发布到门店列表
- (nullable NSURLSessionDataTask *)chainGetPublishInfo:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;


//查看发布记录
- (nullable NSURLSessionDataTask *)chainPublishHistory:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                               failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;
//取消发布
- (nullable NSURLSessionDataTask *)chainCancelPublish:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                               failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;
//发布
- (nullable NSURLSessionDataTask *)chainPublishToShop:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                               failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//重新发布
- (nullable NSURLSessionDataTask *)chainRetryPublishToShop:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                              failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

@end
