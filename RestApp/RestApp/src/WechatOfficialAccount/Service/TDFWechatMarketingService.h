//
//  TDFWechatMarketingService.h
//  RestApp
//
//  Created by Octree on 9/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface TDFWechatMarketingService : NSObject

+ (instancetype)service;

/**
 *  获取微信营销信息（首页）
 *
 */
- (NSURLSessionDataTask *)fetchMarkectingInfoWithCallback:(void(^)(id responseObj, NSError *error))callback;
/**
 *  获取特约商户信息
 *
 *  @param traderId 商户 Id，单店不需要传 id
 *  @param callback 回调
 *
 *  @return Task
 */
- (NSURLSessionDataTask *)fetchWXPayTraderWithId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback;
/**
 *  保存特约商户信息
 *
 *  @param traderId   商户 Id
 *  @param jsonString Data
 *  @param callback   回调
 *
 *  @return Task
 */
- (NSURLSessionDataTask *)saveWXPayTraderWithId:(NSString *)traderId json:(NSString *)jsonString callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  获取微信自动关注的信息
 *
 *  @param callback 回调
 *
 *  @return Task
 */
- (NSURLSessionDataTask *)fetchAutoFollowInfoWithTraderId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback;

//   保存特约商户绑定的门店
- (NSURLSessionDataTask *)saveTraderShopsWithTraderId:(NSString *)traderId shopIds:(NSString *)shopIds callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  保存自动关注的公众号
 *
 *  @param traderId traderId
 *  @param json     jsonString
 *  @param callback callback
 *
 *  @return task
 */
- (NSURLSessionDataTask *)saveAutoFollowInfoWithTraderId:(NSString *)traderId jsonString:(NSString *)json callback:(void(^)(id responseObj, NSError *error))callback;

/**
 * 获取店家微信通知设置
 */
+ (NSURLSessionDataTask *)fetchWechatNotificationSettingWithWechatId:(NSString *)wechatId callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  获取已经绑定的微信公众号们哈
 *
 *  @param callback 回调
 *
 *  @return Task
 */
- (NSURLSessionDataTask *)fetchAuthedOfficialAccountsWithCallback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  获取连锁下的特约商户
 */
- (NSURLSessionDataTask *)fetchTradersWithCallback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  获取连锁下的 门店 & 分公司
 */
- (NSURLSessionDataTask *)fetchTraderBranchShopsWithTraderId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback;


/**
 *  获取特约商户审核状态
 */
- (NSURLSessionDataTask *)fetchTraderAuditInfoWithTraderId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  获取特约商户审核加急
 */
- (NSURLSessionDataTask *)urgentTraderAuditWithTraderId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  获取退款审核信息
 */
- (NSURLSessionDataTask *)fetchRefundAuditInfoWithTraderId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  保存退款信息
 *
 */
- (NSURLSessionDataTask *)saveRefundInfoWithTraderId:(NSString *)traderId json:(NSString *)json callback:(void(^)(id responseObj, NSError *error))callback;
/**
 *  获取公众号信息
 */
- (NSURLSessionDataTask *)fetchOfficialAccountInfoWithId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  更新微信公众号绑定的门店
 */
- (NSURLSessionDataTask *)updateShopsWithOfficialAccountId:(NSString *)accountId shopIds:(NSString *)shopIds callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  获取公众号授权页面
 *
 */
- (NSURLSessionDataTask *)fetchAuthURLWithShopIds:(NSString *)ids officialAcountId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  获取微信公众号绑定的门店，如果为空，则返回所有未绑定的门店
 *
 */
- (NSURLSessionDataTask *)fetchBranchShopsWithOAId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  一键设置 Menu
 *
 */
- (NSURLSessionDataTask *)fetchInitialMenusWithOAId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  把所有链接发送到邮箱
 *
 */
- (NSURLSessionDataTask *)sendLinks:(NSString *)links toEmails:(NSString *)emails callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  获取所有 Menus
 *
 */
- (NSURLSessionDataTask *)fetchMenusWithWXId:(NSString *)wxId callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  保存 Menus
 *
 */
- (NSURLSessionDataTask *)saveMenusWithWXId:(NSString *)wxId menusStrings:(NSString *)menus callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *   获取微信公众号绑定的店铺，如果 OAID 是空，返回所有门店
 */

- (NSURLSessionDataTask *)fetchPurchasedShopsWithOAId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  获取菜单名称, url 列表
 *
 */
- (NSURLSessionDataTask *)fetchMenuURLsWithOAId:(NSString *)oaId shopId:(NSString *)shopId callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  根据店铺 Id 和 URL Type 获取 URL 详情
 */
