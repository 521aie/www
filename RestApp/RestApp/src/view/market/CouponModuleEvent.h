//
//  CouponModuleEvent.h
//  RestApp
//
//  Created by YouQ-MAC on 15/1/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#ifndef RestApp_CouponModuleEvent_h
#define RestApp_CouponModuleEvent_h


#define COUPON_RESULT_FEE 1         //面额
#define COUPON_LESS_FEE 2           //消费满多少时方可使用
#define COUPON_START_TIME 3         //有效期开始时间
#define COUPON_END_TIME 4           //有效期截止时间
#define COUPON_TEXT_MEMO 5          //其他使用规则
#define COUPON_KABAW_RECEIVE 6      //会员可通过火小二应用领取
#define COUPON_LIMIT_NUM 7          //限制店家每日发行数量
#define COUPON_LIMIT_NUMBERS 8      //店家发行数量（张）
#define COUPON_AUTOMIC_KABAW 9      //开卡是自动领取到火小二账户
#define COUPON_EVERYONE_NUM 10      //每人自动领取数量
#define COUPON_RECHARGE 11          //卡充值时自动领取到火小二账户
#define COUPON_RECHARGE_NUM 12      //充值满多少元时自动领取（元）
#define COUPON_EVERYONE_AUTOMIC 13  //每人自动领取数量（张


#define COUPON_NEW_PUBLISH_NUM 14   //新增发行量
#define COUPON_NEW_END_DATE 15      //新有效期截止时间

#define COUPON_DATE_EVENT @"COUPON_DATE_EVENT" //添加不可使用日期 事件
#endif
