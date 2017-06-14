//
//  EditPassView.m
//  RestApp
//
//  Created by zxh on 14-4-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditPassView.h"
#import "NavigateTitle.h"
#import "NavigateTitle2.h"
#import "EditItemText.h"
#import "UIView+Sizes.h"
#import "MBProgressHUD.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "RemoteEvent.h"
#import "User.h"
#import "XHAnimalUtil.h"
#import "NSString+Estimate.h"
#import "RemoteResult.h"
#import "EditItemView.h"
#import "AlertBox.h"

@implementation EditPassView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.changed=NO;
    [self initNotifaction];
    [self initNavigate];
    
    [self initMainView];
    self.needHideOldNavigationBar = YES;
    self.title = NSLocalizedString(@"密码修改", nil);
    [self loadData:self.user employee:self.employee];
    [UIHelper refreshPos:self.container scrollview:nil];
    [UIHelper clearColor:self.container];
}

#pragma navigateTitle.

-(void) initNavigate{
    
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"密码修改", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

-(void) rightNavigationButtonAction:(id)sender{
    [self save];
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

-(void) initMainView{
    [self.lblName initLabel:NSLocalizedString(@"系统登录账号", nil) withHit:nil];
    [self.txtPass initLabel:NSLocalizedString(@"新密码", nil) withHit:nil isrequest:YES type:UIKeyboardTypeEmailAddress];
    [self.txtPassConfirm initLabel:NSLocalizedString(@"重复新密码", nil) withHit:nil isrequest:YES type:UIKeyboardTypeEmailAddress];
    
    self.txtPass.txtVal.secureTextEntry=YES;
    self.txtPassConfirm.txtVal.secureTextEntry=YES;
    
    [self.container setBackgroundColor:[UIColor clearColor]];
    
}

#pragma remote
-(void) loadData:(User*) tempVO employee:(Employee *)employee{
    self.user=tempVO;
    self.employee = employee;
    [self.lblName initData:tempVO.username withVal:tempVO._id];
    [self.txtPass initData:nil];
    [self.txtPassConfirm initData:nil];
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_ADD];
}



#pragma ui-data-save
-(BOOL)isValid{
    if ([NSString isBlank:[self.txtPass getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请输入新密码!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.txtPassConfirm getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请输入重复新密码!", nil)];
        return NO;
    }
    
    if ([NSString isNotNumAndLetter:[self.txtPass getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"新密码只能是数字和英文字母!", nil)];
        return NO;
    }
    
    
    if (![[self.txtPass getStrVal] isEqualToString:[self.txtPassConfirm getStrVal]] ) {
        [AlertBox show:NSLocalizedString(@"输入的两次密码不相同!", nil)];
        return NO;
    }
    return YES;
}


-(void)save{
    if (![self isValid]) {
        return;
    }
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"user_id"] =  self.user._id;
    parma[@"entity_id"] =  self.employee.entityId;
    parma[@"new_psd"] =  [self.txtPass getStrVal];
    
    @weakify(self);
    [[TDFChainService new] changeUserPsdWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self showView];
       } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)showView
{
    [UIHelper ToastNotification:NSLocalizedString(@"保存成功!", nil) andView:self.navigationController.view andLoading:NO andIsBottom:NO];
    [UIHelper clearChange:self.container];
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_ADD];
    
   [self.navigationController popViewControllerAnimated:YES];
}

#pragma notification 处理.
-(void) initNotifaction{
    [UIHelper initNotification:self.container event:Notification_UI_EditPassView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_EditPassView_Change object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification{
    [self configNavigationBar:YES];
}

@end
