//
//  SenderEditView.m
//  RestApp
//
//  Created by zxh on 14-5-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SenderEditView.h"
#import "KabawService.h"
#import "MBProgressHUD.h"
#import "KabawModule.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "RemoteEvent.h"
#import "KabawModuleEvent.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "XHAnimalUtil.h"
#import "JsonHelper.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "FormatUtil.h"
#import "GiftListView.h"
#import "AlertBox.h"
#import "SystemUtil.h"
#import "DeliveryMan.h"
#import "OptionPickerBox.h"
#import "NameItemVO.h"
#import "GlobalRender.h"
#import "SenderListView.h"
#import "HelpDialog.h"
#import "TDFOptionPickerController.h"
#import "TDFRootViewController+FooterButton.h"

@implementation SenderEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)_parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service=[ServiceFactory Instance].kabawService;
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
    [self loadData:self.sender action:self.action];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"送货人", nil);
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }
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
    [self.txtName initLabel:NSLocalizedString(@"姓名", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.lsSex initLabel:NSLocalizedString(@"性别", nil) withHit:nil delegate:self];
    [self.txtMobile initLabel:NSLocalizedString(@"手机号码", nil) withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtIdCard initLabel:NSLocalizedString(@"身份证", nil) withHit:nil isrequest:YES type:UIKeyboardTypeNumbersAndPunctuation];

    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

#pragma remote
-(void) loadData:(DeliveryMan*) tempVO action:(int)action
{
    self.action=action;
    self.sender=tempVO;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加送货人", nil);
        self.title = NSLocalizedString(@"添加送货人", nil);
        [self clearDo];
    }else{
        self.titleBox.lblTitle.text=tempVO.name;
        self.title = @"送货人详情";
        [self fillModel];
    }
    [self.titleBox editTitle:NO act:self.action];
}

#pragma 数据层处理
-(void) clearDo{
    [self.txtName initData:nil];
    [self.txtMobile initData:nil];
    [self.lsSex initData:NSLocalizedString(@"男", nil) withVal:[NSString stringWithFormat:@"%d",SEX_MAN]];
    [self.txtIdCard initData:nil];
}

-(void) fillModel
{
    [self.txtName initData:self.sender.name];
    [self.txtIdCard initData:self.sender.idCard];
    [self.txtMobile initData:self.sender.phone];
    NSString* sexStr=[NSString stringWithFormat:@"%d",self.sender.sex];
    [self.lsSex initData:[GlobalRender obtainItem:[GlobalRender listSexs] itemId:sexStr] withVal:sexStr];
}



#pragma notification 处理.
-(void) initNotifaction{
    [UIHelper initNotification:self.container event:Notification_UI_SenderEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_SenderEditView_Change object:nil];
}


#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification{
    
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }else{
        if ([UIHelper currChange:self.container]) {
            [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
            [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
        }else{
            [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
            [self configRightNavigationBar:nil rightButtonName:@""];
        }
    }

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
    self.callBack();
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)remoteFinsh:(RemoteResult*) result{
    [hud hide:YES];
   
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



#pragma test event
#pragma edititemlist click event.
-(void) onItemListClick:(EditItemList*)obj{
    [SystemUtil hideKeyboard];
//    [OptionPickerBox initData:[GlobalRender listSexs] itemId:[obj getStrVal]];
//    [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                              options:[GlobalRender listSexs]
                                                                        currentItemId:[obj getStrVal]];
    __weak __typeof(self) wself = self;
    pvc.competionBlock = ^void(NSInteger index) {
        
        [wself pickOption:[GlobalRender listSexs][index] event:obj.tag];
    };

    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
}


-(BOOL)pickOption:(id)item event:(NSInteger)event
{
    NameItemVO* vo=(NameItemVO*)item;
    [self.lsSex changeData:vo.itemName withVal:vo.itemId];
    return YES;
}


#pragma save-data

-(BOOL)isValid{
    if ([NSString isBlank:[self.txtName getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"姓名不能为空!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsSex getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"性别不能为空!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.txtMobile getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"手机号码不能为空!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.txtIdCard getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"身份证不能为空!", nil)];
        return NO;
    }
//    if([self.txtIdCard getStrVal].length <18){
//        [AlertBox show:NSLocalizedString(@"身份证号不能小于18位", nil)];
//        return NO;
//    }if([self.txtIdCard getStrVal].length >19){
//        [AlertBox show:NSLocalizedString(@"身份证号不能大于18位", nil)];
//        return NO;
//    }if (![self validateIdentityCard:[self.txtIdCard getStrVal]]) {
//        [AlertBox show:NSLocalizedString(@"请输入正确的身份证号", nil)];
//        return NO;
//    }
    return YES;
}

- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

- (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

-(DeliveryMan*) transMode{
    DeliveryMan* tempUpdate=[DeliveryMan new];
    tempUpdate.name=[self.txtName getStrVal];
    tempUpdate.phone=[self.txtMobile getStrVal];
    
    tempUpdate.sex=[self.lsSex getStrVal].intValue;
    if ([NSString isNotBlank:[self.txtIdCard getStrVal]]) {
        tempUpdate.idCard=[self.txtIdCard getStrVal];
    }
    return tempUpdate;
}

-(void)save{
    if (![self isValid]) {
        return;
    }
    DeliveryMan* objTemp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@送货人", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [UIHelper showHUD:tip andView:self.view andHUD:hud];
        objTemp.id=self.sender.id;
       [ service saveSender:objTemp Target:self Callback:@selector(remoteFinsh:)];
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.sender.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [UIHelper showHUD:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.sender.name] andView:self.view andHUD:hud];
         [service removeSender:self.sender.id Target:self Callback:@selector(delFinish:)];
    }
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"outsale"];
}
@end
