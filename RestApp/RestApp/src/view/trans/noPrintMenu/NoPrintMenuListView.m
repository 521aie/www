//
//  NoPrintMenuListView.m
//  RestApp
//
//  Created by zxh on 14-5-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController+FooterButton.h"
#import "TDFSelectGoodsWithPlateViewController.h"
#import "TDFFoodSelectHeaderView.h"
#import "NoPrintMenuListView.h"
#import "TDFNormalSearchBar.h"
#import "TDFTableViewItem.h"
#import "TDFTransService.h"
#import "TreeNodeUtils.h"
#import <ReactiveObjC.h>
#import "TreeBuilder.h"
#import "HelpDialog.h"
#import "TreeNode.h"
#import "SampleMenuVO.h"
#import "TDFNoPrintMenuModel.h"
#import "ColorHelper.h"
#import "TDFTableViewIsChainItem.h"
#import "TDFMediator+UserAuth.h"

@interface NoPrintMenuListView()<UISearchBarDelegate>

@property (nonatomic, strong) DHTTableViewManager *manager;
@property (strong,nonatomic) TDFNormalSearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *searchBigButton;
@property (nonatomic, strong) NSArray *detailList;
@property (nonatomic, strong) NSMutableArray *headList;
@property (nonatomic, strong) NSMutableArray *backHeadList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) NSMutableDictionary *backDetailMap;
@property (strong,nonatomic) TDFNoPrintMenuModel *model;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation NoPrintMenuListView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"不出单商品", nil);
    [self.view addSubview:self.headView];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchBigButton];
    self.headView.hidden = YES;
    self.label.hidden = YES;
    self.searchBar.hidden = YES;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        if(self.navigationController.viewControllers.lastObject != self) return;
        self.searchBigButton.hidden = NO;
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        if(self.navigationController.viewControllers.lastObject != self) return;
        self.searchBigButton.hidden = YES;
    }];
    
    [self loadMenus];

    [[TDFMediator sharedInstance] TDFMediator_showShopKeepConfigurableAlertWithCode:@"PAD_NOTPRINT"];
}

#pragma mark footbtn事件
- (void)footerAddButtonAction:(UIButton *)sender {
    TDFSelectGoodsWithPlateViewController *vc = [[TDFSelectGoodsWithPlateViewController alloc] init];
    vc.plateEntityId = self.plateEntityId;
    vc.removeChain = [Platform Instance].isChain?NO:YES;

    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (TreeNode *head in self.headList) {
        NSMutableArray *menus = [self.detailMap objectForKey:head.itemId];
        for (SampleMenuVO* model in menus)  {
            [arr addObject:model._id];
        }
    }
    vc.oldArr = arr;
    vc.rightActionCallBack = ^(NSArray<TDFShopSynchModuleModel *> *models) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (TDFShopSynchModuleModel *model in models) {
            [arr addObject:model.moduleId];
        }
        [self saveSelectList:arr];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"transnot"];
}

