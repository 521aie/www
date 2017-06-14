//
//  Target_TDFChainMenuModule.h
//  RestApp
//
//  Created by zishu on 16/10/8.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_ChainMenuModule : NSObject
///连锁商品首页
- (UIViewController *)Action_nativeChainMenuViewController:(NSDictionary *)params;
//连锁品牌关联商品列表
- (UIViewController *)Action_nativeChainBrandRelatedGoodsViewController:(NSDictionary *)params;
//价格方案列表
- (UIViewController *)Action_nativeChainPriceFormatViewController:(NSDictionary *)params;
//门店权限列表
- (UIViewController *)Action_nativeChainShopPowerViewController:(NSDictionary *)params;
//火掌柜连锁员选择商品选择门店（可以选择区头的）
- (UIViewController *)Action_nativeChainSelecttMenuWithHeadViewController:(NSDictionary *)params;
//火掌柜连锁价格方案详情
- (UIViewController *)Action_nativeChainAddPriceFormatViewController:(NSDictionary *)params;
//连锁门店权限详情界面
- (UIViewController *)Action_nativeShopPowerEditViewController:(NSDictionary *)params;

//发布到门店列表
- (UIViewController *)Action_nativeChainShopReleaseViewController :(NSDictionary *)params;

//等待发布界面
- (UIViewController *)Action_nativeChainShopWaitReleaseViewController:(NSDictionary *)params;

//发布商品到门店界面
- (UIViewController *)Action_nativeChainShopPublishGoodsViewController:(NSDictionary *)params;

//发布记录界面
- (UIViewController *)Action_nativeChainPublishRecordViewController:(NSDictionary *)params;

//发布详情页（成功或失败）
- (UIViewController *)Action_nativeChainPublishDetailViewController:(NSDictionary *)params;

@end
