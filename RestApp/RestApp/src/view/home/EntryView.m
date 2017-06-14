//
//  EntryView.m
//  RestApp
//
//  Created by Shaojianqing on 15/9/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Platform.h"
#import "EntryView.h"
#import "DateUtils.h"
#import "ObjectUtil.h"
#import "RemoteEvent.h"
#import "MemberUserVo.h"
#import "ServiceFactory.h"
#import "NSString+Estimate.h"
#import "TDFBuffetShopViewController.h"
#import "TDFLoginService.h"
#import <libextobjc/EXTScope.h>
#import "TDFMediator+ShopManagerModule.h"
#import "TDFBuffetShopViewController.h"

@implementation EntryView

- (void)viewDidLoad
{
    [super viewDidLoad];
    userService = [ServiceFactory Instance].userService;
    self.btnOpenShop.layer.cornerRadius = 5.0f;
    self.btnOpenShop.layer.masksToBounds = YES;
    self.btnOpenShop.layer.borderWidth = 1.0f;
    self.btnOpenShop.layer.borderColor = [[UIColor whiteColor]CGColor];
//    [self initNotification];
}

//- (void)initNotification
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCheckShopList:) name:REMOTE_GET_SHOPLIST_IN_ENTRYVIEW object:nil];
//}

- (void)loadShopData
{
    NSString *nickName;
    if ([NSString isNotBlank:[Platform Instance].userInfo.weixinNickName]) {
        nickName = [Platform Instance].userInfo.weixinNickName;
    } else {
        nickName = [Platform Instance].memberExtend.userName;
    }
    self.lblUser.text = nickName;
    self.lblDay.text = [NSString stringWithFormat:NSLocalizedString(@"今天是%@", nil), [DateUtils formatTimeWithDate:[NSDate date] type:TDFFormatTimeTypeChineseWithWeek]];
    
    //默认显示添加
    [self.btnManage setTitle:NSLocalizedString(@"添加我工作的店家", nil) forState:UIControlStateNormal];
    buttonAdd = YES;
    
    NSString *memberId = [Platform Instance].userInfo.memberId;
    if ([NSString isNotBlank:memberId]) {
        NSDictionary *param = @{@"member_id":memberId};
        @weakify(self);
        [[[TDFLoginService alloc] init] getDindEntityListWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            NSArray *shopList = data[@"data"];
            NSMutableArray *memberUserList = [MemberUserVo convertToMemberUserList:shopList];
            if ([ObjectUtil isNotEmpty:memberUserList]) {
                //显示管理
                [self.btnManage setTitle:NSLocalizedString(@"管理我工作的店家", nil) forState:UIControlStateNormal];
                buttonAdd = NO;
            } else {
                //显示添加
                [self.btnManage setTitle:NSLocalizedString(@"添加我工作的店家", nil) forState:UIControlStateNormal];
                buttonAdd = YES;
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (IBAction)manageBtnClick:(id)sender
{
    if (buttonAdd) {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_shopAttachViewControllerWithParams:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:nav animated:YES completion:nil];

    } else {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_shopListViewController];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:nav animated:YES completion:nil];
//        [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:viewController animated:YES];
    }
}

- (IBAction)extraBtnClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_OTHER_SHOW_NOTIFICATION object:nil] ;
}

- (IBAction)btnBuffetShopClicked:(id)sender {
    TDFBuffetShopViewController *viewController = [[TDFBuffetShopViewController alloc] init];
//    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_buffetShopViewController];
    viewController.openShopMode = TDFShopOpenShop;
    [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:viewController animated:YES];
}

@end
