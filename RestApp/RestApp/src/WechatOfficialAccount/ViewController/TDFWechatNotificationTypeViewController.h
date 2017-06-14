//
//  TDFWechatNotificationTypeViewController.h
//  RestApp
//
//  Created by Xihe on 17/3/21.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"
#import "TDFWXNotificationModel.h"

@interface TDFWechatNotificationTypeViewController : TDFRootViewController

@property (nonatomic) TDFWXNotificationContentType contentType;
@property (copy, nonatomic) NSString *selectedId;
@property (nonatomic, copy) NSString *actionPath;
@property (nonatomic, copy) NSString *wechatId;
@property (strong, nonatomic) void (^completionBlock)(NSString *contentId, NSString *contentName);

@end
