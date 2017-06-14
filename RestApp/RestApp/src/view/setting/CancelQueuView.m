//
//  CancelQueuView.m
//  RestApp
//
//  Created by YouQ-MAC on 15/1/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CancelQueuView.h"
#import "NavigateTitle.h"
#import "NavigateTitle2.h"
#import "EditItemList.h"
#import "UIView+Sizes.h"
#import "MBProgressHUD.h"
#import "SettingService.h"
#import "JsonHelper.h"
#import "ColorHelper.h"
#import "UIHelper.h"
#import "RemoteEvent.h"
#import "NSString+Estimate.h"
#import "SettingModuleEvent.h"
#import "RemoteResult.h"
#import "TDFSettingService.h"
#import "ServiceFactory.h"
#import "DateUtils.h"
#import "AlertBox.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "TDFRootViewController+FooterButton.h"

@implementation CancelQueuView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service=[ServiceFactory Instance].settingService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self initNavigate];
    self.lblWarn.text=NSLocalizedString(@"在更换排队机时必须进行此操作", nil);
    [self.lblWarn setTextColor:[ColorHelper getRedColor]];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [self loadDatas];
}
-(void)loadDatas
{

     [self showProgressHudWithText:NSLocalizedString(@"正在查询排队机", nil)];
    [[TDFSettingService new] searchQueueBindSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hide:YES];
       
        NSString *code= [data objectForKey:@"data"];
        
        if ([code isEqualToString:@"0"]) {
            [self.btnCancel setTitle:NSLocalizedString(@"已解除绑定", nil) forState:UIControlStateNormal];
            [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_grey_large.png"] forState:UIControlStateNormal];
            self.btnCancel.userInteractionEnabled=NO;
        }else{
            [self.btnCancel setTitle:NSLocalizedString(@"解除绑定", nil) forState:UIControlStateNormal];
            [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
            self.btnCancel.userInteractionEnabled=YES;
        }
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];

}
#pragma navigateTitle.
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"更换排队机", nil) backImg:Head_ICON_BACK moreImg:nil];
    self.title = NSLocalizedString(@"更换排队机", nil);
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

#pragma 数据层处理
- (IBAction)btnClearClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:NSLocalizedString(@"确认要更换排队机吗？", nil)];
}

//全部删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){

        [self showProgressHudWithText:NSLocalizedString(@"正在更换排队机", nil)];
        [[TDFSettingService new] cancelQueueBindSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hide:YES];
          
            NSNull *code= [data objectForKey:@"data"];
            if ([code isEqual:[NSNull null]]) {
                [AlertBox show:NSLocalizedString(@"更换排队机成功!", nil)];
                [self.btnCancel setTitle:NSLocalizedString(@"已解除绑定", nil)  forState:UIControlStateNormal];
                [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_grey_large.png"] forState:UIControlStateNormal];
                self.btnCancel.userInteractionEnabled=NO;
                return;
            }else{
                [AlertBox show:NSLocalizedString(@"解除绑定失败", nil)];
                [self.btnCancel setTitle:NSLocalizedString(@"解除绑定", nil) forState:UIControlStateNormal];
                [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
                self.btnCancel.userInteractionEnabled=YES;
                return;
            }
            
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];

    }
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"cancelqueue"];
}

@end
