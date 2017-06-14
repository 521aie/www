//
//  SettingService.h
//  RestApp
//
//  Created by zxh on 14-4-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseService.h"
#import "ShopDetail.h"
#import "OpenTimePlan.h"
#import "RemoteResult.h"
#import "KindPay.h"
#import "TimeArrangeVO.h"
#import "LinkMan.h"
#import "ShopTemplate.h"
#import "KindMenuStyleVO.h"
#import "TailDeal.h"
#import "DicItem.h"
#import "FeePlan.h"
#import "AreaFeePlan.h"
#import "DiscountPlan.h"
#import "KindPayDetailOption.h"
#import "TDFHTTPClient.h"

@interface SettingService : BaseService

/**
 *  系统参数(new)
 */

-(void)listSystemConfig:(NSString *)config_code callback:( void (^)(TDFResponseModel * responseModel) )callBack;

/**
 *   获取店铺配置信息（红包）
 */
-(void)getPacketShopConfigWithCallBack:(void (^)(TDFResponseModel *responseModel) )callBack;

/**
 *  系统参数保存（new）
 */
-(void)saveSystemConfig:(NSDictionary *)ids callBack:(void(^)(TDFResponseModel *responseModel))callBack;

/**
 *  保存自动领券开关设置
 */

-(void)savePacketWithCouponId:(NSString *)couponId
                         type:(NSInteger)type
                       isAuto:(NSInteger)isAuto
                     callBack:(void(^)(TDFResponseModel *responseModel))callBack;
//短信联系人
-(void) listLinkManTarget:(id)target Callback:(SEL)callback;

-(void) saveLinkMan:(LinkMan*)linkMan Target:(id)target Callback:(SEL)callback;


-(void) updateLinkMan:(LinkMan*)linkMan Target:(id)target Callback:(SEL)callback;


-(void) removeLinkMan:(NSString*)objId Target:(id)target Callback:(SEL)callback;

-(void) removeLinkMans:(NSMutableArray*)ids Target:(id)target Callback:(SEL)callback;
-(void) updateTailDeal:(TailDeal*)tailDeal Target:(id)target Callback:(SEL)callback;

-(void) removeTailDeal:(NSString*)objId Target:(id)target Callback:(SEL)callback;

//数据清理
-(void) dataClearTarget:(id)target Callback:(SEL)callback startDate:(NSString*)startDate endDate:(NSString*)endDate;
-(void) queryClearTaskTarget:(id)target Callback:(SEL)callback;

- (void)saveOrUpdateTarget:(id)target Callback:(SEL)callback Integer:(int) count;
- (void)closeAutoClearTarget:(id)target Callback:(SEL)callback;

@end
