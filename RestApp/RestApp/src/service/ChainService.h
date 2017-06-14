//
//  ChainService.h
//  RestApp
//
//  Created by 刘红琳 on 16/2/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseService.h"
#import "Platform.h"
#import "RestConstants.h"
#import <Foundation/Foundation.h>
#import "BrandVo.h"
#import "JsonHelper.h"
#import "Plate.h"
#import "ShopVO.h"

@interface ChainService : BaseService

//展示总部信息
- (void)showInfoByEntityId:(id)target callback:(SEL)callback;

//展示品牌信息
- (void)listPlateByUserId:(id)target callback:(SEL)callback;

//保存总部信息
- (void)saveInfo:(BrandVo*)brandVo Target:(id)target callback:(SEL)callback;

//增加品牌信息
- (void)saveBrandInfo:(Plate*)plate Target:(id)target callback:(SEL)callback;

//修改品牌信息
- (void)updatePlate:(Plate*)plate Target:(id)target callback:(SEL)callback;

//删除品牌信息
- (void)removePlate:(NSString*)_id Target:(id)target callback:(SEL)callback;

//门店详情
- (void)showShopInfoByEntityId:(NSString *)shopId  target:(id)target callback:(SEL)callback;

//修改门店信息
- (void)updateUserShopInfo:(ShopVO *)shopVO  target:(id)target callback:(SEL)callback;

@end
