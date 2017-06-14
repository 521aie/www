//
//  TDFTakeMealController.m
//  RestApp
//
//  Created by Cloud on 2017/3/8.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTakeMealController.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFIntroductionHeaderView.h"
#import "DHTTableViewSection.h"
#import "TDFDisplayCommonItem.h"
#import "DHTTableViewManager.h"
#import "HelpDialog.h"
#import "TDFMediator+KabawModule.h"
#import "TDFMediator+SettingModule.h"
#import "UIViewController+HUD.h"
#import "TDFQueueService.h"
#import "TDFTextEditViewController.h"
#import "TDFPermissionHelper.h"

@interface TDFTakeMealController ()

@property (nonatomic, strong) UITableView *tbvBase;

@property (nonatomic, strong) DHTTableViewManager *manager;

@end

@implementation TDFTakeMealController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"取餐";
    [self configDefaultManager];
    [self registerCells];
    
    
    self.tbvBase.tableHeaderView = [[TDFIntroductionHeaderView alloc] initWithImageIcon:[UIImage imageNamed:@"takeMeal"] description:@"通过电视呼叫取餐单号，引导顾客自助取餐，同时支持播放店家广告，优化顾客的叫号取餐体验。"];
    
    [self addSections];
}

- (void)configDefaultManager
{
    self.tbvBase = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tbvBase.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    self.tbvBase.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbvBase.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tbvBase];
    
    self.manager = [[DHTTableViewManager alloc] initWithTableView:self.tbvBase];
}

- (void)registerCells
{
    [self.manager registerCell:@"TDFDisplayCommonCell" withItem:@"TDFDisplayCommonItem"];
}

- (void)addSections
{
    DHTTableViewSection *section = [DHTTableViewSection section];
    
    TDFDisplayCommonItem *item3 = [[TDFDisplayCommonItem alloc] init];
    item3.code = @"PHONE_VOICE_SET";
    item3.iconImage = [UIImage imageNamed:@"calloutvoice"];
    item3.title = @"叫号语音";
    item3.detail = @"设置叫号和广播语音";
    @weakify(self);
    @weakify(item3);
    item3.clickedBlock = ^ () {
        @strongify(self);
        @strongify(item3);

        if ([self hasPermissionWithIsLock:item3.isLock actionName:item3.title]) {
            UIViewController *vc = [[[TDFMediator alloc] init] TDFMediator_callVoiceSettingViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    TDFDisplayCommonItem *item4 = [[TDFDisplayCommonItem alloc] init];
    item4.code = @"PHONE_SCREEN_ADVERTISEMENT";
    item4.iconImage = [UIImage imageNamed:@"shopscreenadv"];
    item4.title = @"店内屏幕广告";
    item4.detail = @"设置副屏上的图片广告";
    @weakify(item4);
    item4.clickedBlock = ^ () {
        @strongify(self);
        @strongify(item4);

        if ([self hasPermissionWithIsLock:item4.isLock actionName:item4.title]) {
            UIViewController *vc = [[[TDFMediator alloc] init] TDFMediator_shopScreenAdViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    [section addItem:item3];
    [section addItem:item4];
    
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
        
//        item.isLock = ![codeArr containsObject:item.code];
        item.isLock = [[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.code];

    }
    
    [self.manager reloadData];
}

@end
