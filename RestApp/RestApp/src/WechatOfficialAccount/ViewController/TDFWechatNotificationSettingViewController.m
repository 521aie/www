//
//  TDFWechatNotificationSettingViewController.m
//  RestApp
//
//  Created by happyo on 2017/2/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWechatNotificationSettingViewController.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFRootViewController+TableViewManager.h"
#import "DHTTableViewManager.h"
#import "DHTTableViewSection.h"
#import "TDFSwitchItem.h"
#import "TDFWechatMarketingService.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFSwitchItem+Chainable.h"
#import "TDFBaseEditView.h"
#import "TDFEditViewHelper.h"
#import "YYModel.h"
#import "TDFOAAuthIntrouceViewController.h"
#import "STTweetLabel.h"
#import "TDFOAHelpViewController.h"

@interface TDFWechatNotificationSettingViewController ()

@end

@implementation TDFWechatNotificationSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"店家公众号消息推送设置", nil);

    [self configDefaultManager];
    
    self.tbvBase.contentInset = UIEdgeInsetsMake(0, 0, 44 + 64, 0);
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha = 0.7;
    [self.view insertSubview:alphaView atIndex:1];
    
    [self.manager registerCell:@"TDFSwitchCell" withItem:@"TDFSwitchItem"];
    
    [self fetchData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeNavTitles:) name:kTDFEditViewIsShowTipNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)fetchData
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFWechatMarketingService fetchWechatNotificationSettingWithWechatId:self.wechatId callback:^(id responseObj, NSError *error) {
        [self.progressHud setHidden:YES];

        if (error) {
            [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
        } else {
            NSDictionary *dict = responseObj;
            [self configureViewWithList:dict[@"data"]];
            [self.manager reloadData];
        }
    }];
}

- (void)configureViewWithList:(NSArray *)list
{
//    NSNumber *authorizedStatus = dict[@"authorizedStatus"];
    
    [self configureHeaderViewWithAuthorizedStatus:self.isAuthorization];
    
//    NSArray *msgList = dict[@"msgSetVos"];
    [self configureSectionsWithList:list];
}

- (void)configureHeaderViewWithAuthorizedStatus:(BOOL)isAuthorized
{
    UIImage *iconImage = [UIImage imageNamed:@"wxoa_wechat_notification_icon"];
    NSString *description = NSLocalizedString(@"顾客使用在线点单、结账、排队等功能时，会收到公众号推送的消息。所有消息都需要顾客在公众号内点餐领卡后才能收到。以下开关打开时使用店家公众号推送，关闭时使用二维火公众号推送。", nil);

    TDFIntroductionHeaderView *headerView;
    if (isAuthorized) {
        headerView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage description:description badgeIcon:[UIImage imageNamed:@"wxoa_wechat_notification_authorization"]];
    } else {
        headerView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage
                                                                         description:description
                                                                           badgeIcon:[UIImage imageNamed:@"wxoa_wechat_notification_unauthorization"]
                                                                         detailTitle:NSLocalizedString(@"立即去授权", nil)
                                                                         detailBlock:^{
                                                                             [self forwardAuthorizationVC];
                                                                         }];
    }
    [headerView changeBackAlpha:0];
    self.tbvBase.tableHeaderView = headerView;
    
    DHTTableViewSection *blackSection = [DHTTableViewSection section];
    UIView *spliteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    spliteView.backgroundColor = [UIColor blackColor];
    blackSection.headerView = spliteView;
    blackSection.headerHeight = 1;
    
    [self.manager addSection:blackSection];
    
    DHTTableViewSection *infomationSection = [DHTTableViewSection section];
    CGFloat infomationHeight = 0;
    if (self.isAuthorization) {
        infomationHeight = 70;
        UIView *infomationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, infomationHeight)];
        infomationView.backgroundColor = [UIColor clearColor];
        
        STTweetLabel *lblDesc = [[STTweetLabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, infomationHeight - 20)];
        
        NSString *text = NSLocalizedString(@"注：以下消息均为模板消息，此类消息仅限已认证的服务号可以发送。如发送不成功，请到微信公众号后台检查您的公众号。", nil);
        NSString *hotword = NSLocalizedString(@"查看详细教程 〉", nil);
        lblDesc.hotwordRegex = hotword;
        lblDesc.numberOfLines = 2;
        [lblDesc setText:[NSString stringWithFormat:@"%@%@", text, hotword]];
        [lblDesc setAttributes:@{
                                      NSForegroundColorAttributeName : RGBA(204, 0, 0, 1),
                                      NSFontAttributeName: [UIFont systemFontOfSize:12]
                                      }];
        [lblDesc setAttributes:@{
                                      NSForegroundColorAttributeName : RGBA(0, 136, 204, 1),
                                      NSFontAttributeName: [UIFont systemFontOfSize:12]
                                      }
                            hotWord:STTweetLink];
        lblDesc.textSelectable = NO;
        @weakify(self);
        [lblDesc setDetectionBlock:^(STTweetHotWord hotword, NSString *text, NSString *protocol, NSRange range) {
            @strongify(self);
            TDFOAHelpViewController *vc = [[TDFOAHelpViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        [infomationView addSubview:lblDesc];
        
        UIView *spliteView = [[UIView alloc] initWithFrame:CGRectZero];
        spliteView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        
        [infomationView addSubview:spliteView];
        [spliteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(infomationView);
            make.leading.equalTo(@10);
            make.trailing.equalTo(@(-10));
            make.height.equalTo(@1);
        }];
        
        infomationSection.headerView = infomationView;
        infomationSection.headerHeight = infomationHeight;

    } else {
        infomationHeight = 44;
        UIView *infomationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, infomationHeight)];
        infomationView.backgroundColor = [UIColor clearColor];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:15];
        lbl.textColor = RGBA(204, 0, 0, 1);
        lbl.text = NSLocalizedString(@"需完成公众号授权后，才能使用此功能", nil);
        
        [infomationView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(infomationView);
            make.height.equalTo(@20);
            make.leading.equalTo(infomationView);
            make.trailing.equalTo(infomationView);
        }];
        
        UIView *spliteView = [[UIView alloc] initWithFrame:CGRectZero];
        spliteView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        
        [infomationView addSubview:spliteView];
        [spliteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(infomationView);
            make.leading.equalTo(@10);
            make.trailing.equalTo(@(-10));
            make.height.equalTo(@1);
        }];
        
        infomationSection.headerView = infomationView;
        infomationSection.headerHeight = infomationHeight;
    }
    
    [self.manager addSection:infomationSection];
}

