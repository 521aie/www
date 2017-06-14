//
//  TDFOAAuthViewController.m
//  RestApp
//
//  Created by Octree on 16/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOAAuthViewController.h"
#import "TDFWechatMarketingService.h"
#import "TDFWebView.h"
#import "UIColor+Hex.h"
#import "TDFOAAuthDetailViewController.h"
#import <Masonry/Masonry.h>
#import "TDFOAAuthDetailViewController.h"
#import "UIViewController+HUD.h"
#import "Platform.h"
#import "TDFOfficialAccountModel.h"
#import "TDFButtonFactory.h"
#import "BackgroundHelper.h"

@interface TDFOAAuthViewController ()<WKNavigationDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) TDFWebView *webView;
@property (strong, nonatomic) UILabel *promptLabel;
@property (strong, nonatomic) UIView *containerView;

@end

@implementation TDFOAAuthViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self injectResponseJS];
    [self configViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - Method

- (void)configViews {
    
    [self configBackground];
    [self configNavigationBar];
    [self configContentViews];
}

- (void)configBackground {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    UIView *view = [[UIView alloc] initWithFrame:imageView.bounds];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [imageView addSubview:view];
    [self.view addSubview:imageView];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.authURL]];
//    [request setValue:@"http://api.l.whereask.com" forHTTPHeaderField:@"Referer"];
    [self.webView loadRequest:request];
}

- (void)configNavigationBar {
    
    self.title = NSLocalizedString(@"店家公众号授权", nil);
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)configContentViews {

    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(self.containerView.frame.size.height);
    }];
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.containerView.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.containerView addSubview:self.promptLabel];
}

- (void)injectResponseJS {
    
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:[self jsString] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [self.webView.configuration.userContentController addUserScript:userScript];
}


#pragma mark Action

- (void)backButtonTapped {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark WKNavigationDelegate


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (![navigationAction.request.URL.absoluteString containsString:@"shopOfficialAccountsWarrant.html"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    NSString *queryString = [navigationAction.request.URL query];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    for (NSString *param in [queryString componentsSeparatedByString: @"&"]) {
        
        NSArray *elts = [param componentsSeparatedByString: @"="];
        if (elts.count < 2) continue;
        
        params[ elts.firstObject ] = elts.lastObject;
    }

    NSString *appId = params[@"app_id"];
    BOOL success = [params[@"result"] boolValue];
    
    //     授权失败
    if (!success || !appId) {
        decisionHandler(WKNavigationActionPolicyAllow);

        return;
    }
    
    [[TDFWechatMarketingService service] fetchOfficialAccountInfoWithId:appId callback:^(id responseObj, NSError *error) {
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return ;
        }
        
        TDFOfficialAccountModel *model = [TDFOfficialAccountModel yy_modelWithDictionary:[responseObj objectForKey:@"data"]];
        TDFOAAuthDetailViewController *vc = [[TDFOAAuthDetailViewController alloc] init];
        vc.officialAccount = model;
        vc.popDepth = self.authPopDepthAddition + ([[Platform Instance] isChain] ? 3 : 2);
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark - Accessor

- (TDFWebView *)webView {

    if (!_webView) {
        
        _webView = [[TDFWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.navigationDelegate = self;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.backgroundColor = [UIColor clearColor];
    }
    
    return _webView;
}

- (UILabel *)promptLabel {
    
    if (!_promptLabel) {
        
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.text = NSLocalizedString(@"您可以使用另一台手机打开微信，扫描以下二维码；或者将此页面截屏，打开微信扫一扫，从相册中选择图片进行识别。扫码时登录的微信号必须是与待授权的公众号绑定的个人微信号。", nil);
        _promptLabel.textColor = [UIColor colorWithHeX:0xcc0000];
        _promptLabel.font = [UIFont systemFontOfSize:13];
        _promptLabel.numberOfLines = 0;
        _promptLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 0);
        [_promptLabel sizeToFit];
    }
    return _promptLabel;
}

- (UIView *)containerView {
    
    if (!_containerView) {
        
        CGRect frame = CGRectZero;
        frame.size = CGSizeMake(SCREEN_WIDTH, self.promptLabel.frame.size.height + 20);
        _containerView = [[UIView alloc] initWithFrame:frame];
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;    
}

/**
 *  由于微信授权页面没有适配手机，这里的 js 代码用来适配手机屏幕，修改一些 div 的 style
 *
 *  @return js code
 */
- (NSString *)jsString {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"wx_auth" ofType:@"js"];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}

@end
