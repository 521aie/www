//
//  TDFTableDataOptimizeController.m
//  RestApp
//
//  Created by LSArlen on 2017/6/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTableDataOptimizeController.h"
#import "TDFTableDataOptimizePickerService.h"
#import "TDFTableDataOptimizeViewModel.h"

#import "TDFPickerItem+BaseSetting.h"
#import "DHTTableViewSection.h"
#import "TDFSKDisplayedTextItem.h"
#import "TDFSKSingleButtonItem.h"
#import "TDFSKButtonItemTransaction.h"
#import "DHTTableViewManager.h"
#import "UIColor+Hex.h"
#import "BillOptimizationTaskVo.h"
#import "TDFEditViewHelper.h"
#import "TDFBaseEditView.h"

@interface TDFTableDataOptimizeController ()

@property (nonatomic, strong) TDFTableDataOptimizeViewModel *viewModel;





@end

@implementation TDFTableDataOptimizeController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"报表数据优化";
    _isAuto = YES;  //默认是自动优化
    
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange) name:kTDFEditViewIsShowTipNotification object:nil];
    [self.viewModel loadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)leftNavigationButtonAction:(id)sender {
    if (![self dataChange]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"有未保存的操作，是否确定退出" preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:0 handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)rightNavigationButtonAction:(id)sender {
    [self.viewModel saveAutoData];
}


- (BOOL)dataChange {
    DHTTableViewSection *section = [DHTTableViewSection section];
    [section addItem:self.pickerAutoOptimizeDayItem];
    [section addItem:self.autoPickerOptimizeBillTypeItem];
    [section addItem:self.autoPickerBillPerOfTotalNumItem];
    [section addItem:self.autoPickerBillPerOfTurnOverItem];
    [self configNavigationBar:[TDFEditViewHelper isAnyTipsShowedInSections:@[section]]];
    return [TDFEditViewHelper isAnyTipsShowedInSections:@[section]];
}

- (void)registerTableCell {
    [self.manager registerCell:@"TDFSKDisplayedTextCell" withItem:@"TDFSKDisplayedTextItem"];
    [self.manager registerCell:@"TDFSKSingleButtonCell" withItem:@"TDFSKSingleButtonItem"];
    [self.manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
}

- (void)buildConfigureSections {
    
    TDFTableDataOptimizePickerService *pickerService = [[TDFTableDataOptimizePickerService alloc] initWith:_pickerDataOptimizeMethodItem];
    pickerService.pickerType    =   TDFTableDataOptimizePickerTypeOptimizeMethod;
    pickerService.defaultIndex  =   self.isAuto;
    
    [self registerTableCell];

    DHTTableViewSection *section = [DHTTableViewSection section];
    section.headerHeight = CGFLOAT_MIN; 
    
    [section addItem:self.pickerDataOptimizeMethodItem];
    [section addItem:self.pickerStartDateItem];
    [section addItem:self.pickerEndDateItem];
    [section addItem:self.pickerAutoOptimizeDayItem];
    [section addItem:self.autoPickerOptimizeBillTypeItem];
    [section addItem:self.mamualPickerOptimizeBillTypeItem];
    
    [section addItem:self.mamualpickerBillPerOfTotalNumItem];
    [section addItem:self.mamualpickerBillPerOfTurnOverItem];
    
    [section addItem:self.autoPickerBillPerOfTotalNumItem];
    [section addItem:self.autoPickerBillPerOfTurnOverItem];
    
    
    [section addItem:self.textTaskCreateDateItem];
    [section addItem:self.footButton];
    
    [self.manager addSection:section];
    
    [self setItemFilterCallBack];   //设置item的回调
}



- (void)setItemFilterCallBack {
    
    @weakify(self);
    //手动优化操作
    self.startFooterTransaction.clickedHandler = ^{
         @strongify(self);
        [self.viewModel saveMamualData];
    };
    //手动取消优化操作
    self.cancelFooterTransaction.clickedHandler = ^{
        @strongify(self);
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要取消本次优化吗？" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [ac addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.viewModel clearMamualData];
        }]];
        [self presentViewController:ac animated:YES completion:nil];
    };

    
    //更改优化方式
    self.pickerDataOptimizeMethodItem.filterBlock = ^BOOL(NSString *textValue, id requestValue) {
        @strongify(self);
        self.isAuto = [requestValue intValue];
        self.pickerDataOptimizeMethodItem.preValue = textValue;
        [self.viewModel changeOptimizeMethod];
        return YES;
    };
    
    //开始、结束日期
    self.pickerStartDateItem.filterBlock = ^BOOL(NSString *textValue, id requestValue) {
        @strongify(self);
        self.mamualMethodVO.startDate = textValue;
        return YES;
    };
    self.pickerEndDateItem.filterBlock = ^BOOL(NSString *textValue, id requestValue) {
        @strongify(self);
        self.mamualMethodVO.endDate = textValue;
        return YES;
    };

    
    //手动更改百分比所占类型
    self.mamualPickerOptimizeBillTypeItem.filterBlock = ^BOOL(NSString *textValue, id requestValue) {
        @strongify(self);
        self.mamualMethodVO.billOptimizationType = [requestValue intValue];
        [self.viewModel changeMamualOptimizeBillType];
        return YES;
    };
    
    //手动选择的百分比。item
    //根据账单数量的百分比
    self.mamualpickerBillPerOfTotalNumItem.filterBlock = ^BOOL(NSString *textValue, id requestValue) {
        @strongify(self);
        self.mamualMethodVO.billQuantityPercent = [requestValue intValue];
        return YES;
    };
    //根据营业额的百分比
    self.mamualpickerBillPerOfTurnOverItem.filterBlock = ^BOOL(NSString *textValue, id requestValue) {
        @strongify(self);
        self.mamualMethodVO.turnoverPercent = [requestValue intValue];
        return YES;
    };
    
    
    //自动方式，修改优化几天
    self.pickerAutoOptimizeDayItem.filterBlock = ^BOOL(NSString *textValue, id requestValue) {
        @strongify(self);
        self.autoMethodVO.dateOffSet = [textValue intValue];
        return YES;
    };
    
    //自动更改百分比所占类型
    self.autoPickerOptimizeBillTypeItem.filterBlock = ^BOOL(NSString *textValue, id requestValue) {
        @strongify(self);
        self.autoMethodVO.billOptimizationType = [requestValue intValue];
        [self.viewModel changeAutoOptimizeBillType];
        return YES;
    };
    
    //自动选择的百分比。item
    //根据数量的百分比
    self.autoPickerBillPerOfTotalNumItem.filterBlock = ^BOOL(NSString *textValue, id requestValue) {
        @strongify(self);
        self.autoMethodVO.billQuantityPercent = [textValue intValue];
        return YES;
    };
    //根据营业额的百分比
    self.autoPickerBillPerOfTurnOverItem.filterBlock = ^BOOL(NSString *textValue, id requestValue) {
        @strongify(self);
        self.autoMethodVO.turnoverPercent = [textValue intValue];
        return YES;
    };
}