- (void)forwardAuthorizationVC
{
    TDFOAAuthIntrouceViewController *vc = [[TDFOAAuthIntrouceViewController alloc] init];
    vc.authPopDepthAddition = 1;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configureSectionsWithList:(NSArray *)settingList
{
    DHTTableViewSection *section = [DHTTableViewSection section];
    for (NSDictionary *dict in settingList) {
        NSString *msgSettingId = dict[@"msgSettingId"];
        
        NSString *name = dict[@"name"];
        
        NSNumber *status = dict[@"status"];
        
        NSString *templateNo = dict[@"templateNo"];
        
        TDFSwitchItem *item = [[TDFSwitchItem alloc] init];
        item.tdf_title(name).tdf_isOn([status boolValue]).tdf_detail(templateNo).tdf_requestKey(msgSettingId).tdf_preValue(@([status boolValue])).tdf_requestValue(@([status boolValue]));
        
        item.editStyle = self.hasPermission ? TDFEditStyleEditable : TDFEditStyleUnEditable;
        
        if (!self.isAuthorization) {
            item.filterBlock = ^ (BOOL isOn) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您尚未授权，无法开启开关", nil) preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * action) {
                                                                         [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
                                                                     }];
                
                [alertController addAction:cancelAction];
                
                UIAlertAction *enterAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"去授权", nil) style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * action) {
                                                                        [self forwardAuthorizationVC];
                                                                    }];
                
                [alertController addAction:enterAction];
                
                
                [self presentViewController:alertController animated:YES completion:nil];

                
                return NO;
            };
        }
        
        [section addItem:item];
    }
    
    [self.manager addSection:section];
}

- (void)saveChange
{
    NSMutableArray *settingList = [NSMutableArray array];
    for (DHTTableViewSection *section in self.manager.sections) {
        for (DHTTableViewItem *item in section.items) {
            if ([item isKindOfClass:[TDFSwitchItem class]]) {
                TDFSwitchItem *switchItem = (TDFSwitchItem *)item;
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                NSNumber *status = (NSNumber *)switchItem.requestValue;
                [dict setObject:[NSString stringWithFormat:@"%@", status] forKey:@"status"];
                [dict setObject:switchItem.requestKey forKey:@"msgSettingId"];
                
                [settingList addObject:dict];
            }
        }
    }
    
    NSString *json = [settingList yy_modelToJSONString];
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFWechatMarketingService saveWechatNotificationSettingWithWechatId:self.wechatId Json:json callback:^(id responseObj, NSError *error) {
        [self.progressHud setHidden:YES];

        if (error) {
            [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark -- Notifications --

- (void)shouldChangeNavTitles:(NSNotification *)notification
{
    if ([TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections]) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    } else {
        [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
        [self configRightNavigationBar:nil rightButtonName:nil];
    }
}

#pragma mark -- Actions --

- (void)leftNavigationButtonAction:(id)sender
{
    if ([TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections]) {
        __weak typeof(self) weakSelf = self;
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"内容有变更尚未保存，确定要退出吗?", nil) cancelBlock:^(){
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } enterBlock:^(){
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self saveChange];
}


@end
