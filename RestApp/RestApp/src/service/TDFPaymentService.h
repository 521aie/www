//
//  TDFPaymentService.h
//  RestApp
//
//  Created by zishu on 16/8/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFHTTPClient.h"
#import "RestConstants.h"
#import "TDFResponseModel.h"
#import "Platform.h"

@interface TDFPaymentService : UIViewController

//查询指定月微信账单分页
- (nullable NSURLSessionDataTask *)getRecordByDayWithParam:(nullable NSDictionary *)param sucess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//查询微信账单详情
- (nullable NSURLSessionDataTask *)getTotalBillsMoneyWithParam:(nullable NSDictionary *)param sucess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//修改店铺电子支付信息
- (nullable NSURLSessionDataTask *)applyElectronicPaymentWithParam:(nullable NSDictionary *)param sucess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//查询银行开户支行
- (nullable NSURLSessionDataTask *)getSubBanksWithParam:(nullable NSDictionary *)param sucess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//查询银行对应城市
- (nullable NSURLSessionDataTask *)getCitiesWithParam:(nullable NSDictionary *)param sucess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//查询店铺对应城市
- (nullable NSURLSessionDataTask *)getShopCitiesWithParam:(nullable NSDictionary *)param sucess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;


//查询银行对应省
- (nullable NSURLSessionDataTask *)getProvinceWithParam:(nullable NSDictionary *)param sucess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//查询店铺对应省
- (nullable NSURLSessionDataTask *)getShopProvinceWithParam:(nullable NSDictionary *)param sucess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//查询开户银行列表
- (nullable NSURLSessionDataTask *)getBanksWithParam:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//查询店铺电子支付信息
- (nullable NSURLSessionDataTask *)getElectronicPaymentWithParam:(nullable NSDictionary *)param sucess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

//店铺状态
- (nullable NSURLSessionDataTask *)getShopStatusWithParam:(nullable NSDictionary *)param sucess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock;

@end
