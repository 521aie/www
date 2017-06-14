//
//  Target_MenuModule.h
//  RestApp
//
//  Created by zishu on 16/8/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_MenuModule : NSObject
///餐盒选择
-(UIViewController *)Action_nativeBoxSelectViewController:(NSDictionary *)params;
-(UIViewController *)Action_nativeMenuIDViewController:(NSDictionary *)params;

//商品列表页面
- (UIViewController *)Action_nativeMenuListViewController:(NSDictionary *)params;

//商品编辑页面
- (UIViewController *)Action_nativeMenuEditViewController:(NSDictionary *)params;

//商品批量页面
- (UIViewController *)Action_nativeBatchMenuListViewController:(NSDictionary *)params;

// 分类管理页面
- (UIViewController *)Action_nativeKindMenuListViewController:(NSDictionary *)params;

//分类编辑页面
- (UIViewController *)Action_nativeKindMenuEditViewController:(NSDictionary *)params;

//备注列表页面
- (UIViewController *)Action_nativeMultiHeadCheckViewController:(NSDictionary *)params;

//备注管理页面
- (UIViewController *)Action_nativeTasteListViewController:(NSDictionary *)params;

//备注管理添加界面
- (UIViewController *)Action_nativeKindTasteEditViewController:(NSDictionary *)params;

//备注编辑界面
- (UIViewController *)Action_nativeTasteEditViewController:(NSDictionary *)params;

//排序编辑界面
- (UIViewController *)Action_nativeTableEditViewController:(NSDictionary *)params;

//新排序编辑界面
- (UIViewController *)Action_nativeSortTableEditViewController:(NSDictionary *)params;

//备注详情页面
- (UIViewController *)Action_nativeMultiDetailViewController:(NSDictionary *)params;

//加料列表界面
- (UIViewController *)Action_nativeAdditionListViewController:(NSDictionary *)params;

//新增加料界面
- (UIViewController *)Action_nativeMenuAdditionEditViewController:(NSDictionary *)params;

//加料编辑页面
- (UIViewController *)Action_nativeKindAdditionEditViewController:(NSDictionary *)params;

//分类管理界面
- (UIViewController *)Action_nativeKindListViewController:(NSDictionary *)params;

//套餐新增界面
- (UIViewController *)Action_nativeSuitMenuEditViewController:(NSDictionary *)params;

//套餐分类编辑界面
- (UIViewController *)Action_nativeSuitMenuKindEditViewController:(NSDictionary *)params;

//备注库列表界面
- (UIViewController  *)Action_nativeMultiCheckManageViewController:(NSDictionary *)params;

//做法库列表页面
- (UIViewController  *)Action_nativeMakeListViewController:(NSDictionary *)params;

//做法库编辑界面
- (UIViewController *)Action_nativeMakeEditViewController:(NSDictionary *)params;

//规格管理列表
- (UIViewController *)Action_nativeSelectSpecViewController:(NSDictionary *)params;

//规格编辑界面
- (UIViewController *)Action_nativeSpecListViewController:(NSDictionary *)params;

//规格详情界面
- (UIViewController *)Action_nativeSpecEditViewController:(NSDictionary *)params;

//菜肴二维码
- (UIViewController *)Action_nativeMenuCodeViewController:(NSDictionary *)params;

//单位库管理界面
- (UIViewController *)Action_nativeUnitListViewController:(NSDictionary *)params;

//单位库编辑界面
- (UIViewController *)Action_nativeUnitEditViewController:(NSDictionary *)params;

//商品做法编辑界面
- (UIViewController *)Action_nativeMenuMakeEditViewController:(NSDictionary *)params;

//商品规格编辑界面
- (UIViewController *)Action_nativeMenuSpecDetailEditViewController:(NSDictionary *)params;

//套餐内商品编辑界面
- (UIViewController *)Action_nativeSelectMenuListViewController:(NSDictionary *)params;

//套餐商品详情编辑界面
- (UIViewController *)Action_nativeMenuDetailEditViewController:(NSDictionary *)params;

//设置商品便捷界面
- (UIViewController *)Action_nativeSuitMenuChangeEditViewController:(NSDictionary *)params;
@end
