//
//  TDFPaymentNoteViewController.m
//  RestApp
//
//  Created by Xihe on 17/3/30.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFPaymentNoteViewController.h"
#import <WebKit/WebKit.h>


@interface TDFPaymentNoteViewController ()

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation TDFPaymentNoteViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商户服务协议";
    TDFDataCenter *datacenter = [TDFDataCenter sharedInstance];
    self.shopName = datacenter.shopName;
    [self configView];
}

#pragma mark - config View

-(void)configView {
    [self.view addSubview:self.webView];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"agreement" ofType:@"htm"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    htmlString = [self replaceString:htmlString];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_webView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - Method

- (NSString *)replaceString:(NSString *)htmlString {
    NSArray *stringArr = [NSArray arrayWithObjects:@"｛乙方｝",@"｛户名｝",@"｛账号｝",@"｛开户行｝",@"｛联系人及联系电话｝",@"｛联系地址｝" ,nil];
    if (!self.shopName) {
        self.shopName = @" ";
    }
    if (!self.accountNameTxt) {
        self.accountNameTxt = @" ";
    }
    if (!self.accountBankLst) {
        self.accountBankLst = @" ";
    }
    if (!self.bankAccountLst) {
        self.bankAccountLst = @" ";
    }
    if (!self.personName) {
        self.personName = @" ";
    }
    if (!self.personMobile) {
        self.personMobile = @" ";
    }
    if (!self.address) {
        self.address = @" "; 
    }
    NSArray *replaceArr = [NSArray arrayWithObjects:self.shopName,self.accountNameTxt,self.accountBankLst,self.bankAccountLst,[NSString stringWithFormat:@"%@ %@",self.personName,self.personMobile],self.address, nil];
    for (int i=0; i<stringArr.count;i++) {
        htmlString = [htmlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",stringArr[i]] withString:[NSString stringWithFormat:@"%@",replaceArr[i]]];
    }
    return htmlString;
}

#pragma mark - Accessor

- (WKWebView *)webView {
    if (!_webView) {
        WKUserContentController *userController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.processPool = [[WKProcessPool alloc] init];
        configuration.userContentController = userController;
        configuration.allowsInlineMediaPlayback = YES;
        _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:configuration];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.backgroundColor = [UIColor clearColor];
    }
    return _webView;
}

@end
