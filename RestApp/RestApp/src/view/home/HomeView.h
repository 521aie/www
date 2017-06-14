//
//  HomeView.h
//  RestApp
//
//  Created by zxh on 14-3-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "HomeModule.h"
#import "NetworkBox.h"
#import "DateModel.h"
#import <UIKit/UIKit.h>
#import "UserService.h"
#import "MBProgressHUD.h"
#import "WeixinPayPanel.h"
#import "MenuGridPanel.H"
#import "ShopInfoPanel.h"
#import "IEventListener.h"
#import "INavigateEvent.h"
#import "SystemNotePanel.h"
#import "EnvelopeService.h"
#import "NavigateTitle2.h"
#import "BusinessService.h"
#import "MenuSelectHandle.h"
#import "BusinessDetailPanel.h"
#import "RefreshDataController.h"
#import "AccountCenter.h"
#import "SettingService.h"
#import "ChainService.h"
#import "TDFPaymentService.h"

#define SHOP_BOX_HEIGHT 35
#define GOODS_BOX_HEIGHT 58

@interface HomeView : RefreshDataController<IEventListener, NetWorkBoxClient,AlertBoxClient>
{
    HomeModule *homeModule;
    
    BusinessService *service;
    
    EnvelopeService *envelopeService;
    
    UserService *userService;
    
    MBProgressHUD *hud;
    
    SettingService *setservice;
    
    ChainService *chainservice;
}

@property (nonatomic, strong) IBOutlet UILabel *lblShop;        //餐店名称.
@property (nonatomic, strong) IBOutlet UILabel *lblUser;        //用户.
@property (nonatomic, strong) IBOutlet UILabel *lblDay;        //日期.
@property (nonatomic, strong) IBOutlet UIView *mainViewContainer;
@property (nonatomic, strong) IBOutlet UIView *sysNoteContainer;
//@property (nonatomic, strong) IBOutlet UIView *weixinPayContainer;
@property (nonatomic, strong) IBOutlet UIView *businessContainer;
@property (nonatomic, strong) IBOutlet UIView *menuGridContainer;
@property (nonatomic, strong) IBOutlet UIView *shopInfoContainer;
//@property (weak, nonatomic) IBOutlet UIView *memberNoteContainer;
@property (nonatomic, strong) IBOutlet UIImageView *icoSelectShop;
@property (nonatomic, strong) IBOutlet UIImageView *icoSysNotification;
@property (nonatomic, strong) IBOutlet UIButton *btnSelectShop;
@property (weak, nonatomic) IBOutlet UIView *hideline;
@property (weak, nonatomic) IBOutlet UIButton *setUpBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property (weak, nonatomic) IBOutlet UILabel *rightLbl;
@property (weak, nonatomic) IBOutlet UIButton *tapMeBtn;
@property (weak, nonatomic) IBOutlet UIView *naviView;


@property (nonatomic, strong) SystemNotePanel *systemNotePanel;
//@property (nonatomic, strong) WeixinPayPanel *weixinPayPanel;
@property (nonatomic, strong) BusinessDetailPanel *bussinessPanel;   //日营业数据详细面板.
@property (nonatomic, strong) ShopInfoPanel *shopInfoPanel;
@property (nonatomic, strong) MenuGridPanel *menuGridPanel;
@property (nonatomic ,assign) BOOL ISlogin;
@property (nonatomic, strong) IBOutlet UIView *warningViewBox;
@property (weak, nonatomic) IBOutlet UIImageView *warningImg;
@property (nonatomic, strong) IBOutlet UIButton *tiShiBtn;
@property (nonatomic, strong) NSMutableArray *allIteamData;
@property (nonatomic, strong) NSMutableArray *IdsArr;
@property (strong, nonatomic) ShopStatusVo *shopInfo;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(HomeModule *)parent;

- (void)showBusinessDetailEvent;
- (void)loadBusiness;

- (void)reload:(ShopStatusVo *)shopInfoVO;

//系统消息.
- (void)forwardSysNotification;

//微信支付页
- (void)forwardWeixinPay;

//产品页.
- (void)forwardMenuDegree;

//店家页.
- (void)forwardShopDegree;

//微店营销页.
- (void)forwardShopCode;

//会员
- (void)forwardMemberModule;


//点击店家名开始选店
- (IBAction)btnShopName:(id)sender;

//导航按钮.
- (IBAction)btnNavigateClick:(id)sender;

//更多页.
- (IBAction)btnMoreClick:(id)sender;


- (IBAction)tiShiBtnClick:(id)sender;


@end
