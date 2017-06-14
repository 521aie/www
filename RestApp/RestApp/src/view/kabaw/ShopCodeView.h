//
//  ShopCodeView.h
//  RestApp
//
//  Created by 刘红琳 on 15/9/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "UMSocialWechatHandler.h"
#import "TDFRootViewController.h"
#import "NSString+Estimate.h"
#import "FooterListView.h"
#import "QRCodeGenerator.h"
#import "NavigateTitle2.h"
#import "ServiceFactory.h"
#import "RestConstants.h"
#import "KabawService.h"
#import "KabawModule.h"
#import "HelpDialog.h"
#import "AlertBox.h"
#import "Platform.h"

#define WEIXIN_FRIEND 1
#define WEIXIN_MOMENT 2

@class KabawModule, NavigateTitle2, MBProgressHUD, KabawService, FooterListView;
@interface ShopCodeView : TDFRootViewController<INavigateEvent, UIActionSheetDelegate,FooterListEvent>
{
    SystemService *systemService;
    
    KabawService *service;
    
    KabawModule *parent;
    
//    MBProgressHUD *hud;
    
    NSUInteger currentBtnIndex;
}

@property (nonatomic, strong) IBOutlet UIImageView *setQRCodeImageView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *summaryInfoView;
@property (nonatomic, strong) IBOutlet UIView *sendInfoView;
@property (nonatomic, strong) IBOutlet UIView *memoInfoView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet FooterListView *footView;
@property (nonatomic, strong) NavigateTitle2* titleBox;  //标题容器
@property (nonatomic, assign) NSInteger backIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)parentTemp;

//- (void)loadDataView;

- (IBAction)shareToWeChatFriendBtnClick:(UIButton *)sender;

- (IBAction)shareToWeChatMomentBtnClick:(UIButton *)sender;

- (IBAction)downLoadQRCodeBtnClick:(id)sender;

- (IBAction)pasteLinkBtnClick:(UIButton *)sender;

@end
