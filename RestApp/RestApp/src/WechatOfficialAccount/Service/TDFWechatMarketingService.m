//
//  TDFWechatMarketingService.m
//  RestApp
//
//  Created by Octree on 9/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWechatMarketingService.h"
#import "TDFWXPayRequestModel.h"
#import "TDFHTTPClient.h"
#import "TDFResponseModel.h"
#import "TDFDataCenter.h"
#import "TDFWXMockRequestModel.h"

@implementation TDFWechatMarketingService

#pragma mark - Public Methods

+ (instancetype)service {

    return [[[self class] alloc] init];
}

- (TDFRequestModel *)getRequestModelWithPath:(NSString *)path params:(NSDictionary *)params{
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = path;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.timeout = 15;
    
    NSMutableDictionary *mutableParams = params? [params mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:1];
    mutableParams[@"session_key"] = [TDFDataCenter sharedInstance].sessionKey;
    
    requestModel.parameters = [mutableParams copy];
    
    return requestModel;
}


- (NSURLSessionDataTask *)fetchMarkectingInfoWithCallback:(void(^)(id responseObj, NSError *error))callback {
    
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"composite_info";
    requestModel.apiVersion = @"v2";
    return [self sendRequestWithMode:requestModel callback:callback];
}

- (NSURLSessionDataTask *)fetchWXPayTraderWithId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"wxpay_trader_info";
    requestModel.parameters = @{ @"appointed_shop_id": traderId };
    requestModel.apiVersion = @"v1";
    return [self sendRequestWithMode:requestModel callback:callback];
}


- (NSURLSessionDataTask *)saveWXPayTraderWithId:(NSString *)traderId json:(NSString *)jsonString callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"save_wxpay_trader_info";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"wxpay_trader_info_json"] = jsonString;
    requestModel.parameters = params;
    requestModel.apiVersion = @"v1";
    return [self sendRequestWithMode:requestModel callback:callback];
}


- (NSURLSessionDataTask *)fetchAutoFollowInfoWithTraderId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"query_auto_focus_detail";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appointed_shop_id"] = traderId;
    requestModel.parameters = params;
    return [self sendRequestWithMode:requestModel callback:callback];
}


- (NSURLSessionDataTask *)saveTraderShopsWithTraderId:(NSString *)traderId shopIds:(NSString *)shopIds callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"wxpay_trader_save_shops";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appointed_shop_id"] = traderId;
    params[@"entity_id_json"] = shopIds;
    requestModel.parameters = params;
    return [self sendRequestWithMode:requestModel callback:callback];
}
- (NSURLSessionDataTask *)saveAutoFollowInfoWithTraderId:(NSString *)traderId jsonString:(NSString *)json callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"save_auto_focus_detail";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appointed_shop_id"] = traderId;
    params[@"auto_focus_json"] = json;
    requestModel.parameters = params;
    return [self sendRequestWithMode:requestModel callback:callback];
}

- (NSURLSessionDataTask *)fetchAuthedOfficialAccountsWithCallback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"query_authorized_official_account";
    return [self sendRequestWithMode:requestModel callback:callback];
}


- (NSURLSessionDataTask *)fetchRefundAuditInfoWithTraderId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"query_refund_detail";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appointed_shop_id"] = traderId;
    requestModel.apiVersion = @"v2";
    requestModel.parameters = params;
    return [self sendRequestWithMode:requestModel callback:callback];
}

- (NSURLSessionDataTask *)fetchOfficialAccountInfoWithId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"query_wx_account_info";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"wx_app_id"] = oaId;
    requestModel.parameters = params;
    return [self sendRequestWithMode:requestModel callback:callback];
}

- (NSURLSessionDataTask *)updateShopsWithOfficialAccountId:(NSString *)accountId shopIds:(NSString *)shopIds callback:(void(^)(id responseObj, NSError *error))callback {
    
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"update_wx_authorized_shops";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"wx_app_id"] = accountId;
    params[@"entity_id_json"] = shopIds;
    requestModel.parameters = params;
    return [self sendRequestWithMode:requestModel callback:callback];
}

