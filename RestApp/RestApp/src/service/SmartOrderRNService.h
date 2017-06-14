//
//  SmartOrderRNService.h
//  RestApp
//
//  Created by QiYa on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseService.h"
#import "TDFResponseModel.h"

@interface SmartOrderRNService : BaseService

/**
 *  通用接口？
 *
 *  @param target   <#target description#>
 *  @param api      <#api description#>
 *  @param url      <#url description#>
 *  @param params   <#params description#>
 *  @param callback <#callback description#>
 */
- (void)RNNetwork:(id)target
              Api:(NSString *)api
              Url:(NSString *)url
           Params:(NSDictionary *)params
         Callback:(SEL)callback;


- (void)RNPostImage:(UIImage *)image
           Callback:(nullable void (^)(TDFResponseModel *_Nullable))callback;

@end
