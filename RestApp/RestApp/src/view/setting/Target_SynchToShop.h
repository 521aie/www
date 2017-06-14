//
//  Target_SynchToShop.h
//  RestApp
//
//  Created by chaiweiwei on 2017/3/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFIssueCenter.h"

@interface Target_SynchToShop : NSObject

//同步到门店列表
- (UIViewController *)Action_nativeSynchToShopViewController:(NSDictionary *)params;
//从总部获取
- (UIViewController *)Action_nativeSynchFetchFromChainViewController:(NSDictionary *)params;

@end
