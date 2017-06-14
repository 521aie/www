//
//  OrderService.h
//  RestApp
//
//  Created by iOS香肠 on 16/4/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseService.h"

@interface OrderService : BaseService

//获取商品标签设置列表
- (void)getShopSetLblList:(id)target callback:(SEL)callback;


- (void)getShopLblList:(NSString *)menuId target:(id)target callback:(SEL)callback;

//顾客点餐智能推荐玉提醒列表
- (void)getCusOrderAndRecommendList:(id)target callback:(SEL)callback;


-(void)saveShopSetLblList:(NSString *)menuId menulabelStr:(NSString *)str target:(id)target callback:(SEL)callback;

//获取初始化提醒语
- (void)getRemindList:(id)target callback:(SEL)callback;
//保存提示语
-(void)getRemindList:(NSString *)str target:(id)target callback:(SEL)callback;
//获取未配置标签的菜肴数量
-(void)getRemindCount:(id)target callback:(SEL)callback;
//保存智能推荐开关
- (void)saveIntRecommendationTurn:(NSString *)turn target:(id)target callback:(SEL)callback;
//获取指定PlantId的配置方案
- (void)getplanPlantId:(NSString *)plantId target:(id)target callback:(SEL)callback;
//保存推荐信息
-(void)saverRecommendList:(NSString*)plant target:(id)target callback:(SEL)callback;
//初始化保存方案
-(void)getPlantList:(NSString *)plantId mealtcount:(NSString*)mealstcount target:(id)target callback:(SEL)callback;
//获取提示语信息
- (void)getRemindInfo:(id)target callback:(SEL)callback;
//获取空白列表
-(void)getEmptyShopLblList:(id)target callback:(SEL)callback;
@end
