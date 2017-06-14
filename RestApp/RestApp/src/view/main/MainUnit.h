//
//  MainUnit.h
//  RestApp
//
//  Created by zxh on 14-5-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppController, XHMenuController, TDFOtherMenuViewController, TDFNavigateMenuViewController,TDFRightMenuController;
@class TDFHomePageViewController;

typedef NS_ENUM(NSInteger,TDFMainShowType) {
    TDFMainShowTypeEntryView,
    TDFMainShowTypeHomeView,
};
@interface MainUnit : UIViewController

@property (nonatomic, strong) TDFRightMenuController *otherMenu;

/**
 新的首页
 */
@property (nonatomic, strong) TDFHomePageViewController *latestHomeViewController;
@property (nonatomic, strong) TDFNavigateMenuViewController *navigateMenu;
@property (nonatomic, strong) XHMenuController *menuController;

@property (nonatomic,assign) TDFMainShowType showType;

@property (nonatomic,copy) void (^reSetRootVCFromeMainUnitCallBack)(void);

- (void)showEntryView;

- (void)showMainView;

@end
 
