//
//  LogisticModule.m
//  RestApp
//
//  Created by hm on 15/1/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LogisticModule.h"
#import "ServiceFactory.h"
#import "SecondMenuView.h"
#import "SystemUtil.h"
#import "MBProgressHUD.h"
#import "UIMenuAction.h"
#import "MainModule.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "SystemUtil.h"
#import "HelpDialog.h"
#import "ActionConstants.h"
#import "SelectListView.h"
#import "RawPaperEditView.h"
#import "AuditRecordView.h"
#import "RawDetailEditView.h"
#import "BranchWarehouseView.h"
#import "ReturnPaperEditView.h"
#import "PaperListView.h"
#import "AllocatePaperEditView.h"
#import "AllocateRawEditView.h"
#import "MatchingKindMenu.h"
#import "BatchSelectRawListView.h"
#import "SupplierEditView.h"
#import "SupplierKindListView.h"
#import "SupplierKindEditView.h"
#import "SupplierRawListView.h"
#import "SupplyListView.h"
#import "ReturnReasonListView.h"
#import "ReturnReasonEditView.h"
#import "ScanView.h"
#import "LogisticFiltrateListView.h"
#import "PaperExportListView.h"
@implementation LogisticModule

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mainModule = parent;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (void)backMenu
{
    //[self removeNotification];
    
    [mainModule backMenuBySelf:self];
}
-(void)backNavigateMenuView
{
    [mainModule backMenuBySelf:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_SHOW_NOTIFICATION object:nil] ;
    [[NSNotificationCenter defaultCenter] postNotificationName:LODATA object:nil];
}
- (void)removeNotification
{
    if (self.paperListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.paperListView];
    }
    if (self.batchSelectRawListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.batchSelectRawListView];
    }
    if (self.paperExportListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.paperExportListView];
    }
    if (self.rawDetailEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.rawDetailEditView];
    }
    if (self.rawPaperEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.rawPaperEditView];
    }
    if (self.returnReasonListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.returnReasonListView];
    }
    if (self.returnReasonEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.returnReasonEditView];
    }
    if (self.branchWarehouseView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.branchWarehouseView];
    }
    if (self.auditRecordView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.auditRecordView];
    }
    if (self.returnPaperEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.returnPaperEditView];
    }
    if (self.allocatePaperEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.allocatePaperEditView];
    }
    if (self.allocateRawEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.allocateRawEditView];
    }
    if (self.supplierEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.supplierEditView];
    }
    if (self.supplierKindListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.supplierKindListView];
    }
    if (self.supplierKindEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.supplierKindEditView];
    }
    if (self.supplierRawListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.supplierRawListView];
    }
    if (self.supplyListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.supplyListView];
    }
    if (self.secondMenuView) {
        self.secondMenuView = nil;
    }
}


#pragma mark - 隐藏module下所有初始化的view
// 隐藏视图
- (void) hideView
{
    // 遍历所有子视图
    for (UIView *view in [self.view subviews]) {

        // 隐藏所有子视图
        [view setHidden:YES];
    }
}

