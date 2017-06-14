//
//  PantryRender.m
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "PantryRender.h"
#import "NameItemVO.h"

@implementation PantryRender

//打印份数
+(NSMutableArray*) listPrintNums
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"1份", nil) andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"2份", nil) andId:@"2"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"3份", nil) andId:@"3"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"4份", nil) andId:@"4"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"5份", nil) andId:@"5"];
    [vos addObject:item];

    return vos;

}

//传菜方案
+(NSMutableArray*) listPantryDetails
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"使用此传菜方案的分类", nil) andId:@"0"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"使用此传菜方案的商品", nil) andId:@"1"];
    [vos addObject:item];
    
    return vos;
    
}

+(NSMutableArray*) listIsAuto
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"二维火传菜机", nil) andId:@"0"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"打印机", nil) andId:@"1"];
    [vos addObject:item];
    
    return vos;
}

//打印纸宽度
+(NSMutableArray*) listWidth
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"58mm" andId:@"58"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"76mm" andId:@"76"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"80mm" andId:@"80"];
    [vos addObject:item];
    return vos;
}

//每行打印字符数
+(NSMutableArray*) listLineCounts:(NSString*)lineWidth
{
    NSMutableArray* vos=[NSMutableArray array];
    if ([lineWidth isEqualToString:@"58"]) {
        NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"32个字符", nil) andId:@"32"];
        [vos addObject:item];
        item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"33个字符", nil) andId:@"33"];
        [vos addObject:item];
        return vos;
    }else if([lineWidth isEqualToString:@"76"]){
        NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"38个字符", nil) andId:@"38"];
        [vos addObject:item];
        item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"40个字符", nil) andId:@"40"];
        [vos addObject:item];
        item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"42个字符", nil) andId:@"42"];
        [vos addObject:item];
    }else if([lineWidth isEqualToString:@"80"]){
        NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"40个字符", nil) andId:@"40"];
        [vos addObject:item];
        
        item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"42个字符", nil) andId:@"42"];
        [vos addObject:item];
        
        item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"48个字符", nil) andId:@"48"];
        [vos addObject:item];
        
        item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"64个字符", nil) andId:@"64"];
        [vos addObject:item];
    }
    return vos;
}

//传菜设备
+(NSMutableArray*) listPrintDevice
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"小票打印机", nil) andId:NSLocalizedString(@"小票打印机", nil)];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"标签打印机", nil) andId:NSLocalizedString(@"标签打印机", nil)];
    [vos addObject:item];
    
    return vos;
}

//标签纸规格型号
+(NSMutableArray *) listTagSpec{
    
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"宽40mm,高30mm", nil) andId:@"40,30"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"宽40mm,高20mm", nil) andId:@"40,20"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"宽58mm,高40mm", nil) andId:@"58,40"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"宽68mm,高35mm", nil) andId:@"68,35"];
    [vos addObject:item];
    
    
    return vos;
}
@end
