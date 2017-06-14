//
//  TDFSunofKitchenService.h
//  RestApp
//
//  Created by suckerl on 2017/6/7.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFOldSystemService/TDFOldSystemService.h>

@interface TDFSunofKitchenService : BaseService
//
- (nullable NSURLSessionDataTask *)getlistSunofKitchenWithSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                         failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;
@end
