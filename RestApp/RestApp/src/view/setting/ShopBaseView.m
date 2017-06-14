//
//  ShopBaseView.m
//  RestApp
//
//  Created by zxh on 14-4-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopBaseView.h"
#import "NavigateTitle.h"
#import "EditItemText.h"
#import "UIView+Sizes.h"
#import "MBProgressHUD.h"
#import "SettingService.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "RemoteEvent.h"
#import "ShopDetail.h"
#import "NSString+Estimate.h"
#import "SettingModuleEvent.h"
#import "NavigateTitle2.h"
#import "ItemEndNote.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "RemoteResult.h"
#import "ServiceFactory.h"
#import "TDFSettingService.h"
#import "AlertBox.h"
#import "TDFShopInfoService.h"
#import "YYModel.h"
#import "TDFRootViewController+FooterButton.h"

@implementation ShopBaseView

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
    self.changed=NO;
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self loadData];
}

#pragma navigateTitle.

- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"店家信息", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"店家信息", nil);
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self save];
}

- (void)initMainView
{
    [self.txtShopName initLabel:NSLocalizedString(@"店家名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtEmail initLabel:NSLocalizedString(@"常用邮箱", nil) withHit:nil isrequest:NO type:UIKeyboardTypeEmailAddress];
    [self.txtLinker initLabel:NSLocalizedString(@"联系人", nil) withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtMobile initLabel:NSLocalizedString(@"手机号码", nil) withHit:nil isrequest:NO type:UIKeyboardTypePhonePad];
    self.lblNote.text = NSLocalizedString(@"提示:以上信息请如实填写，方便我们为您提供售后联系", nil);
    [self.container setBackgroundColor:[UIColor clearColor]];

    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    //[UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

#pragma remote
-(void) loadData
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//    [service obtainBaseShopDetailTarget:self Callback:@selector(loadFinsh:)];

    [TDFShopInfoService fetchShopInfoWithCompleteBlock:^(TDFResponseModel * response) {
        [self.progressHud hide:YES];
        if ([response isSuccess]) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = response.responseObject;
                self.shopDetail = [ShopDetail yy_modelWithJSON:dict[@"data"]];
                [self refreshUI];
            }
        } else {
            [self.progressHud hide:YES];
            [AlertBox show:response.error.localizedDescription];
        }

    }];
}

#pragma ui-data-bind
-(void)refreshUI
{
    if (self.shopDetail) {
        [self fillModel];
    } else {
        [self clearDo];
    }
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
}

-(void)clearDo
{
    [self.txtShopName initData:nil];
    [self.txtEmail initData:nil];
    [self.txtLinker initData:nil];
    [self.txtMobile initData:nil];
}

-(void)fillModel
{
    [self.txtShopName initData:self.shopDetail.name];
    [self.txtEmail initData:self.shopDetail.zipCode];
    [self.txtLinker initData:self.shopDetail.linkman];
    [self.txtMobile initData:self.shopDetail.phone2];
}

#pragma ui-data-save
-(BOOL)isValid
{
    if (self.txtShopName.txtVal.text.length>20) {
        [AlertBox show:NSLocalizedString(@"名称最多输入20个字符", nil)];
        return NO;
    }
    if (self.txtLinker.txtVal.text.length>10) {
        [AlertBox show:NSLocalizedString(@"联系人最多可输入10个字符", nil)];
        return NO;
    }
    if (self.txtMobile.txtVal.text.length>30) {
        [AlertBox show:NSLocalizedString(@"联系电话最多可输入30个字符", nil)];
        return NO;
    }

    if ([NSString isBlank:[self.txtShopName getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请输入店家信息", nil)];
        return NO;
    }
    if ([NSString isNotBlank:self.txtEmail.txtVal.text]) {
        if ([NSString isValidateEmail:self.txtEmail.txtVal.text]==NO) {
            [AlertBox show:NSLocalizedString(@"您输入的邮箱格式不正确", nil)];
            return NO;
        }
    }
    
    return YES;
}

-(ShopDetail *) transMode
{
    ShopDetail* shopDetailUpdate=[ShopDetail new];
    shopDetailUpdate.name=[self.txtShopName getStrVal];
    if ([NSString isNotBlank:[self.txtEmail getStrVal]]) {
        shopDetailUpdate.zipCode=[self.txtEmail getStrVal];
    }
    
    if ([NSString isNotBlank:[self.txtLinker getStrVal]]) {
        shopDetailUpdate.linkman=[self.txtLinker getStrVal];
    }
    
    if ([NSString isNotBlank:[self.txtMobile getStrVal]]) {
        shopDetailUpdate.phone2=[self.txtMobile getStrVal];
    }
    return shopDetailUpdate;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    ShopDetail* shopDetailUpdate=[self transMode];
    if (self.shopDetail) {
        shopDetailUpdate._id=self.shopDetail._id;
    }
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    //修改
    [TDFShopInfoService saveShopInfoWithShopString:[shopDetailUpdate yy_modelToJSONString] completeBlock:^(TDFResponseModel * response) {
        [self.progressHud hide:YES];
        if ([response isSuccess]) {
            [UIHelper clearChange:self.container];
            [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [AlertBox show:response.error.localizedDescription];
        }
    }];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_ShopBaseView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_ShopBaseView_Change object:nil];

}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}

-(void)loadFinsh:(RemoteResult*) result
{
    [self.progressHud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary* map=[JsonHelper transMap:result.content];
    NSDictionary *userDic = [map objectForKey:@"shopDetail"];
    self.shopDetail=[JsonHelper dicTransObj:userDic obj:[ShopDetail alloc]];
    [self refreshUI];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"baseshop"];
}

@end
