//
//  EmployeeModuleEvent.h
//  RestApp
//
//  Created by zxh on 14-4-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#ifndef RestApp_EmployeeModuleEvent_h
#define RestApp_EmployeeModuleEvent_h

//员工
#define EMPLOYEE_ROLE 1   //角色
#define EMPLOYEE_PASS 2  //登录密码
#define EMPLOYEE_MOBILE 3  //登录密码
#define EMPLOYEE_IS_COMMON_RATIO 4  //允许对可打折的商品进行打折
#define EMPLOYEE_COMMON_RATIO_LIST 28
#define EMPLOYEE_COMMON_RATIO 5 //可打折商品的打折额度
#define EMPLOYEE_IS_FORCE_RATIO 6 //允许对不可打折的商品进行打折
#define EMPLOYEE_FORCE_RATIO  7  //不可打折的商品打折额度
#define EMPLOYEE_FORCE_RATIO_LIST  29 //不可打折的商品打折额度
#define EMPLOYEE_IS_PRINTER_TIME 8 //财务联打印次数限制.
#define EMPLOYEE_PRINTER_TIME 9 //打印次数
#define EMPLOYEE_IS_LIMIT_ZERO 10   //限制打印次数限制
#define EMPLOYEE_IS_USER_CARD 11  //使用ID卡登录
#define EMPLOYEE_USERNAME 12  //用户名.
#define EMPLOYEE_SEX 13  //性别.
#define EMPLOYEE_PORTAIT 14  //头像.
#define EMPLOYEE_FRONTCERTID 15 //身份证正面
#define EMPLOYEE_BACKCERTID 16 //身份证背面.
#define CHAINEMPLOY_SHOP 17 //连锁高级设置门店
#define CHAINEMPLOY_PLATE 20 //连锁高级设置品牌
#define CHAINEMPLOY_BRANCH 22 //连锁高级设置分公司
#define EMPLOYEE_BRANCHCOMPANY  25  //管理的分公司

#define REST_DETAIL_EVENT @"REST_DEDTAIL_EVENT"     //后台详细表.
#define CASH_DETAIL_EVENT @"CASH_DETAIL_EVENT"      //收银详细表.
#define BRANCH_DETAIL_EVENT @"BRANCH_DETAIL_EVENT"      //分公司详细表.
#define CASH_SHOP_DETAIL_EVENT @"CASH_SHOP_DETAIL_EVENT"      //门店收银详细表.

#define SELECT_BRAND_ACTION 30      //选择连锁权限
#define SELECT_BRANCH_ACTION 31      //选择分公司权限
#define SELECT_REST_ACTION 17    //选择后台权限.
#define SELECT_CASH_ACTION 18    //选择收银权限.

#define EMPLOYEE_MAXZERODEAL 19    //选择最大去零额度.

#endif
