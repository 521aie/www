//
//  TDFSelectGoodsWithPlateViewController.m
//  RestApp
//
//  Created by 刘红琳 on 2017/5/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSelectGoodsWithPlateViewController.h"
#import "TDFNormalSearchBar.h"
#import "DHTTableViewManager.h"
#import "TDFFoodSelectHeaderView.h"
#import "TDFTableViewItem.h"
#import <TDFRootViewController+FooterButton.h>
#import "TDFSidebarViewController.h"
#import "TDFNameItemSimpleModel.h"
#import <ReactiveObjC.h>
#import <TDFMediator+MenuModule.h>
#import "TDFAlertAPIHUDPresenter.h"
#import "TDFTransGoodsListApi.h"
#import "TDFShopSynchGroupModel.h"
#import <TDFBatchOperation.h>
#import "TDFEmptyView.h"

@interface TDFSelectGoodsWithPlateViewController ()<TDFSidebarViewControllerDelegate,UISearchBarDelegate>
@property (strong,nonatomic) TDFNormalSearchBar *searchBar;

@property (nonatomic, strong) DHTTableViewManager *manager;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *circelButton;

@property (nonatomic,copy) NSArray<TDFShopSynchGroupModel *> *dataSource;

@property (nonatomic,copy) NSArray<TDFShopSynchGroupModel *> *buildDataSource;

@property (nonatomic,copy) NSArray<NSString *> *categrayDataList;

@property (strong, nonatomic) TDFTransGoodsListApi *issueGoodsListApi;

@property (strong, nonatomic) TDFAlertAPIHUDPresenter *HUDPresenter;

@property (nonatomic,strong) UIButton *searchBigButton;
@property (strong,nonatomic) TDFEmptyView *emptyView;

@end

@implementation TDFSelectGoodsWithPlateViewController

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"选择商品", nil) ;
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(48);
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view. mas_right);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view. mas_right);
    }];
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.circelButton];
    [self.circelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-64);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.searchBigButton];
    [self.searchBigButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView);
    }];
    
    [self changeFooterView];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        if(self.navigationController.viewControllers.lastObject != self) return;
        self.searchBigButton.hidden = NO;
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        if(self.navigationController.viewControllers.lastObject != self) return;
        self.searchBigButton.hidden = YES;
    }];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Method

- (void)buildUI {
    
    //-----------------分类索引--------------------//
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.buildDataSource.count];
    [self.buildDataSource tdf_forEach:^(TDFShopSynchGroupModel *model) {
        [temp addObject:model.groupName];
    }];
    
    self.categrayDataList = [temp copy];
    //------------------------------------------//
    
    [self.manager removeAllSections];
    [self.buildDataSource enumerateObjectsUsingBlock:^(TDFShopSynchGroupModel * _Nonnull groupModel, NSUInteger sectionIdx, BOOL * _Nonnull stop) {
        DHTTableViewSection *section = [DHTTableViewSection section];
        TDFFoodSelectHeaderView *header;
        header = [[TDFFoodSelectHeaderView alloc] initWithTitle:groupModel.groupName isSelected:[self isAllCheckInSection:sectionIdx]];
        
        @weakify(self);
        header.selectedBlock = ^(BOOL isSelected) {
            @strongify(self);
            [self changeDataItemInSection:section selected:isSelected applyToAll:NO];
        };
        section.headerView = header;
        section.headerHeight = [TDFFoodSelectHeaderView heightForView];
        
        [groupModel.moduleVos enumerateObjectsUsingBlock:^(TDFShopSynchModuleModel * _Nonnull model, NSUInteger rowIdx, BOOL * _Nonnull stop) {
            TDFTableViewItem *item = [[TDFTableViewItem alloc] init];
            item.title = model.name;
            item.style = TDFTableViewCellStyleDefault;
            item.accessoryType = TDFTableViewCellAccessoryCircleSelect;
            item.preValue = @(model.isCheck);
            item.selected = model.isCheck;
            
            item.didSelectRowBlock = ^(BOOL isSelected) {
                model.isCheck = isSelected;
                [header changeSelected:[self isAllCheckInSection:sectionIdx]];
                [self shouldChangeNavTitles];
            };
            [section addItem:item];
        }];
        
        [self.manager addSection:section];
    }];
    [self.manager reloadData];
}

