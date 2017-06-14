//
//  TransModuleEvent.h
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#ifndef RestApp_TransModuleEvent_h
#define RestApp_TransModuleEvent_h

#define PANTRY_ISAUTO 1 //传菜设备
#define PANTRY_PRINTIP 2 //打印机IP
#define PANTRY_CHARCOUNT 3 //每行打印字符数
#define PANTRY_PRINTNUM 4 //打印份数
#define PANTRY_KIND 5 //分类
#define PANTRY_MENU 6 //商品
#define PANTRY_ISWIDTH 7//打印纸宽度
#define PANTRY_AREA 8   //区域.
#define PANTRY_IS_CUT_RATIO  11 //一菜一切
#define PANTRY_IS_TOTAL_PRINT_RATIO 12 //同时打印一份总单
#define PANTRY_IS_ALL_AREA_RATIO 13 //同时打印一份总单
#define PANTRY_TYPE 14//打印机类型
#define PANTRY_IS_PRINTER 15//打印机
#define PANTRY_PRINTER_DEVICE 16//传菜设备
#define PANTRY_PRINTER_TAGSPEC 17//传菜设备


#define PANTRY_KIND_EVENT @"PANTRY_KIND_EVENT" //商品分类事件.
#define PANTRY_MENU_EVENT @"PANTRY_MENU_EVENT"  //商品事件.
#define PANTRY_AREA_EVENT @"PANTRY_AREA_EVENT"  //区域事件.


#define PANTRY_ORIGIN_IP 9  //原始打印机IP
#define PANTRY_BACKUP_IP 10  //备用打印机IP

#endif
