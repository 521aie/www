//
//  TailDealEditView.m
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TailDealEditView.h"
#import "SettingService.h"
#import "MBProgressHUD.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "RemoteEvent.h"
#import "SettingModuleEvent.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "JsonHelper.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "AlertBox.h"
#import "SystemUtil.h"
#import "TailDeal.h"
#import "SingleCheckView.h"
#import "NameItemVO.h"
#import "GlobalRender.h"
#import "ZeroListView.h"
#import "XHAnimalUtil.h"
#import "NavigateTitle2.h"
#import "TDFSettingService.h"
#import "HelpDialog.h"
#import "TDFRootViewController+FooterButton.h"

@implementation TailDealEditView

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
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData:nil action:self.action];
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"不吉利尾数处理", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"不吉利尾数处理", nil);
}

- (void)leftNavigationButtonAction:(id)sender {
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void)rightNavigationButtonAction:(id)sender {
    [self save];
}

- (void)initMainView
{
    [self.txtVal initLabel:NSLocalizedString(@"尾数", nil) withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtDealVal initLabel:NSLocalizedString(@"扣减额", nil) withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

#pragma remote
-(void) loadData:(TailDeal*) tempVO action:(int)action
{
    self.action=action;
    self.tailDeal=tempVO;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加不吉利尾数", nil);
        [self clearDo];
    } else {
        self.titleBox.lblTitle.text=NSLocalizedString(@"编辑不吉利尾数", nil);
        [self fillModel];
    }
    [self.titleBox editTitle:NO act:self.action];
}

#pragma 数据层处理
-(void) clearDo{
    [self.txtVal initData:nil];
    [self.txtDealVal initData:nil];
}

-(void) fillModel
{
    [self.txtVal initData:[NSString stringWithFormat:@"%d",self.tailDeal.val]];
    [self.txtDealVal initData:[NSString stringWithFormat:@"%d",self.tailDeal.dealVal]];
}


#pragma notification 处理.
-(void) initNotifaction{
    [UIHelper initNotification:self.container event:Notification_UI_TailDealEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_TailDealEditView_Change object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteFinsh:) name:REMOTE_TAILDEAL_SAVE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteFinsh:) name:REMOTE_TAILDEAL_UPDATE object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delFinish:) name:REMOTE_TAILDEAL_DELONE object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification{
    if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[self class]]) {
        [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
    }
}

-(void) delFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)remoteFinsh:(RemoteResult*) result
{
    [self.progressHud hide:YES];
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [UIHelper clearChange:self.container];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma save-data

-(BOOL)isValid{
    
    if ([NSString isBlank:[self.txtVal getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"尾数不能为空!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.txtDealVal getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"扣减额不能为空!", nil)];
        return NO;
    }
    
    if ([[self.txtDealVal getStrVal] isEqualToString:@"0"]) {
        [AlertBox show:NSLocalizedString(@"扣减额不能为零!", nil)];
        return NO;
    }
    
    return YES;
}

-(TailDeal*) transMode{
    TailDeal* tempUpdate=[TailDeal new];
    tempUpdate.val=[self.txtVal getStrVal].intValue;
    tempUpdate.dealVal=[self.txtDealVal getStrVal].intValue;
    return tempUpdate;
}

-(void)save{
    if (![self isValid]) {
        return;
    }
    TailDeal* objTemp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@不吉利尾数处理", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {
        [[TDFSettingService new] aveTailDeal:objTemp sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hideAnimated:YES];
            [UIHelper clearChange:self.container];
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hideAnimated:YES];
            [AlertBox show:error.localizedDescription];
        }];

    }else{
        objTemp._id=self.tailDeal._id;//实际并未用到
        [service updateTailDeal:objTemp Target:self Callback:@selector(remoteFinsh:)];
    }
}


-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[尾数:%d]吗？", nil),self.tailDeal.val]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){

        [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[尾数:%d]", nil),self.tailDeal.val]];
         [service removeTailDeal:self.tailDeal._id Target:self Callback:@selector(delFinish:)];

    }
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"zeropara"];
}
@end
