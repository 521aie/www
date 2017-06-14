//
//  ConfigConstants.h
//  RestApp
//
//  Created by zxh on 14-4-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#ifndef RestApp_ConfigConstants_h
#define RestApp_ConfigConstants_h


// 零头处理
#define DEAL_ZERO  @"DEAL_ZERO"

// <code>零头处理精度</code>.
#define PRECISE  @"PRECISE"

// <code>收银点菜界面是否显示菜类</code>.
#define IS_SHOW_KINDMENU  @"IS_SHOW_KINDMENU"

//<code>收银点菜查询模式</code>.
#define NAME_INPUT_MODE  @"NAME_INPUT_MODE"

//启用桌位标签
#define IS_SEAT_LABEL @"IS_SEAT_LABEL"

//<code>客单确认后相同商品是否合并数量</code>.
#define MERGE_SENDINSTANCE  @"MERGE_SENDINSTANCE"

//<code>点单过程中相同商品是否合并数量</code>.
#define MERGE_INSTANCE  @"MERGE_INSTANCE"

// <code>是否允许拼桌（一桌多单）</code>
#define MULTIORDER @"MULTIORDER"

// <code>收银开单时可选择"限时用餐"</code>
#define ISLIMITTIME @"IS_LIMIT_TIME"

// <code>收银查看账单汇总需要权限验证</code>
#define IS_ACCOUTSUM_CONFIRM @"IS_ACCOUTSUM_CONFIRM"

// <code>限时用餐时间</code>
#define LIMITTIMEEND @"LIMIT_TIME_END"

// <code>限时用餐提醒时间</code>
#define LIMITTIMEWARN @"LIME_TIME_WARN"

// <code>使用语言</code>.
#define DEFAULT_LANGUAGE  @"DEFAULT_LANGUAGE"

// * <code>整单打折时服务费默认是否打折</code>.
#define IS_SERVICEFEE_DISCOUNT  @"IS_SERVICEFEE_DISCOUNT"
// * <code>整单打折时最低消费默认是否打折</code>.
#define MINCONSUMEMODE  @"MINCONSUMEMODE"

//* <code>是否允许调整附加费</code>.
#define IS_SET_MINCONSUMEMODE  @"IS_SET_MINCONSUMEMODE"

//* <code>员工的收银权限设置对主收银有效</code>.
#define IS_PERMISSION_CASH  @"IS_PERMISSION_CASH"

/**
 * <code>打印时单号前加字符</code>.
 */
#define IS_ADD_PREFIX @"IS_ADD_PREFIX"

/**
 * <code>商品下单后是否在点单设备连接的打印机打印点菜单</code>.
 */
#define IS_PRINT_ORDER @"IS_PRINT_ORDER"

/**
 * <code>打印单商品排列方式</code>.
 */
#define PRINT_ORDER  @"PRINT_ORDER"

/**
 * <code>打印客户联时自动打开钱箱</code>.
 */
#define ACCOUNT_CASH_DRAWER  @"ACCOUNT_CASH_DRAWER"

/**
 * <code>客户联和财务联上打印赠送商品</code>.
 */
#define IS_PRINT_GIFT @"IS_PRINT_GIFT"

/**
 * <code>客户联和财务联上打印退菜明细</code>.
 */
#define IS_PRINT_BACK @"IS_PRINT_BACK"

/**
 * <code>打印财务联时自动打开钱箱</code>.
 */
#define FINANCE_CASH_DRAWER  @"FINANCE_CASH_DRAWER"

/**
 * <code>使用会员卡支付时消费凭证的打印份数</code>.
 */
#define NUMBERS_OF_VIP @"CARD_CONSUM_PRINT_NUMBER"

/**
 * <code>结账完毕是否打印财务联</code>.
 */
#define ACCOUNT_BILL  @"ACCOUNT_BILL"

/**
 * <code>打印时是否发出蜂鸣声</code>.
 */
#define IS_PRINT_BELL  @"IS_PRINT_BELL"

/**
 * <code>下单后是否打印消费底联</code>.
 */
#define IS_PRINT_CONSUME  @"IS_PRINT_CONSUME"

