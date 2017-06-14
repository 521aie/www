//
//  SettingService.m
//  RestApp
//
//  Created by zxh on 14-4-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindPay.h"
#import "LinkMan.h"
#import "SignUtil.h"
#import "Platform.h"
#import "JsonHelper.h"
#import "MobileUtil.h"
#import "RemoteResult.h"
#import "RestConstants.h"
#import "TimeArrangeVO.h"
#import "SettingService.h"
#import "KindMenuStyleVO.h"
#import "NSString+Estimate.h"
#import "KindConfigConstants.h"
#import "JSONKit.h"
#import "TDFNetworkingConstants.h"
#import "TDFResponseModel.h"
#import "AlertBox.h"
@implementation SettingService

/**
 *  系统参数(new)
 */

-(void)listSystemConfig:(NSString *)config_code callback:( void (^)(TDFResponseModel * responseModel) )callBack{

    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = @"boss";
    requestModel.apiVersion = @"v1";
    requestModel.actionPath = @"batch_get_entity_config";
    requestModel.parameters =  @{@"config_codes":config_code,
                                 @"session_key":[[Platform Instance] getkey:SESSION_KEY]
                                 }.mutableCopy;
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callBack];
}

/**
 *   获取店铺配置信息（红包）  
 */
-(void)getPacketShopConfigWithCallBack:( void (^)(TDFResponseModel * responseModel) )callBack{
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = @"promotion";
    requestModel.apiVersion = @"v2";
    requestModel.actionPath = @"get_shop_conf_by_entity_id";
    requestModel.parameters =  @{@"session_key":[[Platform Instance] getkey:SESSION_KEY]}.mutableCopy;
     [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callBack];
}
/**
 *  系统参数保存（new）
 */

-(void)saveSystemConfig:(NSDictionary *)ids callBack:(void(^)(TDFResponseModel *responseModel))callBack{
  
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = @"boss";
    requestModel.apiVersion = @"v1";
    requestModel.actionPath = @"batch_set_entity_config";
    requestModel.parameters =  @{@"config_map_json":[ids JSONString],
                                 @"session_key":[[Platform Instance] getkey:SESSION_KEY]?[[Platform Instance] getkey:SESSION_KEY]:@""
                                 }.mutableCopy;
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callBack];
    
}



/**
 *   保存自动领券开关设置
 */

-(void)savePacketWithCouponId:(NSString *)couponId
                         type:(NSInteger)type
                       isAuto:(NSInteger)isAuto
                     callBack:(void (^)(TDFResponseModel *))callBack
{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = @"promotion";
    requestModel.apiVersion = @"v1";
    requestModel.actionPath = @"set_auto_send_and_coupon";
    requestModel.parameters =  @{@"coupon_id":couponId,
                                 @"type":[NSString stringWithFormat:@"%ld",type],
                                 @"is_auto_send":[NSString stringWithFormat:@"%ld",isAuto],
                                 @"session_key":[[Platform Instance] getkey:SESSION_KEY]
                                 }.mutableCopy;
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callBack];
}
//短信联系人
-(void) listLinkManTarget:(id)target Callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [super postSession:@"ios/sms-link-man!list.action" param:param target:target callback:callback];
}


- (void)saveLinkMan:(LinkMan *)linkMan Target:(id)target Callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:linkMan] forKey:@"linkManStr"];
    [super postSession:@"ios/sms-link-man!save.action" param:param  target:target callback:callback];
}

-(void) updateLinkMan:(LinkMan *)linkMan Target:(id)target Callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:linkMan] forKey:@"linkManStr"];
    [super postSession:@"ios/sms-link-man!update.action" param:param target:target callback:callback];
}


-(void) removeLinkMan:(NSString *)objId Target:(id)target Callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:objId forKey:@"id"];
    [super postSession:@"ios/sms-link-man!remove.action" param:param  target:target callback:callback];
    
}

-(void) removeLinkMans:(NSMutableArray*)ids Target:(id)target Callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper arrTransJson:ids] forKey:@"idsStr"];
    [super postSession:@"ios/sms-link-man!batchRemove.action" param:param  target:target callback:callback];
}
-(void) updateTailDeal:(TailDeal*)tailDeal Target:(id)target Callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:tailDeal] forKey:@"tailDealStr"];
    [super postSession:@"ios/tail-deal!update.action" param:param  target:target callback:callback];
}

-(void) removeTailDeal:(NSString*)objId Target:(id)target Callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:objId forKey:@"id"];
    [super postSession:@"ios/tail-deal!remove.action" param:param  target:target callback:callback];
}

//数据清理
-(void) dataClearTarget:(id)target Callback:(SEL)callback startDate:(NSString *)startDate endDate:(NSString *)endDate
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:startDate forKey:@"startDate"];
    [param setObject:endDate forKey:@"endDate"];
    [super postSession:@"ios/data-clear!clear.action" param:param target:target callback:callback];
}

//数据清理
- (void) queryClearTaskTarget:(id)target Callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [super postSession:@"ios/data-task-clear!queryClearTask.action" param:param target:target callback:callback];
}

//自动清理保存
- (void)saveOrUpdateTarget:(id)target Callback:(SEL)callback  Integer:(int) count
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];

    [param setObject:[NSString stringWithFormat:@"%d",count] forKey:@"cycle"];
    [param setObject:@"03:00:00" forKey:@"startTime"];
    [super postSession:@"ios/data-task-clear!saveOrUpdate.action" param:param target:target callback:callback];
}

//关闭自动清理
- (void)closeAutoClearTarget:(id)target Callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [super postSession:@"ios/data-task-clear!stopTask.action" param:param target:target callback:callback];
}

@end
