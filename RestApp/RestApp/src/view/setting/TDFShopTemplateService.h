//
//  TDFShopTemplateService.h
//  RestApp
//
//  Created by BK_G on 2017/1/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFResponseModel.h"

@interface TDFShopTemplateService : NSObject

//获取标签打印列表
+ (void)query_template_function_listCompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;

//查询智能点菜收银单模版
+ (void)query_template_function_detailWithCode:(NSString *)code andFieldCode:(NSString *)fieldCode andFieldValue:(NSString *)fieldValue CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;

//保存智能点菜收银单模版
+ (void)save_template_functionWithModel:(NSString *)model CompleteBlock:(nullable void (^)(TDFResponseModel * _Nullable))callback;


@end