/**
 * <code>下单后是否打印划菜单</code>.
 */
#define IS_PRINT_DRAW  @"IS_PRINT_DRAW"

/**
 * <code>划菜打印机IP地址</code>.
 */
#define DRAW_PRINTER_IP  @"DRAW_PRINTER_IP"

/**
 * <code>消费底联打印机IP地址</code>.
 */
#define CONSUME_PRINTER_IP  @"CONSUME_PRINTER_IP"

/**
 *  收银打印 - 税率
 */
#define DEFAULT_TAX_RATE  @"DEFAULT_TAX_RATE"

/**
 *  收银打印 - 货币单位
 */
#define DEFAULT_CURRENCY  @"DEFAULT_CURRENCY"

/**
 * <code>消费底联打印机每行打印字符数</code>.
 */
#define CONSUME_PRINTER_CHAR_NUM  @"CONSUME_PRINTER_CHAR_NUM"

/**
 * <code>划菜联打印机每行打印字符数</code>.
 */
#define DRAW_PRINTER_CHAR_NUM  @"DRAW_PRINTER_CHAR_NUM"

/**
 * <code>是否打印二维码</code>.
 */
#define ONLINEPAY_ENABLE @"ONLINEPAY_ENABLE"


// /////////////////////////////////////////////////////////////////////////////////////
// /////    打印设置        ////////////////////////////////////////////////////////////////////////
// ///////////////////////////////////////////////////////////////////////////////////
/**
 * <code>卡包加商品是否需要审核</code>.
 */
#define IS_ADD_REVIEW  @"IS_ADD_REVIEW"

/**
 * <code>卡包催商品是否需要审核</code>.
 */
#define IS_URGENCY_REVIEW  @"IS_URGENCY_REVIEW"
#define IS_DISPLAY_COUNT @"IS_DISPLAY_COUNT"  //是否显示总价
#define IS_DISPLAY_NEXT_SEAT @"IS_DISPLAY_NEXT_SEAT"  //是否看邻桌

/**
 * <code>微店菜单排版</code>
 */
#define MENU_STYLE @"MENU_STYLE" //微店菜单排版

/**
 * <code>是否添加整单备注</code>
 */
#define IS_DISPLAY_NOTE @"IS_DISPLAY_NOTE"  

/**
 * <code>顾客扫桌码下单时需要先付款</code>
 */
#define IS_PRE_PAY @"IS_PRE_PAY"

/**
 * <code>顾客扫店码下单时需要先付款</code>
 */
#define IS_PRE_PAY_SHOP @"IS_PRE_PAY_SHOP"

/**
 * <code>顾客可以选择“暂不上菜”</code>
 */
#define IS_WAIT_MENU @"IS_WAIT_MENU"

/**
 * <code>顾客可以选择“冷上热待”</code>
 */
#define IS_PART_WAIT @"IS_PART_WAIT"

/**
 * <code>顾客可以选择“打包带走”</code>
 */
#define IS_PACK_MENU @"IS_PACK_MENU"

/**
 * <code>顾客手机下单后，厨房打印机上每份商品打印一张配菜联</code>
 */
#define IS_EACH_MENU_PRINT @"IS_EACH_MENU_PRINT"

/**
 * <code>顾客端显示扫菜码点菜按钮</code>
 */
#define USE_MENU_QR_CODE @"USE_MENU_QR_CODE"

/**
 *  <code>顾客付款后可以申请开纸质发票</code>
 */
#define IS_CUSTOMER_INVOICE @"IS_CUSTOMER_INVOICE"
/**
 * <code>顾客付款后可以申请开纸质发票</code>
 */
#define IS_CUSTOMER_E_INVOICE @"IS_CUSTOMER_E_INVOICE"
/**
 * <code>菜肴详情商品展示图片排版留空</code>
 */
#define IS_MENU_SHOW_BLANK @"IS_MENU_SHOW_BLANK"

/**
<<<<<<< HEAD
 * <code>顾客下但是账号验证弹窗</code>
 */
#define IS_ACCOUNT_VERIFY @"IS_ACCOUNT_VERIFY"


#define SHOW_TOP_MENU @"SHOW_TOP_MENU"

#endif
