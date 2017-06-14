//
//  TDFWXNotificationEditViewController.h
//  RestApp
//
//  Created by Octree on 20/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFWXNotificationModel.h"
#import "TDFOfficialAccountModel.h"

/**
 *   微信公众号定向推送设置页面
 */


@interface TDFWXNotificationEditViewController : UIViewController

@property (strong, nonatomic) TDFOfficialAccountModel *officialAccount;
@property (strong, nonatomic) TDFWXNotificationModel *model;

@end
