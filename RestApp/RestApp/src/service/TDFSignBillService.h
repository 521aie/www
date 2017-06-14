//
//  TDFSignBillService.h
//  RestApp
//
//  Created by iOS香肠 on 2016/12/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignBillPayNoPayOptionTotalVO.h"
#import "SignBillVO.h"
@interface TDFSignBillService : NSObject

//单个挂账人的未收账单列表
- (nullable NSURLSessionDataTask *)listSignBillPeopleNoPayList:(SignBillPayNoPayOptionTotalVO *_Nonnull)signBillVo page:(NSInteger)page startDate:(NSDate *_Nonnull)startDate endDate:(NSDate *_Nonnull)endDate sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//未还款列表
- (nullable NSURLSessionDataTask *)listSignBillListSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//挂账单确认
- (nullable NSURLSessionDataTask *)listSignBillOptNoPayList:(NSMutableArray *_Nonnull)payIds sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//确认还款
- (nullable NSURLSessionDataTask *)saveSignBillPayList:(NSMutableArray *_Nonnull)payIdSet signBill:(SignBillVO *_Nonnull)signBill sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//已处理账单列表及查找
- (nullable NSURLSessionDataTask *)listSignBillPayList:(NSInteger)page sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//已处理账单详情页
- (nullable NSURLSessionDataTask *)findSignBillDetail:(NSString *_Nonnull)signBillId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//撤销收账
- (nullable NSURLSessionDataTask *)removeSignBillDetail:(NSString *_Nonnull)signBillId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

@end
