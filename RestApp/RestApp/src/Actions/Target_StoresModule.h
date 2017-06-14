//
//  Target_StoresModule.h
//  RestApp
//
//  Created by zishu on 16/8/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_StoresModule : NSObject

//门店列表:zishu
- (UIViewController *)Action_nativeStoresListViewController:(NSDictionary *)params;

//门店详情：zishu
- (UIViewController *)Action_nativeEditStoresViewController:(NSDictionary *)params;
@end
