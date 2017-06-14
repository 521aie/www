//
//  TDFShopInfoService.h
//  RestApp
//
//  Created by happyo on 2016/12/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHTTPClient.h"

@interface TDFShopInfoService : NSObject

// 查询店家信息
+ (void)fetchShopInfoWithCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 保存店家信息
+ (void)saveShopInfoWithShopString:(NSString * _Nonnull)shopString completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

@end
