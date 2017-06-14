//
//  TDFMemberCouponService.h
//  RestApp
//
//  Created by iOS香肠 on 16/7/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFResponseModel.h"
#import "TDFMemCouEditData.h"
#import "TDFMemDiscountTemplateVo.h"

@interface TDFMemberCouponService : NSObject

/***获取优惠券列表*/
+ (void)memberCouponListpage:(NSString *_Nullable)page pageSize:(NSString *_Nullable)pageSize andPlate:(NSString *_Nullable)plateId  CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;
//优惠券编辑
+(void)memberCouponEditObj:(TDFMemCouEditData *_Nullable)obj CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;
//优惠券删除
+(void)memberCouponDeleteItemId:(NSString *_Nullable)itemId andEntityId:(NSString *_Nullable)plateEntityId CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;
//优惠方案列表
+(void)memberCouponPlantCompleteBlock:(nullable  void (^)(TDFResponseModel * _Nullable))callback;
//待定
+(void)editDiscountPlanIteamId:(NSString*_Nullable)itemId CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;

//优惠方案保存
+(void)memberPromotionEditObj:(TDFMemDiscountTemplateVo *_Nullable)obj CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;

//优惠方案删除列表
+(void)memberPromotionDeleteIteamId:(NSString *_Nullable)obj CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;
//优惠方案，商品列表//rerp暂时使用原先网络架构！
//+(void)memberMenuList:(NSString *_Nullable)type  CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;

//获取支付宝是否享受店内优惠
+(void)alipayPaymentCompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;

//修改支付宝是否不享受店内优惠
+(void)alipayPaymentType:(NSString *_Nullable)type  CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;
//获取单个优惠方案
+(void)singlePlantId:(NSString *_Nullable)Id CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;

/***获取优惠券图片列表**/
+ (void)memberCouponBGImgpage:(NSString *_Nullable)page pageSize:(NSString *_Nullable)pageSize   CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

/***查询商品规格做法**/
+ (void)memberCouponMakeTypeWithMenuId:(NSString *_Nullable)menuId CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

/***上传图片**/
+ (void)memberUpLoadBGImgWithImg:(UIImage *_Nullable)img CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

/***上传图片 with domain**/
+ (void)uploadWithImg:(UIImage *_Nullable)img domain:(NSString *)domain CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

/***查询可选商品列表**/
+ (void)memberGoodsOptionListCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

/***判断商家是否为直连加绑定用户*/
+(void)memberCouponJudgeShopIsStrightAndAliUserCompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;

/***品牌下业务数量列表*/
+(void)memberCouponBrandListWithType:(NSString *_Nullable)type CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;

/***门店权限列表*/
+(void)memberShopPermissionListWithPlateID:(NSString *_Nullable)plateId andPrmission:(NSString *_Nullable)permission CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;

/***连锁给门店授权*/
+(void)memberShopGrantShopPermissionWithList:(NSMutableArray *_Nullable)arr CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;

/***查询单店新增营销活动权限(1-商品;2-优惠券/促销活动)*/
+ (void)memberCouponShopHasPermissionWithType:(NSString *_Nullable)type CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

/***请求不适用商品列表*/
+(void)memberExceptMenusNameWithListStr:(NSString *_Nullable)listStr andIsChain:(NSString *_Nullable)ischain CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;

/***请求打折方案列表*/
+(void)memberExceptKindNameWithListStr:(NSString *_Nullable)listStr andIsChain:(NSString *_Nullable)ischain CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;
@end




















