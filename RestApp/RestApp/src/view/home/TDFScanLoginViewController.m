//
//  TDFScanLoginViewController.m
//  RestApp
//
//  Created by doubanjiang on 16/8/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFScanLoginViewController.h"
#import <Masonry.h>
#import "TDFBarcodeService.h"
@interface TDFScanLoginViewController ()

@end

@implementation TDFScanLoginViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layOutUI];
}

#pragma mark - UI布局
- (void)layOutUI {
    
    [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
    
    self.title                   = NSLocalizedString(@"二维码登录", nil);
    __weak typeof(self) weakSelf = self;
    
    //电脑图片
    UIImageView *phoneMacView    = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iphoneMac@2x"]];
    [self.view addSubview:phoneMacView];
    
    UILabel *tipsLabel           = [[UILabel alloc]init];
    tipsLabel.textColor          = [UIColor whiteColor];
    tipsLabel.font               = [UIFont systemFontOfSize:11];
    tipsLabel.textAlignment      = NSTextAlignmentCenter;
    tipsLabel.text               = [_type stringByAppendingString:NSLocalizedString(@"登录确认", nil)];
    [self.view addSubview:tipsLabel];
    
    //登录按钮
    UIButton *loginBtn           = [[UIButton alloc]init];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font     = [UIFont systemFontOfSize:11];
    loginBtn.backgroundColor     = [UIColor cyanColor];
    [loginBtn setTitle:[NSLocalizedString(@"登录", nil) stringByAppendingString:_type] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius  = 5;
    [loginBtn setBackgroundColor:[UIColor colorWithRed:192/255.0 green:0 blue:6/255.0 alpha:1]];
    [self.view addSubview:loginBtn];
    
    //取消按钮
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn addTarget:self action:@selector(leftNavigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font    = [UIFont systemFontOfSize:11];
    [cancelBtn setTitle:NSLocalizedString(@"取消登录", nil) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    
    [phoneMacView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(weakSelf.view.mas_top).with.offset(50);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(144, 110));
        
    }];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(phoneMacView.mas_bottom).with.offset(20);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(tipsLabel.mas_bottom).with.offset(40);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-30);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    
}

#pragma mark - 点击确认登陆
- (void)login {

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:_code forKey:@"code"];
    
    [[[TDFBarcodeService alloc]init]loginConfirmWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull datafe) {
        
        [self leftNavigationButtonAction:nil];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
//        [self leftNavigationButtonAction:nil];
    }];
}

#pragma mark - 导航左按钮以及取消按钮点击事件
- (void)leftNavigationButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end




































