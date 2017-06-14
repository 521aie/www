//
//  TDFSubShopHeader.m
//  RestApp
//
//  Created by Cloud on 2017/4/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSubShopHeader.h"

#import "TDFMultipleFilterViewController.h"
#import "TDFFilterSearchBar.h"
#import "TDFMemberService.h"
#import "BranchShopVo.h"
#import "PlateVo.h"
#import "TDFShopTypeModel.h"


@interface TDFSubShopHeader ()<TDFMultipleFilterViewDelegate>

@property (nonatomic ,copy) NSString *fromOutSidepassedDateString;

@property (nonatomic ,strong) NSDate *fromOutSidepassedDate;


//日或者月，1日 2月
@property (nonatomic ,assign) NSInteger type;

@property (nonatomic ,copy) NSString *dateStr;

@property (nonatomic ,strong) NSDate *date;

@property (nonatomic ,strong) NSDateFormatter *dateFormatter;

@property (nonatomic ,strong) UISegmentedControl *typeControl;

@property (nonatomic ,strong) UIView *titleView;

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UIButton *backBtn;

@property (nonatomic ,strong) UIView *tabHeaderView;

@property (nonatomic ,strong) UILabel *tabTitleLabel;

@property (nonatomic ,strong) UILabel *tabDateLabel;

@property (nonatomic ,strong) UIButton *tabLeftBtn;

@property (nonatomic ,strong) UIButton *tabRightBtn;

@property (nonatomic ,strong) UILabel *tableTipLabel;

@property (nonatomic,strong) NSMutableDictionary *filterDic;

@property (nonatomic, strong) TDFFilterSearchBar *searchPanelView;

@property (nonatomic, strong) NSMutableArray *filterDataSource;

@property (nonatomic, strong) TDFMultipleFilterViewController *filter;

@property (nonatomic ,copy) void(^callBack)(NSMutableDictionary *dic);

@property (nonatomic ,strong) UIViewController *vc;

@property (nonatomic ,strong) NSMutableArray *plateids;



@property (nonatomic ,strong) NSMutableArray *branchList;

@property (nonatomic ,strong) NSMutableArray *plateList;

@property (nonatomic ,strong) NSMutableArray *joinModeList;


@property (nonatomic ,strong) NSMutableArray *beginList;


@end

@implementation TDFSubShopHeader

- (instancetype)initWithController:(UIViewController *)vc
                        andDateStr:(NSString *)date
                        andTypeStr:(NSString *)type
                       andCallBack:(void(^)(NSMutableDictionary *dic))dic {
    
    if (self = [super init]) {
        
        self.vc = vc;
        
        self.callBack = dic;
        
        self.type = [type isEqualToString:@"month"]?2:1;
        
        self.typeControl.selectedSegmentIndex = self.type-1;
        
        self.fromOutSidepassedDateString = date;
        
        [self initDate];
        
        [self makeDate];
        
        [self updateDate];
        
        [self configLayout];
        
        [self loadFilterDataSource];
    }
    return self;
}

