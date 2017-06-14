//
//  Target_TDFChainMenuModule.m
//  RestApp
//
//  Created by zishu on 16/10/8.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "Target_ChainMenuModule.h"
#import "TDFChainMenuViewController.h"
#import "TDFChainBrandRelatedGoodsViewController.h"
#import "TDFPriceFormatViewController.h"
#import "TDFShopPowerViewController.h"
#import "TDFSelecttMenuWithHeadViewController.h"
#import "TDFAddChainPriceFormatViewController.h"
#import "TDFShopPowerEditViewController.h"
#import "TDFChainShopReleaseViewController.h"
#import "TDFChainShopWaitReleaseViewController.h"
#import "TDFChainShopPublishGoodsViewController.h"
#import "TDFChainPublishRecordViewController.h"
#import "TDFChainPublishDetailViewController.h"
@implementation Target_ChainMenuModule

///连锁商品首页
- (UIViewController *)Action_nativeChainMenuViewController:(NSDictionary *)params
{
    TDFChainMenuViewController *chainMenuViewController = [[TDFChainMenuViewController alloc]init];
    return chainMenuViewController;
}

//连锁品牌关联商品列表
- (UIViewController *)Action_nativeChainBrandRelatedGoodsViewController:(NSDictionary *)params
{
    TDFChainBrandRelatedGoodsViewController *chainBrandRelatedGoodsViewController = [[TDFChainBrandRelatedGoodsViewController alloc]init];
    return chainBrandRelatedGoodsViewController;
}

//价格方案列表
- (UIViewController *)Action_nativeChainPriceFormatViewController:(NSDictionary *)params
{
    TDFPriceFormatViewController *priceFormatViewController = [[TDFPriceFormatViewController alloc]init];
    priceFormatViewController.priceFormatCallBack = params[@"editAction"];
    return priceFormatViewController;
}

//门店权限列表
- (UIViewController *)Action_nativeChainShopPowerViewController:(NSDictionary *)params
{
    TDFShopPowerViewController *shopPowerController = [[TDFShopPowerViewController alloc]init];
    return shopPowerController;
}

//火掌柜连锁员选择商品选择门店（可以选择区头的）
- (UIViewController *)Action_nativeChainSelecttMenuWithHeadViewController:(NSDictionary *)params
{
    TDFSelecttMenuWithHeadViewController *selectMenuWithHeadViewController = [[TDFSelecttMenuWithHeadViewController alloc]init];
    selectMenuWithHeadViewController.event = [params[@"event"] integerValue];
    selectMenuWithHeadViewController.delegate = params[@"delegate"];
    selectMenuWithHeadViewController.title = params[@"titleName"];
    selectMenuWithHeadViewController.nodeList = params[@"nodeList"];
    selectMenuWithHeadViewController.detailMap = params[@"detailMap"];
    selectMenuWithHeadViewController.content = params[@"content"];
    if (params[@"changeData"]) {
        NSDictionary *changeDic  = params[@"changeData"];
        NSString *isHideSearch  =changeDic [@"isHideSearch"];
        NSString *isChangeTitle  = changeDic [@"isChangeTitle"];
        selectMenuWithHeadViewController.isHideSearch  = isHideSearch.integerValue;
        selectMenuWithHeadViewController.isChangeTitle = isChangeTitle.integerValue;
    }
   
    return selectMenuWithHeadViewController;
}
//火掌柜连锁价格方案详情
- (UIViewController *)Action_nativeChainAddPriceFormatViewController:(NSDictionary *)params
{
    TDFAddChainPriceFormatViewController *viewController = [[TDFAddChainPriceFormatViewController alloc] init];
    viewController.vo = params[@"menuPricePlanVo"];
    viewController.action = [params[@"action"] intValue];
    viewController.isContinue = [params[@"isContinue"] boolValue];
    viewController.addPriceFormatCallBack = params[@"editAction"];
    return viewController;
}

//连锁门店权限详情界面
- (UIViewController *)Action_nativeShopPowerEditViewController:(NSDictionary *)params
{
    TDFShopPowerEditViewController *viewController = [[TDFShopPowerEditViewController alloc] init];
    viewController.plate = params[@"plate"];
    viewController.shopPowerCallBack = params[@"editAction"];
    return viewController;
}

//发布到门店列表
- (UIViewController *)Action_nativeChainShopReleaseViewController:(NSDictionary *)params
{
    TDFChainShopReleaseViewController *viewController =  [[TDFChainShopReleaseViewController  alloc] init];
    return viewController;
    
}

//等待发布界面
- (UIViewController *)Action_nativeChainShopWaitReleaseViewController:(NSDictionary *)params
{
    TDFChainShopWaitReleaseViewController * viewController  =  [[TDFChainShopWaitReleaseViewController alloc] init];
    viewController.dataDic = [NSDictionary dictionaryWithDictionary:params];
    return viewController;
}

//发布商品到门店界面
- (UIViewController *)Action_nativeChainShopPublishGoodsViewController:(NSDictionary *)params
{
    TDFChainShopPublishGoodsViewController *viewController  =  [[TDFChainShopPublishGoodsViewController  alloc] init];
    viewController.dic  = [NSDictionary dictionaryWithDictionary:params];
    return viewController;
}

//发布记录界面
- (UIViewController *)Action_nativeChainPublishRecordViewController:(NSDictionary *)params
{
    TDFChainPublishRecordViewController *viewController  =  [[TDFChainPublishRecordViewController  alloc] init];
    return viewController;
}

//发布详情页
- (UIViewController *)Action_nativeChainPublishDetailViewController:(NSDictionary *)params
{
    TDFChainPublishDetailViewController *viewController  =  [[TDFChainPublishDetailViewController  alloc] init];
    viewController.dic = [NSDictionary dictionaryWithDictionary:params];
    return viewController;
}
@end
