//
//  TDFSuitMenuService.h
//  RestApp
//
//  Created by zishu on 16/9/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHTTPClient.h"
#import "Platform.h"
#import "RestConstants.h"
#import "TDFResponseModel.h"
@interface TDFSuitMenuService : NSObject

//获取套餐列表
- (nullable NSURLSessionDataTask *)listSuitAll:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//保存套餐
- (nullable NSURLSessionDataTask *)saveSuitWithParam:(nullable NSMutableDictionary *)param suscess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//更新套餐
- (nullable NSURLSessionDataTask *)updateSuitWithParam:(nullable NSMutableDictionary *)param suscess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//获取套餐明细
- (nullable NSURLSessionDataTask *)listSuitDetailWithParam:(nullable NSMutableDictionary *)param suscess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//获取套餐扩展属性
- (nullable NSURLSessionDataTask *)loadMenuReserveDataWithParam:(nullable NSMutableDictionary *)param suscess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//更新套餐扩展属性
- (nullable NSURLSessionDataTask *)updateMenuReserveWithParam:(nullable NSMutableDictionary *)param suscess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//保存套餐内分组
- (nullable NSURLSessionDataTask *)saveSuitMenuDetailWithParam:(nullable NSMutableDictionary *)param suscess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//删除套餐内分组
- (nullable NSURLSessionDataTask *)removeSuitMenuDetailWithParam:(nullable NSMutableDictionary *)param suscess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//更新套餐内分组
- (nullable NSURLSessionDataTask *)updateSuitMenuDetailWithParam:(nullable NSMutableDictionary *)param suscess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//保存套餐内子菜
- (nullable NSURLSessionDataTask *)saveSuitMenuChangeWithParam:(nullable NSMutableDictionary *)param suscess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//删除套餐内子菜
- (nullable NSURLSessionDataTask *)removeSuitMenuChangeWithParam:(nullable NSMutableDictionary *)param suscess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//套餐内分组排序
- (nullable NSURLSessionDataTask *)sortSuitMenuDetailsWithParam:(nullable NSMutableDictionary *)param suscess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//套餐内子菜排序
- (nullable NSURLSessionDataTask *)sortSuitMenuChangesWithParam:(nullable NSMutableDictionary *)param suscess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//获取套餐使用的商品规格
- (nullable NSURLSessionDataTask *)listSuitSpecaDetailWithParam:(nullable NSMutableDictionary *)param suscess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//套餐获取商品图片
- (nullable NSURLSessionDataTask *)listSuitMenuImgWithParam:(nullable NSMutableDictionary *)param suscess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

/**
 *  套餐内计价规则列表
 */
- (void)getSuitMenuValuationRuleList:(nonnull NSString *)suit_menu_id callBack:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack;

/**
 *  规则内新增组合选择商品列表
 */
- (void)getSuitMenuValuationItemList:(nonnull NSString *)suit_menu_id callBack:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack;

/**
 *  套餐内计价规则保存
 */
- (void)saveSuitMenuValuationRule:(nonnull NSDictionary *)dict callBack:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack;

/**
 *  套餐内计价规则删除
 */
- (void)deleteSuitMenuValuationRule:(nonnull NSMutableDictionary *)parameters callBack:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack;

@end
