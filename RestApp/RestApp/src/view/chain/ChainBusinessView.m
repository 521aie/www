//
//  ChainBusinessView.m
//  RestApp
//
//  Created by iOS香肠 on 16/1/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "AlertBox.h"
#import "SystemUtil.h"
#import "HelpDialog.h"
#import "UIMenuAction.h"
#import "ActionConstants.h"
#import "ChainBusinessView.h"
#import "NSString+Estimate.h"
#import "TDFChainService.h"
#import "EditItemText.h"
#import "UIHelper.h"
#import "TDFRootViewController+FooterButton.h"


@implementation ChainBusinessView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        chainService = [ServiceFactory Instance].chainService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.changed=NO;
    self.title = @"总部";
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self initNotifaction];
    [self initMainView];
    [self clearDo];
    [self loadData];
}

- (void)initMainView
{
    [self.txtShopName initLabel:NSLocalizedString(@"连锁总部名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtLinker initLabel:NSLocalizedString(@"联系人", nil) withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtMobile initLabel:NSLocalizedString(@"联系电话", nil) withHit:nil isrequest:NO type:UIKeyboardTypePhonePad];
    [self.txtAddreess initLabel:NSLocalizedString(@"地址", nil) withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.container setBackgroundColor:[UIColor clearColor]];
    
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [UIHelper clearColor:self.container];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_ChainBusinessView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_ChainBusinessView_Change object:nil];
    
}

-(void)clearDo
{
    [self.txtShopName initData:nil];
    [self.txtLinker initData:nil];
    [self.txtMobile initData:nil];
    [self.txtAddreess initData:nil];
}

- (void)loadData
{
     [UIHelper showHUD:NSLocalizedString(@"请稍候", nil) andView:self.view andHUD:hud];
    [[TDFChainService  new] showInfoByEntityIdSucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [hud hide:YES];
        self.brandVo = [[BrandVo alloc]initWithDictionary:data[@"data"]];
        if (self.brandVo==nil) {
            [self clearDo];
        } else {
            [self fillModel];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [hud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self configNavigationBar:[UIHelper currChange:self.container]];
}

- (void)rightNavigationButtonAction:(id)sender {
    [self save];
}

-(void)showInfoByEntityIdFinish:(RemoteResult *)result
{
    [hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary* map=[JsonHelper transMap:result.content];
    self.brandVo = [[BrandVo alloc]initWithDictionary:map[@"brandVo"]];
    
    if (self.brandVo==nil) {
        [self clearDo];
    } else {
        [self fillModel];
    }

}

-(void)fillModel
{
    [self.txtShopName initData:self.brandVo.name];
    [self.txtLinker initData:self.brandVo.linkman];
    [self.txtMobile initData:self.brandVo.tel];
    [self.txtAddreess initData:self.brandVo.address];
}

#pragma ui-data-save
-(BOOL)isValid
{
    if ([NSString isBlank:[self.txtShopName getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"名称不能为空", nil)];
        return NO;
    }
    
    if (self.txtShopName.txtVal.text.length>20) {
        [AlertBox show:NSLocalizedString(@"连锁名称最多输入20个字符", nil)];
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
    
    if (self.txtAddreess.txtVal.text.length>25) {
        [AlertBox show:NSLocalizedString(@"地址最多可输入25个字符", nil)];
        return NO;
    }
    return YES;
}

-(BrandVo *) transMode
{
    BrandVo* brandVo=[BrandVo new];
    brandVo.id = self.brandVo.id;
    brandVo.code = self.brandVo.code;
    if ([NSString isNotBlank:[self.txtAddreess getStrVal]]) {
        brandVo.address=[self.txtAddreess getStrVal];
    }
    if ([NSString isNotBlank:[self.txtLinker getStrVal]]) {
        brandVo.linkman=[self.txtLinker getStrVal];
    }
    if ([NSString isNotBlank:[self.txtShopName getStrVal]]) {
        brandVo.name=[self.txtShopName getStrVal];
    }

    if ([NSString isNotBlank:[self.txtMobile getStrVal]]) {
        brandVo.tel=[self.txtMobile getStrVal];
    }

    brandVo.entityId = [[Platform Instance] getkey:ENTITY_ID];
    return brandVo;
}

- (void)save
{
    if (![self isValid]) {
    return;
    }
    BrandVo* bradVo=[self transMode];

    [self  showProgressHudWithText:NSLocalizedString(@"正在保存，请稍候", nil)];
   
    [[TDFChainService new] saveInfo:bradVo sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hide:YES];
        [UIHelper clearChange:self.container];
        [self configNavigationBar:NO];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

- (void)footerHelpButtonAction:(UIButton *)sender {

    [HelpDialog show:@"chainhdinfo"];
}

@end