#pragma mark ---- lazy

- (TDFTableDataOptimizeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TDFTableDataOptimizeViewModel alloc] initWith:self];
    }
    return _viewModel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor  = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
    return _tableView;
}

- (DHTTableViewManager *)manager {
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
    }
    return _manager;
}


- (TDFPickerItem *)pickerDataOptimizeMethodItem {
    if (!_pickerDataOptimizeMethodItem) {
        _pickerDataOptimizeMethodItem = [TDFPickerItem item];
        _pickerDataOptimizeMethodItem.title = @"数据优化方式";
    }
    return _pickerDataOptimizeMethodItem;
}


- (TDFPickerItem *)pickerStartDateItem {
    if (!_pickerStartDateItem) {
        _pickerStartDateItem = [TDFPickerItem item];
        _pickerStartDateItem.title = @"▪︎ 选择开始日期";
        TDFTableDataOptimizePickerService *pickerService = [[TDFTableDataOptimizePickerService alloc] initWith:_pickerStartDateItem];
        pickerService.pickerType    =   TDFTableDataOptimizePickerTypeStartDate;
    }
    return _pickerStartDateItem;
}

- (TDFPickerItem *)pickerEndDateItem {
    if (!_pickerEndDateItem) {
        _pickerEndDateItem = [TDFPickerItem item];
        _pickerEndDateItem.title = @"▪︎ 选择结束日期";
        TDFTableDataOptimizePickerService *pickerService = [[TDFTableDataOptimizePickerService alloc] initWith:_pickerEndDateItem];
        pickerService.pickerType    =   TDFTableDataOptimizePickerTypeEndDate;
    }
    return _pickerEndDateItem;
}

- (TDFPickerItem *)pickerAutoOptimizeDayItem {
    if (!_pickerAutoOptimizeDayItem) {
        _pickerAutoOptimizeDayItem = [TDFPickerItem item];
        _pickerAutoOptimizeDayItem.title = @"▪︎ 自动优化前几天的账单（天）";
        TDFTableDataOptimizePickerService *pickerService = [[TDFTableDataOptimizePickerService alloc] initWith:_pickerAutoOptimizeDayItem];
        pickerService.pickerType    =   TDFTableDataOptimizePickerTypeNumDay;
    }
    return _pickerAutoOptimizeDayItem;
}

- (TDFPickerItem *)autoPickerOptimizeBillTypeItem {
    if (!_autoPickerOptimizeBillTypeItem) {
        _autoPickerOptimizeBillTypeItem = [TDFPickerItem item];
        _autoPickerOptimizeBillTypeItem.title = @"▪︎ 选择优化账单类型";
        TDFTableDataOptimizePickerService *pickerService = [[TDFTableDataOptimizePickerService alloc] initWith:_autoPickerOptimizeBillTypeItem];
        pickerService.pickerType    =   TDFTableDataOptimizePickerTypeBillType;
    }
    return _autoPickerOptimizeBillTypeItem;
}