- (void)showView:(int)viewTag {
    
    if (viewTag == SELECT_LIST_VIEW ) {
        [self loadSelectListView];
        [self.view bringSubviewToFront:self.selectListView.view];
        [self.selectListView oper];
        return;
    }
    
    [self hideView];
    
    if (viewTag == LOGISTIC_SECOND_VIEW) {
        [self loadSecondMenuView];
        self.secondMenuView.titleBox.lblTitle.text = NSLocalizedString(@"物流", nil);
       // [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromLeft];
        
    }else if (viewTag == LOGISTIC_FILTRATE_LIST_VIEW){   //导出筛选

        [self loadLogisticFiltrateListView];
    
    }else if (viewTag==PAPER_EXPORT_LIST_VIEW){
        
        [self loadPaperExportListView];
        
    }else if (viewTag == PAPER_LIST_VIEW) {
        
        [self loadPaperListView];
        
    } else if (viewTag == RAW_PAPER_EDIT_VIEW) { //收货单详情页面吗
        
        [self loadRawPaperEditView];
        
    } else if (viewTag == RAW_DETAIL_EDIT_VIEW) { //原料详情页面
        
        [self loadRawDetailEditView];
        
    } else if (viewTag == AUDIT_RECORD_VIEW) {   //审核记录页面
        
        [self loadAuditRecordView];
        
    } else if (viewTag == BRANCH_WAREHOUSE_VIEW) { //分库页面
        
        [self loadBranchWarehouseView];
        
    } else if (viewTag == RETURN_PAPER_EDIT_VIEW) { //退货详情编辑页
        
        [self loadReturnPaperEditView];
        
    } else if (viewTag == ALLOCATE_PAPER_EDIT_VIEW) { //调拨详情编辑页
        
        [self loadAllocatePaperEditView];
        
    } else if (viewTag == ALLOCATE_RAW_EDIT_VIEW) { //调拨原料详情编辑页
        
        [self loadAllocateRawEditView];
        
    }else if (viewTag == BATCH_SELECT_SCAN_VIEW) {  //扫描页面

//        self.scanView.view.hidden = NO;
        [self loadScanView];
//        [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromTop];
        
    }else if (viewTag == BATCH_SELECT_RAW_LIST_VIEW) {
        
        [self loadBatchSelectRawListView];
        
        [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromTop];
        
    } else if (viewTag == SUPPLIER_LIST_VIEW) {
        
        [self loadSupplyListView];

    } else if (viewTag == SUPPLIER_EDIT_VIEW) {
        
        [self loadSupplyEditView];
        
    } else if (viewTag == SUPPLIER_KIND_LIST_VIEW) {
        
        [self loadSupplyKindListView];
        
    } else if (viewTag ==  SUPPLIER_KIND_EDIT_VIEW) {
        
        [self loadSupplyKindEditView];
        
    } else if (viewTag == SUPPLIER_RAW_LIST_VIEW) {
        
        [self loadSupplyRawListView];
        
    } else if (viewTag == RETURN_REASON_LIST_VIEW) {
        
        [self loadReturnReasonListView];
        
    } else if (viewTag == RETURN_REASON_EDIT_VIEW) {
        
        [self loadReturnReasonEditView];
    }
}

-(void) loadDatas;
{
    [self showView:LOGISTIC_SECOND_VIEW];
}

//列表与筛选列表一起显示
- (void)showSpecialView:(int)viewTag
{
    if (viewTag == SELECT_LIST_VIEW) {
        [self hideView];
        self.selectListView.view.hidden = NO;
        self.paperListView.view.hidden = NO;
    }

}

#pragma mark - MenuSelectHandle协议方法创建二级菜单

- (NSMutableArray *)createList {
    NSMutableArray *items = [NSMutableArray array];
    
    UIMenuAction *action = [[UIMenuAction alloc] init:NSLocalizedString(@"收货入库单", nil) detail:NSLocalizedString(@"收货入库单", nil) img:@"ico_shouhuo.png" code:SUPPLY_IN];
    [items addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"退货出库单", nil) detail:NSLocalizedString(@"退货出库单", nil) img:@"ico_tuihuo.png" code:SUPPLY_OUT];
    [items addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"内部调拨单", nil) detail:NSLocalizedString(@"内部调拨单", nil) img:@"ico_diaobo.png" code:SUPPLY_GET];
    [items addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"供应商管理", nil) detail:NSLocalizedString(@"对供应商进行管理", nil) img:@"ico_gongyingshang.png" code:SUPPLY_SUPPLIER];
    [items addObject:action];
    
    return items;
}


#pragma mark - 捕捉页面itemslist事件
-(void) onMenuSelectHandle:(UIMenuAction *)action {
    if ([action.code isEqualToString:SUPPLY_SUPPLIER]){
        
        [self showView:SUPPLIER_LIST_VIEW];
        [self.supplyListView searchData:0];
    }else{

        [self showView:PAPER_LIST_VIEW];
    
        if ([action.code isEqualToString:SUPPLY_IN]) {
            
            [self.paperListView loadDatas:nil action:ACTION_RAW_PAPER_LIST];
            [self.selectListView resetLblVal];
            
        }else if ([action.code isEqualToString:SUPPLY_OUT]) {
            
            [self.paperListView loadDatas:nil action:ACTION_RETURN_PAPER_LIST];
            [self.selectListView resetLblVal];
            
        }else if ([action.code isEqualToString:SUPPLY_GET]) {
        
            [self.paperListView loadDatas:nil action:ACTION_ALLOCATE_PAPER_LIST];
            [self.selectListView resetLblVal];
            
        }
    }
    [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];

}

