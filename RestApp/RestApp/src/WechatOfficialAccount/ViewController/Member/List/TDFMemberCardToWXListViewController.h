//
//  TDFMemberCardToWXListViewController.h
//  RestApp
//
//  Created by 黄河 on 2017/3/20.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFRootViewController.h"
@class TDFOfficialAccountModel;
@interface TDFMemberCardToWXListViewController : TDFRootViewController
@property (nonatomic, assign)BOOL isAuthorized;
@property (nonatomic, strong) TDFOfficialAccountModel *officialAccount;
@end
