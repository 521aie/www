//
//  ReserveRender.m
//  RestApp
//
//  Created by zxh on 14-5-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReserveRender.h"
#import "ReserveSet.h"
#import "NameItemVO.h"

@implementation ReserveRender

+(NSMutableArray*) listMode
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"不收费", nil) andId:[NSString stringWithFormat:@"%d",FEE_MODE_NO]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"按固定金额", nil) andId:[NSString stringWithFormat:@"%d",FEE_MODE_FIX]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"商品总价百分比", nil) andId:[NSString stringWithFormat:@"%d",FEE_MODE_RATIO]];
    [vos addObject:item];
    
    return vos;
    
}

+ (NSMutableArray  *)listArea
{
    NSMutableArray *vos   =  [[NSMutableArray  alloc] init ];
    for (NSInteger  i=1;  i<= 50; i++) {
        NameItemVO *item=[[NameItemVO alloc] initWithVal: [NSString stringWithFormat:@"%ld",i] andId:[NSString stringWithFormat:@"%ld",i]];
        [vos addObject:item];
    }
    return  vos;
}

+(NSString*) obtainReserveFeeUnit:(short)mode
{
    if (mode==FEE_MODE_FIX) {
        return NSLocalizedString(@"(元)", nil);
    }else if(mode==FEE_MODE_RATIO){
        return @"(%)";
    }
    return @"";
}

@end