- (NSURLSessionDataTask *)fetchAuthURLWithShopIds:(NSString *)ids officialAcountId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"to_authorized_qr_code_url";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"entity_ids"] = ids;
    params[@"wx_app_id"] = oaId ?: @"";
    requestModel.parameters = params;
    return [self sendRequestWithMode:requestModel callback:callback];
}

- (NSURLSessionDataTask *)fetchBranchShopsWithOAId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"query_wx_authorized_shops";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"wx_app_id"] = oaId ?: @"";
    requestModel.parameters = params;
    return [self sendRequestWithMode:requestModel callback:callback];
}

- (NSURLSessionDataTask *)saveRefundInfoWithTraderId:(NSString *)traderId json:(NSString *)json callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"save_refund_detail";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appointed_shop_id"] = traderId;
    params[@"refund_info_json"] = json;
    requestModel.parameters = params;
    return [self sendRequestWithMode:requestModel callback:callback];
}


/**
 *  获取特约商户审核状态
 */
- (NSURLSessionDataTask *)fetchTraderAuditInfoWithTraderId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"wxpay_status";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"appointed_shop_id"] = traderId;
    requestModel.parameters = dict;
    return [self sendRequestWithMode:requestModel callback:callback];
}

/**
 *  获取连锁下的特约商户
 */
- (NSURLSessionDataTask *)fetchTradersWithCallback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"wxpay_traders";
    return [self sendRequestWithMode:requestModel callback:callback];
}

- (NSURLSessionDataTask *)fetchTraderBranchShopsWithTraderId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"query_wxpay_trader_shops";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"appointed_shop_id"] = traderId;
    requestModel.parameters = dict;
    return [self sendRequestWithMode:requestModel callback:callback];
}

- (NSURLSessionDataTask *)urgentTraderAuditWithTraderId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"mark_urgent";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"appointed_shop_id"] = traderId;
    requestModel.parameters = dict;
    return [self sendRequestWithMode:requestModel callback:callback];
}


/**
 *  一键设置 Menu
 *
 */
- (NSURLSessionDataTask *)fetchInitialMenusWithOAId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback {
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"init_wx_account_menu";
    requestModel.parameters = @{@"wx_app_id": oaId};
    requestModel.apiVersion = @"v2";
    return [self sendRequestWithMode:requestModel callback:callback];
}

/**
 *  把所有链接发送到邮箱
 *
 */
- (NSURLSessionDataTask *)sendLinks:(NSString *)links toEmails:(NSString *)emails callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"send_links";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"links"] = links;
    dict[@"mail_to"] = emails;
    requestModel.parameters = dict;
    return [self sendRequestWithMode:requestModel callback:callback];
}

/**
 *  获取所有 Menus
 *
 */
- (NSURLSessionDataTask *)fetchMenusWithWXId:(NSString *)wxId callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"get_wx_account_menu_info";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"wx_app_id"] = wxId ?: @"";
    requestModel.parameters = dict;
    return [self sendRequestWithMode:requestModel callback:callback];
}


- (NSURLSessionDataTask *)saveMenusWithWXId:(NSString *)wxId menusStrings:(NSString *)menus callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"save_wx_account_menu";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"wx_app_id"] = wxId;
    dict[@"menu_str"] = menus;
    requestModel.parameters = dict;
    return [self sendRequestWithMode:requestModel callback:callback];
}

/**
 *   获取微信公众号绑定的店铺
 */

- (NSURLSessionDataTask *)fetchPurchasedShopsWithOAId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"wx_account_bind_shops";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"wx_app_id"] = oaId ?: @"";
    requestModel.parameters = dict;
    return [self sendRequestWithMode:requestModel callback:callback];
}

/**
 *  获取菜单名称, url 列表
 *
 */
- (NSURLSessionDataTask *)fetchMenuURLsWithOAId:(NSString *)oaId shopId:(NSString *)shopId callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"get_wx_account_menu_url";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"shop_entity_id"] = shopId;
    requestModel.parameters = dict;
    return [self sendRequestWithMode:requestModel callback:callback];
}