- (NSURLSessionDataTask *)fetchURLDetailWithType:(NSInteger)type shopId:(NSString *)shopId callback:(void(^)(id responseObj, NSError *error))callback;
/*
 * 保存店家微信通知设置
 */
+ (NSURLSessionDataTask *)saveWechatNotificationSettingWithWechatId:(NSString *)wechatId Json:(NSString *)json callback:(void(^)(id responseObj, NSError *error))callback;

/*
 * 请求公众号二维码
 */
+ (NSURLSessionDataTask *)fetchOfficialAccountsQrcodeWithWechatId:(NSString *)wechatId callback:(void(^)(id responseObj, NSError *error))callback;

/*
 * 删除店家公众号二维码
 */
+ (NSURLSessionDataTask *)deleteOfficialAccountsQrcodeWithWechatId:(NSString *)wechatId callback:(void(^)(id responseObj, NSError *error))callback;

/*
 * 保存店家公众号二维码
 */
+ (NSURLSessionDataTask *)saveOfficialAccountsQrcodeWithWechatId:(NSString *)wechatId imagePath:(NSString *)imagePath callback:(void(^)(id responseObj, NSError *error))callback;


/*
 * 重新请求公众号二维码
 */
+ (NSURLSessionDataTask *)reloadOfficialAccountsQrcodeWithWechatId:(NSString *)wechatId callback:(void(^)(id responseObj, NSError *error))callback;

/*
 * 请求公众号授权列表
 */
+ (NSURLSessionDataTask *)fetchOfficialAccountsAuthorizationListWithCallback:(void(^)(id responseObj, NSError *error))callback;




#pragma mark - 二期
/**
 *  获取微信粉丝分析的信息
 *
 *  @param oaId     公众号 Id
 *  @param callback 回调
 *
 *  @return Task
 */
- (NSURLSessionDataTask *)fetchOfficialAccountFansInfoWithId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback;


/*
 * 请求定向推送卡／券／促销活动列表
 */
- (NSURLSessionDataTask *)fetchPromotionListWithOAId:(NSString *)oaId page:(NSInteger)page limitation:(NSInteger)limitation callback: (void(^)(id responseObj, NSError *error))callback;

/*
 * 统一获取推送列表
 */
- (NSURLSessionDataTask *)fetchAllPromotionListWithOAId:(NSString *) oaId actionPath:(NSString *)actionPath callback:(void(^) (id responseObj, NSError *error))callback;

/*
 * 获取优惠券列表
 */

- (NSURLSessionDataTask *)fetchPromotionCouponListWithOAId:(NSString *) oaId callback:(void(^) (id responseObj, NSError *error))callback;
/*
 * 获取会员卡列表
 */
- (NSURLSessionDataTask *)fetchKindCardListWithOAId:(NSString *) oaId callback:(void(^) (id responseObj, NSError *error))callback;

/*
 * 获取促销活动列表
 */
- (NSURLSessionDataTask *)fetchPromotionSaleListWithOAId:(NSString *) oaId callback:(void(^) (id responseObj, NSError *error))callback;


/**
 *  请求定向推送的配置信息（Tag、分组等）
 *
 *  @param oaId     公众号 id
 *  @param callback 回调
 *
 *  @return task
 */
- (NSURLSessionDataTask *)fetchNotificationOptionsWithOAId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  发送推送消息
 *
 *  @param oaId     公众号 id
 *  @param json     notification json
 *  @param callback callback
 *
 *  @return task
 */
- (NSURLSessionDataTask *)sendNotificationWithOAId:(NSString *)oaId json:(NSString *)json callback:(void(^)(id responseObj, NSError *error))callback;

/**
 *  获取会员卡设置信息
 
 @param oaId            公众号 id
 @param sucessBlock     sucessBlock description
 @param failureBlock    failureBlock description
 @return
 */
- (NSURLSessionDataTask *)getCardInfoWithOAId:(NSString *)oaId
                                       sucess:(void(^)(NSURLSessionDataTask *task, id data))sucessBlock
                                      failure:(void(^)(NSURLSessionDataTask *task, NSError * error))failureBlock;

/**
 *  获取优惠券设置信息
 
 @param oaId            公众号 id
 @param sucessBlock     sucessBlock description
 @param failureBlock    failureBlock description
 @return
 */
- (NSURLSessionDataTask *)getConpousInfoWithOAId:(NSString *)oaId
                                       sucess:(void(^)(NSURLSessionDataTask *task, id data))sucessBlock
                                      failure:(void(^)(NSURLSessionDataTask *task, NSError * error))failureBlock;

/**
 *  查询可同步的会员卡
  
 @param oaId            公众号 id
 @param sucessBlock     sucessBlock description
 @param failureBlock    failureBlock description
 @return
 */
