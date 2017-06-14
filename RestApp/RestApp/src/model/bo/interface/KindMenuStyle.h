//
//  KindMenuStyle.h
//  RestApp
//
//  Created by zxh on 14-4-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseKindMenuStyle.h"

typedef enum
{
    USAGE_PC=1,      //PC设备
    USAGE_PDA=2      //PDA设置
}KindMenuStyle_Usage_Enum;


typedef enum
{
    TYPE_SET_NORMAL=1,      //1、普通（既按风格Id展示）
    TYPE_SET_SELF=2,      //2.自排版
    TYPE_SET_TEMPLATE=3    //3.自选模板.
}KindMenuStyle_Type_Enum;

@interface KindMenuStyle : BaseKindMenuStyle

@end
