//
//  TDFShopPowerEditViewController.m
//  RestApp
//
//  Created by zishu on 16/10/14.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFShopPowerEditViewController.h"
#import "DHTTableViewManager.h"
#import "TDFChainMenuService.h"
#import "SimpleBranchVo.h"
#import <ReactiveObjC.h>
#import "TDFFoodSelectHeaderView.h"
#import <TDFBatchOperation.h>
#import "TDFMultiSwitchItem.h"
#import "TDFSidebarViewController.h"
#import "TDFEmptyItem.h"
#import "TDFEditViewHelper.h"
#import "ColorHelper.h"

@interface TDFShopPowerEditViewController ()<TDFSidebarViewControllerDelegate>

@property (nonatomic, strong) DHTTableViewManager *manager;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *circelButton;
@property (nonatomic , strong) NSArray *dataSource;
@property (nonatomic , strong) NSMutableArray *saveArr;

@end

@implementation TDFShopPowerEditViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryChainShopPower];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:NSLocalizedString(@"%@-权限设置", nil),self.plate.name];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.view addSubview:self.circelButton];
    [self.circelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-64);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(40);
    }];

    [self configureManager];
}
    
- (void) queryChainShopPower
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"plate_entity_id"] = self.plate.entityId;
    @weakify(self);
    [[TDFChainMenuService new] queryChainShopPowerWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        self.dataSource = [NSArray yy_modelArrayWithClass:[SimpleBranchVo class] json:data[@"data"]];
        [self buildUI];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma mark - Method

- (void)buildUI {
    [self.manager removeAllSections];
     [self.saveArr removeAllObjects];
    
    if(self.dataSource.count <= 0) {
        DHTTableViewSection *section = [DHTTableViewSection section];
        TDFEmptyItem *emptyItem = [[TDFEmptyItem alloc] init];
        emptyItem.title = NSLocalizedString(@"该品牌下没有门店，请先关联门店。", nil);
        [section addItem:emptyItem];
        [self.manager addSection:section];
    }
    
    [self.dataSource tdf_forEach:^(SimpleBranchVo *model) {
        DHTTableViewSection *section = [DHTTableViewSection section];
        TDFFoodSelectHeaderView *header;
        header = [[TDFFoodSelectHeaderView alloc] initWithTitle:model.branchName];
        section.headerView = header;
        section.headerHeight = [TDFFoodSelectHeaderView heightForView];
        
        [model.simpleShopVoList tdf_forEach:^(SimpleShopVo *model) {
            TDFMultiSwitchItem *item = [[TDFMultiSwitchItem alloc] init];
            item.title = model.name;
            
            if (model.joinMode == 1) {
                item.subtitle = NSLocalizedString(@"直营", nil);
                item.subtitleColor = [ColorHelper getTipColor6];
            }else{
                if (model.joinMode == 0) {
                    item.subtitle = NSLocalizedString(@"加盟", nil);
                }else if (model.joinMode == 2)
                {
                    item.subtitle = NSLocalizedString(@"合作", nil);
                }else if (model.joinMode == 3)
                {
                    item.subtitle = NSLocalizedString(@"合营", nil);
                }
                item.subtitleColor = [ColorHelper getRedColor];
            }
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [model.switchList tdf_forEach:^(TDFSwitchModel *model) {
                TDFSwitchItem *switchItem = [[TDFSwitchItem alloc] init];
                switchItem.tdf_title([NSString stringWithFormat:@"•%@",model.name]).tdf_isOn([model.status boolValue]).tdf_detail(nil).tdf_preValue(@([model.status boolValue])).tdf_requestValue(@([model.status boolValue]));
                __weak typeof(switchItem) weakItem = switchItem;
                switchItem.filterBlock = ^ (BOOL isOn) {
                    weakItem.isOn = isOn;
                    model.status = [NSNumber numberWithInt:isOn];
                    [self shouldChangeNavTitles];
                    if (isOn != [weakItem.preValue boolValue]) {
                        [self.saveArr addObject:model];
                    }
                    return YES;
                };
                [arr addObject:switchItem];
            }];
            item.switchItems = arr;
            [section addItem:item];
        }];
        [self.manager addSection:section];
    }];
    [self.manager reloadData];
}

#pragma mark SET---GET
-(UITableView *) tableView
{
    if (! _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.opaque=NO;
    }
    return _tableView;
}

- (UIButton *)circelButton {
    if(!_circelButton) {
        _circelButton = [[UIButton alloc] init];
        _circelButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Ico_Crile"]];
        [_circelButton addTarget:self action:@selector(categrayButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_circelButton setImage:[UIImage imageNamed:@"Ico_Kind_Menu.png"] forState:UIControlStateNormal];
        [_circelButton setTitleEdgeInsets:UIEdgeInsetsMake(25, -25, 0, -12)];
        _circelButton.imageEdgeInsets = UIEdgeInsetsMake(-14, 0, 0, -32);
        _circelButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_circelButton setTitle:NSLocalizedString(@"分公司", nil) forState:UIControlStateNormal];
        [_circelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _circelButton;
}

- (DHTTableViewManager *)manager
{
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
    }
    return _manager;
}

- (NSMutableArray *) saveArr
{
    if (!_saveArr) {
        _saveArr = [[NSMutableArray alloc] init];
    }
    return _saveArr;
}

#pragma mark circelButtonCilck
- (void)categrayButtonAction {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    [self.dataSource tdf_forEach:^(SimpleBranchVo *model) {
        [temp addObject:model.branchName];
    }];
    TDFSidebarViewController *vc = [TDFSidebarViewController sidebarControllerWithTitles:[temp copy] circleButton:self.circelButton];
    vc.delegate = self;
    [vc presentViewController:self];
}

#pragma mark - DHTableViewManager

- (void)configureManager {
     [self.manager registerCell:@"TDFMultiSwitchCell" withItem:@"TDFMultiSwitchItem"];
    [self.manager registerCell:@"TDFEmptyCell" withItem:@"TDFEmptyItem"];
     [self.manager registerCell:@"TDFSwitchCell" withItem:@"TDFSwitchItem"];
}

#pragma mark - TDFSidebarViewControllerDelegate

- (void)sidebarViewCellClick:(NSUInteger)location {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:location] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void) rightNavigationButtonAction:(id)sender
{
    [self save];
}

- (void) save
{
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"switches_str"] = [self.saveArr yy_modelToJSONString];
    @weakify(self);
    [[TDFChainMenuService new] saveChainShopPowerWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        self.shopPowerCallBack(YES);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)shouldChangeNavTitles {
    if ([self isAnyChange]) {
        [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:@"ico_ok" rightButtonName:NSLocalizedString(@"保存", nil)];
    } else {
        [self configLeftNavigationBar:@"icon_back" leftButtonName:NSLocalizedString(@"返回", nil)];
        [self configRightNavigationBar:nil rightButtonName:nil];
    }
}

- (BOOL)isAnyChange
{
    __block BOOL isChange = NO;
    [self.manager.sections tdf_forEach:^(DHTTableViewSection *section) {
        [section.items tdf_forEach:^(TDFMultiSwitchItem *item) {
            if(!isChange) {
                NSArray *temp = [item.switchItems tdf_filter:^BOOL(TDFSwitchItem *switchItem) {
                    return [switchItem.preValue boolValue] != switchItem.isOn;
                }];
                isChange = temp.count > 0;
            }
        }];
    }];
    
    return isChange;

}

@end