- (TDFPickerItem *)mamualPickerOptimizeBillTypeItem {
    if (!_mamualPickerOptimizeBillTypeItem) {
        _mamualPickerOptimizeBillTypeItem = [TDFPickerItem item];
        _mamualPickerOptimizeBillTypeItem.title = @"▪︎ 选择优化账单类型";
        TDFTableDataOptimizePickerService *pickerService = [[TDFTableDataOptimizePickerService alloc] initWith:_mamualPickerOptimizeBillTypeItem];
        pickerService.pickerType    =   TDFTableDataOptimizePickerTypeBillType;
    }
    return _mamualPickerOptimizeBillTypeItem;
}

- (TDFPickerItem *)mamualpickerBillPerOfTotalNumItem {
    if (!_mamualpickerBillPerOfTotalNumItem) {
        _mamualpickerBillPerOfTotalNumItem = [TDFPickerItem item];
        _mamualpickerBillPerOfTotalNumItem.title = @"▪︎ 账单所占总单数的百分比（%）";
        TDFTableDataOptimizePickerService *pickerService = [[TDFTableDataOptimizePickerService alloc] initWith:_mamualpickerBillPerOfTotalNumItem];
        pickerService.pickerType    =   TDFTableDataOptimizePickerTypePer;
    }
    return _mamualpickerBillPerOfTotalNumItem;
}
- (TDFPickerItem *)mamualpickerBillPerOfTurnOverItem {
    if (!_mamualpickerBillPerOfTurnOverItem) {
        _mamualpickerBillPerOfTurnOverItem = [TDFPickerItem item];
        _mamualpickerBillPerOfTurnOverItem.title = @"▪︎ 账单所占营业额的百分比（%）";
        TDFTableDataOptimizePickerService *pickerService = [[TDFTableDataOptimizePickerService alloc] initWith:_mamualpickerBillPerOfTurnOverItem];
        pickerService.pickerType    =   TDFTableDataOptimizePickerTypePer;
    }
    return _mamualpickerBillPerOfTurnOverItem;
}

- (TDFPickerItem *)autoPickerBillPerOfTotalNumItem {
    if (!_autoPickerBillPerOfTotalNumItem) {
        _autoPickerBillPerOfTotalNumItem = [TDFPickerItem item];
        _autoPickerBillPerOfTotalNumItem.title = @"▪︎ 账单所占总单数的百分比（%）";
        TDFTableDataOptimizePickerService *pickerService = [[TDFTableDataOptimizePickerService alloc] initWith:_autoPickerBillPerOfTotalNumItem];
        pickerService.pickerType    =   TDFTableDataOptimizePickerTypePer;
    }
    return _autoPickerBillPerOfTotalNumItem;
}
- (TDFPickerItem *)autoPickerBillPerOfTurnOverItem {
    if (!_autoPickerBillPerOfTurnOverItem) {
        _autoPickerBillPerOfTurnOverItem = [TDFPickerItem item];
        _autoPickerBillPerOfTurnOverItem.title = @"▪︎ 账单所占营业额的百分比（%）";
        TDFTableDataOptimizePickerService *pickerService = [[TDFTableDataOptimizePickerService alloc] initWith:_autoPickerBillPerOfTurnOverItem];
        pickerService.pickerType    =   TDFTableDataOptimizePickerTypePer;
    }
    return _autoPickerBillPerOfTurnOverItem;
}


- (TDFSKDisplayedTextItem *)textTaskCreateDateItem {
    if (!_textTaskCreateDateItem) {
        _textTaskCreateDateItem = [TDFSKDisplayedTextItem item];
        _textTaskCreateDateItem.textAlignment   = NSTextAlignmentLeft;
        _textTaskCreateDateItem.font            = [UIFont systemFontOfSize:13];
        _textTaskCreateDateItem.textColor       = [UIColor colorWithHexString:@"#E51C23"];
    }
    return _textTaskCreateDateItem;
}

- (TDFSKSingleButtonItem *)footButton {
    if (!_footButton) {
        _footButton = [TDFSKSingleButtonItem item];
        _footButton.transaction = self.startFooterTransaction;
    }
    return _footButton;
}

- (TDFSKButtonItemTransaction *)startFooterTransaction {
    if (!_startFooterTransaction) {
        _startFooterTransaction = [[TDFSKButtonItemTransaction alloc] init];
        _startFooterTransaction.title = @"优化账单";
    }
    return _startFooterTransaction;
}

- (TDFSKButtonItemTransaction *)cancelFooterTransaction {
    if (!_cancelFooterTransaction) {
        _cancelFooterTransaction = [[TDFSKButtonItemTransaction alloc] init];
        _cancelFooterTransaction.title = @"取消优化账单";
    }
    return _cancelFooterTransaction;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


















