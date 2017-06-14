//
//  MenuService.h
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseService.h"
#import "Menu.h"
#import "Taste.h"
#import "Make.h"
#import "MenuProp.h"
#import "SpecDetail.h"
#import "MenuMake.h"
#import "MenuSpecDetail.h"
#import "KindTaste.h"
#import "KindMenu.h"

@interface MenuService : BaseService

//- (void)updateIsPrint:(NSMutableArray*)ids flag:(NSString*)flag Target:(id)target Callback:(SEL)callback;

- (void)removeKindMenus:(NSString*)kindId type:(NSString*)type Target:(id)target Callback:(SEL)callback;

//不出单商品
//- (void)listNoPrintMenuSampleTarget:(id)target Callback:(SEL)callback;

/**
 *  菜肴二维码
 */
- (void)loadMenuCode:(NSString *)menuId target:(id)target callback:(SEL)callback;
/**
 *  发送菜肴二维码
 */

-(void)sendMenuCodes:(NSString *)email target:(id)target callback:(SEL)callback;
@end
