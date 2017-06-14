//
//  TDFShopScreenAdViewController.m
//  RestApp
//
//  Created by happyo on 16/10/21.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFShopScreenAdViewController.h"
#import "TDFRootViewController+TableViewManager.h"
#import "DHTTableViewManager.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFDisplayCommonItem.h"
#import "HelpDialog.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFImageAdViewController.h"
#import "TDFTextEditViewController.h"
#import "UIViewController+HUD.h"
#import "TDFQueueService.h"

@interface TDFShopScreenAdViewController ()

@end

@implementation TDFShopScreenAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"店内屏幕广告", nil);
    [self configDefaultManager];
    [self registerCells];
   
    @weakify(self);
    self.tbvBase.tableHeaderView = [[TDFIntroductionHeaderView alloc] initWithImageIcon:[UIImage imageNamed:@"ShopScreenAd_Header_Icon"] description:NSLocalizedString(@"店内屏幕广告，店家在此处设置图片广告，上传的图片将以轮播的形式通过二维火取餐叫号、二维火收银机副屏等应用在店内屏幕上进行展示。", nil) detailBlock:^{
        //
        @strongify(self);
        [self showHelpEvent];
    }];
    
    [self addAdSection];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

- (void)registerCells {
    [self.manager registerCell:@"TDFDisplayCommonCell" withItem:@"TDFDisplayCommonItem"];
}

- (void)addAdSection
{
    DHTTableViewSection *section = [DHTTableViewSection section];
    
    TDFDisplayCommonItem *imageAdItem = [[TDFDisplayCommonItem alloc] init];
    imageAdItem.iconImage = [UIImage imageNamed:@"ImageAd_Icon"];
    imageAdItem.title = NSLocalizedString(@"图片广告", nil);
    imageAdItem.detail = NSLocalizedString(@"上传/删除图片广告", nil);
    @weakify(self);
    imageAdItem.clickedBlock = ^ () {
        @strongify(self);
        [self forwardImageAdVC];
    };
    
    TDFDisplayCommonItem *textAdItem = [[TDFDisplayCommonItem alloc] init];
    textAdItem.iconImage = [UIImage imageNamed:@"ad_text_icon"];
    textAdItem.title = NSLocalizedString(@"文字广告", nil);
    textAdItem.detail = NSLocalizedString(@"设置二维火取餐叫号应用中叫号功能底部滚动文字", nil);
    textAdItem.clickedBlock = ^ () {
        @strongify(self);
        [self forwardTextVC];
    };
    
    [section addItem:imageAdItem];
    [section addItem:textAdItem];
    
    [self.manager addSection:section];
}


- (void)forwardTextVC {

    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[[TDFQueueService alloc] init] adTextWithSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        
        [self dismissHUD];
        [self showTextAdVCWithText:[data objectForKey:@"data"] ];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
       
        @strongify(self);
        [self dismissHUD];
        [self showErrorMessage:error.localizedDescription];
    }];
}


- (void)showTextAdVCWithText:(NSString *)text {

    TDFTextEditViewController *tvc = [[TDFTextEditViewController alloc] initWithTitle:NSLocalizedString(@"火叫号文字设置", nil)
                                                                                 text:text
                                                                                limit:100
                                                                          placeholder:NSLocalizedString(@"最多可输入100个中文字符", nil)
                                                                               prompt:NSLocalizedString(@"屏幕底部滚动文字", nil)];
    tvc.forbiddenNewLine = YES;
    @weakify(self);
    tvc.finishBlock = ^void (NSString *text) {
        @strongify(self);
        [self saveAdText:text];
    };
    [self.navigationController pushViewController:tvc animated:YES];
}


- (void)saveAdText:(NSString *)text {
    
    [self showHUBWithText:NSLocalizedString(@"正在保存", nil)];
    @weakify(self);
    [[[TDFQueueService alloc] init] updateAdTextWithText:(text ?: @"") success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self dismissHUD];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self dismissHUD];
        [self showErrorMessage:error.localizedDescription];
    }];
}


- (void)forwardImageAdVC
{
    TDFImageAdViewController *vc = [[TDFImageAdViewController alloc] init];

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [self showHelpEvent];
}

- (void)showHelpEvent
{
    [HelpDialog show:@"shopScreenAd"];
}


@end
