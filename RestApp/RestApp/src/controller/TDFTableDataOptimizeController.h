//
//  TDFTableDataOptimizeController.h
//  RestApp
//
//  Created by LSArlen on 2017/6/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"
#import "TDFTableDataOptimizeStringFormater.h"

@class TDFSKDisplayedTextItem,TDFSKSingleButtonItem,TDFSKButtonItemTransaction,BillOptimizationTaskVo;

@interface TDFTableDataOptimizeController : TDFRootViewController


@property (nonatomic, assign)   BOOL isAuto;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BillOptimizationTaskVo *mamualMethodVO;       //手动优化的数据
@property (nonatomic, strong) BillOptimizationTaskVo *autoMethodVO;         //自动优化的数据

@property (nonatomic, strong) TDFPickerItem *pickerDataOptimizeMethodItem;  //数据优化方式
@property (nonatomic, strong) TDFPickerItem *pickerStartDateItem;           //选择开始日期
@property (nonatomic, strong) TDFPickerItem *pickerEndDateItem;             //选择结束日期
@property (nonatomic, strong) TDFPickerItem *pickerAutoOptimizeDayItem;     //自动优化前几天的账单

@property (nonatomic, strong) TDFPickerItem *autoPickerOptimizeBillTypeItem;    //选择优化账单类型
@property (nonatomic, strong) TDFPickerItem *mamualPickerOptimizeBillTypeItem;    //选择优化账单类型

@property (nonatomic, strong) TDFPickerItem *mamualpickerBillPerOfTotalNumItem;     //账单所占总数量的百分比
@property (nonatomic, strong) TDFPickerItem *autoPickerBillPerOfTotalNumItem;       //账单所占总数量的百分比

@property (nonatomic, strong) TDFPickerItem *mamualpickerBillPerOfTurnOverItem;     //账单所占营业额的百分比
@property (nonatomic, strong) TDFPickerItem *autoPickerBillPerOfTurnOverItem;       //账单所占营业额的百分比

@property (nonatomic, strong) TDFSKDisplayedTextItem        *textTaskCreateDateItem;   //任务创建时间
@property (nonatomic, strong) TDFSKSingleButtonItem         *footButton;
@property (nonatomic, strong) TDFSKButtonItemTransaction    *startFooterTransaction;    //优化
@property (nonatomic, strong) TDFSKButtonItemTransaction    *cancelFooterTransaction;      //取消优化


@property (nonatomic, strong) DHTTableViewManager *manager;

- (void)buildConfigureSections ;

@end
