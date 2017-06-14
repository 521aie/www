//
//  XHMenuController.h
//  XHMenuController
//
//  Created by zxh on 14-3-19.
//  参考源码实现以后，我做了比较大的调整SJQ.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateMenu.h"
#import "HomeView.h"

@interface XHMenuController : UIViewController <UIGestureRecognizerDelegate>
{    
    BOOL showingLeftView;
    
    BOOL showingRightView;
}

@property (nonatomic, strong)UIButton *shadowButton;

@property (nonatomic, strong) UIViewController *leftController;
@property (nonatomic, strong) UIViewController *rightController;
@property (nonatomic, strong) UIViewController *rootController;
@property (nonatomic, strong) NavigateMenu *navigateMenu;
@property (nonatomic, strong) HomeView *homeview;
- (id)initWithRootViewController:(UIViewController*)controller;

- (void)showRootController;

- (void)showRightController;

- (void)showLeftController;

@end
