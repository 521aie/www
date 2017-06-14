//
//  Target_SmartModel.h
//  RestApp
//
//  Created by iOS香肠 on 2016/10/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_SmartModule : NSObject

///首页跳转到智能点餐主页
- (UIViewController *)Action_nativeTDFSmartOrderModuleViewController:(NSDictionary *)params;

//智能点餐列表页面
- (UIViewController *)Action_nativeOrderListViewController:(NSDictionary *)params;

//商品标签设置页面
- (UIViewController *)Action_nativeOrderSetViewController:(NSDictionary *)params;

//顾客点餐提醒与推荐页面
- (UIViewController *)Action_nativeOrderRecommendViewController:(NSDictionary *)params;

//点餐提醒与推荐页面
- (UIViewController *)Action_nativeOrderRdDetailViewController:(NSDictionary *)params;

//标签设置详情页面
- (UIViewController *)Action_nativeOrderDetailsViewController:(NSDictionary *)params;

//提示语页面
- (UIViewController *)Action_nativeOrderRemindViewController:(NSDictionary *)params;

//特色标签管理页面
- (UIViewController *)Action_nativeSpecialTagListViewController:(NSDictionary *)params;

@end
