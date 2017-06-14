//
//  TDFOtherMenuViewController.h
//  RestApp
//
//  Created by 刘红琳 on 2016/11/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"

@interface TDFOtherMenuViewController : TDFRootViewController
@property (nonatomic, assign) NSUInteger sysNotificationCount;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* roleName;
@property (nonatomic, strong) NSString* server;
@property (nonatomic, strong) NSString* path;

- (void)refreshSysStatus:(NSUInteger)sysNoteCount;
+ (TDFOtherMenuViewController *)sharedInstance;
- (void)resetShopInfo;
- (void)resetDataView;
@end
