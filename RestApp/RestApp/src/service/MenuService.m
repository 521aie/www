//
//  MenuService.m
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuService.h"
#import "JsonHelper.h"
#import "Platform.h"
#import "RestConstants.h"
#import "Menu.h"
#import "MenuProp.h"
#import "KindMenu.h"
#import "NSString+Estimate.h"
@implementation MenuService

- (void)removeKindMenus:(NSString*)kindId type:(NSString*)type Target:(id)target Callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:kindId forKey:@"id"];
    [param setObject:type forKey:@"type"];
    [super postSession:@"ios/kind-menu!batchRemove.action" param:param  target:target callback:callback];
}
/*
 *  菜肴二维码(单个)
 */
- (void)loadMenuCode:(NSString *)menuId target:(id)target callback:(SEL)callback{
 
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:menuId forKey:@"menu_id"];
    [super postBossAPI:@"menu/v1/get_short_url" param:param target:target callback:callback];
}

/**
 *  发送菜肴二维码
 */

-(void)sendMenuCodes:(NSString *)email target:(id)target callback:(SEL)callback{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:email forKey:@"mail_address"];
    [super postBossAPI:@"menu/v1/batch_send_qrcode" param:param target:target callback:callback];
}

@end
