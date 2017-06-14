//
//  TDFBusinessService.h
//  RestApp
//
//  Created by happyo on 2016/11/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHTTPClient.h"

@interface TDFBusinessService : NSObject

// 获取首页营业汇总数据
+ (void)fetchHomeBusinessSummaryWithMonthDate:(NSString * _Nonnull)monthDate completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 获取首页营业汇总数据 v2
+ (void)fetchV2HomeBusinessSummaryWithMonthDate:(NSString * _Nonnull)monthDate completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 获取当日营业汇总详情
+ (void)fetchDayBusinessDetailWithMonthDate:(NSString * _Nonnull)monthDate completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 获取当日营业汇总详情 v2
+ (void)fetchV2DayBusinessDetailWithCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 获取当月营业汇总详情
+ (void)fetchMonthBusinessDetailWithCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 获取近期月份营业汇总详情
+ (void)fetchRecentMonthsBusinessDetailWithCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;


// 获取营业班次
+ (void)fetchBusinessSpellWithCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 保存或者修改营业班次
+ (void)saveBusinessSpellWithSpellString:(NSString * _Nonnull)spellString completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 删除单条营业班次
+ (void)removeBusinessSpellWithSpellId:(NSString * _Nonnull)spellId completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 删除多条营业班次
+ (void)removeBusinessSpellWithSpellIds:(NSString * _Nonnull)spellIdsJson completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 获取班次内的支付方式汇总
+ (void)fecthPayInfoWithDate:(NSString * _Nonnull)date
                   startTime:( NSString * _Nonnull )startTime
                     endTime:(NSString * _Nonnull)endTime
                       isAll:(BOOL)isAll
               completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 获取班次内的支付方式汇总 v2
+ (void)fecthV2PayInfoWithDate:(NSString * _Nonnull)date
                   startTime:( NSString * _Nonnull )startTime
                     endTime:(NSString * _Nonnull)endTime
                       isAll:(BOOL)isAll
               completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 分页拉取营业流水记录，三个纬度筛选
+ (void)fecthPayDetailWithDate:(NSString * _Nonnull)date
                     startTime:( NSString * _Nonnull )startTime
                       endTime:(NSString * _Nonnull)endTime
                         isAll:(BOOL)isAll
                     kindPayId:(NSString * _Nonnull )kindPayId
                       pageNum:(NSInteger)pageNum
                 completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

// 分页拉取营业流水记录，三个纬度筛选 v2
+ (void)fecthV2PayDetailWithDate:(NSString * _Nonnull)date
                     startTime:( NSString * _Nonnull )startTime
                       endTime:(NSString * _Nonnull)endTime
                         isAll:(BOOL)isAll
                     kindPayId:(NSString * _Nonnull )kindPayId
                          type:(NSString * _Nonnull)type
                       pageNum:(NSInteger)pageNum
                 completeBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;


// 获取支付方式图片
+ (void)fetchPayTypeImageUrlWithCompleteBlock:(nullable void (^)(TDFResponseModel *_Nullable))callback;

@end
