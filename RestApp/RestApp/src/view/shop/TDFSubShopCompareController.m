//
//  TDFSubShopCompareController.m
//  RestApp
//
//  Created by Cloud on 2017/3/29.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSubShopCompareController.h"
#import "DHTTableViewManager.h"
#import "TDFShopCompareItem.h"
#import "TDFShopCompareService.h"
#import "TDFShopTurnOverController.h"
#import "TDFMultipleFilterViewController.h"
#import "TDFFilterSearchBar.h"
#import "TDFMemberService.h"
#import "BranchShopVo.h"
#import "PlateVo.h"
#import "TDFShopTypeModel.h"
#import "MJRefresh.h"
#import "TDFSubShopHeader.h"

@interface TDFSubShopCompareController ()

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic ,strong) NSMutableArray<TDFShopCompareItem *> *dataArr;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) UILabel *tableTipLabel;

@property (nonatomic ,strong) UIView *tableBgView;

@property (nonatomic, strong) DHTTableViewManager *manager;

@property (nonatomic ,strong) TDFSubShopHeader *headerView;

@property (nonatomic ,strong) NSMutableDictionary *param;

@end

@implementation TDFSubShopCompareController

#pragma mark - lifeCircle

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self.manager registerCell:@"TDFShopCompareCell" withItem:@"TDFShopCompareItem"];
    
    self.type = [self.typeStr isEqualToString:@"month"]?2:1;
    
    self.pageIndex = 1;
    
    [self configLayout];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)configLayout {

    [self.view addSubview:self.headerView];
    
    [self.view addSubview:self.tableBgView];
    
    [self.view addSubview:self.tableTipLabel];
    
    [self.view addSubview:self.tableView];
    
    
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(176);
        make.top.left.right.offset(0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.headerView.mas_bottom).offset(5);
        make.left.offset(5);
        make.right.bottom.offset(-5);
    }];
    
    [self.tableTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
//        make.edges.equalTo(self.tableView);
        make.centerY.equalTo(self.tableView).with.offset(-30);
        make.leading.equalTo(self.tableView);
        make.trailing.equalTo(self.tableView);
        make.height.equalTo(self.tableView);
    }];
    
    [self.tableBgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.tableView);
    }];
}

#pragma mark - Getter

- (NSMutableArray<TDFShopCompareItem *> *)dataArr {

    if (!_dataArr) {
        
        _dataArr = [NSMutableArray<TDFShopCompareItem *> array];
    }
    return _dataArr;
}

- (DHTTableViewManager *)manager {
    
    if (!_manager) {
        
        _manager = [[DHTTableViewManager alloc]initWithTableView:self.tableView];
    }
    return _manager;
}

- (UITableView *)tableView {

    if (!_tableView) {
        
        _tableView = [UITableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            self.pageIndex = 1;
            
            [self loadData];
            
        }];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            self.pageIndex += 1;
            
            [self loadData];
        }];
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)_tableView.mj_footer;
        footer.refreshingTitleHidden = YES;
        footer.stateLabel.hidden = YES;
    }
    return _tableView;
}

