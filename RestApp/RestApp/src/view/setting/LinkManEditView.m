//
//  LinkManEditView.m
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "LinkManEditView.h"
#import "SettingService.h"
#import "MBProgressHUD.h"
#import "SettingModule.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "RemoteEvent.h"
#import "SettingModuleEvent.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "JsonHelper.h"
#import "NameItemVO.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "LinkManListView.h"
#import "GlobalRender.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "SystemUtil.h"
#import "LinkMan.h"
#import "SingleCheckView.h"
#import "StrItemVO.h"
#import "GlobalRender.h"
#import "SmsRender.h"
#import "TDFOptionPickerController.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "HelpDialog.h"


@implementation LinkManEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SettingModule *)_parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent=_parent;
        service=[ServiceFactory Instance].settingService;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
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
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"营业短信接收人", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [parent showView:LINKMAN_LIST_VIEW];
        [XHAnimalUtil animalEdit:parent action:self.action];
    }else{
        [self save];
    }
}

-(void) initMainView{
    [self.txtName initLabel:NSLocalizedString(@"姓名", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtMobile initLabel:NSLocalizedString(@"手机号", nil) withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.lsReceiveTime initLabel:NSLocalizedString(@"短信接收时间", nil) withHit:nil delegate:self];
    
    [self.lsDateKind initLabel:NSLocalizedString(@"短信内容时间", nil) withHit:nil delegate:self];
    [self.lsSmsKind initLabel:NSLocalizedString(@"短信内容类型", nil) withHit:nil delegate:self];
    [self.footView initDelegate:self btnArrs:nil];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.lsDateKind.tag=1;
    self.lsSmsKind.tag=2;
    self.lsReceiveTime.tag=3;
}

#pragma remote
-(void) loadData:(LinkMan *)tempVO action:(NSInteger)action
{
    self.action=action;
    self.linkMan=tempVO;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加接收人", nil);
        [self clearDo];
    } else {
        self.titleBox.lblTitle.text=tempVO.name;
        [self fillModel];
    }
    [self.titleBox editTitle:NO act:self.action];
}

#pragma 数据层处理
-(void) clearDo
{
    [self.txtName initData:nil];
    [self.txtMobile initData:nil];
    [self.lsReceiveTime initData:@"9:00" withVal:@"9"];
    [self.lsDateKind initData:NSLocalizedString(@"当日营业汇总", nil) withVal:[NSString stringWithFormat:@"%d",DATEKIND_TODAY]];
    [self.lsSmsKind initData:NSLocalizedString(@"简要营业汇总", nil) withVal:[NSString stringWithFormat:@"%d",SMSKIND_SAMPLE]];
}

-(void) fillModel
{
    [self.txtName initData:self.linkMan.name];
    [self.txtMobile initData:self.linkMan.mobile];
    NSString* recTime=[NSString stringWithFormat:@"%d",self.linkMan.receiveTime];
    [self.lsReceiveTime initData:[NSString stringWithFormat:@"%d:00",self.linkMan.receiveTime] withVal:recTime];
    
    
    NSString* itemName=[GlobalRender obtainItem:[SmsRender listDateKind] itemId:[NSString stringWithFormat:@"%d",self.linkMan.dateKind]];
    [self.lsDateKind initData:itemName withVal:[NSString stringWithFormat:@"%d",self.linkMan.dateKind]];
    
    itemName=[GlobalRender obtainItem:[SmsRender listSmsKind] itemId:[NSString stringWithFormat:@"%d",self.linkMan.smsKind]];
    [self.lsSmsKind initData:itemName withVal:[NSString stringWithFormat:@"%d",self.linkMan.smsKind]];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_LinkManEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_LinkManEditView_Change object:nil];
  
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

-(void) delFinish:(RemoteResult*) result
{
    [hud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    [parent showView:LINKMAN_LIST_VIEW];
    [parent.linkManListView loadDatas];
    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
}

-(void)remoteFinsh:(RemoteResult*) result
{
    [hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [parent showView:LINKMAN_LIST_VIEW];
    [parent.linkManListView loadDatas];
    [XHAnimalUtil animalEdit:parent action:self.action];
}

#pragma test event
#pragma edititemlist click event.
-(void) onItemListClick:(EditItemList*)obj
{
    [SystemUtil hideKeyboard];
    if (obj.tag==1) {
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[SmsRender listDateKind]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[SmsRender listDateKind][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    } else if(obj.tag==2){
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[SmsRender listSmsKind]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[SmsRender listSmsKind][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    } else if (obj.tag==3){
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[self getRecTimes]
                                                                                currentItemId:[self.lsReceiveTime getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[self getRecTimes][index] event:0];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }
}

-(NSMutableArray*) getRecTimes
{
    NSMutableArray* vos=[NSMutableArray array];
    StrItemVO *item=nil;
    for (int i=0; i<24; i++) {
        item=[[StrItemVO alloc] initWithVal:[NSString stringWithFormat:@"%d:00",i] andId:[NSString stringWithFormat:@"%d",i]];
        [vos addObject:item];
    }
    return vos;
}

- (BOOL)pickOption:(id)item event:(NSInteger)event
{
     id<INameItem> vo=(id<INameItem>)item;
    if (event==1) {
        [self.lsDateKind changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    } else if (event==2){
        [self.lsSmsKind changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    } else {
        [self.lsReceiveTime changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    }
    return YES;
}

#pragma save-data
-(BOOL)isValid
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"营业短信接收人姓名不能为空!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.txtMobile getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"手机号不能为空!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsReceiveTime getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"短信接收时间(单位:时)不能为空!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsDateKind getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请选择短信时间!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsSmsKind getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请选择短信内容类型!", nil)];
        return NO;
    }
 
    return YES;
}

-(LinkMan*) transMode
{
    LinkMan* tempUpdate=[LinkMan new];
    tempUpdate.name=[self.txtName getStrVal];
    tempUpdate.mobile=[self.txtMobile getStrVal];
    tempUpdate.receiveTime=[self.lsReceiveTime getStrVal].intValue;
    if ([NSString isNotBlank:[self.lsDateKind getStrVal]]) {
        tempUpdate.dateKind=[self.lsDateKind getStrVal].intValue;
    }
    if ([NSString isNotBlank:[self.lsSmsKind getStrVal]]) {
        tempUpdate.smsKind=[self.lsSmsKind getStrVal].intValue;
    }
    return tempUpdate;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    LinkMan* objTemp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [UIHelper showHUD:tip andView:self.view andHUD:hud];
    if (self.action==ACTION_CONSTANTS_ADD) {
    
        [service saveLinkMan:objTemp Target:self Callback:@selector(remoteFinsh:)];
    } else {
        objTemp._id=self.linkMan._id;
   
        [service updateLinkMan:objTemp Target:self Callback:@selector(remoteFinsh:)];
        
    }
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.linkMan.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [UIHelper showHUD:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.linkMan.name] andView:self.view andHUD:hud];
        
         [service removeLinkMan:self.linkMan._id Target:self Callback:@selector(delFinish:)];
    }
}

-(void) showHelpEvent
{
    [HelpDialog show:@"linkman"];
}

@end
