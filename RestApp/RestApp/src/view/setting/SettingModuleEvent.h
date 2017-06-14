//
//  SettingModuleEvent.h
//  RestApp
//
//  Created by zxh on 14-4-6.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#ifndef RestApp_SettingModuleEvent_h
#define RestApp_SettingModuleEvent_h


//系统参数.
#define SYSPARA_SELECT_LANGUAGE 1
#define SYSPARA_LIMIT_TIME_END 2
#define SYSPARA_LIMIT_TIME_WARN 3
#define SYSPARA_LIMIT_TIME 4
#define SYSPARA_MULTI_ORDER 5

//营业结束时间.
#define OPEN_TIME_PLAN_TYPE 1 //选择营业结束时间类型.

//付款方式
#define KIND_PAY_TYPE 1 //选择付款方式类型.
#define KIND_IS_INCLUDE 2 //是否计入销售
#define KIND_IS_CASHBOX 3 //是否钱箱

//零头处理方式
#define ZERO_PARA_TYPE 1 //选择零头处理方式.
#define ZERO_PARA_PRECISE 2 //选择精度

//收银参数.
#define PRINTER_PARA_SORT 1  //单据上的商品排序方式
#define PRINTER_PARA_CONSUME_WORDCOUNT 3  //消费底联每行打印字符数
#define PRINTER_PARA_DRAW_WORDCOUNT 4  //划菜联每行字符数
#define PRINTER_PARA_IS_CONSUME 5 //下单时打印消费底联
#define PRINTER_PARA_IS_DRAW 6  //下单时打印划菜联.
#define PRINTER_PARA_IS_GIFT 7  //客户联和财务联上打印赠送商品.
#define PRINTER_PARA_DRAWPRINTIP 8   //划菜Ip
#define PRINTER_PARA_CONSUMEPRINTIP 9 //消费底联Ip.
#define PRINTER_PARA_IS_BACK 10 //退菜明细.
#define CARD_CONSUM_PRINT_NUMBER 11//使用会员卡支付时消费凭证的打印份数

//附加费
#define FEEPLAN_AREA 1   //区域
#define FEEPLAN_IS_SERVICEMODE 2  //收取服务费
#define FEEPLAN_SERVICEMODE_CALBASE 3  //选择服务费的计费标准
#define FEEPLAN_IS_MINFEE 4 //最低消费
#define FEEPLAN_MINFEE_MODE 5 //最低消费的计费标准
#define FEEPLAN_IS_DATE  6  //指定日期
#define FEEPLAN_STARTDATE 7 //开始日期
#define FEEPLAN_ENDDATE 8 //结束日期
#define FEEPLAN_IS_TIME 9   //指定时间
#define FEEPLAN_STARTTIME 10  //开始时间
#define FEEPLAN_ENDTIME 11  //结束时间
#define FEEPLAN_IS_WEEK 12    //特定的星期
#define FEEPLAN_WEEKS 13      //日期.
#define FEEPLAN_SERVICEFEE 14  //服务费
#define FEEPLAN_MINFEE 15  //最低消费

//打折方案
#define DISCOUNTPLAN_MODE 1  //打折方案优惠方式
#define DISCOUNTPLAN_IS_ALL_KIND 2  //所有分类折扣率是否相同
#define DISCOUNTPLAN_KIND_RATIO 3   //个别分类设置不同的折扣率.
#define DISCOUNTPLAN_MENU_RATIO 7   //个别商品设置不同的折扣率.
#define DISCOUNTPLAN_IS_ALL_USER 4  //全部员工可使用此折扣
#define DISCOUNTPLAN_USERS 5    //可使用此折扣的员工
#define DISCOUNTPLAN_RATIO 6    //折扣率
#define DISCOUNTPLAN_IS_DATE  8 //指定日期
#define DISCOUNTPLAN_STARTDATE 9 //开始日期
#define DISCOUNTPLAN_ENDDATE 10 //结束日期
#define DISCOUNTPLAN_IS_TIME 11   //指定时间
#define DISCOUNTPLAN_STARTTIME 12  //开始时间
#define DISCOUNTPLAN_ENDTIME 13  //结束时间
#define DISCOUNTPLAN_IS_WEEK 14    //特定的星期
#define DISCOUNTPLAN_WEEKS 15      //日期.
#define DISCOUNTPLAN_IS_MONTH 16    //特定的日期
#define DISCOUNTPLAN_DAYS 17      //日期.

//数据清理
#define DATACLEAR_KIND_DATA 3    //数据清理方式
#define DATACLEAR_TIME_DATA 4   //数据清理频率
#define DATACLEAR_START_DATE 1  //数据清理开始日期
#define DATACLEAR_END_DATE 2    //数据清理结束日期.

#endif
