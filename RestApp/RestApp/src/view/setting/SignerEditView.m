//
//  SignerEditView.m
//  RestApp
//
//  Created by zxh on 14-7-13.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignerEditView.h"
#import "SettingService.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "RemoteEvent.h"
#import "SettingModuleEvent.h"
#import "EditItemList.h"
#import "EditItemRadio.h"
#import "EditItemView.h"
#import "EditItemText.h"
#import "JsonHelper.h"
#import "GlobalRender.h"
#import "KindPayRender.h"
#import "UIView+Sizes.h"
#import "KindPay.h"
#import "KindPayDetail.h"
#import "KindPayVO.h"
#import "XHAnimalUtil.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "SignBillListView.h"
#import "AlertBox.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "TDFOptionPickerController.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFSettingService.h"

@implementation SignerEditView

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
    [self loadData:self.kindPay option:self.option action:self.action];
}

#pragma navigateTitle.
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"本店签字人", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

- (void) leftNavigationButtonAction:(id)sender
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        if ([UIHelper currChange:self.container]) {
            [self alertChangedMessage:[UIHelper currChange:self.container]];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self alertChangedMessage:[UIHelper currChange:self.container]];
    }
}

- (void) rightNavigationButtonAction:(id)sender
{
    [self save];
}

-(void) initMainView
{
    [self.lblKind initLabel:NSLocalizedString(@"挂账名称", nil) withHit:nil];
    [self.txtName initLabel:NSLocalizedString(@"签字人名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];

    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

#pragma remote
-(void) loadData:(KindPay*)kindPayTemp option:(KindPayDetailOption*)option  action:(int)action
{
    [self.lblKind initData:self.kindPay.name withVal:self.kindPay._id];
    if (action==ACTION_CONSTANTS_ADD) {
        self.title=NSLocalizedString(@"添加本店签字人", nil);
        [self clearDo];
    } else {
        self.title=self.kindPay.name;
        [self fillModel];
    }
}

#pragma 数据层处理
-(void) clearDo
{
    [self.txtName initData:nil];
}

-(void) fillModel
{
    [self.txtName initData:self.option.name];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_SignerEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_SignerEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configNavigationBar:YES];
    }else{
        [self configNavigationBar:[UIHelper currChange:self.container]];
    }
}

#pragma save-data
-(BOOL)isValid
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"挂账人名称不能为空!", nil)];
        return NO;
    }
    return YES;
}

-(KindPayDetailOption*) transMode
{
    KindPayDetailOption* tempUpdate=[KindPayDetailOption new];
    tempUpdate.name=[self.txtName getStrVal];
    tempUpdate._id=@"";
    return tempUpdate;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    KindPayDetailOption* objTemp=[self transMode];
    if (self.action==ACTION_CONSTANTS_ADD) {

        [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
        [[TDFSettingService new] saveSignBillRelation:self.kindPay._id signers:objTemp.name sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hide:YES];
            self.callBack();
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(void)remoteRelationFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    self.callBack();
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"signbill"];
}

@end
