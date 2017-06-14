//
//  TDFOrderReminderViewController.m
//  RestApp
//
//  Created by happyo on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOrderReminderViewController.h"
#import "TDFRootViewController+TableViewManager.h"
#import "TDFIntroductionHeaderView.h"
#import "DHTTableViewManager.h"
#import "DHTTableViewSection.h"
#import "TDFSwitchItem.h"
#import "TDFOrderReminderService.h"
#import "TDFResponseModel.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFFoodDisplayItem.h"
#import "YYModel.h"
#import "TDFFoodCategoryHeaderView.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFMemberCustomerView.h"
#import "SampleMenuVO.h"
#import "TDFFoodSelectViewController.h"
#import "TDFFoodCategorySelectedModel.h"
#import "TDFFoodSelectHeaderView.h"

@interface TDFOrderReminderViewController () <TDFFoodSelectViewControllerDelegate>

@property (nonatomic, strong) TDFSwitchItem *reminderItem;

@property (nonatomic, strong) NSArray *foodDataList;

@end

@implementation TDFOrderReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"点餐重复提醒";
    
    [self configDefaultManager];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAdd];
    
    [self.manager registerCell:@"TDFSwitchCell" withItem:@"TDFSwitchItem"];
    [self.manager registerCell:@"TDFFoodDisplayCell" withItem:@"TDFFoodDisplayItem"];
    
    TDFIntroductionHeaderView *headerView = [[TDFIntroductionHeaderView alloc] initWithImageIcon:[UIImage imageNamed:@"reminder_repeate_header_icon"] description:NSLocalizedString(@"开启点重提醒后，当商品选择份数超过起点份数时，系统将会自动提示用户。\n若有需要关闭点重提醒的商品，可在下方添加。", nil)];
    self.tbvBase.tableHeaderView = headerView;
    self.tbvBase.contentInset = UIEdgeInsetsMake(0, 0, 76 + 64, 0);

    [self fetchOrderReminderDetailData];
}

- (void)addReminderSection
{
    DHTTableViewSection *section = [DHTTableViewSection section];
    
    self.reminderItem = [[TDFSwitchItem alloc] init];
    self.reminderItem.isOn = YES;
    self.reminderItem.preValue = @(YES);
    self.reminderItem.alpha = 0.7;
    self.reminderItem.title = NSLocalizedString(@"商品点重提醒", nil);
    self.reminderItem.detail = NSLocalizedString(@"注:开启此功能后，可在下方选择或编辑点餐重复时无需提醒的商品。", nil);
    @weakify(self);
    self.reminderItem.filterBlock = ^ (BOOL isOn) {
        @strongify(self);
        self.reminderItem.preValue = @(isOn);
        [self modifyReminderSwitch:isOn];
        
        return YES;
    };
    
    [section addItem:self.reminderItem];
    
    [self.manager addSection:section];
}

- (void)fetchOrderReminderDetailData
{
    [self.manager removeAllSections];
    [self addReminderSection];
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFOrderReminderService fetchOrderReminderDetailWithCompleteBlock:^(TDFResponseModel * response) {
        self.progressHud.hidden = YES;
        if ([response isSuccess]) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = response.responseObject;
                NSDictionary *dataDict = dict[@"data"];
                
                NSNumber *status = dataDict[@"status"];
                
                self.reminderItem.isOn = [status boolValue];
                self.reminderItem.preValue = status;
                
                NSArray *kindMenuList = dataDict[@"kindMenuVos"];
                
                [self removeAllFooterButtons];
                if (self.reminderItem.isOn) { // 打开才显示数据
                    [self configureFoodSectionWithDataList:kindMenuList];
                    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAdd];
                } else {
                    [self configureFoodSectionWithDataList:@[]];
                }
                
                [self.manager reloadData];
            }
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }

    }];
}

- (void)modifyReminderSwitch:(BOOL)isOn
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFOrderReminderService modifyReminderSwithWithIsOn:isOn completeBlock:^(TDFResponseModel * response) {
        self.progressHud.hidden = YES;
        if ([response isSuccess]) {
            [self fetchOrderReminderDetailData];
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }

    }];
}

- (void)configureFoodSectionWithDataList:(NSArray *)dataList
{
    self.foodDataList = dataList;
    for (NSDictionary *foodCategory in dataList) {
        NSString *foodCategoryName = foodCategory[@"kindMenuName"];
        
        DHTTableViewSection *foodSection = [DHTTableViewSection section];
        foodSection.headerView = [[TDFFoodSelectHeaderView alloc] initWithTitle:foodCategoryName];
        foodSection.headerHeight = [TDFFoodSelectHeaderView heightForView];
        
        NSArray<TDFFoodDisplayItem *> *foodDisplayList = [NSArray yy_modelArrayWithClass:[TDFFoodDisplayItem class] json:foodCategory[@"menuVos"]];
        
        @weakify(self);
        for (TDFFoodDisplayItem *foodItem in foodDisplayList) {
            foodItem.deleteBlock = ^ (NSString *foodId) {
                @strongify(self);
                [self deleteFoodWithId:foodId];
            };
            [foodSection addItem:foodItem];
        }
        
        [self.manager addSection:foodSection];
    }
}

- (void)deleteFoodWithId:(NSString *)foodId
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFOrderReminderService deleteReminderFoodWithFoodId:foodId completeBlock:^(TDFResponseModel * response) {
        self.progressHud.hidden = YES;
        if ([response isSuccess]) {
            [self fetchOrderReminderDetailData];
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }
    }];
}

- (void)footerAddButtonAction:(UIButton *)sender
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFOrderReminderService fetchFoodSelectedListWithCompleteBlock:^(TDFResponseModel * response) {
        self.progressHud.hidden = YES;
        if ([response isSuccess]) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = response.responseObject;

                NSArray<TDFFoodCategorySelectedModel *> *foodCategorySelectedList = [NSArray yy_modelArrayWithClass:[TDFFoodCategorySelectedModel class] json:dict[@"data"]];

                TDFFoodSelectViewController *vc = [[TDFFoodSelectViewController alloc] init];
                vc.foodCategorySelectedList = [NSMutableArray arrayWithArray:foodCategorySelectedList];
                vc.navTitle = NSLocalizedString(@"商品选择列表", nil);
                vc.delegate = self;
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }
        
    }];
}

#pragma mark -- TDFFoodSelectViewControllerDelegate --

- (void)viewController:(TDFFoodSelectViewController *)viewController changedFoodCategoryList:(NSArray<TDFFoodCategorySelectedModel *> *)foodCategorySelectedList
{
    NSMutableArray *idList = [NSMutableArray array];
    
    for (TDFFoodCategorySelectedModel *foodCategorySelected in foodCategorySelectedList) {
        for (TDFFoodSelectedModel *foodSelected in foodCategorySelected.menuVos) {
            if (foodSelected.isSelected) {
                [idList addObject:foodSelected.menuId];
            }
        }
    }
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFOrderReminderService saveReminderFoodListWithIds:[idList yy_modelToJSONString] completeBlock:^(TDFResponseModel * response) {
        self.progressHud.hidden = YES;
        if ([response isSuccess]) {
            [self fetchOrderReminderDetailData];
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }

    }];
}


@end