- (void)configLayout {
    
    __weak typeof(self) ws = self;
    
    [self addSubview:self.titleView];
    [self addSubview:self.searchPanelView];
    [self.titleView addSubview:self.backBtn];
    [self.titleView addSubview:self.titleLabel];
    [self.titleView addSubview:self.typeControl];
    
    
    [self addSubview:self.tabHeaderView];
    [self.tabHeaderView addSubview:self.tabTitleLabel];
    [self.tabHeaderView addSubview:self.tabDateLabel];
    [self.tabHeaderView addSubview:self.tabLeftBtn];
    [self.tabHeaderView addSubview:self.tabRightBtn];
    
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(20);
        make.left.offset(0);
        make.right.offset(0);
        make.height.mas_equalTo(44);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.offset(0);
        make.top.offset(0);
        make.left.offset(0);
        make.width.mas_equalTo(40);
    }];
    
    [self.typeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-10);
        make.top.offset(5);
        make.bottom.offset(-5);
        make.width.mas_equalTo(60);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(ws.titleView.mas_centerX);
        make.bottom.offset(0);
        make.top.offset(0);
    }];
    
    [self.searchPanelView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.offset(0);
        make.top.equalTo(ws.titleView.mas_bottom);
        make.height.mas_equalTo(48);
    }];
    
    
    [self.tabHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(ws.searchPanelView.mas_bottom);
        make.left.offset(0);
        make.right.offset(0);
        make.height.mas_equalTo(64);
    }];
    
    [self.tabTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.equalTo(ws.tabHeaderView.mas_height).multipliedBy(0.5);
    }];
    
    [self.tabLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(0);
        make.width.mas_equalTo(60);
        make.bottom.offset(0);
        make.top.equalTo(ws.tabTitleLabel.mas_bottom);
    }];
    
    [self.tabRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(0);
        make.width.mas_equalTo(60);
        make.bottom.offset(0);
        make.top.equalTo(ws.tabTitleLabel.mas_bottom);
    }];
    
    [self.tabDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(ws.tabTitleLabel.mas_bottom);
        make.bottom.offset(0);
        make.centerX.equalTo(ws.tabTitleLabel);
    }];
    
}

#pragma mark - getter

- (UISegmentedControl *)typeControl {
    
    if (!_typeControl) {
        
        _typeControl = [[UISegmentedControl alloc]initWithItems:@[@"日",@"月"]];
        
        [_typeControl addTarget:self action:@selector(segmentDidSelect:) forControlEvents:UIControlEventValueChanged];
        
        _typeControl.tintColor = [UIColor lightGrayColor];
        
        _typeControl.selectedSegmentIndex = 0;
        
        [_typeControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        
        [_typeControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    }
    return _typeControl;
}

- (UIView *)titleView {
    
    if (!_titleView) {
        
        _titleView = [UIView new];
    }
    return _titleView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [UILabel new];
        
        _titleLabel.text = @"门店营业额对比";
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.textColor = [UIColor whiteColor];
        
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    
    if (!_backBtn) {
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_backBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        
        UIImage *backIcon = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_back"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
        [_backBtn setImage:backIcon forState:UIControlStateNormal];
        
        [_backBtn addTarget:self action:@selector(leftNavigationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIView *)tabHeaderView {
    if (!_tabHeaderView) {
        
        _tabHeaderView = [UIView new];
    }
    return _tabHeaderView;
}
- (UILabel *)tabTitleLabel {
    if (!_tabTitleLabel) {
        
        _tabTitleLabel = [UILabel new];
        _tabTitleLabel.text = @" ";
        _tabTitleLabel.font = [UIFont systemFontOfSize:13];
        _tabTitleLabel.textColor = [UIColor whiteColor];
        _tabTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tabTitleLabel;
}
- (UILabel *)tabDateLabel {
    if (!_tabDateLabel) {
        
        _tabDateLabel = [UILabel new];
        _tabDateLabel.text = @"xxxx年xx月xx日";
        _tabDateLabel.font = [UIFont systemFontOfSize:12];
        _tabDateLabel.textColor = [UIColor lightGrayColor];
    }
    return _tabDateLabel;
}
- (UIButton *)tabLeftBtn {
    if (!_tabLeftBtn) {
        _tabLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tabLeftBtn setTitle:@"前一天" forState:UIControlStateNormal];
        [_tabLeftBtn setImage:[UIImage imageNamed:@"business_bar_chart_left_arrow"] forState:UIControlStateNormal];
        _tabLeftBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_tabLeftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_tabLeftBtn addTarget:self action:@selector(preDate) forControlEvents:UIControlEventTouchUpInside];
        _tabLeftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    }
    return _tabLeftBtn;
}
- (UIButton *)tabRightBtn {
    if (!_tabRightBtn) {
        _tabRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tabRightBtn setTitle:@"后一天" forState:UIControlStateNormal];
        [_tabRightBtn setImage:[UIImage imageNamed:@"business_arrow_icon_right"] forState:UIControlStateNormal];
        _tabRightBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_tabRightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_tabRightBtn addTarget:self action:@selector(nextDate) forControlEvents:UIControlEventTouchUpInside];
        _tabRightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 34, 0, -34);
        _tabRightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 12);
    }
    return _tabRightBtn;
}