- (BOOL)isAllCheckInSection:(NSInteger)section {
    TDFShopSynchGroupModel *sectionModel = self.buildDataSource[section];
    
    __block BOOL isAllCheck = YES;
    [sectionModel.moduleVos tdf_forEach:^(TDFShopSynchModuleModel *model) {
        if(isAllCheck) {
            isAllCheck = model.isCheck;
        }
    }];
    
    return isAllCheck;
}

- (void)rightNavigationButtonAction:(id)sender {
    NSMutableArray *tempArray = [NSMutableArray array];
    
    [self.dataSource enumerateObjectsUsingBlock:^(TDFShopSynchGroupModel * _Nonnull groupModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [groupModel.moduleVos enumerateObjectsUsingBlock:^(TDFShopSynchModuleModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if(model.isCheck) {
                [tempArray addObject:model];
            }
        }];
    }];
    
    !self.rightActionCallBack?:self.rightActionCallBack([tempArray copy]);
    
    [self.navigationController popViewControllerAnimated:YES];
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
        if(!isChange) {
            NSArray *temp = [section.items tdf_filter:^BOOL(TDFTableViewItem *item) {
                return [item.preValue boolValue] != item.isSelected;
            }];
            isChange = temp.count > 0;
        }
    }];
    
    return isChange;
}

- (void)changeFooterView {
    
    [self.footerButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.titleLabel.text isEqualToString:@"其他"]) {
            
            [obj setBackgroundImage:[UIImage imageNamed:@"icon_foot_mamager"] forState:UIControlStateNormal];
            [obj setTitle:nil forState:UIControlStateNormal];
            
            *stop = YES;
        }
    }];
}

- (void)categrayButtonAction {
//    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.dataSource.count];
//    [self.dataSource tdf_forEach:^(TDFShopSynchGroupModel *model) {
//        [temp addObject:model.groupName];
//    }];
    TDFSidebarViewController *vc = [TDFSidebarViewController sidebarControllerWithTitles:self.categrayDataList circleButton:self.circelButton];
    vc.delegate = self;
    [vc presentViewController:self];
}

- (void)changeDataItemInSection:(DHTTableViewSection *)section selected:(BOOL)selected applyToAll:(BOOL)isAll{
    if(isAll) {
        NSArray *sections = self.manager.sections;
        
        [sections tdf_forEach:^(DHTTableViewSection *section) {
            
            TDFFoodSelectHeaderView *header = (TDFFoodSelectHeaderView *)section.headerView;
            [header changeSelected:selected];
            
            [self changeDataItemInSection:section selected:selected applyToAll:NO];
        }];
    }else {
        NSArray *items = section.items;
        
        [items tdf_forEach:^(TDFTableViewItem *item) {
            item.selected = selected;
            
            TDFShopSynchGroupModel *model = self.buildDataSource[item.indexPath.section];
            model.moduleVos[item.indexPath.row].isCheck = selected;
        }];
        
        [self.manager reloadData];
    }
    [self shouldChangeNavTitles];
}

#pragma mark - Network

- (void)loadData {

    self.issueGoodsListApi.plateEntityId = self.plateEntityId;
    self.issueGoodsListApi.removeChain = self.removeChain;
    @weakify(self);
    [self.issueGoodsListApi setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response){
        @strongify(self);
        self.dataSource = response;
        self.buildDataSource = response;
        if(self.dataSource.count <= 0) {
            self.emptyView.hidden = NO;
            self.tableView.hidden = YES;
            self.searchBar.hidden = YES;
            self.circelButton.hidden = YES;
        }else {
            self.emptyView.hidden = YES;
            self.tableView.hidden = NO;
            self.searchBar.hidden = NO;
            self.circelButton.hidden = NO;
            [self generateFooterButtonWithTypes:TDFFooterButtonTypeAllCheck | TDFFooterButtonTypeNotAllCheck];
        }
        [self.dataSource tdf_forEach:^(TDFShopSynchGroupModel *groupModel) {
            [groupModel.moduleVos tdf_forEach:^(TDFShopSynchModuleModel *model) {
                model.isCheck = [self.oldArr containsObject:model.moduleId];
            }];
        }];

        [self buildUI];
    }];
    
    [self.issueGoodsListApi start];
}

