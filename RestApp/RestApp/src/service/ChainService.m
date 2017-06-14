//
//  ChainService.m
//  RestApp
//
//  Created by 刘红琳 on 16/2/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ChainService.h"

@implementation ChainService

//展示总部信息
- (void)showInfoByEntityId:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[[Platform Instance]getkey:ENTITY_ID] forKey:@"entityId"];
    [super postSession:@"brand/brand!showInfoByEntityId.action" param:param target:target callback:callback];
}

//保存总部信息
- (void)saveInfo:(BrandVo*)brandVo Target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:brandVo] forKey:@"brandStr"];
    [super postSession:@"brand/brand!saveInfo.action" param:param target:target callback:callback];
}

//展示品牌信息
- (void)listPlateByUserId:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[[Platform Instance]getkey:ENTITY_ID] forKey:@"entityId"];
    [super postSession:@"platforms/employee!listPlateInfoByUserId.action" param:param target:target callback:callback];
}

//增加品牌信息
- (void)saveBrandInfo:(Plate*)plate Target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:plate] forKey:@"plateStr"];
    [super postSession:@"shop/plate!savePlate.action" param:param target:target callback:callback];
}

//修改品牌信息
- (void)updatePlate:(Plate*)plate Target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:plate] forKey:@"plateStr"];
    [super postSession:@"shop/plate!updatePlate.action" param:param target:target callback:callback];
}

//删除品牌信息
- (void)removePlate:(NSString*)_id Target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:_id forKey:@"id"];
    [super postSession:@"shop/plate!removePlate.action" param:param target:target callback:callback];
}

//门店详情
- (void)showShopInfoByEntityId:(NSString *)shopId  target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:shopId forKey:@"id"];
    [super postSession:@"shop/shop!showShopInfoByEntityId.action" param:param target:target callback:callback];
}

//修改门店信息
- (void)updateUserShopInfo:(ShopVO *)shopVO  target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[JsonHelper transJson:shopVO] forKey:@"shopStr"];
    [super postSession:@"shop/shop!updateUserShopInfo.action" param:param target:target callback:callback];
}



@end
