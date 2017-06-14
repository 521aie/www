//
//  TDFMemberCouponService.m
//  RestApp
//
//  Created by iOS香肠 on 16/7/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFMemberCouponService.h"
#import "Platform.h"
#import "RestConstants.h"
#import "TDFHTTPClient.h"
#import "TDFNetworkingConstants.h"
#import "TDFRequestModel.h"
#import "JSONKit.h"
#import "YYModel.h"
#import "NSString+Estimate.h"
#import "ImageUtils.h"
#import "BaseService.h"
#import "ASIFormDataRequest.h"
#import "RemoteResult.h"
#import "TDFDataCenter.h"


@implementation TDFMemberCouponService

#define BBAPI @"http://10.1.6.217:8080/boss-api"

/***请求打折方案列表*/
+(void)memberExceptKindNameWithListStr:(NSString *_Nullable)listStr andIsChain:(NSString *_Nullable)ischain CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback {

    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"batch_query_kind_menu_name";
    requestModel.serviceName =@"menu";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:listStr forKey:@"kind_menu_id_list"];
    [param setObject:ischain forKey:@"query_brand"];
    [param setObject:[[Platform Instance] getkey:SESSION_KEY] forKey:@"session_key"];
    
    requestModel.parameters = param;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

/***请求不适用商品列表*/
+(void)memberExceptMenusNameWithListStr:(NSString *_Nullable)listStr andIsChain:(NSString *_Nullable)ischain CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback {

    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"batch_query_menu_name";
    requestModel.serviceName =@"menu";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:listStr forKey:@"menu_id_list"];
    [param setObject:ischain forKey:@"query_brand"];
    [param setObject:[[Platform Instance] getkey:SESSION_KEY] forKey:@"session_key"];
    
    requestModel.parameters = param;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];

}

/***获取优惠券列表*/
+ (void)memberCouponListpage:(NSString *_Nullable)page pageSize:(NSString *_Nullable)pageSize andPlate:(NSString *_Nullable)plateId  CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback
{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"list_coupon_promotion";
    requestModel.serviceName =@"promotion";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:page forKey:@"page"];
    [param setObject:pageSize forKey:@"page_size"];
    [param setObject:[[Platform Instance] getkey:SESSION_KEY] forKey:@"session_key"];
    [param setObject:@"0,1,20,21,22,23" forKey:@"coupon_types_str"];
    if (plateId) {
        
        [param setObject:plateId forKey:@"plate_entity_id"];
    }
    
    requestModel.parameters = param;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
    
}

/***查询单店新增营销活动权限(1-商品;2-优惠券/促销活动)*/
+ (void)memberCouponShopHasPermissionWithType:(NSString *_Nullable)type CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback
{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"shop_has_permission";
    requestModel.serviceName =@"brand";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:[[Platform Instance] getkey:SESSION_KEY] forKey:@"session_key"];
    [param setObject:type forKey:@"permission_type"];
    requestModel.parameters = param;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

/***获取优惠券图片列表**/
+ (void)memberCouponBGImgpage:(NSString *_Nullable)page pageSize:(NSString *_Nullable)pageSize   CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback {

    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"list_coupon_default_bg_img";
    requestModel.serviceName =@"promotion";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
    requestModel.parameters = @{ @"session_key" : [[Platform Instance] getkey:SESSION_KEY]};
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

/***查询商品规格做法**/
+ (void)memberCouponMakeTypeWithMenuId:(NSString *_Nullable)menuId CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback {

    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"list_menu_make_spec";
    requestModel.serviceName =@"promotion";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
    requestModel.parameters = @{ @"session_key" : [[Platform Instance] getkey:SESSION_KEY],@"menu_id":menuId};
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

/***上传图片**/
+ (void)memberUpLoadBGImgWithImg:(UIImage *_Nullable)img CompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback {
    //,@"width":@"1280",@"height":@"1280",@"small_width":@"128",@"small_height":@"72"  @"file":imgData,
//    UIImage *scaleImg = [ImageUtils scaleImage:img width:1280 height:1280];
    
    NSData *imgData = UIImageJPEGRepresentation(img, 0.2);
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"image_upload";
    requestModel.serviceName =@"boss";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.parameters = @{ @"domain":@"couponBackground",@"session_key" : [[Platform Instance] getkey:SESSION_KEY],@"width":@"1280",@"height":@"1280",@"small_width":@"128",@"small_height":@"72"};
    
    requestModel.constructingBodyWithBlock = ^(id<AFMultipartFormData>  _Nonnull formData){
    
        [formData appendPartWithFileData:imgData name:@"file" fileName:@"file.jpg" mimeType:@"image/jpg"];
    };
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];

}

+ (void)uploadWithImg:(UIImage *)img domain:(NSString *)domain CompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    NSData *imgData = UIImageJPEGRepresentation(img, 0.2);
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"image_upload";
    requestModel.serviceName =@"boss";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.parameters = @{ @"domain":domain,@"session_key" : [[Platform Instance] getkey:SESSION_KEY],@"width":@"1280",@"height":@"1280",@"small_width":@"128",@"small_height":@"72"};
    
    requestModel.constructingBodyWithBlock = ^(id<AFMultipartFormData>  _Nonnull formData){
        
        [formData appendPartWithFileData:imgData name:@"file" fileName:@"file.jpg" mimeType:@"image/jpg"];
    };
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];

}

