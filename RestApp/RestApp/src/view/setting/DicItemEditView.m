//
//  DicItemEditView.m
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "DicItemEditView.h"
#import "SettingService.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "RemoteEvent.h"
#import "SettingModuleEvent.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "JsonHelper.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "SpecialReasonListView.h"
#import "RemoteResult.h"
#import "CustomerListView.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "SystemUtil.h"
#import "DicItem.h"
#import "SingleCheckView.h"
#import "NameItemVO.h"
#import "GlobalRender.h"
#import "NavigateTitle2.h"
#import "TDFSettingService.h"
#import "HelpDialog.h"
#import "TDFRootViewController+FooterButton.h"

@implementation DicItemEditView

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
    self.needHideOldNavigationBar = YES;
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    
    [self.btnDel setHidden:self.action == ACTION_CONSTANTS_ADD];
    if (self.action == ACTION_CONSTANTS_ADD) {
        self.title = [NSString stringWithFormat:NSLocalizedString(@"添加%@", nil),self.titleName];
        [self clearDo];
    }
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

#pragma navigateTitle.
-(void) initNavigate{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

- (void) leftNavigationButtonAction:(id)sender
{
    [SystemUtil hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightNavigationButtonAction:(id)sender
{
    [self save];
}

- (void)initMainView
{
    [self.txtName initLabel:NSLocalizedString(@"客单备注名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

#pragma 数据层处理
-(void) clearDo{
    [self.txtName initData:nil];
}

#pragma notification 处理.
-(void) initNotifaction{
    [UIHelper initNotification:self.container event:Notification_UI_DicItemEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_DicItemEditView_Change object:nil];
   
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification{
    [self configNavigationBar:YES];
}

-(void)remoteFinsh:(RemoteResult*) result{
    [self.progressHud hide:YES];
   
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    self.callBack(YES);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma save-data

-(BOOL)isValid{
    
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"名称不能为空!", nil)];
        return NO;
    }
    
    return YES;
}

-(DicItem*) transMode{
    DicItem* tempUpdate=[DicItem new];
    tempUpdate.name=[self.txtName getStrVal];
    return tempUpdate;
}

-(void)save{
    if (![self isValid]) {
        return;
    }
    DicItem* objTemp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@处理", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {

        //[service saveDicItem:objTemp code:self.dicCode Target:self Callback:@selector(remoteFinsh:)];
        [[TDFSettingService new] saveDicItem:objTemp code:self.dicCode sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hide:YES];
            self.callBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
            
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }else{
     
    }
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.dicItem.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){

      [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.dicItem.name]];
        NSMutableArray *dataArry  = [[NSMutableArray alloc] initWithObjects:self.dicItem._id, nil];

          [[TDFSettingService new] removeDicItems:dataArry code:self.dicCode sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
              self.callBack(YES);
              [self.navigationController popViewControllerAnimated:YES];
          } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
              [AlertBox show:error.localizedDescription];
          }];

        
    }
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    NSString* key=[self.dicCode isEqual:SERVICE_CUSTOMER]?@"dicitem":@"spcialreason";
    [HelpDialog show:key];
}
@end

