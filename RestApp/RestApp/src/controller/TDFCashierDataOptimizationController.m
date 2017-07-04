//
//  TDFCashierDataOptimizationController.m
//  RestApp
//
//  Created by LSArlen on 2017/6/12.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFCashierDataOptimizationController.h"
#import "TDFSwitchItem+BaseSetting.h"
#import "TDFPickerItem+BaseSetting.h"
#import "TDFSKDisplayedTextItem.h"
#import "DHTTableViewSection.h"
#import "TDFShowPickerStrategy.h"
#import "NameItemVO.h"
#import "DHTTableViewManager+BaseSetting.h"
#import "TDFBSConfigModel.h"
#import "NSArray+SwiftOperation.h"

@interface TDFCashierDataOptimizationController ()

@property (nonatomic, strong) TDFSwitchItem *switchAutoOptimizeBillItem;        //开关：每天自动优化
@property (nonatomic, strong) TDFSwitchItem *switchAllowCashierAlterBillItem;   //开关：允许收银员修改账单
@property (nonatomic, strong) TDFSwitchItem *switchBillNumberRandomGenerateItem;//开关：订单流水号是否随机生成

@property (nonatomic, strong) TDFPickerItem *pickerHideOneForNumberOrderItem;//选择器：每几张订单隐藏一张。

@property (nonatomic, strong) TDFSKDisplayedTextItem *textFooter;
@property (nonatomic, strong) TDFShowPickerStrategy *strategy;
@end

@implementation TDFCashierDataOptimizationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收银数据优化";
    
    //    [self buildConfigureSections];//如果后天有数据的情况下，注释掉
    
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavigationButtonAction:(id)sender {
    
    
    
}

- (NSArray *)registedItemsClassString {
    return @[BSS(TDFSwitchItem),BSS(TDFPickerItem),BSS(TDFSKDisplayedTextItem)];
}

- (NSString *)codeForRequestConfigure {
    return @"SYSJYH";
}

- (void)bindConfigureCode {
    [super bindConfigureCode];
    
    self.switchAutoOptimizeBillItem.bs_code             =   @"OPTIMIZE_ORDER_EVERYDAY";
    self.switchAllowCashierAlterBillItem.bs_code        =   @"ALLOW_MODIFY_OPTIMIZED_ORDER";
    self.switchBillNumberRandomGenerateItem.bs_code     =   @"RANDOM_GENERATION_SERIAL_NUMBER";
    self.pickerHideOneForNumberOrderItem.bs_code        =   @"HIDDEN_ORDER_PERCENT";
    
}

- (void)configureItemsValue {
    [super configureItemsValue];
    
    [self.switchAutoOptimizeBillItem            bs_safeExecuteFilterBlock];
    [self.switchAllowCashierAlterBillItem       bs_safeExecuteFilterBlock];
    [self.switchBillNumberRandomGenerateItem    bs_safeExecuteFilterBlock];
    [self.pickerHideOneForNumberOrderItem       bs_bindPickerStrategy];

}

- (void)viewControllerDidTriggerRightClick:(UIViewController *)viewController {
    if ([self.manager bs_anyItemInvalid]) {
        return;
    }
    [self enumerateConfigures:self.baseSetting.configs usingBlock:^(TDFBaseEditItem<TDFBSItemValueProtocol> *item, TDFBSConfigModel *configure) {
            configure.val = [item bs_newValue];
    }];
    
    TDFLogInfo(@"\npost message: %@\n", [self.baseSetting.configs tdf_foldLeftWithStart:@"" reduce:^id(NSString *result, TDFBSConfigModel *next) {
        return [NSString stringWithFormat:@"%@\n\t\t%@  %@  %@", result, next.name, next.code, next.val];
    }]);
    
    
    self.saveConfigAPI.configs = [self.baseSetting.configs tdf_map:^id(TDFBSConfigModel *value) {
        return [value copy];
    }];
    @weakify(self)
    [self.saveConfigAPI setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.saveConfigAPI start];
}
- (void)initializeItemsWithConfigures:(NSArray *)configures usingFilterBlock:(BOOL (^)(DHTTableViewItem *item))filterBlock {
    [self enumerateConfigures:configures usingBlock:^(TDFBaseEditItem<TDFBSItemValueProtocol> *item, TDFBSConfigModel *configure) {
        if (filterBlock && !filterBlock(item)) {
            return;
        }
        [item setBs_configure:configure];
        [item setBs_originValue:configure.val];
        [item setBs_editable:configure.editable.boolValue];
    }];
}