/***查询可选商品列表**/
+ (void)memberGoodsOptionListCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback {
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"list_optional_menu";
    requestModel.serviceName =@"promotion";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
//    requestModel.parameters = @{ @"session_key" : [[Platform Instance] getkey:SESSION_KEY]};
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:[[Platform Instance] getkey:SESSION_KEY]?[[Platform Instance] getkey:SESSION_KEY]:@"" forKey:@"session_key"];
    
    if ([TDFDataCenter sharedInstance].plateEntityId) {
        
        [param setObject:[TDFDataCenter sharedInstance].plateEntityId forKey:@"plate_entity_id"];
    }
    requestModel.parameters = [NSDictionary dictionaryWithDictionary:param];
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}


/***编辑或保存*/
+(void)memberCouponEditObj:(TDFMemCouEditData *_Nullable)obj CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;
{
    NSDictionary *dic =[obj yy_modelToJSONObject];
    NSString *jsonStr =[dic  JSONString];
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"save_coupon_promotion";
    requestModel.serviceName =@"promotion";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.parameters = @{@"coupon_promotion_str" :[NSString isNotBlank:jsonStr]?jsonStr:@"" , @"session_key" : [NSString isNotBlank:[[Platform Instance] getkey:SESSION_KEY]]?[[Platform Instance] getkey:SESSION_KEY]:@""};
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

/***连锁给门店授权*/
+(void)memberShopGrantShopPermissionWithList:(NSMutableArray *_Nullable)arr CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback {
    
    
    NSArray *dic = [arr yy_modelToJSONObject];
    
    NSString *jsonStr = [dic JSONString];
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"grant_shop_permission";
    requestModel.serviceName = @"brand";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
    requestModel.parameters = @{ @"session_key" : [NSString isNotBlank:[[Platform Instance] getkey:SESSION_KEY]]?[[Platform Instance] getkey:SESSION_KEY]:@"",@"shop_permission_list":jsonStr};
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

/***判断商家是否为直连加绑定用户*/
+(void)memberCouponJudgeShopIsStrightAndAliUserCompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback {
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"judge_koubei_coupon";
    requestModel.serviceName =@"promotion";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.parameters = @{ @"session_key" : [NSString isNotBlank:[[Platform Instance] getkey:SESSION_KEY]]?[[Platform Instance] getkey:SESSION_KEY]:@""};
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}
/***品牌下业务数量列表*/
+(void)memberCouponBrandListWithType:(NSString *)type CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback {
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"plate_biz_type_count_list";
    requestModel.serviceName = @"brand";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;//@"http://mock.2dfire-daily.com/mockjsdata/58/";
    
    requestModel.parameters = @{ @"session_key" : [NSString isNotBlank:[[Platform Instance] getkey:SESSION_KEY]]?[[Platform Instance] getkey:SESSION_KEY]:@"",@"biz_type":type};
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
    
}

/***门店权限列表*/
+(void)memberShopPermissionListWithPlateID:(NSString *_Nullable)plateId andPrmission:(NSString *_Nullable)permission CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback {

    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"shop_permission_list";
    requestModel.serviceName = @"brand";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
    requestModel.parameters = @{ @"session_key" : [NSString isNotBlank:[[Platform Instance] getkey:SESSION_KEY]]?[[Platform Instance] getkey:SESSION_KEY]:@"",@"plate_id":plateId,@"permission_type_list":permission};
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+(void)memberCouponDeleteItemId:(NSString *)itemId andEntityId:(NSString *)plateEntityId CompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"delete_coupon_promotion";
    requestModel.serviceName =@"promotion";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
//    requestModel.parameters = @{@"coupon_promotion_id" :itemId , @"session_key" : [[Platform Instance] getkey:SESSION_KEY]};
    
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    
    [paramDic setObject:itemId forKey:@"coupon_promotion_id"];
    
    [paramDic setObject: [[Platform Instance] getkey:SESSION_KEY] forKey:@"session_key"];
    
    if (plateEntityId) {
        
        [paramDic setObject:plateEntityId forKey:@"plate_entity_id"];
    }
    
    requestModel.parameters = [NSDictionary dictionaryWithDictionary:paramDic];
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
    
}



+(void)memberCouponPlantCompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"list_discount_template";
    requestModel.serviceName =@"promotion";
    requestModel.serverRoot =kTDFBossAPI;
    requestModel.apiVersion =@"v1";
//    requestModel.parameters = @{ @"session_key" : [[Platform Instance] getkey:SESSION_KEY]?[[Platform Instance] getkey:SESSION_KEY]:@""};
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:[[Platform Instance] getkey:SESSION_KEY]?[[Platform Instance] getkey:SESSION_KEY]:@"" forKey:@"session_key"];
    
    if ([TDFDataCenter sharedInstance].plateEntityId) {
        
        [param setObject:[TDFDataCenter sharedInstance].plateEntityId forKey:@"plate_entity_id"];
    }
    requestModel.parameters = [NSDictionary dictionaryWithDictionary:param];
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
    
}

