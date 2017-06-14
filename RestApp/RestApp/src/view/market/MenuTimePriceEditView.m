//
//  MenuTimePriceEditView.m
//  RestApp
//
//  Created by zxh on 14-5-27.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuTimePriceEditView.h"
#import "NavigateTitle2.h"
#import "MenuTimeListView.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "NavigateTitle.h"
#import "RemoteEvent.h"
#import "MenuTimeModuleEvent.h"
#import "EditItemList.h"
#import "EditItemView.h"
#import "EditItemRadio.h"
#import "JsonHelper.h"
#import "GlobalRender.h"
#import "NSString+Estimate.h"
#import "RemoteResult.h"
#import "FormatUtil.h"
#import "AlertBox.h"
#import "SystemUtil.h"
#import "MenuTimePrice.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "YYModel.h"
#import "TDFMemberService.h"
#import "TDFRootViewController+FooterButton.h"
@implementation MenuTimePriceEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.needHideOldNavigationBar = YES;
    
    self.changed=NO;
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [self loadData:self.menuTimePrice action:self.action];
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"商品促销", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_MenuTimePriceEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_MenuTimePriceEditView_Change object:nil];

}

- (void) leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void) rightNavigationButtonAction:(id)sender
{
    [self save];
}

- (void)initMainView
{
    [self.lblName initLabel:NSLocalizedString(@"商品名称", nil) withHit:nil];
    [self.lblName.lblVal setTextColor:[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1]];
    [self.lblPrice initLabel:NSLocalizedString(@"商品原价(元)", nil) withHit:nil];
    [self.lblPrice.lblVal setTextColor:[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1]];
    [self.lsPrice initLabel:NSLocalizedString(@"促销价格(元)", nil) withHit:nil delegate:self];
    
    [self.footView initDelegate:self btnArrs:nil];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    [self.lsPrice setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
}

#pragma remote
- (void)loadData:(MenuTimePrice *) tempVO action:(NSInteger)action
{
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    [self fillModel];
    self.title=tempVO.menuName;
}

#pragma 数据层处理
- (void)fillModel
{
    [self.lblName initData:self.menuTimePrice.menuName withVal:self.menuTimePrice.menuId];
    NSString* menuPriceStr=[FormatUtil formatDouble4:self.menuTimePrice.menuPrice];
    [self.lblPrice initData:menuPriceStr withVal:menuPriceStr];
    
    NSString* priceStr=[FormatUtil formatDouble4:self.menuTimePrice.price];
    [self.lsPrice initData:priceStr withVal:priceStr];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*) notification
{
    [self configNavigationBar:YES];
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
}

- (void)clientInput:(NSString*)val event:(NSInteger)eventType
{
    [self.lsPrice changeData:val withVal:val];
}

- (BOOL)isValid
{
    if ([NSString isBlank:[self.lsPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"促销价格(元)不能为空!", nil)];
        return NO;
    }
    if (![NSString isFloat:[self.lsPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"促销价格(元)不是数字!", nil)];
        return NO;
    }
    return YES;
}

- (MenuTimePrice *)transMode
{
    MenuTimePrice* tempUpdate=[MenuTimePrice new];
    tempUpdate.menuId=self.menuTimePrice.menuId;
    tempUpdate.menuTimeId=self.menuTimePrice.menuTimeId;
    tempUpdate.menuName=self.menuTimePrice.menuName;
    tempUpdate.price=[self.lsPrice getStrVal].doubleValue;
    tempUpdate.isRatio = self.menuTimePrice.isRatio;
    return tempUpdate;
}

- (void)save
{
    if (![self isValid]) {
        return;
    }
    MenuTimePrice *objTemp=[self transMode];
    NSString *tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@促销商品", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        param[@"menu_time_price_str"] = [objTemp yy_modelToJSONString];
        @weakify(self);
        [[TDFMemberService new] saveMenuTimePriceWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            self.callBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.menuTimePrice.menuName]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.menuTimePrice.menuName]];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        param[@"id"] = self.menuTimePrice._id;
        @weakify(self);
        [[TDFMemberService new] removeMenuTimePriceWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
          
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"menutime"];
}

@end