- (UILabel *)tableTipLabel {
    
    if (!_tableTipLabel) {
        
        _tableTipLabel = [UILabel new];
        _tableTipLabel.text = @"抱歉，没有查询到任何内容...";
        _tableTipLabel.font = [UIFont boldSystemFontOfSize:17];
        _tableTipLabel.backgroundColor = [UIColor clearColor];
        _tableTipLabel.textColor = [UIColor whiteColor];
        _tableTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tableTipLabel;
}

- (TDFFilterSearchBar *)searchPanelView {
    //在筛选框和查询之间的互斥问题需要确定
    if(!_searchPanelView) {
        
        __weak typeof(self) ws = self;
        
        _searchPanelView = [[TDFFilterSearchBar alloc] init];
        [_searchPanelView changeFilterLabelColor:[UIColor whiteColor]];
        _searchPanelView.beginSearchCallBack = ^{
            
            [ws.searchPanelView.searchTextField resignFirstResponder];
            [ws.searchPanelView changeFilterLabelColor:[UIColor whiteColor]];
            [ws.filter gotoRest];
            [ws.filterDic removeObjectForKey:@"branchEntityIds"];
            [ws.filterDic removeObjectForKey:@"joinModes"];
            [ws.filterDic removeObjectForKey:@"plateEntityIds"];
            //            [ws.filterDic setObject:ws.plateids forKey:@"plateEntityIds"];
            ws.filterDic[@"type"] = @"2";
            ws.filterDic[@"keyword"] = ws.searchPanelView.searchTextField.text;
            ws.tabTitleLabel.text = @"全部";
            [ws loadNew];
        };
        
        _searchPanelView.beginFilterCallBack = ^{
            
            [ws.searchPanelView.searchTextField resignFirstResponder];
            [ws beginFileter];
        };
    }
    return _searchPanelView;
}


- (NSDateFormatter *)dateFormatter {
    
    if (!_dateFormatter) {
        
        _dateFormatter = [NSDateFormatter new];
    }
    return _dateFormatter;
}

- (void)beginFileter {
    
    if (!self.filterDataSource) {
        
        return;
    }
    
    if (!_filter) {
        
        self.beginList = [NSMutableArray new];
        
        TDFMultipleFilterModel *model1 = [TDFMultipleFilterModel new];
        model1.title = @"分公司（可多选）";
        model1.isRadio = NO;
        
        TDFMultipleFilterModel *model2 = [TDFMultipleFilterModel new];
        model2.title = @"品牌（单选）";
        model2.isRadio = YES;
        
        TDFMultipleFilterModel *model3 = [TDFMultipleFilterModel new];
        model3.title = @"门店类型（可多选）";
        model3.isRadio = NO;
        
        NSMutableArray *titles = [NSMutableArray new];
        
        NSMutableArray *datas = [NSMutableArray new];
        
        
        //    self.filterDic[@"branchEntityIds"] = branchEntityIds;
        //    self.filterDic[@"joinModes"] = joinModes;
        //    self.filterDic[@"plateEntityIds"] = plateEntityIds;
        
        if (self.branchList.count) {
            
            [titles addObject:model1];
            [datas addObject:self.branchList];
            [self.beginList addObject:@{@"branchEntityIds":self.branchList}];
        }
        
        if (self.plateList.count) {
            
            [titles addObject:model2];
            [datas addObject:self.plateList];
            [self.beginList addObject:@{@"plateEntityIds":self.plateList}];
        }
        
        if (self.joinModeList.count) {
            
            [titles addObject:model3];
            [datas addObject:self.joinModeList];
            [self.beginList addObject:@{@"joinModes":self.joinModeList}];
        }
        
        self.filter = [TDFMultipleFilterViewController filterControllerWithTitles:titles sectionDataSource:datas delegate:self];
    }
    
    self.searchPanelView.filterFoldIcon.image = [UIImage imageNamed:@"ico_up_gray"];
    [self.filter presentViewController];
}

- (NSMutableDictionary *)filterDic {
    if(!_filterDic) {
        _filterDic = [NSMutableDictionary dictionaryWithCapacity:7];
        _filterDic[@"moduleType"] = @"1";
        _filterDic[@"type"] = @"1";
    }
    return _filterDic;
}

- (NSMutableArray *)plateids {
    
    if (!_plateids) {
        
        _plateids = [NSMutableArray new];
    }
    return _plateids;
}

#pragma mark - funcs

- (void)segmentDidSelect:(UISegmentedControl *)control {
    
    self.type = control.selectedSegmentIndex+1;
    
    self.date = [NSDate date];
    
    //    self.date = self.fromOutSidepassedDate;
    
    [self updateDate];
}

- (void)leftNavigationButtonAction {
    
    if (self.back) {
        
        self.back();
    }
}

- (void)preDate {
    
    [self moveDatePre:YES];
}

- (void)nextDate {
    
    [self moveDatePre:NO];
}

- (void)moveDatePre:(BOOL)isPre {
    
    NSDateComponents * components = [[NSDateComponents alloc] init];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    if (self.type == 2) {
        
        components.month = isPre?-1:1;
        
        self.date = [calendar dateByAddingComponents:components toDate:self.date options:NSCalendarMatchStrictly];
        
    }else {
        
        components.day = isPre?-1:1;
        
        self.date = [calendar dateByAddingComponents:components toDate:self.date options:NSCalendarMatchStrictly];
    }
    
    [self updateDate];
}


- (void)makeDate {
    
    if (self.type == 1) {//日
        
        self.dateFormatter.dateFormat = @"yyyyMMdd";
        
    }else {//月
        
        self.dateFormatter.dateFormat = @"yyyyMM";
    }
    self.date = [self.dateFormatter dateFromString:self.fromOutSidepassedDateString];
}

- (void)initDate {
    
    if (self.type == 1) {//日
        
        self.dateFormatter.dateFormat = @"yyyyMMdd";
        
    }else {//月
        
        self.dateFormatter.dateFormat = @"yyyyMM";
    }
    self.fromOutSidepassedDate = [self.dateFormatter dateFromString:self.fromOutSidepassedDateString];
}

- (void)updateDate {
    
    [self judgeBtnShouldHide];
    
    if (self.type == 1) {
        
        [self.tabLeftBtn setTitle:@"前一天" forState:UIControlStateNormal];
        [self.tabRightBtn setTitle:@"后一天" forState:UIControlStateNormal];
        self.dateFormatter.dateFormat = @"yyyyMMdd";
        self.dateStr = [self.dateFormatter stringFromDate:self.date];
        self.dateFormatter.dateFormat = @"yyyy年MM月dd日";
        
    }else {
        [self.tabLeftBtn setTitle:@"上个月" forState:UIControlStateNormal];
        [self.tabRightBtn setTitle:@"下个月" forState:UIControlStateNormal];
        self.dateFormatter.dateFormat = @"yyyyMM";
        self.dateStr = [self.dateFormatter stringFromDate:self.date];
        self.dateFormatter.dateFormat = @"yyyy年MM月";
    }
    
    self.tabDateLabel.text = [self.dateFormatter stringFromDate:self.date];
    
    [self loadNew];
}

- (void)judgeBtnShouldHide {
    
    NSDateComponents * components = [[NSDateComponents alloc] init];
    
    if (self.type == 2) {
        
        self.dateFormatter.dateFormat = @"yyyyMM";
        
        self.tabRightBtn.hidden = [[self.dateFormatter stringFromDate:self.date] isEqualToString:[self.dateFormatter stringFromDate:[NSDate date]]]?YES:NO;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        components.month = -11;
        
        NSDate *lastestDate = [calendar dateByAddingComponents:components toDate:[NSDate date] options:NSCalendarMatchStrictly];
        
        self.tabLeftBtn.hidden = [[self.dateFormatter stringFromDate:self.date] isEqualToString:[self.dateFormatter stringFromDate:lastestDate]]?YES:NO;
        
    }else {
        
        self.dateFormatter.dateFormat = @"yyyyMMdd";
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        self.tabRightBtn.hidden = [[self.dateFormatter stringFromDate:self.date] isEqualToString:[self.dateFormatter stringFromDate:[NSDate date]]];
        
        components.day = -90;
        
        NSDate *lastestDate = [calendar dateByAddingComponents:components toDate:[NSDate date] options:NSCalendarMatchStrictly];
        
        self.tabLeftBtn.hidden = [[self.dateFormatter stringFromDate:self.date] isEqualToString:[self.dateFormatter stringFromDate:lastestDate]]?YES:NO;
    }
}


#pragma mark - load
- (void)loadFilterDataSource {
    
    @weakify(self);
    [[[TDFMemberService alloc] init] getShopFilterWithSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        
        self.filterDataSource = [NSMutableArray array];
        NSDictionary *dic = data[@"data"];
        
        NSArray *tempArray = dic[@"branchList"];
        //@"分公司（可多选）"
        self.branchList = [NSMutableArray array];
        [tempArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BranchShopVo *branchShopVo = [[BranchShopVo alloc] initWithDictionary:obj];
            [self.branchList addObject:branchShopVo];
        }];
        [self.filterDataSource addObject:self.branchList];
        //@"品牌（可多选）"
        tempArray = dic[@"plateList"];
        self.plateList = [NSMutableArray array];
        [tempArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PlateVo *plateVo = [[PlateVo alloc] initWithDictionary:obj];
            [self.plateList addObject:plateVo];
        }];
        [self.filterDataSource addObject:self.plateList];
        //@"门店类型（可多选）"
        self.joinModeList = [NSMutableArray array];
        NSArray *list = [NSArray yy_modelArrayWithClass:[TDFShopTypeModel class] json:dic[@"joinModeList"]];
        [self.joinModeList addObjectsFromArray:list];
        [self.filterDataSource addObject:self.joinModeList];
        
        if (self.plateList.count) {
            self.tabTitleLabel.text = ((PlateVo *)self.plateList[0]).plateName;
        }
        
        if (self.plateList.count) {
            
            NSArray *arr = @[((PlateVo *)self.plateList[0]).plateEntityId];
            
            [self.plateids addObjectsFromArray:arr];
            
            [self.filterDic setObject:arr forKey:@"plateEntityIds"];
        }
        
        [self updateDate];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma mark - delegate

- (void)multipleFilterViewHidden:(TDFMultipleFilterViewController *)multipleFilterView {
    
    self.searchPanelView.filterFoldIcon.image = [UIImage imageNamed:@"ico_down_gray"];
}

/**
 点击确定按钮
 
 @return indexPath 返回选中的选项位置，已经剔除“全部” 根据isChange判断是否有数据更改，来定制是否需要重新加载数据
 */
- (void)multipleFilterViewClickDoneButton:(TDFMultipleFilterViewController *)multipleFilterView
                                indexPath:(NSArray<NSIndexPath *> *)indexPath
                                 isChange:(BOOL)isChange {
    self.searchPanelView.filterFoldIcon.image = [UIImage imageNamed:@"ico_down_gray"];
    //    if (isChange) {
    self.filterDic[@"keyword"] = nil;
    [self.searchPanelView changeFilterLabelColor:[UIColor redColor]];
    if(indexPath.count > 0) {
        self.filterDic[@"type"] = @"1";
        
        NSMutableArray *branchEntityIds = [NSMutableArray array];
        NSMutableArray *joinModes = [NSMutableArray array];
        NSMutableArray *plateEntityIds = [NSMutableArray array];
        for (NSIndexPath *indexP in indexPath) {
            
            
            
            /***
             
             if (self.branchList.count) {
             
             [titles addObject:model1];
             [datas addObject:self.branchList];
             [self.beginList addObject:@{@"branchEntityIds":self.branchList}];
             }
             
             if (self.plateList.count) {
             
             [titles addObject:model2];
             [datas addObject:self.plateList];
             [self.beginList addObject:@{@"plateEntityIds":self.plateList}];
             }
             
             if (self.joinModeList.count) {
             
             [titles addObject:model3];
             [datas addObject:self.joinModeList];
             [self.beginList addObject:@{@"joinModes":self.plateList}];
             }
             
             ***/
            
            
            if ([[self.beginList[indexP.section] allKeys].firstObject isEqualToString:@"branchEntityIds"]) {
                
                NSMutableArray *arr = [self.beginList[indexP.section] objectForKey:@"branchEntityIds"];
                BranchShopVo *branchShopVo = arr[indexP.row];
                [branchEntityIds addObject:branchShopVo.branchEntityId];
                
            }else if ([[self.beginList[indexP.section] allKeys].firstObject isEqualToString:@"plateEntityIds"]) {
                
                NSMutableArray *arr = [self.beginList[indexP.section] objectForKey:@"plateEntityIds"];
                PlateVo *plateVo = arr[indexP.row];
                self.tabTitleLabel.text = plateVo.plateName;
                [plateEntityIds addObject:plateVo.plateEntityId];
                
            }else if ([[self.beginList[indexP.section] allKeys].firstObject isEqualToString:@"joinModes"]) {
                
                NSMutableArray *arr = [self.beginList[indexP.section] objectForKey:@"joinModes"];
                TDFShopTypeModel *typeModel = arr[indexP.row];
                [joinModes addObject:@(typeModel.value)];
            }
            
            
            
            
            
            
            
            
            
//            NSArray *tempList = self.filterDataSource[indexP.section];
//            if(indexP.section == 0){
//                BranchShopVo *branchShopVo = tempList[indexP.row];
//                [branchEntityIds addObject:branchShopVo.branchEntityId];
//            }else if(indexP.section == 1){
//                PlateVo *plateVo = tempList[indexP.row];
//                self.tabTitleLabel.text = plateVo.plateName;
//                [plateEntityIds addObject:plateVo.plateEntityId];
//            }else if(indexP.section == 2){
//                TDFShopTypeModel *typeModel = tempList[indexP.row];
//                [joinModes addObject:@(typeModel.value)];
//            }
        }
        self.filterDic[@"branchEntityIds"] = branchEntityIds;
        self.filterDic[@"joinModes"] = joinModes;
        self.filterDic[@"plateEntityIds"] = plateEntityIds;
    }else {
        [self.searchPanelView changeFilterLabelColor:[UIColor whiteColor]];
        self.filterDic[@"type"] = @"0";
        [self.filterDic removeObjectForKey:@"branchEntityIds"];
        [self.filterDic removeObjectForKey:@"joinModes"];
        [self.filterDic removeObjectForKey:@"keyword"];
    }
    self.searchPanelView.searchTextField.text = nil;
    [self.searchPanelView.searchTextField resignFirstResponder];
    
    [self loadNew];
}

- (void)loadNew {
    
    if (!self.filterDic) {
        
        return;
    }
    if (!self.callBack) {
        
        return;
    }
//    if (([self.filterDic[@"type"] integerValue]==1)&&(![self.filterDic.allKeys containsObject:@"plateEntityIds"])) {
//        
//        return;
//    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    dic[@"date"] = self.dateStr;
    
    dic[@"date_type"] = [NSString stringWithFormat:@"%ld",(long)self.type];
    
    dic[@"filter"] = self.filterDic;
    
    self.callBack(dic);
}

@end
