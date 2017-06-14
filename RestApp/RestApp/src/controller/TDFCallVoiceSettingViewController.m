//
//  TDFCallVoiceSettingViewController.m
//  RestApp
//
//  Created by happyo on 16/10/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFCallVoiceSettingViewController.h"
#import "TDFRootViewController+TableViewManager.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFIntroductionHeaderView.h"
#import "DHTTableViewSection.h"
#import "TDFDisplayCommonItem.h"
#import "DHTTableViewManager.h"
#import "HelpDialog.h"
#import "TDFCallVoiceViewController.h"
#import "TDFNotificationVoiceViewController.h"

@interface TDFCallVoiceSettingViewController ()

@end

@implementation TDFCallVoiceSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"叫号语音设置", nil);
    [self configDefaultManager];
    [self registerCells];
    
    @weakify(self);
    self.tbvBase.tableHeaderView = [[TDFIntroductionHeaderView alloc] initWithImageIcon:[UIImage imageNamed:@"call_voice_setting_header_icon"] description:NSLocalizedString(@"叫号语音设置，店家在此处设置叫号语音和广播语音，上传的语音文件将通过二维火取餐叫号、二维火排队应用在店内进行播放。", nil) detailBlock:^{
        //
        @strongify(self);
        [self showHelpEvent];
    }];
    
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    
    [self addSections];
}

- (void)registerCells
{
    [self.manager registerCell:@"TDFDisplayCommonCell" withItem:@"TDFDisplayCommonItem"];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [self showHelpEvent];
}

- (void)addSections
{
    DHTTableViewSection *section = [DHTTableViewSection section];
    
    TDFDisplayCommonItem *callVoiceItem = [[TDFDisplayCommonItem alloc] init];
    callVoiceItem.iconImage = [UIImage imageNamed:@"call_voice_icon"];
    callVoiceItem.title = NSLocalizedString(@"叫号语音", nil);
    callVoiceItem.detail = NSLocalizedString(@"设置叫号语音内容", nil);
    @weakify(self);
    callVoiceItem.clickedBlock = ^ () {
        @strongify(self);
        [self forwardCallVoiceVC];
    };
    
    [section addItem:callVoiceItem];
    
    TDFDisplayCommonItem *notiVoiceItem = [[TDFDisplayCommonItem alloc] init];
    notiVoiceItem.iconImage = [UIImage imageNamed:@"notification_voice_icon"];
    notiVoiceItem.title = NSLocalizedString(@"广播语音", nil);
    notiVoiceItem.detail = NSLocalizedString(@"设置广播语音内容", nil);
    notiVoiceItem.clickedBlock = ^ () {
        @strongify(self);
        [self forwardNotiVoiceVC];
    };
    
    [section addItem:notiVoiceItem];
    
    [self.manager addSection:section];
}

- (void)forwardCallVoiceVC
{
    TDFCallVoiceViewController *vc = [[TDFCallVoiceViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)forwardNotiVoiceVC
{
    TDFNotificationVoiceViewController *vc = [[TDFNotificationVoiceViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showHelpEvent
{
    [HelpDialog show:@"callVoiceSetting"];
}

@end
