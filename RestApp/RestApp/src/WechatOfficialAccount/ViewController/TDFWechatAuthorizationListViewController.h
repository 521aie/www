//
//  TDFWechatAuthorizationListViewController.h
//  RestApp
//
//  Created by happyo on 2017/2/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"
@class TDFOfficialAccountModel;

@interface TDFWechatAuthorizationListViewController : TDFRootViewController

@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, assign) BOOL headerHidden;
@property (nonatomic, assign) BOOL addButtonHidden;
@property (nonatomic, strong) void (^selectedBlock)(TDFOfficialAccountModel *model);

@end