#pragma mark - 加载module下的页面
/*加载主页面*/
- (void)loadSecondMenuView
{
    if (self.secondMenuView) {
        self.secondMenuView.view.hidden = NO;
    }else{
        self.secondMenuView = [[SecondMenuView alloc] initWithNibName:@"SecondMenuView" bundle:nil delegate:self];
        [self.view addSubview:self.secondMenuView.view];
    }
}

/*加载收货、退货、调拨页面*/
- (void)loadPaperListView
{
    if (self.paperListView) {
        self.paperListView.view.hidden = NO;
    }else{
        self.paperListView = [[PaperListView alloc] initWithNibName:[SystemUtil getXibName:@"PaperSampleListView"] bundle:nil parent:self];
        [self.view addSubview:self.paperListView.view];
    }
}


/*加载筛选页面*/
- (void)loadSelectListView
{
    if (self.selectListView) {
        self.selectListView.view.hidden = NO;
    }else{
        self.selectListView = [[SelectListView alloc] initWithNibName:[SystemUtil getXibName:@"SelectListView"] bundle:nil parent:self];
        [self.view addSubview:self.selectListView.view];
    }
}

/*加载导出筛选页面*/
- (void)loadLogisticFiltrateListView
{
    if (self.logisticFiltrateListView) {
        self.logisticFiltrateListView.view.hidden = NO;
    }else{
        self.logisticFiltrateListView = [[LogisticFiltrateListView alloc] initWithNibName:[SystemUtil getXibName:@"FiltrateListView"] bundle:nil parent:self];
        [self.view addSubview:self.logisticFiltrateListView.view];
    }

}


/*加载选择原料页面*/
- (void)loadBatchSelectRawListView
{
    if (self.batchSelectRawListView) {
        self.batchSelectRawListView.view.hidden = NO;
    }else{
        //原料添加页面.
        self.batchSelectRawListView = [[BatchSelectRawListView alloc] initWithNibName:[SystemUtil getXibName:@"BatchSelectRawListView"] bundle:nil parent:self];
        [self.view addSubview:self.batchSelectRawListView.view];
    }

}

/*加载原料分类页*/



/*加载收货详情编辑、添加页面*/
- (void)loadRawPaperEditView
{
    if (self.rawPaperEditView) {
        self.rawPaperEditView.view.hidden = NO;
    }else{
        self.rawPaperEditView = [[RawPaperEditView alloc] initWithNibName:[SystemUtil getXibName:@"PaperDetailEditView"] bundle:nil parent:self];
        [self.view addSubview:self.rawPaperEditView.view];
    }
}

/*加载原料详情编辑页面*/
- (void)loadRawDetailEditView
{
    if (self.rawDetailEditView) {
        self.rawDetailEditView.view.hidden = NO;
    }else{
        self.rawDetailEditView = [[RawDetailEditView alloc] initWithNibName:[SystemUtil getXibName:@"RawDetailEditView"] bundle:nil parent:self];
        [self.view addSubview:self.rawDetailEditView.view];
    }
}

/*加载审核记录页面*/
- (void)loadAuditRecordView
{
    if (self.auditRecordView) {
        self.auditRecordView.view.hidden = NO;
    }else{
        
        self.auditRecordView = [[AuditRecordView alloc] initWithNibName:[SystemUtil getXibName:@"AuditRecordView"] bundle:nil parent:self];
        [self.view addSubview:self.auditRecordView.view];
    }

}

/*加载分库收货页面*/
- (void)loadBranchWarehouseView
{
    if (self.branchWarehouseView) {
        self.branchWarehouseView.view.hidden = NO;
    }else{
        self.branchWarehouseView = [[BranchWarehouseView alloc] initWithNibName:[SystemUtil getXibName:@"BranchWarehouseView"] bundle:nil parent:self];
        [self.view addSubview:self.branchWarehouseView.view];
    }
}

/*加载退货单详情编辑页*/
- (void)loadReturnPaperEditView
{
    if (self.returnPaperEditView) {
        self.returnPaperEditView.view.hidden = NO;
    }else{
        self.returnPaperEditView = [[ReturnPaperEditView alloc] initWithNibName:[SystemUtil getXibName:@"PaperDetailEditView"] bundle:nil parent:self];
        [self.view addSubview:self.returnPaperEditView.view];
    }

}

