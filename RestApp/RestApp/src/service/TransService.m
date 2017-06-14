//
//  TransService.m
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "Area.h"
#import "Platform.h"
#import "TransService.h"
#import "JsonHelper.h"
#import "RestConstants.h"
#import "YYModel.h"
@implementation TransService

/**
 *  添加打印设置(区域打印)
 */
-(void)saveAreaPrinterSetting:(AreaPantry *)areaPantry target: (id)target callback:(SEL)callback{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:areaPantry.ipAddress forKey:@"ip_address"];
    [param setObject:[NSString stringWithFormat:@"%d",areaPantry.paperWidth] forKey:@"paper_width"];
    NSMutableArray *newList = [NSMutableArray array];
    for (Area* area in areaPantry.areaList) {
        [newList addObject:area._id];
    }

    [param setObject:[NSString stringWithFormat:@"%d",areaPantry.rowNum] forKey:@"row_num"];
    
    [param setObject:[JsonHelper arrTransJson:newList] forKey:@"area_id_list"];
    [super postBossAPI:@"print/v1/upload_print" param:param target:target callback:callback];
}

/**
 *  更新打印机设置(区域打印)
 */

-(void)updateAreaPrinterSetting:(AreaPantry *)areaPantry target: (id)target callback:(SEL)callback{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:areaPantry._id forKey:@"id"];
    [param setObject:areaPantry.ipAddress forKey:@"ip_address"];
    [param setObject:[NSString stringWithFormat:@"%d",areaPantry.paperWidth] forKey:@"paper_width"];
    NSMutableArray *newList = [NSMutableArray array];
    for (Area* area in areaPantry.areaList) {
        [newList addObject:area._id];
    }
    
    [param setObject:[NSString stringWithFormat:@"%d",areaPantry.rowNum] forKey:@"row_num"];
    
    [param setObject:[JsonHelper arrTransJson:newList] forKey:@"area_id_list"];
    [super postBossAPI:@"print/v1/update_print" param:param target:target callback:callback];
}
/**
 *  删除打印机设置(区域打印)
 */
-(void)deleteAreaPrinter:(NSString *)printerId target: (id)target callback:(SEL)callback{
      NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:printerId forKey:@"id"];
    [super postBossAPI:@"print/v1/delete_print_by_id" param:param target:target callback:callback];
}
@end
