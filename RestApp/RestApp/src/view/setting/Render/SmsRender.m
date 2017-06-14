//
//  SmsRender.m
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SmsRender.h"
#import "NameItemVO.h"
#import "LinkMan.h"

@implementation SmsRender

+(NSMutableArray*) listDateKind
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"昨日营业汇总", nil) andId:[NSString stringWithFormat:@"%d",DATEKIND_YESTODAY]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"当日营业汇总", nil) andId:[NSString stringWithFormat:@"%d",DATEKIND_TODAY]];
    [vos addObject:item];
    return vos;
}

+(NSMutableArray*) listSmsKind
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"详细营业汇总", nil) andId:[NSString stringWithFormat:@"%d",SMSKIND_DETAIL]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"简要营业汇总", nil) andId:[NSString stringWithFormat:@"%d",SMSKIND_SAMPLE]];
    [vos addObject:item];
    return vos;
}

@end
