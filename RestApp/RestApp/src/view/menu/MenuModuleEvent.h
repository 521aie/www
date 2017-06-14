//
//  MenuModuleEvent.h
//  RestApp
//
//  Created by zxh on 14-5-6.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#ifndef RestApp_MenuModuleEvent_h
#define RestApp_MenuModuleEvent_h

//商品
#define MENU_KIND 1
#define MENU_ACCOUNT 2
#define MENU_MAKE 3
#define MENU_SPEC 4
#define MENU_IS_TWO_ACCOUNT 5
#define MENU_DEDUCT_KIND 6
#define MENU_SERVICE_MODE 7
#define MENU_DEDUCT 8
#define MENU_SERVICE 9
#define MENU_PRICE 10
#define MENU_CONSUME 11
#define MENU_BUYACCOUNT 12
#define MENU_KABAW 13
#define MENU_ISSELF 14
#define MENU_SETLABEL 28

#define MENU_KIND_SORT_EVENT 15
#define MENU_SORT_EVENT 16
#define MENU_CODE 17

#define MENU_MAKE_EVENT @"MENU_MAKE_EVENT" //做法事件.
#define MENU_SPEC_EVENT @"MENU_SPEC_EVENT"  //规格事件.

#define MENU_PRICE_FORMAT @"MENU_PRICE_FORMAT"
#define MENU_ID 20
#define MENU_STEP_LENGTH 23/*顾客端点菜时最小累加单位*/
#define MENU_ONLY 22 /*此商品仅在套餐显示*/
#define MENU_BASEPRICE  30


//商品分类
#define KINDMENU_IS_SECONDE 1   //此分类是二级分类
#define KINDMENU_PARENT 2  //上级分类
#define KINDMENU_TASTE 3  //商品备注
#define KINDMENU_IS_GROUP 4 //销售额归到其他分类
#define KINDMENU_GROUP 5 //归到分类
#define KINDMENU_DEDUCT_KIND  6  //销售提成
#define KINDMENU_DEDUCT 7 //提成金额
#define KINDMENU_MEMO 8  //商品加料
#define KINDMENU_ADDITION 9  //商品加料

#define KINDMENU_MEMO_EVENT @"kind_memo" //备注列表.
#define KINDMENU_ADDITION_EVENT @"kind_addition"  //商品加料


#define KINDMENU_SHOW_CHILD @"KINDMENU_SHOW_CHILD"  //显示子节点


//商品做法.


#define MENUMAKE_DEL_EVENT @"MENUMAKE_DEL_EVENT"
#define MENUMAKE_SORT_EVENT @"MENUMAKE_SORT_EVENT"

#define MENUMAKE_PRICEMODE 1
#define MENUMAKE_PRICE 2

//商品规格
#define MENUSPEC_RAWSCALE 1
#define MENUSPEC_SPECPRICE 2

// 商品标签设置
#define ORDER_TYPE    11   //主料标签
#define ORDAER_MEAT   12   // 肉类标签
#define ORDER_VDISHES  13  // 蔬菜标签
#define ORDER_AQUATIC  14  // 水产标签
#define ORDER_CHILIINDEX 15  //辣椒指数标签
#define ORDER_FMANAGE    16  // 特色标签
#define ORDER_RINDEX    17    //推荐标签

#endif
