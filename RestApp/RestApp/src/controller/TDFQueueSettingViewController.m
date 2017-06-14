//
//  TDFQueueSettingViewController.m
//  RestApp
//
//  Created by Octree on 7/12/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFQueueSettingViewController.h"
#import "BackgroundHelper.h"
#import "UIColor+Hex.h"
#import "TDFTextEditViewController.h"
#import "QueuKindListView.h"
#import "TDFMediator+KabawModule.h"
#import "TDFQueueService.h"
#import "UIViewController+HUD.h"
#import <Masonry/Masonry.h>
#import "TDFForm.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFDisplayCommonItem.h"
#import "TDFMediator+KabawModule.h"
#import "TDFMediator+SettingModule.h"
#import "TDFFunctionVo.h"
#import "TDFIsOpen.h"
#import "TDFPermissionHelper.h"

@interface TDFQueueSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSString *remarkId;
@property (strong, nonatomic) DHTTableViewManager *manager;

@end

@implementation TDFQueueSettingViewController


#pragma mark - Life Cycle


- (void)viewDidLoad {

    [super viewDidLoad];
    [self configViews];
    self.title = NSLocalizedString(@"排队", nil);
    [self configNavigateButtons];
}


#pragma mark - Methods

- (void)configNavigateButtons {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 60.0f, 40.0f);
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    UIImage *backIcon = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_back"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    [backButton setImage:backIcon forState:UIControlStateNormal];
    [backButton setTitle:NSLocalizedString(@"返回", nil) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = nil;
    return;
}


- (void)popButtonTapped {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)configViews {
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    
    UIView *v = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [imageView addSubview:v];
    [self.view addSubview:imageView];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);                                                                                                                                                                                                                       
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    self.tableView.tableHeaderView = [[TDFIntroductionHeaderView alloc] initWithImageIcon:[UIImage imageNamed:@"queue_setting"] description:@"店家可进行排队桌位类型、排队单备注、叫号语音、店内屏幕广告、更换排队机等和排队相关的设置。提高排队效率，减少顾客的排队时间，并在排队过程中传播优惠活动和店铺促销等。"];
    [self.manager registerCell:@"TDFDisplayCommonCell" withItem:@"TDFDisplayCommonItem"];
    [self addSection];
}


