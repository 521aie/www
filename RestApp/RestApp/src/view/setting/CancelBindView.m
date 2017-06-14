//
//  CancelBindView.m
//  RestApp
//
//  Created by zxh on 14-4-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "CancelBindView.h"
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
#import "SettingModule.h"
#import "RemoteResult.h"
#import "ServiceFactory.h"
#import "DateUtils.h"
#import "AlertBox.h"
#import "FooterListView.h"
#import "TDFSettingService.h"
#import "HelpDialog.h"
#import "NSNull+NSNullCast.h"
@implementation CancelBindView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SettingModule *)_parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent=_parent;
        service=[ServiceFactory Instance].settingService;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNotifaction];
    [self initNavigate];
    self.lblWarn.text=NSLocalizedString(@"在更换主收银机时必须进行此操作\n副收银可直接更换使用,无需进行此操作", nil);
    [self.lblWarn setTextColor:[ColorHelper getRedColor]];
    [self.footView initDelegate:self btnArrs:nil];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    
 }
-(void)loadDatas
{
    [UIHelper showHUD:NSLocalizedString(@"正在查询收银机", nil) andView:self.view andHUD:hud];
    [[TDFSettingService new] searchQueueBindSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [hud  hideAnimated: YES];
        NSNull *code= [data objectForKey:@"data"];
        if ([code isEqual:[NSNull null]]) {
            [self.btnCancel setTitle:NSLocalizedString(@"已解除绑定", nil) forState:UIControlStateNormal];
            [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_grey_large.png"] forState:UIControlStateNormal];
            self.btnCancel.userInteractionEnabled=NO;
        }else{
            [self.btnCancel setTitle:NSLocalizedString(@"解除绑定", nil) forState:UIControlStateNormal];
            [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
            self.btnCancel.userInteractionEnabled=YES;
        }
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         [hud  hideAnimated: YES];
        [AlertBox show:error.localizedDescription];
    }];
}
#pragma navigateTitle.
-(void) initNavigate{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"更换主收银机", nil) backImg:Head_ICON_BACK moreImg:nil];
}

-(void) onNavigateEvent:(NSInteger)event{
    if (event==DIRECT_LEFT) {
        [parent showView:SECOND_MENU_VIEW];
    }
}

#pragma 数据层处理
- (IBAction)btnClearClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:NSLocalizedString(@"确认要更换收银机吗？", nil)];
}

//全部删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [UIHelper showHUD:NSLocalizedString(@"正在更换收银机", nil) andView:self.view andHUD:hud];
        [[TDFSettingService new] cancelBindSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [hud hideAnimated:YES];
            NSNull *code= [data  objectForKey:@"data"];
            if ([code isEqual:[NSNull null]]) {
                [AlertBox show:NSLocalizedString(@"更换收银机成功!", nil)];
                [self.btnCancel setTitle:NSLocalizedString(@"已解除绑定", nil) forState:UIControlStateNormal];
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
            [hud hideAnimated: YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

#pragma notification 处理.
-(void) initNotifaction{

}

-(void) showHelpEvent
{
    [HelpDialog show:@"cancelbind"];
}
@end
