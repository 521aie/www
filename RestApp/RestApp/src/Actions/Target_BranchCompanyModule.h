//
//  Target_BranchCompanyModule.h
//  RestApp
//
//  Created by zishu on 16/8/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_BranchCompanyModule : NSObject

//分公司列表:zishu
- (UIViewController *)Action_nativeBranchCompanyListViewController:(NSDictionary *)params;

//分公司详情:zishu
- (UIViewController *)Action_nativeBranchCompanyEditViewController:(NSDictionary *)params;
@end
