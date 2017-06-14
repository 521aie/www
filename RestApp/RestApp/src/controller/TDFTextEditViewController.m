//
//  TDFTextAdEditViewController.m
//  RestApp
//
//  Created by Octree on 7/12/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTextEditViewController.h"
#import "UITextView+Placeholder.h"
#import "UIColor+Hex.h"
#import "BackgroundHelper.h"
#import <Masonry/Masonry.h>
#import "UIViewController+HUD.h"

@interface TDFTextEditViewController ()<UITextViewDelegate>

@property (strong, nonatomic) NSString *originAdText;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) NSString *placeholder;
@property (strong, nonatomic) NSString *prompt;
@property (nonatomic) NSInteger limit;

@end

@implementation TDFTextEditViewController


#pragma mark - Life Cycle

- (instancetype)initWithTitle:(NSString *)title text:(NSString *)text limit:(NSInteger)limit placeholder:(NSString *)placeholder prompt:(NSString *)prompt {

    if (self = [super init]) {
        
        self.title = title;
        self.originAdText = text;
        self.placeholder = placeholder;
        self.prompt = prompt;
        self.limit = limit;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configViews];
    [self updateNavigateButtons];
}


#pragma mark - Methods

- (void)configViews {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    
    [self.view addSubview:imageView];
    [self.view addSubview: self.containerView];
    
    @weakify(self);
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(150);
    }];
    
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.containerView.mas_left).with.offset(10);
        make.right.equalTo(self.containerView.mas_right).with.offset(-10);
        make.top.equalTo(self.containerView.mas_top);
        make.height.mas_equalTo(44);
    }] ;
    
    [self.containerView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        @strongify(self);
        make.left.equalTo(self.containerView.mas_left).with.offset(0);
        make.right.equalTo(self.containerView.mas_right).with.offset(0);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.mas_equalTo(self.containerView.mas_bottom);
    }];
}


- (void)updateNavigateButtons {
    
    if (![self valueChanged]) {
        
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0.0f, 0.0f, 60.0f, 40.0f);
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        UIImage *backIcon = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_back"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
        [backButton setImage:backIcon forState:UIControlStateNormal];
        [backButton setTitle:NSLocalizedString(@"返回", nil) forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    
    UIImage *cancelImage = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_cancel"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(.0, .0, 60, 40)];
    [cancelButton setTitle:NSLocalizedString(@"取消", nil) forState: UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton setImage:cancelImage forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 4);
    cancelButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    [cancelButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    UIImage *okImage = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_ok"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(.0, .0, 60, 40)];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveButton setTitle:NSLocalizedString(@"保存", nil) forState: UIControlStateNormal];
    [saveButton setImage:okImage forState:UIControlStateNormal];
    saveButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 4);
    saveButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
}


- (BOOL)valueChanged {

    if (self.textView.text.length == 0 && self.originAdText.length == 0) {
        
        return NO;
    }
    
    return ![self.textView.text isEqualToString:self.originAdText];
}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {

    [self updateNavigateButtons];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (self.forbiddenNewLine && [text isEqualToString:@"\n"]) {
        
        return NO;
    }

    return (textView.text.length - range.length + text.length) < self.limit;
}

#pragma mark Action

- (void)cancelButtonTapped {
    
    UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"内容有变更尚未保存,确定要退出吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    __weak __typeof(self) wself = self;
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [wself.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:avc animated:YES completion:nil];
}

- (void)saveButtonTapped {
    
    NSString *trimmedString = [self.textView.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    
    if (trimmedString.length == 0) {
    
        [self showErrorMessage:NSLocalizedString(@"内容不能为空", nil)];
        return;
    }
    
    !self.finishBlock ?: self.finishBlock(trimmedString);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popButtonTapped {

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Accessor

- (UIView *)containerView {

    if (!_containerView) {
        
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    
    return _containerView;
}

- (UILabel *)titleLabel {

    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHeX:0x333333];
        _titleLabel.text = self.prompt;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return _titleLabel;
}

- (UITextView *)textView {

    if (!_textView) {
     
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor colorWithHeX:0xeeeeee];
        _textView.placeholderColor = [UIColor lightGrayColor];
        _textView.placeholderLabel.font = [UIFont systemFontOfSize:13];
        _textView.placeholder = self.placeholder;
        _textView.textColor = [UIColor colorWithHeX:0x333333];
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.delegate = self;
        _textView.text = self.originAdText;
    }
    
    return _textView;
}


@end