- (void)buildConfigureSections {
    [super buildConfigureSections];
    [self setBaseSettingSwitchItems];
    
    DHTTableViewSection  *section  = [DHTTableViewSection section];
    section.headerHeight = CGFLOAT_MIN;
    
    [section addItem:self.switchAutoOptimizeBillItem];
    [section addItem:self.pickerHideOneForNumberOrderItem];
    [section addItem:self.switchAllowCashierAlterBillItem];
    [section addItem:self.switchBillNumberRandomGenerateItem];
    [section addItem:self.textFooter];
    
    [self.manager addSection:section];
    
    [self setItemFilterCallBack];   //设置操作数据回调
}

- (void)setBaseSettingSwitchItems {
    
    self.switchAutoOptimizeBillItem         = [TDFSwitchItem bs_switchItemWithTitle:@"每天自动优化账单" on:NO];
    self.switchAllowCashierAlterBillItem    = [TDFSwitchItem bs_switchItemWithTitle:@"允许收银员修改账单优化状态" detail:@"开关打开后，收银员可在已结账单页面操作时修改账单显示状态，比如将某个系统提示已隐藏的账单改为不隐藏，或将某个不隐藏的账单改为隐藏。" on:NO];
    self.switchBillNumberRandomGenerateItem = [TDFSwitchItem bs_switchItemWithTitle:@"账单流水号需要随机生成" detail:@"开关打开后，收银上账单流水号的编码规则由原来的按顺序生成改为随机生成。如果不打开，账单流水号则仍是按顺序生成，但会因部分账单被隐藏而缺失。" on:YES];
}


- (void)setItemFilterCallBack {
    
    @weakify(self);
    
    self.switchAutoOptimizeBillItem.filterBlock = ^BOOL(BOOL isOn) {
        @strongify(self);
        
        self.switchBillNumberRandomGenerateItem.shouldShow  =   isOn;
        self.switchAllowCashierAlterBillItem.shouldShow     =   isOn;
        self.textFooter.shouldShow                          =   isOn;
        self.pickerHideOneForNumberOrderItem.shouldShow     =   isOn;
        
        [self.manager reloadData];
        return YES;
    };
    
    
    
}

- (TDFPickerItem *)pickerHideOneForNumberOrderItem {
    if (!_pickerHideOneForNumberOrderItem) {
        _pickerHideOneForNumberOrderItem = [TDFPickerItem item];
        _pickerHideOneForNumberOrderItem.title      =   @"▪︎ 每几张订单隐藏1张";
        _pickerHideOneForNumberOrderItem.bs_useDisplayValue = YES;
        _pickerHideOneForNumberOrderItem.strategy = self.strategy;
    }
    return _pickerHideOneForNumberOrderItem;
}

- (TDFSKDisplayedTextItem *)textFooter {
    if (!_textFooter) {
        _textFooter = [TDFSKDisplayedTextItem item];
        _textFooter.text = @"提示：设置完成并将收银机数据更新后，收银上的已结账单会根据掌柜上设置的规则显示每张账单的优化状态。如果员工没有查看隐藏账单的权限就只能看到部分营业数据，收银数据上传后，在报表上看到的数据也是优化后的数据。";
    }
    return _textFooter;
}

- (TDFShowPickerStrategy *)strategy {
    if (!_strategy) {
        _strategy = [[TDFShowPickerStrategy alloc] init];
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 2;  i <= 20; i++) {
            NSString *num = [NSString stringWithFormat:@"%d",i];
            NameItemVO *item = [[NameItemVO alloc] initWithVal:num andId:num];
            [array addObject:item];
        }
        _strategy.pickerItemList = array;
    }
    return _strategy;
}



@end














