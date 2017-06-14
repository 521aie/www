//
//  SmartOrderRNService.m
//  RestApp
//
//  Created by QiYa on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SmartOrderRNService.h"
#import "RestAppConstants.h"
#import "RestConstants.h"
#import "Platform.h"
#import "TDFNetworkingConstants.h"
#import "ImageUtils.h"
#import "NSString+Estimate.h"
#import "SignUtil.h"
#import "TDFRequestModel.h"
#import "TDFHTTPClient.h"
#import "UIImage+TDF_fixOrientation.h"

//http://10.1.5.95:8080/boss-api/template/v1/get_template_index_data

@interface SmartOrderRNService ()

@end

@implementation SmartOrderRNService

/**
 *  通用接口？
 *
 *  @param target   <#target description#>
 *  @param api      <#api description#>
 *  @param url      <#url description#>
 *  @param params   <#params description#>
 *  @param callback <#callback description#>
 */
- (void)RNNetwork:(id)target Api:(NSString *)api Url:(NSString *)url Params:(NSDictionary *)params Callback:(SEL)callback {
    
    NSMutableDictionary *param;
    
    if (!params) {
        param = [[NSMutableDictionary alloc]init];
    } else {
        param = [NSMutableDictionary dictionaryWithDictionary:params];
    }
        
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entity_id"];
    
    [super postBossAPI:url
                 param:param
                target:target
              callback:callback];
    
}

/**
 RN 上传图片接口，和本地的图片上传一致，接口不同，参数拼接在本地
 */
- (void)RNPostImage:(UIImage *)image
           Callback:(nullable void (^)(TDFResponseModel *_Nullable))callback;
{
    UIImage *newImage = [image fixOrientation];//拍照会转90度需要处理
    NSData *imgData = UIImageJPEGRepresentation(newImage, 0.2);
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    
    requestModel.requestType =TDFHTTPRequestTypePOST;
    requestModel.actionPath = @"image_upload";
    requestModel.serviceName =@"boss";
    requestModel.apiVersion =@"v1";
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.parameters = @{ @"domain":@"template",@"session_key" : [[Platform Instance] getkey:SESSION_KEY],@"width":@"1280",@"height":@"1280",@"small_width":@"128",@"small_height":@"72"};
    
    requestModel.constructingBodyWithBlock = ^(id<AFMultipartFormData>  _Nonnull formData){
        
        [formData appendPartWithFileData:imgData name:@"file" fileName:@"file.jpg" mimeType:@"image/jpg"];
    };
    
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:callback];
}

@end
