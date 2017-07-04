//
//  BillModifyModule.m
//  RestApp
//
//  Created by 栀子花 on 16/5/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BillModifyModule.h"
#import "ActionConstants.h"

#import "BillModifyCell.h"
#import "TDFIntroductionHeaderView.h"
#import "UIMenuAction.h"
#import "TDFMediator+BillModifyModule.h"
#import "TDFLoginService.h"

#define CASHIER_DATA_OPTIMIZE   @"CASHIER_DATA_OPTIMIZE"
#define TABLE_DATA_OPTIMIZW     @"TABLE_DATA_OPTIMIZW"

@interface BillModifyModule() <UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isVersionAuth;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<UIMenuAction *> *menuItems;

@end

static NSString * const reuseCellID = @"Cell";

@implementation BillModifyModule


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor  = [UIColor clearColor];
        _tableView.delegate         = self;
        _tableView.dataSource       = self;
        _tableView.rowHeight        = [BillModifyCell cell_height];
        _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[BillModifyCell class] forCellReuseIdentifier:reuseCellID];
    }
    return _tableView;
}

- (NSArray *)menuItems
{
    if (!_menuItems) {
        NSMutableArray* menuItems=[NSMutableArray array];
        UIMenuAction *action=[[UIMenuAction alloc] init:NSLocalizedString(@"报表数据优化", nil) detail:@"可手工或自动报表相关账单数据" img:@"ico_nav_shoudong.png" code:TABLE_DATA_OPTIMIZW];
        [menuItems addObject:action];
        
        action=[[UIMenuAction alloc] init:NSLocalizedString(@"收银机数据优化", nil) detail:@"可以自动优化收银机账单数据" img:@"ico_nav_zidong.png" code:CASHIER_DATA_OPTIMIZE];
        [menuItems addObject:action];
        
        _menuItems = [menuItems copy];
    }
    return _menuItems;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账单优化";

    [self configTableView];
    [self    loadAuth];
    
}

- (void)loadAuth {
    [[[TDFLoginService alloc] init ] cashierVersionWithParams:@{@"cashier_version_key":@"cashVersion4ABZhang"} sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        if ([data[@"code"] intValue] == 1 && [data[@"data"] intValue] == 1) {
            _isVersionAuth = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [AlertBox show:error.localizedDescription];
    }];
}


- (void)configTableView {
    [self.view addSubview:self.tableView];
    UIImage *headerIcon = [UIImage imageNamed:@"BillOptimize"];
    NSString *description = @"可将报表和收银机的账单数据进行优化，设置优化的规则后，系统会将部分账单设置为隐藏状态。员工查看报表或操作收银机时，如果没有查看隐藏账单的权限，则只显示部分未经隐藏的账单；如果员工有查看隐藏账单的权限，则显示全部账单。";
    self.tableView.tableHeaderView = [TDFIntroductionHeaderView headerViewWithIcon:headerIcon description:description];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(64);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillModifyCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellID forIndexPath:indexPath];
    cell.img_next.hidden = NO;
    
    UIMenuAction *menuItem = self.menuItems[indexPath.row];
    cell.lblTitle.text= menuItem.name;
    cell.lblDetail.text = menuItem.detail;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIMenuAction *menuAction = self.menuItems[indexPath.row];
    UIViewController *viewController = nil;
    if ([menuAction.code isEqualToString:TABLE_DATA_OPTIMIZW]) {
        viewController = [[TDFMediator sharedInstance] TDFMediator_tableDataOptimizeController];
    }
    else if([menuAction.code isEqualToString:CASHIER_DATA_OPTIMIZE])
    {
        if (!_isVersionAuth) {
            [AlertBox show:@"此功能需配合收银机v5.6.5及以上版本使用。"];
            return;
        }
        viewController = [[TDFMediator sharedInstance] TDFMediator_cashierDataOptimizeController];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

@end








