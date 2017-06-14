//
//  TDFWechatOfficialAccountsViewController.h
//  RestApp
//
//  Created by happyo on 2017/2/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"

@interface TDFWechatOfficialAccountsViewController : TDFRootViewController

@property (nonatomic, assign) BOOL isChain;

@property (nonatomic, assign) BOOL isAuthorization; // 是否授权

@property (nonatomic, copy) NSString *wechatId;

@property (nonatomic, copy) NSString *wechatName;

@end
