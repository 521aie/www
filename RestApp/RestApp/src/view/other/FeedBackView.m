//
//  AboutView.m
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-25.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "NavigateTitle2.h"
#import "TDFKabawService.h"
#import "RestConstants.h"
#import "XHAnimalUtil.h"
#import "FeedBackView.h"
#import "RemoteEvent.h"
#import "SystemUtil.h"
#import "Platform.h"
#import "AlertBox.h"

@implementation FeedBackView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        systemService = [ServiceFactory Instance].systemService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:@"关闭"];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:@"提交"];
    
    [self initMainView];
    [self initDataView];
}

- (void)rightNavigationButtonAction:(id)sender {
    [self sendSuggestion];
}
- (void)leftNavigationButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initMainView
{
    [self.suggestionTxt initPlaceHolder:NSLocalizedString(@"说说您的意见吧，我们将为您不断地改进", nil)];
    [self.emailTxt initPlaceHolder:NSLocalizedString(@"选填，便于我们给您反馈", nil)];
    self.emailTxt.tintColor = [UIColor lightGrayColor];
    self.suggestionTxt.layer.borderWidth=1.0;
    self.suggestionTxt.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.emailBackground.layer.cornerRadius=6;
    self.emailBackground.layer.borderWidth=1.0;
    self.emailBackground.layer.borderColor=[UIColor lightGrayColor].CGColor;
}

- (void)initDataView
{
    [self.emailTxt initData:nil];
    [self.suggestionTxt initData:nil];
}

- (void)sendFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [AlertBox show:NSLocalizedString(@"意见反馈发送成功!", nil)];
    self.suggestionTxt.text=@"";
    self.emailTxt.text=@"";
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendSuggestion
{
    NSString *email = self.emailTxt.text;
    NSString *backMemo = self.suggestionTxt.text;
    
    if ([NSString isNotBlank:email]) {
        if ([NSString isValidateEmail:email]==NO) {
            [AlertBox show:NSLocalizedString(@"您输入的邮箱格式不正确", nil)];
            return;
        }
    }
    
    if ([NSString isBlank:backMemo]) {
        [AlertBox show:NSLocalizedString(@"请输入您的意见及建议", nil)];
        return;
    }
    
    [SystemUtil hideKeyboard];

   [self showProgressHudWithText:NSLocalizedString(@"正在提交", nil)];
    [[TDFKabawService new] sendUserSuggestion:email backMemo:backMemo sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:NSLocalizedString(@"意见反馈发送成功!", nil)];
        self.suggestionTxt.text=@"";
        self.emailTxt.text=@"";
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];

    
}

@end