- (NSURLSessionDataTask *)fetchURLDetailWithType:(NSInteger)type shopId:(NSString *)shopId callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"query_url_detail";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"url_type"] = [NSString stringWithFormat:@"%zd", type];
    dict[@"shop_entity_id"] = shopId;
    requestModel.parameters = dict;
    return [self sendRequestWithMode:requestModel callback:callback];
}

+ (NSURLSessionDataTask *)fetchWechatNotificationSettingWithWechatId:(NSString *)wechatId callback:(void (^)(id, NSError *))callback
{
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"query_msg_push_setting";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"wx_app_id"] = wechatId;
    
    requestModel.parameters = params;

    
    return [self sendClassRequestWithMode:requestModel callback:callback];
}

+ (NSURLSessionDataTask *)saveWechatNotificationSettingWithWechatId:(NSString *)wechatId Json:(NSString *)json callback:(void (^)(id, NSError *))callback
{
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"update_msg_push_setting";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"msg_set_str"] = json;
    params[@"wx_app_id"] = wechatId;
    
    requestModel.parameters = params;
    
    return [self sendClassRequestWithMode:requestModel callback:callback];
}

+ (NSURLSessionDataTask *)fetchOfficialAccountsQrcodeWithWechatId:(NSString *)wechatId callback:(void (^)(id, NSError *))callback
{
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"query_official_accounts_qrcode";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"wx_app_id"] = wechatId;
    
    requestModel.parameters = params;
    
    return [self sendClassRequestWithMode:requestModel callback:callback];
}

+ (NSURLSessionDataTask *)deleteOfficialAccountsQrcodeWithWechatId:(NSString *)wechatId callback:(void (^)(id, NSError *))callback
{
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"delete_official_accounts_qrcode";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"wx_app_id"] = wechatId;
    
    requestModel.parameters = params;
    
    return [self sendClassRequestWithMode:requestModel callback:callback];
}

+ (NSURLSessionDataTask *)saveOfficialAccountsQrcodeWithWechatId:(NSString *)wechatId imagePath:(NSString *)imagePath callback:(void (^)(id, NSError *))callback
{
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"save_official_accounts_qrcode";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"wx_app_id"] = wechatId;
    params[@"file_path"] = imagePath;
    
    requestModel.parameters = params;
    
    return [self sendClassRequestWithMode:requestModel callback:callback];
}

+ (NSURLSessionDataTask *)reloadOfficialAccountsQrcodeWithWechatId:(NSString *)wechatId callback:(void (^)(id, NSError *))callback
{
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"reload_official_accounts_qrcode";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"wx_app_id"] = wechatId;
    
    requestModel.parameters = params;
    
    return [self sendClassRequestWithMode:requestModel callback:callback];
}

+ (NSURLSessionDataTask *)fetchOfficialAccountsAuthorizationListWithCallback:(void (^)(id, NSError *))callback
{
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"query_authorized_official_account";
    
    return [self sendClassRequestWithMode:requestModel callback:callback];
}


#pragma mark - 二期

- (NSURLSessionDataTask *)fetchOfficialAccountFansInfoWithId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"query_fans_analyze_info";
    requestModel.parameters = @{ @"wx_app_id": oaId };
    requestModel.apiVersion = @"v2";
    return [self sendRequestWithMode:requestModel callback:callback];
}

/**
 * 获取推送消息给微信会员列表
 */
- (NSURLSessionDataTask *)fetchPromotionListWithOAId:(NSString *)oaId page:(NSInteger)page limitation:(NSInteger)limitation callback:(void (^)(id, NSError *))callback{
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"query_notifications";
    requestModel.parameters = @{ @"wx_app_id": oaId ?: @"",
                                 @"page": [NSString stringWithFormat:@"%zd", page],
                                 @"page_size":[NSString stringWithFormat:@"%zd", limitation]
                                 };
    return [self sendRequestWithMode:requestModel callback:callback];
}

/**
 * 获取推送券列表
 */
