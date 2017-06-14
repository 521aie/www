//
//  LinkMan.h
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseLinkMan.h"
#import "INameValueItem.h"

typedef enum
{
    DATEKIND_YESTODAY=0,   //前一日
    DATEKIND_TODAY=1,      //当日
}LinkMan_DateKind_Enum;

typedef enum
{
    SMSKIND_DETAIL=0,   //详细
    SMSKIND_SAMPLE=1,      //简要
}LinkMan_SmsKind_Enum;

@interface LinkMan : BaseLinkMan<INameValueItem>

@end
