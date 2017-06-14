//
//  TDFAddNewCopousInfoViewController.h
//  RestApp
//
//  Created by hulatang on 16/7/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFRootViewController.h"
#import "NavigationToJump.h"
@class SettingModule,KindPay;
@interface TDFAddNewCopousInfoViewController : TDFRootViewController
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, assign) id<NavigationToJump>delegate;
- (instancetype)initWithParent:(SettingModule *)parent;

- (void)addNewInfoWith:(KindPay *)kindPay;
@end
