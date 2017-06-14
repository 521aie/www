//
//  TDFSignBillController.m
//  RestApp
//
//  Created by Cloud on 2017/3/8.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSignBillController.h"
#import "TDFPermissionHelper.h"

@interface TDFSignBillController ()

@property (nonatomic, strong) UITableView *tbvBase;

@property (nonatomic, strong) DHTTableViewManager *manager;

@end

@implementation TDFSignBillController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"挂账";
    [self configDefaultManager];
    [self registerCells];
    
    self.tbvBase.tableHeaderView = [[TDFIntroductionHeaderView alloc] initWithImageIcon:[UIImage imageNamed:@"SignBill"] description:@"商家可在此处对挂帐支付方式下的挂帐人和本店签字确认人进行管理，并对在本店挂帐的账单进行收账，以及对已收账的账单撤销收账等操作。"];
    
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
    item3.code = @"PAD_SIGN_PERSON";
    item3.iconImage = [UIImage imageNamed:@"SignBillSetting"];
    item3.title = @"挂账设置";
    item3.detail = @"管理挂账人和本店签字确认人";
    @weakify(self);
    @weakify(item3);
    item3.clickedBlock = ^ () {
        @strongify(self);
        @strongify(item3);

        if ([self hasPermissionWithIsLock:item3.isLock actionName:item3.title]) {
            UIViewController *vc = [[[TDFMediator alloc] init] TDFMediator_SignBillListView];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    TDFDisplayCommonItem *item4 = [[TDFDisplayCommonItem alloc] init];
    item4.code = @"PAD_SIGN_BILL";
    item4.iconImage = [UIImage imageNamed:@"SignBillDeal"];
    item4.title = @"挂账处理";
    item4.detail = @"进行账单收账和撤销收账等操作处理";
    @weakify(item4);
    item4.clickedBlock = ^ () {
        @strongify(self);
        @strongify(item4);

        if ([self hasPermissionWithIsLock:item4.isLock actionName:item4.title]) {
            UIViewController *vc = [[[TDFMediator alloc] init] TDFMediator_signBillViewController];
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
