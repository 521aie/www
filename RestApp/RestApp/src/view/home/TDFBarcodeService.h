//
//  TDFBarcodeService.h
//  RestApp
//
//  Created by doubanjiang on 16/8/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDFResponseModel.h"

@interface TDFBarcodeService : NSObject


- (nullable NSURLSessionDataTask *)barcodeLoginWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

- (nullable NSURLSessionDataTask *)loginConfirmWithParam:(nonnull NSDictionary *)param sucess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

/***口碑获取授权二维码*/
+(void)kouBeiGetAuthQRCodeCompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;
@end
