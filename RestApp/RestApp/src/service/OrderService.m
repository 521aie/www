//
//  OrderService.m
//  RestApp
//
//  Created by iOS香肠 on 16/4/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderService.h"
#import "RestConstants.h"
#import "RestAppConstants.h"
#import "Platform.h"


@implementation OrderService

-(void)getShopSetLblList:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [super postBossAPI:@"intelligence/v1/get_menus" param:param target:target callback:callback];
}

- (void)getShopLblList:(NSString *)menuId target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:menuId forKey:@"menu_id"];
    [super postBossAPI:@"intelligence/v3/get_labels" param:param target:target callback:callback];
}


-(void)getEmptyShopLblList:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
     [super postBossAPI:@"intelligence/v2/get_empty_labels" param:param target:target callback:callback];
    
}


-(void)getCusOrderAndRecommendList:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [super postBossAPI:@"intelligence/v2/query_all_configs" param:param target:target callback:callback];
    
}

-(void)saveShopSetLblList:(NSString *)menuId menulabelStr:(NSString *)menustr target:(id)target callback:(SEL)callback
{
     NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:menuId forKey:@"menu_id"];
    [param setValue:menustr forKey:@"menu_label_str"];
    [super postBossAPI:@"intelligence/v1/save_or_update_menu_label" param:param target:target callback:callback];
    
}

-(void)getRemindList:(id)target callback:(SEL)callback
{
   NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [super postBossAPI:@"intelligence/v1/reset_label_configs" param:param target:target callback:callback];
}

-(void)getRemindList:(NSString *)strId target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:strId forKey:@"label_configs_json"];
    [super postBossAPI:@"intelligence/v1/save_label_configs" param:param target:target callback:callback];
    
}

-(void)getRemindCount:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [super postBossAPI:@"intelligence/v1/query_unlabeled_menu_count" param:param target:target callback:callback];
}

-(void)saveIntRecommendationTurn:(NSString *)turn target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:turn forKey:@"is_turn_on"];
    [super postBossAPI:@"intelligence/v1/save_entity_config" param:param target:target callback:callback];
}

-(void)getplanPlantId:(NSString *)plantId target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:plantId forKey:@"plan_id"];
    [super postBossAPI:@"intelligence/v1/get_plan_config" param:param target:target callback:callback];
}

-(void)saverRecommendList:(NSString*)plant target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:plant forKey:@"plan_config_json"];
    [super postBossAPI:@"intelligence/v1/save_plan_config" param:param target:target callback:callback];
}


-(void)saverRecommendList:(NSString*)plant recommendtype:(NSString *)recommendType  target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:plant forKey:@"planId"];
    [param setValue:recommendType forKey:@"recommendType"];
    [param setValue:recommendType forKey:@"recommendType"];
    
    [super postBossAPI:@"intelligence/v1/save_plan_config" param:param target:target callback:callback];
}


-(void)getPlantList:(NSString *)plantId mealtcount:(NSString*)mealstcount target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:plantId forKey:@"plan_id"];
    [param setValue:mealstcount forKey:@"meals_count"];
    [super postBossAPI:@"intelligence/v1/reset_plan_config" param:param target:target callback:callback];
}

- (void)getRemindInfo:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [super postBossAPI:@"intelligence/v1/get_label_configs" param:param target:target callback:callback];
}


@end
