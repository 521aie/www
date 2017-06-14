//
//  Target_PaymentModule.h
//  RestApp
//
//  Created by xueyu on 16/8/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_PaymentModule : NSObject
/**
 *   电子支付代收代付协议
 */
-(UIViewController *)Action_nativePaymentNoteViewController:(NSDictionary *)params;

/**
 *   绑定收款账户
 */
-(UIViewController *)Action_nativePaymentEditViewController:(NSDictionary *)params;
/**
 *   收款账户的状态
 */
-(UIViewController *)Action_nativePaymentStatusViewController:(NSDictionary *)params;

/**
 *  电子收款明细
 */
-(UIViewController *)Action_nativePaymentTypeViewController:(NSDictionary *)params;

/**
 *  微信/支付宝/二维火支付明细
 */
-(UIViewController *)Action_nativeOrderPayListViewController:(NSDictionary *)params;
/**
 *  当日账单流水
 */
-(UIViewController *)Action_nativeOrderDetailListViewController:(NSDictionary *)params;
/**
 *  订单详情
*/
-(UIViewController *)Action_nativeOrderPayDetailViewController:(NSDictionary *)params;
/**
 *  会员消费记录
 */
-(UIViewController *)Action_nativePayOrderListViewController:(NSDictionary *)params;
@end
