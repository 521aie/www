//
//  TDFSuitMenuPrinterViewController.m
//  RestApp
//
//  Created by 黄河 on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSuitMenuPrinterViewController.h"
#import "TDFMediator+SupplyChain.h"
#import "TDFSuitMenuPrintManageModel.h"
#import "TDFTransService.h"
#import "HelpDialog.h"
#import "AlertBox.h"
#import "YYModel.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFRootViewController+TableViewManager.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFFoodSelectHeaderView.h"
#import "TDFTableViewIsChainItem.h"
#import "TDFTableViewItem.h"
#import "ColorHelper.h"
#import "TDFMediator+UserAuth.h"

@interface TDFSuitMenuPrinterViewController ()
@property (nonatomic, strong) TDFSuitMenuPrintManageModel *model;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)NSMutableArray *chainDataSource;
@property (nonatomic, strong) UIView *headView;
@end
@implementation TDFSuitMenuPrinterViewController

#pragma mark --init
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"套餐中商品分类打印设置", nil);
    [self configDefaultManager];
    [self registerCells];
    
    self.tbvBase.tableHeaderView = [[TDFIntroductionHeaderView alloc] initWithImageIcon:[UIImage imageNamed:@"ico_suitmenu_print"] description:NSLocalizedString(@"如果您在传菜方案中设置了一菜一切，但套餐打印时某些分类不需要一菜一切，可以在此处设置。\n此处设置仅在套餐打印时生效，普通商品打印仍然按照传菜方案中的设置。", nil) detailBlock:^{
        [HelpDialog show:@"suitMenuPrinter"];
    }];

    [self loadData];

    [[TDFMediator sharedInstance] TDFMediator_showShopKeepConfigurableAlertWithCode:@"PHONE_SUIT_MENU_PRINT"];
}

#pragma mark --registerCell
- (void)registerCells
{
    [self.manager registerCell:@"TDFTableViewCell" withItem:@"TDFTableViewItem"];
    [self.manager registerCell:@"TDFTableViewIsChainCell" withItem:@"TDFTableViewIsChainItem"];
}


#pragma mark --service
- (void)loadData
{
    [self.dataSource removeAllObjects];
    [self.chainDataSource removeAllObjects];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[TDFTransService shareInstance] getSuitMenuPrinterList:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud setHidden:YES];
        @strongify(self);
        self.model = [TDFSuitMenuPrintManageModel yy_modelWithJSON:data[@"data"]];
        for (TDFSuitMenuPrinterModel *model in self.model.kindMenuList) {
            if (model.needOneMealOneCut) {
                [self.dataSource addObject:model];
            }
        }
        [self.manager removeAllSections];
        if (self.model.addible) {
            [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp|TDFFooterButtonTypeAdd];
        }else{
            [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
        }
        [self buildUI];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma mark 初始化UI
- (void) buildUI
{
    [self.manager removeAllSections];
    
    if (!self.model.addible) {
        DHTTableViewSection *section = [DHTTableViewSection section];
        section.headerView = self.headView;
        section.headerHeight = 31;
        [self.manager addSection:section];
    }
    TDFFoodSelectHeaderView *header = [[TDFFoodSelectHeaderView alloc] initWithTitle:NSLocalizedString(@"套餐中不一菜一切的商品分类", nil)];
    DHTTableViewSection *section = [DHTTableViewSection section];
    section.headerView = header;
    section.headerHeight = [TDFFoodSelectHeaderView heightForView];
    [self.manager addSection:section];
    
    for (TDFSuitMenuPrinterModel *model in self.dataSource) {
        if (model.isChain) {
            if (![Platform Instance].isChain) {
                [self.chainDataSource addObject:model];
            }
            TDFTableViewIsChainItem *item = [[TDFTableViewIsChainItem alloc] init];
            item.title = model.name;
            item.isDelete = self.model.chainDataManageable;
            @weakify(self);
            item.selectedBlock = ^{
                if (self.model.chainDataManageable) {
                    @strongify(self);
                    [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"您确认要删除[%@]分类吗？", nil),model.name] cancelBlock:nil enterBlock:^{
                        [self.dataSource removeObject:model];
                        [self updateSuitMenuPrinterInfoWithKindMenuIDs:NSLocalizedString(@"正在删除", nil)];
                    }];

                }else{
                    
                }
            };
            [section addItem:item];
        }else{
            TDFTableViewItem *item = [[TDFTableViewItem alloc] init];
            item.title = model.name;
            item.preValue = @(NO);
            item.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_issue_delete"]];;
            item.style = TDFTableViewCellStyleDefault;
            item.accessoryType = TDFTableViewCellAccessoryCustomAccessoryView;
            @weakify(self);
            item.selectedBlock = ^{
                @strongify(self);
                [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"您确认要删除[%@]分类吗？", nil),model.name] cancelBlock:nil enterBlock:^{
                    [self.dataSource removeObject:model];
                    [self updateSuitMenuPrinterInfoWithKindMenuIDs:NSLocalizedString(@"正在删除", nil)];
                }];
            };
            [section addItem:item];
        }
    }
    [self.manager reloadData];
}

#pragma mark --MultiCheckHandle
- (void)multiCheck:(NSInteger)event items:(NSMutableArray*)items
{
    [self.dataSource removeAllObjects];
    if (self.chainDataSource.count != 0) {
        [self.dataSource addObjectsFromArray:self.chainDataSource];
    }
    [self.dataSource addObjectsFromArray:items];
    [self updateSuitMenuPrinterInfoWithKindMenuIDs:NSLocalizedString(@"正在保存", nil)];
}

#pragma mark --保存或删除
- (void)updateSuitMenuPrinterInfoWithKindMenuIDs:(NSString *)text
{
    [self showProgressHudWithText:text];
    NSMutableArray *kindMenuIDArray = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    for (TDFSuitMenuPrinterModel*printModel in self.dataSource) {
        if (printModel.menuID) {
            [kindMenuIDArray addObject:printModel.menuID];
        }
    }
    NSString *kindMenuIDs = [kindMenuIDArray componentsJoinedByString:@","];
    @weakify(self);
    [[TDFTransService shareInstance] updateSuitMenuPrinterInfoWithKindMenuIDs:kindMenuIDs success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud setHidden:YES];
        @strongify(self);
        [self loadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)closeMultiView:(NSInteger)event
{
    
}

#pragma mark footbtn
- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"suitMenuPrinter"];
}

- (void)footerAddButtonAction:(UIButton *)sender {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if (![Platform Instance].isChain) {
        for (TDFSuitMenuPrinterModel *model in self.model.kindMenuList) {
            if (!model.isChain) {
                [arr addObject:model];
            }
        }
    }else{
        arr = [NSMutableArray arrayWithArray:self.model.kindMenuList];
    }
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:0 delegate:self title:NSLocalizedString(@"选择分类", nil) dataTemps:arr selectList:self.dataSource needHideOldNavigationBar:NO];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark SET--GET
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)chainDataSource
{
    if (!_chainDataSource) {
        _chainDataSource = [NSMutableArray array];
    }
    return _chainDataSource;
}

-(UIView *) headView
{
    if (!_headView) {
        _headView = [[UIView alloc]init];
        _headView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        _headView.tag = 100;
        [self.view addSubview:_headView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 31)];
        label.text = @"注：本店的套餐中不一菜一切的商品分类由总部管理，暂无法添加，如需添加，请联系总部。";
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [ColorHelper getRedColor];
        label.numberOfLines = 0;
        [_headView addSubview:label];
        return _headView;
    }
    return _headView;
}

@end