- (void)addSection {

    DHTTableViewSection *section = [DHTTableViewSection section];
    
    TDFDisplayCommonItem *seatItem = [[TDFDisplayCommonItem alloc] init];
    seatItem.code = @"PAD_QUEUE_SEAT";
    seatItem.iconImage = [UIImage imageNamed:@"queue_seat_setting"];
    seatItem.title = @"排队桌位类型";
    seatItem.detail = @"设置桌位类型和桌位的最大容纳人数";
    @weakify(self);
    @weakify(seatItem);
    seatItem.clickedBlock = ^ () {
        @strongify(self);
        @strongify(seatItem);
        if ([self hasPermissionWithIsLock:seatItem.isLock actionName:seatItem.title]) {
            UIViewController *vc = [[[TDFMediator alloc] init] TDFMediator_QueuKindListViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }

    };
    
    TDFDisplayCommonItem *remarkItem = [[TDFDisplayCommonItem alloc] init];
    // 这个没有code，默认不加锁的
    remarkItem.code = @"";
    remarkItem.iconImage = [UIImage imageNamed:@"queue_remark"];
    remarkItem.title = NSLocalizedString(@"排队单备注", nil);
    remarkItem.detail = @"设置排队单的相关说明和备注";
    @weakify(remarkItem);
    remarkItem.clickedBlock = ^ () {
        @strongify(self);
        @strongify(remarkItem);
        if ([self hasPermissionWithIsLock:remarkItem.isLock actionName:remarkItem.title]) {
            [self forwardTextEditVC];

        }
    };
    
    TDFDisplayCommonItem *callVoiceItem = [[TDFDisplayCommonItem alloc] init];
    callVoiceItem.code = @"PHONE_VOICE_SET";
    callVoiceItem.iconImage = [UIImage imageNamed:@"calloutvoice"];
    callVoiceItem.title = @"叫号语音";
    callVoiceItem.detail = @"设置叫号和广播语音";
    @weakify(callVoiceItem);
    callVoiceItem.clickedBlock = ^ () {
        @strongify(self);
        @strongify(callVoiceItem);

        if ([self hasPermissionWithIsLock:callVoiceItem.isLock actionName:callVoiceItem.title]) {
            UIViewController *vc = [[[TDFMediator alloc] init] TDFMediator_callVoiceSettingViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    TDFDisplayCommonItem *shopAds = [[TDFDisplayCommonItem alloc] init];
    shopAds.code = @"PHONE_SCREEN_ADVERTISEMENT";
    shopAds.iconImage = [UIImage imageNamed:@"shopscreenadv"];
    shopAds.title = @"店内屏幕广告";
    shopAds.detail = @"设置副屏上的图片广告";
    @weakify(shopAds);
    shopAds.clickedBlock = ^ () {
        @strongify(self);
        @strongify(shopAds);

        if ([self hasPermissionWithIsLock:shopAds.isLock actionName:shopAds.title]) {
            UIViewController *vc = [[[TDFMediator alloc] init] TDFMediator_shopScreenAdViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    TDFDisplayCommonItem *changeQItem = [[TDFDisplayCommonItem alloc] init];
    changeQItem.code = @"PAD_CHANGE_QUEUE";
    changeQItem.iconImage = [UIImage imageNamed:@"changequeuemachine"];
    changeQItem.title = @"更换排队机";
    changeQItem.detail = @"旧版排队机硬件更换时使用";
    @weakify(changeQItem);
    changeQItem.clickedBlock = ^ () {
        @strongify(self);
        @strongify(changeQItem);

        if ([self hasPermissionWithIsLock:changeQItem.isLock actionName:changeQItem.title]) {
            UIViewController *vc = [[[TDFMediator alloc] init] TDFMediator_CancelQueuViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    [section addItem:seatItem];
    [section addItem:remarkItem];
    [section addItem:callVoiceItem];
    [section addItem:shopAds];
    [section addItem:changeQItem];
    
    [self.manager addSection:section];
    [self judgeRights];
}

- (BOOL)hasPermissionWithIsLock:(BOOL)isLock actionName:(NSString *)actionName
{
    if (isLock) {
        [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),actionName]];
        return NO;
    }

    return YES;

}

- (void)judgeRights {
    
    
    /**
     
     权限判断
     
     */
    
//    NSArray *codeArr = [[Platform Instance] notLockedActionCodeList];
    
    NSArray *itemArr = ((DHTTableViewSection *)(self.manager.sections[0])).items;
    
    for (TDFDisplayCommonItem *item in itemArr) {
        
        item.isLock = [[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.code];
    }

    
    [self.manager reloadData];
}

- (void)forwardTextEditVC {

    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[[TDFQueueService alloc] init] queueRemarkWithSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data)  {
        @strongify(self);
        [self dismissHUD];
        self.remarkId = [[data objectForKey:@"data"] objectForKey:@"id"];
        [self showTextEditVCWithText:[[data objectForKey:@"data"] objectForKey:@"queueRemark"]];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self dismissHUD];
        [self showErrorMessage:error.localizedDescription];
    }];
}

- (void)showTextEditVCWithText:(NSString *)text {
    
    TDFTextEditViewController *tvc = [[TDFTextEditViewController alloc] initWithTitle:NSLocalizedString(@"排队单备注", nil)
                                                                                 text:text
                                                                                limit:200
                                                                          placeholder:NSLocalizedString(@"最多可输入20个中文字符", nil)
                                                                               prompt:NSLocalizedString(@"排队单备注信息（此备注会打印在排队单）", nil)];
    tvc.forbiddenNewLine = NO;
    tvc.finishBlock = ^void(NSString *text) {
    
        [self saveRemark:text];
    };
    [self.navigationController pushViewController:tvc animated:YES];
}


#pragma mark Network

- (void)saveRemark:(NSString *)remark {

    [self showHUBWithText:NSLocalizedString(@"正在保存", nil)];
    @weakify(self);
    [[[TDFQueueService alloc] init] updateQueueRemarkWithRemark:(remark ?: @"") remarkId:self.remarkId success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self dismissHUD];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self dismissHUD];
        [self showErrorMessage:error.localizedDescription];
    }];
}


#pragma mark - Accessor


- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _tableView;
}

- (DHTTableViewManager *)manager {

    if (!_manager) {
    
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
    }
    
    return _manager;
}

@end