- (NSURLSessionDataTask *)getCanSynchronizeCardInfoWithOAId:(NSString *)oaId
                                                     sucess:(void(^)(NSURLSessionDataTask *task, id data))sucessBlock
                                                    failure:(void(^)(NSURLSessionDataTask *task, NSError * error))failureBlock;

/**
 *  查询可同步的优惠券
  
 @param oaId            公众号 id
 @param sucessBlock     sucessBlock description
 @param failureBlock    failureBlock description
 @return
 */
- (NSURLSessionDataTask *)getCanSynchronizeConpousInfoWithOAId:(NSString *)oaId
                                                     sucess:(void(^)(NSURLSessionDataTask *task, id data))sucessBlock
                                                    failure:(void(^)(NSURLSessionDataTask *task, NSError * error))failureBlock;

/**
 * 保存会员卡设置信息
 
 @param oaId 公众号 id
 @param overwriteFlag 是否作强制覆盖，0否，1覆盖
 @param cardSyncStr 会员卡设置信息, json
 @param sucessBlock sucessBlock description
 @param failureBlock
 @return
 */
- (NSURLSessionDataTask *)saveSynchronizeCardInfoWithOAId:(NSString *)oaId
                                         andOverwriteFlag:(int)overwriteFlag
                                                 cardInfo:(NSString *)cardSyncStr
                                                   sucess:(void(^)(NSURLSessionDataTask *task, id data))sucessBlock
                                                  failure:(void(^)(NSURLSessionDataTask *task, NSError * error))failureBlock;

/**
 * 保存优惠券设置信息
 
 @param oaId 公众号 id
 @param overwriteFlag 是否作强制覆盖，0否，1覆盖
 @param coupon_sync_str 会员卡设置信息, json
 @param sucessBlock sucessBlock description
 @param failureBlock
 @return
 */
- (NSURLSessionDataTask *)saveSynchronizeConpousInfoWithOAId:(NSString *)oaId
                                         andOverwriteFlag:(int)overwriteFlag
                                                 cardInfo:(NSString *)couponSyncStr
                                                   sucess:(void(^)(NSURLSessionDataTask *task, id data))sucessBlock
                                                  failure:(void(^)(NSURLSessionDataTask *task, NSError * error))failureBlock;

/**
 * 同步会员卡
 
 @param cardIds 卡类型id拼成的字符串,','隔开
 @param sucessBlock sucessBlock description
 @param failureBlock failureBlock description
 @return
 */
- (NSURLSessionDataTask *)synchronizeCardWithOAId:(NSString *)oaId
                                       andCardIds:(NSString *)cardIds
                                           sucess:(void(^)(NSURLSessionDataTask *task, id data))sucessBlock
                                          failure:(void(^)(NSURLSessionDataTask *task, NSError * error))failureBlock;

/**
 * 同步优惠券
 
 @param conpousIds 卡类型id拼成的字符串,','隔开
 @param sucessBlock sucessBlock description
 @param failureBlock failureBlock description
 @return
 */
- (NSURLSessionDataTask *)synchronizeConpousWithOAId:(NSString *)oaId
                                       andConpousIds:(NSString *)couponsIds
                                           sucess:(void(^)(NSURLSessionDataTask *task, id data))sucessBlock
                                          failure:(void(^)(NSURLSessionDataTask *task, NSError * error))failureBlock;


/**
 *  菜单自定义的配置信息
 *
 *  @param oaId     公众号 Id
 *  @param callback 回调
 *
 *  @return Task
 */
- (NSURLSessionTask *)fetchMenuOptionsWithOAId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback;


/**
 *  申请退款托管
 *
 *  @param traderId 特约商户 Id
 *  @param callback 回调
 *
 *  @return Task
 */
- (NSURLSessionTask *)applyRefundWithTraderId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback;


/**
 *  接受托管邀请
 *
 *  @param traderId 特约商户 Id
 *  @param callback 回调
 *
 *  @return Task
 */
- (NSURLSessionTask *)acceptRefundInvitationWithTraderId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback;


/**
 *  发送公众号菜单的链接到邮箱
 *
 *  @param oaId     公众号 Id
 *  @param email    邮箱
 *  @param callback 回调
 *
 *  @return Task
 */
- (NSURLSessionTask *)sendMenuLinksWithOAId:(NSString *)oaId toEmail:(NSString *)email callback:(void(^)(id responseObj, NSError *error))callback;


/**
 *  根据店铺 Id 和 URL Type 获取 URL 详情
 */
- (NSURLSessionDataTask *)fetchURLDetailWithType:(NSInteger)type shopEntityId:(NSString *)entityId scopeType:(NSInteger)scopeType plateId:(NSString *)plateId callback:(void(^)(id responseObj, NSError *error))callback;

@end
