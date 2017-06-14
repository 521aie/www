//
//  SignBillDetailEditView.m
//  RestApp
//
//  Created by zxh on 14-7-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignBillDetailEditView.h"
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
#import "TDFSettingService.h"
#import "TDFOptionPickerController.h"
#import "TDFRootViewController+FooterButton.h"

@implementation SignBillDetailEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory Instance].settingService;
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
- (void)initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"挂账人", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
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

- (void)initMainView
{
    [self.lsKind initLabel:NSLocalizedString(@"挂账人类型", nil) withHit:nil delegate:self];
    [self.lblKind initLabel:NSLocalizedString(@"挂账名称", nil) withHit:nil];
    [self.txtName initLabel:NSLocalizedString(@"挂账人名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];

    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

#pragma remote
- (void)loadData:(KindPay*)kindPayTemp option:(KindPayDetailOption *)option action:(NSInteger)action
{
    [self.lblKind initData:self.kindPay.name withVal:self.kindPay._id];
    self.details=[NSMutableArray array];
    for (KindPayDetail* detail in kindPayTemp.kindPayDetails) {
        if (detail.sortCode !=2) {
                if ([detail.name isEqualToString:NSLocalizedString(@"挂账人", nil)] || [detail.name isEqualToString:NSLocalizedString(@"个人", nil)] || [detail.name isEqualToString:NSLocalizedString(@"挂帐人", nil)]) {
            detail.name=NSLocalizedString(@"个人", nil);
            [self.details addObject:detail];
        } else if ([detail.name isEqualToString:NSLocalizedString(@"挂账单位", nil)] || [detail.name isEqualToString:NSLocalizedString(@"单位", nil)] || [detail.name isEqualToString:NSLocalizedString(@"挂帐单位", nil)]) {
            detail.name=NSLocalizedString(@"单位", nil);
            [self.details addObject:detail];
          }
      }
    }
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.title=NSLocalizedString(@"添加挂账人", nil);
        [self clearDo];
    } else {
        self.title=self.kindPay.name;
        [self fillModel];
    }
}

#pragma 数据层处理
- (void)clearDo
{
    [self.txtName initData:nil];
    KindPayDetail* detail ;
    if (self.details.count > 0) {
        detail= [self.details firstObject];
    } else{
        detail = [KindPayDetail new];
    }
    [self.lsKind initData:detail.name withVal:detail._id];
}

- (void)fillModel
{
    KindPayDetail* detail=[self getDetail:self.option.kindPayDetailId];
    [self.lsKind initData:detail.name withVal:detail._id];
    [self.txtName initData:self.option.name];
}

- (KindPayDetail*)getDetail:(NSString*)kindPayDetailId
{
    for (KindPayDetail* detail in self.details) {
        if ([detail._id isEqualToString:kindPayDetailId]) {
            return detail;
        }
    }
    return nil;
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_KindPayDetailOptionEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_KindPayDetailOptionEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*) notification
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configNavigationBar:YES];
    }else
    {
        [self configNavigationBar:[UIHelper currChange:self.container]];
    }
}

- (void)delFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
       if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        if ([NSLocalizedString(@"所选付款类型中，存在未还款账单，不能删除", nil) isEqualToString:result.errorStr]) {
            [AlertBox show:NSLocalizedString(@"此挂账人存在未还款账单，不能删除", nil)];
        } else {
            [AlertBox show:result.errorStr];
        }
        return;
    }
    
    self.callBack(YES);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)remoteFinsh:(RemoteResult*) result
{
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

#pragma test event
#pragma edititemlist click event.
- (void)onItemListClick:(EditItemList*)obj
{
//    [OptionPickerBox initData:self.details itemId:[obj getStrVal]];
//    [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                              options:self.details
                                                                        currentItemId:[obj getStrVal]];
    __weak __typeof(self) wself = self;
    pvc.competionBlock = ^void(NSInteger index) {
        
        [wself pickOption:wself.details[index] event:obj.tag];
    };

    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
}

- (BOOL)pickOption:(id)item event:(NSInteger)event
{
    KindPayDetail* vo=(KindPayDetail*)item;
    [self.lsKind changeData:vo.name withVal:vo._id];
    return YES;
}

#pragma save-data
- (BOOL)isValid
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"挂账人名称不能为空!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsKind getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请选择挂账人类型!", nil)];
        return NO;
    }
    
    return YES;
}

- (KindPayDetailOption*)transMode
{
    KindPayDetailOption* tempUpdate=[KindPayDetailOption new];
    tempUpdate.kindPayId=self.kindPay._id;
    tempUpdate.name=[self.txtName getStrVal];
    tempUpdate.kindPayDetailId=[self.lsKind getStrVal];
    return tempUpdate;
}

- (void)save
{
    if (![self isValid]) {
        return;
    }
    KindPayDetailOption* objTemp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {
        [[TDFSettingService new] saveKindPayDetailOption:objTemp sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hideAnimated:YES];
            self.callBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
            
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             [self.progressHud hideAnimated:YES];
             [AlertBox show:error.localizedDescription];
        }];
    }else{
        objTemp.id= self.option._id;
        [[TDFSettingService new] updateKindPayDetailOption:objTemp sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
               [self.progressHud hideAnimated:YES];
               self.callBack(YES);
               [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             [self.progressHud hideAnimated:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.option.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {

        [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
        NSMutableArray *arry  = [NSMutableArray arrayWithObject:self.option._id];
        [[ TDFSettingService new] removeKindPayDetailOptions:arry  sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hideAnimated:YES];
            self.callBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud  hideAnimated:YES];
            if ([NSLocalizedString(@"所选付款类型中，存在未还款账单，不能删除", nil) isEqualToString:error.localizedDescription]) {
                [AlertBox show:NSLocalizedString(@"此挂账人存在未还款账单，不能删除", nil)];
            } else {
                [AlertBox show:error.localizedDescription];
            }
            return;
        }];


    }
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"signbill"];
}

@end
