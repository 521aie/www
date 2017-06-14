//
//  MainUI.h
//  RestApp
//
//  Created by zxh on 14-5-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppController, MainModule;
@class TDFOtherMenuViewController, XHMenuController, NavigateMenu,TDFRightMenuController;
@interface MainUI : UIViewController
{
    AppController *appController;
}

@property (nonatomic, strong) TDFRightMenuController *otherMenu;
@property (nonatomic, strong) MainModule *mainModule;
@property (nonatomic, strong) NavigateMenu *navigateMenu;
@property (nonatomic, strong) XHMenuController *menuController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(AppController *)appController;

@end
