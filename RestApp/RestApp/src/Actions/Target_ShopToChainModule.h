//
//  Target_ShopToChainModule.h
//  RestApp
//
//  Created by 刘红琳 on 2017/3/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_ShopToChainModule : NSObject
///开通连锁首页
- (UIViewController *)Action_nativeOpenChainViewController:(NSDictionary *)params;
@end