#pragma mark 保存不出单商品
-(void) saveSelectList:(NSMutableArray*)ids
{
    if ([Platform Instance].isChain) {
        [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
        [[TDFTransService new] saveNoPrintChain:ids plateEntityId:self.plateEntityId success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hideAnimated:YES];
            [self loadMenus];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hideAnimated: YES];
            [AlertBox show:error.localizedDescription];
        }];
    }else{
        [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
        [[TDFTransService new] updateIsPrint:ids flag:@"0" success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hideAnimated:YES];
            [self loadMenus];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hideAnimated: YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

#pragma 数据加载.
-(void) loadMenus
{
    [self.headList removeAllObjects];
    [self.detailMap removeAllObjects];
    [self.backHeadList removeAllObjects];
    [self.backDetailMap removeAllObjects];
    self.detailList = [[NSArray alloc] init];

    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([Platform Instance].isChain) {
        param[@"plate_entity_id"] = self.plateEntityId;
    }
    [[TDFTransService new] listNoPrintMenuSampleWithParam:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        
        self.model = [TDFNoPrintMenuModel yy_modelWithJSON:data[@"data"]];
        [self updateViewWithaddible:self.model.addible];
        NSMutableArray *kindMenuList = self.model.pantryKindMenuVOs;
        NSMutableArray *allNodeList=[TreeBuilder buildTree:kindMenuList];
        self.headList=[TreeNodeUtils convertEndNode:allNodeList];
        self.backHeadList = [TreeNodeUtils convertEndNode:allNodeList];

        self.detailList = self.model.pantryMenuVOs;
        
        for (SampleMenuVO *menu in self.detailList) {
            menu._id   = menu.menuId;
        };
        
        NSMutableArray* arr=nil;
        for (SampleMenuVO* menu in self.detailList) {
            arr=[self.detailMap objectForKey:menu.kindMenuId];
            if (!arr) {
                arr=[NSMutableArray array];
            } else {
                [self.detailMap removeObjectForKey:menu.kindMenuId];
            }
            [arr addObject:menu];
            [self.detailMap setObject:arr forKey:menu.kindMenuId];
            [self.backDetailMap setObject:arr forKey:menu.kindMenuId ];
        }

        [self buildUI:self.headList detailMap:self.detailMap];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma mark UI布局
- (void) buildUI:(NSMutableArray *)headList detailMap:(NSMutableDictionary *)detailMap
{
    [self.manager removeAllSections];
    
    for (TreeNode *head in headList) {
        TDFFoodSelectHeaderView *header = [[TDFFoodSelectHeaderView alloc] initWithTitle:head.itemName];
        DHTTableViewSection *section = [DHTTableViewSection section];
        section.headerView = header;
        section.headerHeight = [TDFFoodSelectHeaderView heightForView];
        [self.manager addSection:section];
        
        NSMutableArray *menus = [detailMap objectForKey:head.itemId];
        for (SampleMenuVO* model in menus)  {
            if (model.chain) {
                TDFTableViewIsChainItem *item = [[TDFTableViewIsChainItem alloc] init];
                item.title = model.name;
                item.isDelete = self.model.chainDataManageable;
                @weakify(self);
                item.selectedBlock = ^{
                    if (self.model.chainDataManageable) {
                        @strongify(self);
                        SampleMenuVO* menu=(SampleMenuVO*)model;
                        [self deleteNoPrintMenuWithModel:menu];
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
                    SampleMenuVO* menu=(SampleMenuVO*)model;
                    [self deleteNoPrintMenuWithModel:menu];
                };
                [section addItem:item];
            }
            
        }
    }
    [self.manager reloadData];
}

#pragma mark 删除不出单商品
- (void)deleteNoPrintMenuWithModel:(SampleMenuVO *)menu
{
    if ([Platform Instance].isChain) {
        [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
        NSMutableArray* ids=[NSMutableArray array];
        [ids addObject:menu.relationId];
        @weakify(self);
        [[TDFTransService new] delateNoPrintChain:ids  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hideAnimated:YES];
            [self loadMenus];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            @strongify(self);
            [self.progressHud hideAnimated:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }else{
        [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
        NSMutableArray* ids=[NSMutableArray array];
        [ids addObject:menu._id];
        @weakify(self);
        [[TDFTransService new] updateIsPrint:ids flag:@"1" success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hideAnimated:YES];
            [self loadMenus];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            @strongify(self);
            [self.progressHud hideAnimated:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

#pragma mark 是否有添加权限调整界面
- (void) updateViewWithaddible:(BOOL)addible
{
    self.headView.hidden = addible;
    self.label.hidden = addible;
    if (addible) {
        [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp|TDFFooterButtonTypeAdd];
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view. mas_right);
        }];
    }else{
        [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(31);
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view. mas_right);
        }];
    }
    self.searchBar.hidden = NO;
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(48);
        make.top.equalTo(self.headView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view. mas_right);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view. mas_right);
    }];
    [self.searchBigButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView);
    }];
}

#pragma mark - Get Set

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
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
        [_manager registerCell:@"TDFTableViewIsChainCell" withItem:@"TDFTableViewIsChainItem"];
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

- (NSMutableDictionary *) detailMap
{
    if (!_detailMap) {
        _detailMap=[[NSMutableDictionary alloc] init];
    }
    return _detailMap;
}

- (NSMutableDictionary *) backDetailMap
{
    if (!_backDetailMap) {
        _backDetailMap=[[NSMutableDictionary alloc] init];
    }
    return _backDetailMap;
}

-(UIView *) headView
{
    if (!_headView) {
        _headView = [[UIView alloc]init];
        _headView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        [_headView addSubview:self.label];
        return _headView;
    }
    return _headView;
}


- (UILabel *) label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 31)];
        _label.text = @"注：本店的不出单商品是由总部管理，暂无法添加，如需添加，请联系总部。";
        _label.font = [UIFont systemFontOfSize:11];
        _label.textColor = [ColorHelper getRedColor];
        _label.numberOfLines = 0;
    }
    return _label;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    self.headList=[NSMutableArray array];
    self.detailMap=[NSMutableDictionary dictionary];
    NSMutableArray *details=nil;
    NSMutableArray* arr=nil;
    BOOL isExist=NO;
    for (id<INameValueItem> item in self.backHeadList) {
        details= [self.backDetailMap objectForKey:[item obtainItemId]];
        isExist=NO;
        BOOL nameCheck=NO;
        BOOL spellCheck=NO;
        BOOL codeCheck=NO;
        
        if ([ObjectUtil isNotEmpty:details]) {
            for (id<IImageDataItem> detail in details) {
                nameCheck=[[detail obtainItemName] rangeOfString:searchBar.text].location!=NSNotFound;
                
                if (nameCheck || spellCheck || codeCheck) {
                    arr=[self.detailMap objectForKey:[detail obtainHeadId]];
                    if (!arr) {
                        arr=[NSMutableArray array];
                    } else {
                        [self.detailMap removeObjectForKey:[detail obtainHeadId]];
                    }
                    [arr addObject:detail];
                    [self.detailMap setObject:arr forKey:[detail obtainHeadId]];
                    isExist=YES;
                }
            }
        }
        if (isExist) {
            [self.headList addObject:item];
        }
    }
    [self buildUI:self.headList detailMap:self.detailMap];
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
    [self buildUI:self.backHeadList detailMap:self.backDetailMap];
}

#pragma mark - TDFSidebarViewControllerDelegate

- (void)sidebarViewCellClick:(NSUInteger)location {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:location] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

@end
