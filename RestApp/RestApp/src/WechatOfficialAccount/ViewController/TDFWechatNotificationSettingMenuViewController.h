//
//  TDFWechatNotificationSettingMenuViewController.h
//  RestApp
//
//  Created by Xihe on 17/3/20.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"
#import "TDFOfficialAccountModel.h"

@interface TDFWechatNotificationSettingMenuViewController : TDFRootViewController
@property (nonatomic, assign) BOOL isAuthorization; // 是否授权
@property (nonatomic, strong) TDFOfficialAccountModel *officialAccount;
@end