/*加载内部调拨单详情编辑页*/
- (void)loadAllocatePaperEditView
{
    if (self.allocatePaperEditView) {
        self.allocatePaperEditView.view.hidden =NO;
    }else{
        self.allocatePaperEditView = [[AllocatePaperEditView alloc] initWithNibName:[SystemUtil getXibName:@"PaperDetailEditView"] bundle:nil parent:self];
        [self.view addSubview:self.allocatePaperEditView.view];
    }
}

/*加载调拨单原料详情页面*/
- (void)loadAllocateRawEditView
{
    if (self.allocateRawEditView) {
        self.allocateRawEditView.view.hidden = NO;
    }else{
        self.allocateRawEditView = [[AllocateRawEditView alloc] initWithNibName:[SystemUtil getXibName:@"AllocateRawEditView"] bundle:nil parent:self];
        [self.view addSubview:self.allocateRawEditView.view];
    }
}

/*加载退货原因列表页面*/
- (void)loadReturnReasonListView
{
    if (self.returnReasonListView) {
        
        self.returnReasonListView.view.hidden = NO;
        
    }else{
        
        self.returnReasonListView = [[ReturnReasonListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:self];
        [self.view addSubview:self.returnReasonListView.view];
    }
}

/*加载退货原因编辑页面*/
- (void)loadReturnReasonEditView
{
    if (self.returnReasonEditView) {
        self.returnReasonEditView.view.hidden = NO;
    }else{
        self.returnReasonEditView = [[ReturnReasonEditView alloc] initWithNibName:[SystemUtil getXibName:@"ReturnReasonEditView"] bundle:nil parent:self];
        [self.view addSubview:self.returnReasonEditView.view];
    }

}

// 加载供应商列表
- (void)loadSupplyListView
{
    if (self.supplyListView) {
        
        self.supplyListView.view.hidden = NO;
    
    } else {
        
        self.supplyListView = [[SupplyListView alloc]initWithNibName:[SystemUtil getXibName:@"SupplyListView"] bundle:nil parent:self];
        
        [self.view addSubview:self.supplyListView.view];
    }
}

// 加载供应商编辑页面
- (void)loadSupplyEditView
{
    if (self.supplierEditView) {
        
        self.supplierEditView.view.hidden = NO;
        
    } else {
        
        self.supplierEditView = [[SupplierEditView alloc]initWithNibName:[SystemUtil getXibName:@"SupplierEditView"] bundle:nil parent:self];
        
        [self.view addSubview:self.supplierEditView.view];
    }
}

// 加载供应商分类列表视图
- (void)loadSupplyKindListView
{
    if (self.supplierKindListView) {
        
        self.supplierKindListView.view.hidden = NO;
        
    } else {
        
        self.supplierKindListView = [[SupplierKindListView alloc]initWithNibName:@"SampleListView" bundle:nil parent:self];
        
        [self.view addSubview:self.supplierKindListView.view];
    }
}

// 加载供应商分类编辑视图
- (void)loadSupplyKindEditView
{
    if (self.supplierKindEditView) {
        
        self.supplierKindEditView.view.hidden = NO;
        
    } else {
        
        self.supplierKindEditView = [[SupplierKindEditView alloc]initWithNibName:[SystemUtil getXibName:@"SupplierKindEditView"] bundle:nil parent:self];
        
        [self.view addSubview:self.supplierKindEditView.view];
    }
}

// 加载供应商供应原料编辑页面
- (void)loadSupplyRawListView
{
    if (self.supplierRawListView) {
        
        self.supplierRawListView.view.hidden = NO;
        
    } else {
        
        self.supplierRawListView = [[SupplierRawListView alloc]initWithNibName:[SystemUtil getXibName:@"SupplierRawListView"] bundle:nil parent:self];
        
        [self.view addSubview:self.supplierRawListView.view];
    }
}

/*加载二维码扫描页面*/
- (void)loadScanView
{
    if (self.scanView) {
        self.scanView.view.hidden = NO;
    }else{
        self.scanView = [[ScanView alloc] initWithNibName:[SystemUtil getXibName:@"ScanView"] bundle:nil];
        [self.view addSubview:self.scanView.view];
    }
    [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromTop];
}

/*导出页面*/
- (void)loadPaperExportListView
{
    if (self.paperExportListView) {
        
        self.paperExportListView.view.hidden = NO;
        
    }else{
    
        self.paperExportListView =  [[PaperExportListView alloc] initWithNibName:[SystemUtil getXibName:@"PaperExportListView"] bundle:nil];
        [self.view addSubview:self.paperExportListView.view];
    }

}


@end
