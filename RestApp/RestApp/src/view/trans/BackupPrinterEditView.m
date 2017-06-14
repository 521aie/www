//
//  BackupPrinterEditView.m
//  RestApp
//
//  Created by SHAOJIANQING-MAC on 14-11-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BackupPrinterEditView.h"
#import "TransService.h"
#import "MBProgressHUD.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "RemoteEvent.h"
#import "EditItemList.h"
#import "ItemTitle.h"
#import "JsonHelper.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "FormatUtil.h"
#import "AlertBox.h"
#import "SystemUtil.h"
#import "XHAnimalUtil.h"
#import "ColorHelper.h"
#import "GlobalRender.h"
#import "TransModuleEvent.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "TDFTransService.h"
#import "TDFRootViewController+FooterButton.h"

@implementation BackupPrinterEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service=[ServiceFactory Instance].transService;
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
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"备用打印机", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    
    self.title = NSLocalizedString(@"备用打印机", nil);
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_BackupEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_BackupEditView_Change object:nil];
  
}

- (void)initMainView
{
    [self.lsOriginIp initLabel:NSLocalizedString(@"原打印机IP", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsBackupIp initLabel:NSLocalizedString(@"备用打印机IP", nil) withHit:nil isrequest:YES delegate:self];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.lsOriginIp.tag=PANTRY_ORIGIN_IP;
    self.lsBackupIp.tag=PANTRY_BACKUP_IP;
    
    [SystemUtil hideKeyboard];
    
    [self.lsOriginIp setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeIPAddress hasSymbol:NO];
    [self.lsBackupIp setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeIPAddress hasSymbol:NO];
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self save];
}


#pragma remote
- (void)loadData:(BackupPrinter*) tempVO action:(NSInteger)action
{
    self.action=action;
    self.backupPrinter=tempVO;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        [self clearDo];
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"确定", nil)];
    } else {
        [self fillModel];
    }
}

#pragma 数据层处理
- (void)clearDo
{
    [self.lsOriginIp initData:nil withVal:nil];
    [self.lsBackupIp initData:nil withVal:nil];
}

- (void)fillModel
{
    [self.lsOriginIp initData:self.backupPrinter.originIp withVal:self.backupPrinter.originIp];
    [self.lsBackupIp initData:self.backupPrinter.backupIp withVal:self.backupPrinter.backupIp];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

//-(void) delFinish:(RemoteResult*) result
//{
//    [self.progressHud hide:YES];
//    if (result.isRedo) {
//        return;
//    }
//    if (!result.isSuccess) {
//        [AlertBox show:result.errorStr];
//        return;
//    }
//    if (self.callBack) {
//        self.callBack();
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//}


#pragma test event
#pragma edititemlist click event.
-(void) onItemListClick:(EditItemList*)obj
{
}

#pragma save-data

-(BOOL)isValid
{
    if ([NSString isBlank:[self.lsOriginIp getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"原始打印机IP不能为空！", nil)];
        return NO;
    }
    if ([NSString isBlank:self.lsBackupIp.lblVal.text]) {
        [AlertBox show:NSLocalizedString(@"备用打印机IP不能为空!", nil)];
        return NO;
    }
    if (![NSString isValidatIP:self.lsOriginIp.lblVal.text]) {
        [AlertBox show:NSLocalizedString(@"原始打印机IP地址无效!", nil)];
        return NO;
    }
    if (![NSString isValidatIP:[self.lsBackupIp getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"备用打印机IP地址无效!", nil)];
        return NO;
    }
    NSString* oldIp=[self.lsOriginIp getStrVal];
    NSString* placeIp=[self.lsBackupIp getStrVal];
    if ([oldIp isEqualToString:placeIp]) {
        [AlertBox show:NSLocalizedString(@"原打印机IP与备用打印机IP不能相同!", nil)];
        return NO;
    }
    return YES;
}

-(BackupPrinter *) transMode
{
    BackupPrinter* tempUpdate=[BackupPrinter new];
    tempUpdate.originIp=[self.lsOriginIp getStrVal];
    tempUpdate.backupIp=[self.lsBackupIp getStrVal];
    return tempUpdate;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    BackupPrinter* objTemp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {
        //[service saveBackupPrinter:objTemp Target:self Callback:@selector(remoteFinsh:)];
        [[TDFTransService new] saveBackupPrinter:objTemp success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hide:YES];
            if (self.callBack) {
                self.callBack();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }else{
        objTemp.backupPrinterId=self.backupPrinter.backupPrinterId;
        objTemp._id   = self.backupPrinter.backupPrinterId;
      //    [service updateBackupPrinter:objTemp Target:self Callback:@selector(remoteFinsh:)];
         [[TDFTransService new] updateBackupPrinter:objTemp success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
             [self.progressHud hide: YES];
             if (self.callBack) {
                 self.callBack();
             }
             [self.navigationController popViewControllerAnimated:YES];
         } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             [self.progressHud hide:YES];
             [AlertBox show:error.localizedDescription];
         }];

    }
}
-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:NSLocalizedString(@"确认要删除吗？", nil)];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
       // [service removeBackupPrinter:self.backupPrinter._id Target:self Callback:@selector(delFinish:)];
        [[TDFTransService new] removeBackupPrinter:self.backupPrinter.backupPrinterId lastVer:self.backupPrinter.lastVer success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hide: YES];
            if (self.callBack) {
                self.callBack();
            }
            [self.navigationController popViewControllerAnimated:YES];

        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide: YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"transaltprinter"];
}

// 数字键盘方法
- (void) clientInput:(NSString*)val event:(NSInteger)eventType
{
    if(eventType==PANTRY_ORIGIN_IP){
        [self.lsOriginIp changeData:val withVal:val];
    }else if(eventType==PANTRY_BACKUP_IP){
        [self.lsBackupIp changeData:val withVal:val];
    }
}

@end
