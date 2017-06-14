//
//  MarketModule.h
//  RestApp
//
//  Created by zxh on 14-11-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "INavigateEvent.h"
#import "MainModule.h"
#import "MBProgressHUD.h"
#import "TDFRootViewController.h"
@interface ReportModule : TDFRootViewController<INavigateEvent, UIWebViewDelegate>
{
    MBProgressHUD *hud;
    
    MainModule *mainModule;
}
@property (nonatomic, strong) IBOutlet UIWebView *webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent;

- (void)loadReportData;

- (void)loadReportDataWithToken:(NSString *)token;


@end
