//
//  TDFSunOfKitchenVideoController.m
//  RestApp
//
//  Created by suckerl on 2017/6/7.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSunOfKitchenVideoController.h"

@interface TDFSunOfKitchenVideoController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UILabel *noticeLabel;
@end

@implementation TDFSunOfKitchenVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
    
}

#pragma mark - setupUI
- (void)setupUI {
    self.navigationItem.title = self.areaName;
    [self.view addSubview:self.webView];
}

#pragma mark - loadData
- (void)loadData {
    NSURL *url = [NSURL URLWithString:self.videoURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view insertSubview:self.noticeLabel atIndex:1];
    [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.noticeLabel removeFromSuperview];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.delegate = self;
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _webView;
}

- (UILabel *)noticeLabel {
    if (_noticeLabel == nil) {
        _noticeLabel = [[UILabel alloc] init];
        _noticeLabel.text = @"无视频信号";
        _noticeLabel.textColor = [UIColor whiteColor];
        _noticeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _noticeLabel;
}

@end
