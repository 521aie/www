//
//  Target_SuitMenuModule.h
//  RestApp
//
//  Created by 黄河 on 16/8/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_SuitMenuModule : NSObject

///套餐选择可换商品 .
-(UIViewController *)Action_nativeSuitMenuChangeEditViewController:(NSDictionary *)params;
///套餐内商品组合计价规则
-(UIViewController *)Action_nativeValuationEditViewController:(NSDictionary *)params;
@end