#pragma mark - FooterButton

- (void)footerAllCheckButtonAction:(UIButton *)sender {
    [self changeDataItemInSection:nil selected:YES applyToAll:YES];
}

- (void)footerNotAllCheckButtonAction:(UIButton *)sender {
    [self changeDataItemInSection:nil selected:NO applyToAll:YES];
}

#pragma mark - TDFSidebarViewControllerDelegate

- (void)sidebarViewCellClick:(NSUInteger)location {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:location] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    [self.dataSource tdf_forEach:^(TDFShopSynchGroupModel *groupModel) {
        NSArray *models = [groupModel.moduleVos tdf_filter:^BOOL(TDFShopSynchModuleModel *model) {
            return [model.name containsString:searchBar.text];
        }];
        
        if(models.count > 0) {
            TDFShopSynchGroupModel *tempModel = [groupModel copy];
            tempModel.moduleVos = [models copy];
            [tempArray addObject:tempModel];
        }
    }];
    
    self.buildDataSource = [tempArray copy];
    [self buildUI];
    [self.view endEditing:YES];
     [self.searchBar cancelButtonEnable:YES show:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    [self.view endEditing:YES];
    searchBar.text = nil;
    self.buildDataSource = self.dataSource;
    [self buildUI];
}

#pragma mark - Get Set

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.opaque=NO;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 76, 0);
    }
    return _tableView;
}

- (DHTTableViewManager *)manager
{
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
        [_manager registerCell:@"TDFTableViewCell" withItem:@"TDFTableViewItem"];
    }
    
    return _manager;
}

- (TDFNormalSearchBar *)searchBar {
    if(!_searchBar) {
        _searchBar = [TDFNormalSearchBar searchBar];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"商品名称";
    }
    return _searchBar;
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
        [_circelButton setTitle:NSLocalizedString(@"分类", nil) forState:UIControlStateNormal];
        [_circelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _circelButton;
}

- (NSArray *)dataSource {
    if(!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

- (NSArray<TDFShopSynchGroupModel *> *)buildDataSource {
    if(!_buildDataSource) {
        _buildDataSource = [NSArray array];
    }
    return _buildDataSource;
}

- (TDFTransGoodsListApi *)issueGoodsListApi {
    if (!_issueGoodsListApi) {
        _issueGoodsListApi = [[TDFTransGoodsListApi alloc] init];
        _issueGoodsListApi.presenter = self.HUDPresenter;
    }
    
    return _issueGoodsListApi;
}

- (TDFAlertAPIHUDPresenter *)HUDPresenter {
    if (!_HUDPresenter) {
        _HUDPresenter = [TDFAlertAPIHUDPresenter HUDWithView:self.view];
    }
    
    return _HUDPresenter;
}

- (UIButton *)searchBigButton {
    if(!_searchBigButton) {
        _searchBigButton = [[UIButton alloc] init];
        _searchBigButton.hidden = YES;
        @weakify(self);
        [[_searchBigButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.view endEditing:YES];
            if(self.searchBar.text.length > 0) {
                 [self.searchBar cancelButtonEnable:YES show:YES];
            }else {
                 [self.searchBar cancelButtonEnable:YES show:NO];;
            }
        }];
    }
    return _searchBigButton;
}

- (TDFEmptyView *)emptyView {
    if(!_emptyView) {
        _emptyView = [TDFEmptyView emptyViewWithContent:@"该品牌下暂无商品,\n请先关联商品吧!"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

@end
