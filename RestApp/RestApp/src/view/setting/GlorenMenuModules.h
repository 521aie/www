//
//  GlorenMenuModules.h
//  RestApp
//
//  Created by iOS香肠 on 15/12/31.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GlobalRender.h"

@interface GlorenMenuModules : GlobalRender

+ (NSMutableArray *)listNavigateIteamMenu;

//+ (NSMutableArray *)listNavigateIteamSale;


+(NSMutableArray *)listNavigateIteamShop;

+(NSMutableArray *)listNavigateIteamcashier;

+(NSMutableArray *)listNavigateIteamTool:(int)billSettingCode;


+(NSMutableArray *)listChainBranchIteam;

+ (NSMutableArray *)listOrderIteam;

//会员新增
+ (NSMutableArray *)listActionMember;
+ (NSMutableArray *)listActionCoupons;
//连锁会员
+ (NSMutableArray *)chainListActionCoupons;
+ (NSMutableArray *)listActionIteam;

//连锁商品
+ (NSMutableArray *)listChainMenuActions;

+ (NSMutableArray *)listMenuAndSuit;
+ (NSMutableArray *) listMenuSpecAndTaste;
@end
