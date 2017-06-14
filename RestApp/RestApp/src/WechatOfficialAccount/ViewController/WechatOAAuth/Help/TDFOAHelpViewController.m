//
//  TDFOAHelpViewController.m
//  RestApp
//
//  Created by Octree on 3/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOAHelpViewController.h"
#import "UIColor+Hex.h"
#import "BackgroundHelper.h"
#import "WXOAConst.h"
#import "TDFLabelFactory.h"
#import "TDFButtonFactory.h"
#import <Masonry/Masonry.h>

@interface TDFOAHelpViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation TDFOAHelpViewController


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
}

#pragma mark - Methods


- (void)configViews {
    
    [self configBackground];
    [self configNavigationBar];
    [self configContentViews];
}


- (void)configBackground {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    [self.view addSubview:imageView];
}

- (void)configNavigationBar {

    self.title = @"如何使用公众号营销";
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)configContentViews {
    
    [self.view addSubview:self.scrollView];
    @weakify(self);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.edges.equalTo(self.view);
    }];
    
    UIImage *image = [UIImage imageNamed:@"wxoa_auth_help"];
    
    CGFloat width = SCREEN_WIDTH - 20;
    CGFloat height = width * image.size.height / image.size.width;
    
    self.imageView.image = image;
    [self.scrollView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.scrollView.mas_left).with.offset(10);
        make.top.equalTo(self.scrollView.mas_top).with.offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
        make.height.mas_equalTo(height);
    }];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height + 30);
}

- (void)backButtonTapped {

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Accessor

- (UIImageView *)imageView {

    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
    }
    
    return _imageView;
}

- (UIScrollView *)scrollView {

    if (!_scrollView) {
    
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

@end
