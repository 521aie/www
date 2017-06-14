//
//  TDFWechatNotificationSettingViewController.h
//  RestApp
//
//  Created by happyo on 2017/2/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"

@interface TDFWechatNotificationSettingViewController : TDFRootViewController

@property (nonatomic, assign) BOOL isAuthorization; // 是否授权

@property (nonatomic, assign) BOOL isChain; //  是否是连锁

@property (nonatomic, assign) BOOL hasPermission; // 是否有权限

@property (nonatomic, strong) NSString *wechatId;

@end
