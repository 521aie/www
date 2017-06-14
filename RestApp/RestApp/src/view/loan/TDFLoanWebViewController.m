//
//  TDFLoanWebViewController.m
//  RestApp
//
//  Created by zishu on 16/8/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFLoanWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RestConstants.h"
#import "TDFSettingService.h"
#import "SettingService.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "Platform.h"
#import "MobClick.h"
#import <WebKit/WebKit.h>

@implementation TDFLoanWebViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我要贷款", nil);
    [self loadData];
    [self configLeftNavigationBar];
}

#pragma mark - configLeftNavigationBar
- (void)configLeftNavigationBar {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 60.0f, 40.0f);
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    UIImage *backIcon = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_back"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    [backButton setImage:backIcon forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftNavigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (IBAction)leftNavigationButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) loadData
{
    [[TDFSettingService new] obtainBaseShopDetailSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        NSDictionary *userDic = [data objectForKey:@"data"];
        self.shopDetail=[JsonHelper dicTransObj:userDic obj:[ShopDetail alloc]];
        [self loadWebData];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [AlertBox show:error.localizedDescription];
    }];

}




- (void)loadWebData
{
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSString *name = self.shopDetail.name;
    NSString *linkman = self.shopDetail.linkman;
    NSString *phone = self.shopDetail.phone1;

    NSString *urlString = [NSString stringWithFormat:kTDFKLoanURL,self.h5Url,entityId,[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[linkman stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],phone];
    
    self.webURLString = [NSString stringWithFormat:kTDFKLoanURL,self.h5Url,entityId,[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[linkman stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],phone];
}

#pragma mark - web view delegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
}

@end