+(void)editDiscountPlanIteamId:(NSString *)itemId CompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.serviceName =@"ios";
    requestModel.actionPath = @"discount-plan!edit.action";
     requestModel.serverRoot =[Platform Instance].serverPath;
    requestModel.parameters = @{@"id" : itemId,  @"isMenuDiscount" : @"true" };
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

+(void)memberPromotionEditObj:(TDFMemDiscountTemplateVo *)obj CompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    
    NSDictionary *dic =[obj yy_modelToJSONObject];
    NSString *jsonStr =[dic  JSONString];
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"save_discount_template";
    requestModel.serviceName =@"promotion";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
//    requestModel.parameters = @{@"discount_template_str" :jsonStr , @"session_key" : [[Platform Instance] getkey:SESSION_KEY]};
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:[[Platform Instance] getkey:SESSION_KEY]?[[Platform Instance] getkey:SESSION_KEY]:@"" forKey:@"session_key"];
    [param setObject:jsonStr forKey:@"discount_template_str"];
    
    
    if ([TDFDataCenter sharedInstance].plateEntityId) {
        
        [param setObject:[TDFDataCenter sharedInstance].plateEntityId forKey:@"plate_entity_id"];
    }
    requestModel.parameters = param;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
    
}

+(void)memberPromotionDeleteIteamId:(NSString *)itemId CompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"delete_discount_template";
    requestModel.serviceName =@"promotion";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
//    requestModel.parameters = @{@"discount_template_id" :itemId , @"session_key" : [[Platform Instance] getkey:SESSION_KEY]};
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:[[Platform Instance] getkey:SESSION_KEY]?[[Platform Instance] getkey:SESSION_KEY]:@"" forKey:@"session_key"];
    
    [param setObject:itemId forKey:@"discount_template_id"];
    
    if ([TDFDataCenter sharedInstance].plateEntityId) {
        
        [param setObject:[TDFDataCenter sharedInstance].plateEntityId forKey:@"plate_entity_id"];
    }
    requestModel.parameters = [NSDictionary dictionaryWithDictionary:param];
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}


+(void)memberMenuList:(NSString *)type CompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.serviceName =@"ios";
    requestModel.actionPath = @"menu!kingMenuList.action";
    requestModel.serverRoot =[Platform Instance].serverPath;
    requestModel.parameters = @{@"type" : type, @"keyword":@"" ,@"kindMenuId" :@""};
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
    
}


+(void)alipayPaymentCompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"get_alipay_payment";
    requestModel.serviceName =@"pay";
    requestModel.apiVersion =@"alipay/v1";
    requestModel.serverRoot =kTDFBossAPI;
    requestModel.parameters = @{ @"session_key" : [[Platform Instance] getkey:SESSION_KEY]};
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}


+(void)alipayPaymentType:(NSString *)type CompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"update_alipay_payment";
    requestModel.serviceName =@"pay";
    requestModel.apiVersion =@"alipay/v1";
    requestModel.serverRoot =kTDFBossAPI;
    NSString *str ;
    if (type.integerValue==1) {
        str =@"true";
    }
    else
    {
        str=@"false";
    }
    requestModel.parameters = @{@"alipay_is_enjoy_preferential":str, @"session_key" : [[Platform Instance] getkey:SESSION_KEY]};
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}


+(void)singlePlantId:(NSString *)Id CompleteBlock:(void (^)(TDFResponseModel * _Nullable))callback
{
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"query_discount_template";
    requestModel.serviceName =@"promotion";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot =kTDFBossAPI;
    
//    requestModel.parameters = @{@"template_id":Id, @"session_key" : [[Platform Instance] getkey:SESSION_KEY]};
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:[[Platform Instance] getkey:SESSION_KEY]?[[Platform Instance] getkey:SESSION_KEY]:@"" forKey:@"session_key"];
    [param setObject:Id forKey:@"template_id"];
    
    
    if ([TDFDataCenter sharedInstance].plateEntityId) {
        
        [param setObject:[TDFDataCenter sharedInstance].plateEntityId forKey:@"plate_entity_id"];
    }
    requestModel.parameters = param;
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
    
}

@end