- (NSURLSessionDataTask *)fetchPromotionCouponListWithOAId:(NSString *) oaId callback:(void(^) (id responseObj, NSError *error))callback {
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"list_coupon_promotion";
    requestModel.parameters = @{ @"wx_app_id": oaId };
    return [self sendRequestWithMode:requestModel callback:callback];
}

- (NSURLSessionDataTask *)fetchNotificationOptionsWithOAId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback {
    
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"get_notification_object_options";
    requestModel.parameters = @{ @"wx_app_id": oaId };
    return [self sendRequestWithMode:requestModel callback:callback];
}
/**
 * 获取推送会员卡列表
 */
- (NSURLSessionDataTask *)fetchKindCardListWithOAId:(NSString *) oaId callback:(void(^) (id responseObj, NSError *error))callback {
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"kind_card_list";
    requestModel.parameters = @{ @"wx_app_id": oaId };
    return [self sendRequestWithMode:requestModel callback:callback];
}


/**
 * 获取推送优惠活动列表
 */
- (NSURLSessionDataTask *)fetchPromotionSaleListWithOAId:(NSString *) oaId callback:(void(^) (id responseObj, NSError *error))callback {
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"list_sales_promotion";
    requestModel.parameters = @{ @"wx_app_id": oaId };
    return [self sendRequestWithMode:requestModel callback:callback];
}


- (NSURLSessionDataTask *)sendNotificationWithOAId:(NSString *)oaId json:(NSString *)json callback:(void(^)(id responseObj, NSError *error))callback {

    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"save_notification";
    requestModel.parameters = @{ @"wx_app_id": oaId,
                                 @"notification_str": json
                                 };
    return [self sendRequestWithMode:requestModel callback:callback];
}

- (NSURLSessionTask *)fetchMenuOptionsWithOAId:(NSString *)oaId callback:(void(^)(id responseObj, NSError *error))callback {
    
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"get_menu_options";
    requestModel.parameters = @{ @"wx_app_id": oaId };
    return [self sendRequestWithMode:requestModel callback:callback];
}


- (NSURLSessionTask *)applyRefundWithTraderId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback {
    
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"apply_wx_refund";
    requestModel.parameters = @{ @"appointed_shop_id": traderId };
    return [self sendRequestWithMode:requestModel callback:callback];
}

- (NSURLSessionTask *)acceptRefundInvitationWithTraderId:(NSString *)traderId callback:(void(^)(id responseObj, NSError *error))callback {
    
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"refund_accept_invitation";
    requestModel.parameters = @{ @"appointed_shop_id": traderId };
    return [self sendRequestWithMode:requestModel callback:callback];
}


- (NSURLSessionTask *)sendMenuLinksWithOAId:(NSString *)oaId toEmail:(NSString *)email callback:(void(^)(id responseObj, NSError *error))callback {
    
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"send_links_to_email";
    requestModel.parameters = @{ @"wx_app_id": oaId, @"mail_to" : email };
    return [self sendRequestWithMode:requestModel callback:callback];
}


- (NSURLSessionDataTask *)fetchURLDetailWithType:(NSInteger)type shopEntityId:(NSString *)entityId scopeType:(NSInteger)scopeType plateId:(NSString *)plateId callback:(void(^)(id responseObj, NSError *error))callback {
    
    TDFWXPayRequestModel *requestModel = [[TDFWXPayRequestModel alloc] init];
    requestModel.actionPath = @"query_menu_url_detail";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"url_type"] = [NSString stringWithFormat:@"%zd", type];
    dict[@"shop_entity_id"] = entityId ?: @"";
    dict[@"scope_type"] = [NSString stringWithFormat:@"%zd", scopeType];
    dict[@"plate_id"] = plateId ?: @"";
    requestModel.parameters = dict;
    return [self sendRequestWithMode:requestModel callback:callback];
}


#pragma mark - Private Methods


- (NSURLSessionDataTask *)sendRequestWithMode:(TDFRequestModel *)requestModel callback:(void(^)(id responseObj, NSError *error))callback {

    return [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * responseModel) {
        
        if (responseModel.isSuccess) {
            callback(responseModel.responseObject, nil);
            return;
        }
        callback(nil, responseModel.error);
    }];
}

