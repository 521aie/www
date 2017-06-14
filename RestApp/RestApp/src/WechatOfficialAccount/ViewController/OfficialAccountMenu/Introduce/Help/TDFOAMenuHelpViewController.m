//
//  TDFOAMenuHelpViewController.m
//  RestApp
//
//  Created by Octree on 7/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOAMenuHelpViewController.h"
#import <Masonry/Masonry.h>
#import "TDFButtonFactory.h"
#import <WebKit/WebKit.h>

@interface TDFOAMenuHelpViewController ()

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation TDFOAMenuHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configViews];
}

#pragma mark - Methods


#pragma mark Config Views


- (void)configViews {
    
    [self configNavigationBar];
    [self configContentViews];
}

- (void)configNavigationBar {
    
    self.title = NSLocalizedString(@"店家公众号菜单自定义", nil);
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)configContentViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    NSURL *url = [NSURL URLWithString:@"https://kf.qq.com/faq/120911VrYVrA150212ENnyqM.html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)backButtonTapped {

    [self.navigationController popViewControllerAnimated:YES];
}


- (WKWebView *)webView {

    if (!_webView) {
        
        WKUserContentController *controller = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = controller;
        _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:config];
    }
    
    return _webView;
}


@end