- (UILabel *)tableTipLabel {

    if (!_tableTipLabel) {
        
        _tableTipLabel = [UILabel new];
        _tableTipLabel.text = @"抱歉，没有查询到任何内容...";
        _tableTipLabel.font = [UIFont systemFontOfSize:17];
        _tableTipLabel.backgroundColor = [UIColor clearColor];
        _tableTipLabel.textColor = [UIColor whiteColor];
        _tableTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tableTipLabel;
}

- (UIView *)tableBgView {
    
    if (!_tableBgView) {
        
        _tableBgView = [UIView new];
        _tableBgView.backgroundColor = [UIColor whiteColor];
        _tableBgView.alpha = 0.1;
        _tableBgView.layer.cornerRadius = 5;
        _tableBgView.layer.masksToBounds = YES;
    }
    return _tableBgView;
}

- (NSMutableDictionary *)param {

    if (!_param) {
        
        _param = [NSMutableDictionary new];
    }
    return _param;
}

- (TDFSubShopHeader *)headerView {

    if (!_headerView) {
        
        @weakify(self)
        _headerView = [[TDFSubShopHeader alloc]initWithController:self
                                                       andDateStr:self.dateStr
                                                       andTypeStr:self.typeStr
                                                      andCallBack:^(NSMutableDictionary *dic) {
                                                          
                                                          @strongify(self)
                                                          
                                                          self.pageIndex = 1;
                                                          
                                                          self.type = [dic[@"date_type"] integerValue];
                                                          
                                                          [self loadDataWithParam:dic];
        }];
        
        _headerView.back = ^(){
        
            @strongify(self)
            [self leftNavigationButtonAction:nil];
        };
    }
    return _headerView;
}

- (void)loadDataWithParam:(NSMutableDictionary *)dic {

    [self.dataArr removeAllObjects];
    
    [self.manager removeAllSections];
    
    [self.manager reloadData];
      
    self.param = dic;
    
    [self loadData];
}

#pragma mark - NetWork

- (void)loadData {
    
    [self showProgressHudWithText:NSLocalizedString(@"加载数据", nil)];
    
    __weak typeof(self) ws = self;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.param];
    
    dic[@"filter"][@"pageIndex"] = @(self.pageIndex);
    
    NSString *filter = [dic[@"filter"] yy_modelToJSONString];
    
    dic[@"filter"] = filter;
    
    [TDFShopCompareService checkShopBussinessCompareWithParam:dic CompleteBlock:^(TDFResponseModel * _Nullable response) {
        
        [self.progressHud hideAnimated:YES];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (response.error) {
            
            if (self.pageIndex>1) {
                
                self.pageIndex -=1;
            }
            
            [AlertBox show:response.error.localizedDescription];
            return ;
        }
        [ws dealWithData:response.responseObject];
    }];
}

- (void)dealWithData:(id )data {
    
    NSArray *arr = [NSArray yy_modelArrayWithClass:[TDFShopCompareItem class] json:data[@"data"][@"compareBusinesses"]];
    
    if (self.pageIndex == 1) {
        
        self.dataArr = [NSMutableArray arrayWithArray:arr];
    }else {
        
        if (arr.count == 0) {
            
            if (self.pageIndex == 1) {
                
            }else {
            
                self.pageIndex -=1;
            }
        }
        
        [self.dataArr addObjectsFromArray:arr];
    }
    
    
    [self dealWithEmptyOrNot:self.dataArr.count==0?YES:NO];
    
    double maxTurnover = [data[@"data"][@"maxActualAmount"] doubleValue];
    
    
    DHTTableViewSection *sec = [DHTTableViewSection section];
    
    for (TDFShopCompareItem *item in self.dataArr) {
        
        if (!item.maxActualAmount) {
            
            item.maxActualAmount = maxTurnover;
        }
        
        __weak typeof(item) weakItem = item;
        
        item.selectedBlock = ^(){
            
            [self didSelect:weakItem];
            
        };
        
        [sec addItem:item];
    }
    
    [self.manager removeAllSections];
    [self.manager addSection:sec];
    [self.manager reloadData];
}

- (void)dealsWithData:(id )data {

    NSArray *arr = [NSArray yy_modelArrayWithClass:[TDFShopCompareItem class] json:data[@"data"][@"compareBusinesses"]];
    

    if (self.pageIndex == 1) {
        
        [self.dataArr removeAllObjects];
    }
    [self.dataArr addObjectsFromArray:arr];
    
    [self dealWithEmptyOrNot:self.dataArr.count==0?YES:NO];
    
    
}

- (void)didSelect:(TDFShopCompareItem *)item {
    
    TDFShopTurnOverController *vc = [TDFShopTurnOverController new];
    
    vc.item = item;
    
    vc.dateType = (self.type == 1)?TDFShopTurnOverDateTypeDay:TDFShopTurnOverDateTypeMonth;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealWithEmptyOrNot:(BOOL )empty {
    
    self.tableTipLabel.hidden = !empty;
    self.tableBgView.hidden = empty;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end


