+ (NSURLSessionDataTask *)sendClassRequestWithMode:(TDFRequestModel *)requestModel callback:(void(^)(id responseObj, NSError *error))callback {
    
    return [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * responseModel) {
        
        if (responseModel.isSuccess) {
            callback(responseModel.responseObject, nil);
            return;
        }
        callback(nil, responseModel.error);
    }];
}

- (NSURLSessionDataTask *)getCardInfoWithOAId:(NSString *)oaId
                                       sucess:(void(^)(NSURLSessionDataTask * task, id data))sucessBlock
                                      failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failureBlock {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"wx_app_id"] = oaId;
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"wx_official_account/v1/list_sync_kind_card" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)getConpousInfoWithOAId:(NSString *)oaId
                                          sucess:(void(^)(NSURLSessionDataTask *task, id data))sucessBlock
                                         failure:(void(^)(NSURLSessionDataTask *task, NSError * error))failureBlock {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"wx_app_id"] = oaId;
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"wx_official_account/v1/list_sync_coupon" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)getCanSynchronizeCardInfoWithOAId:(NSString *)oaId
                                                     sucess:(void(^)(NSURLSessionDataTask * task, id data))sucessBlock
                                                    failure:(void(^)(NSURLSessionDataTask *task, NSError * error))failureBlock {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"wx_app_id"] = oaId;
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"wx_official_account/v1/query_cards" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)getCanSynchronizeConpousInfoWithOAId:(NSString *)oaId
                                                        sucess:(void(^)(NSURLSessionDataTask *task, id data))sucessBlock
                                                       failure:(void(^)(NSURLSessionDataTask *task, NSError * error))failureBlock {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"wx_app_id"] = oaId;
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"wx_official_account/v1/query_coupons" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)saveSynchronizeCardInfoWithOAId:(NSString *)oaId
                                         andOverwriteFlag:(int)overwriteFlag
                                                 cardInfo:(NSString *)cardSyncStr
                                                   sucess:(void(^)(NSURLSessionDataTask *task, id data))sucessBlock
                                                  failure:(void(^)(NSURLSessionDataTask *task, NSError * error))failureBlock {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"wx_app_id"] = oaId;
    param[@"overwrite_flag"] = [NSString stringWithFormat:@"%d",overwriteFlag];
    param[@"card_sync_str"] = cardSyncStr;
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"wx_official_account/v1/save_sync_card_switch" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;

}

- (NSURLSessionDataTask *)saveSynchronizeConpousInfoWithOAId:(NSString *)oaId
                                            andOverwriteFlag:(int)overwriteFlag
                                                    cardInfo:(NSString *)couponSyncStr
                                                      sucess:(void(^)(NSURLSessionDataTask *task, id data))sucessBlock
                                                     failure:(void(^)(NSURLSessionDataTask *task, NSError * error))failureBlock {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"wx_app_id"] = oaId;
    param[@"overwrite_flag"] = [NSString stringWithFormat:@"%d",overwriteFlag];
    param[@"coupon_sync_str"] = couponSyncStr;
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"wx_official_account/v1/save_sync_coupon_switch" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)synchronizeCardWithOAId:(NSString *)oaId
                                       andCardIds:(NSString *)cardIds
                                           sucess:(void(^)(NSURLSessionDataTask *task, id data))sucessBlock
                                          failure:(void(^)(NSURLSessionDataTask *task, NSError * error))failureBlock {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"wx_app_id"] = oaId;
    param[@"card_ids"] = cardIds;
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"wx_official_account/v1/synchronize_card" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)synchronizeConpousWithOAId:(NSString *)oaId
                                       andConpousIds:(NSString *)couponsIds
                                              sucess:(void(^)(NSURLSessionDataTask *task, id data))sucessBlock
                                             failure:(void(^)(NSURLSessionDataTask *task, NSError * error))failureBlock {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"wx_app_id"] = oaId;
    param[@"coupon_ids"] = couponsIds;
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"wx_official_account/v1/synchronize_coupon" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
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
