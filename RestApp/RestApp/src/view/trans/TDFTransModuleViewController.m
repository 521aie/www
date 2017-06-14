//
//  TDFTransModuleViewController.m
//  RestApp
//
//  Created by 黄河 on 2016/10/20.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFTransModuleViewController.h"
#import "TDFRootViewController+TableViewManager.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFDisplayCommonItem.h"
#import "TDFTransPlateViewController.h"

#import "ActionConstants.h"
#import "TDFFunctionVo.h"
#import "HelpDialog.h"
#import "AlertBox.h"
#import "Platform.h"
#import "TDFIsOpen.h"

@interface TDFTransModuleViewController ()
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation TDFTransModuleViewController

#pragma mark --SET --GET
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [self initDataArray];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDefaultManager];
    [self registerCells];
    
    self.title = NSLocalizedString(@"传菜", nil);
    self.tbvBase.tableHeaderView = [[TDFIntroductionHeaderView alloc] initWithImageIcon:[UIImage imageNamed:@"ico_transmenu_header"] description:NSLocalizedString(@"在收银、火服务生、微信等应用上下单后，如果厨房要接收到点单信息，那么需要先创建一个传菜方案，在传菜方案里面设置接收的规则。设置好后，在点菜设备上下单，菜单会在相应区域内打印机上打印出来。您还可以在这里设置不用出单的商品和备用打印机。", nil) detailBlock:^{
         [HelpDialog show:@"tranModule"];
    }];
    [self addSections];
}

#pragma mark -- 界面UI
- (void)addSections
{
    DHTTableViewSection *section = [DHTTableViewSection section];
    for (TDFFunctionVo * item in self.dataArray) {
        TDFDisplayCommonItem *callVoiceItem = [[TDFDisplayCommonItem alloc] init];
        callVoiceItem.iconImage = [UIImage imageNamed:item.iconImageUrl.hUrl];
        callVoiceItem.title = item.actionName;
        callVoiceItem.detail = item.detail;
        callVoiceItem.isLock = item.isLock;
        callVoiceItem.isModuleRecharge = ![TDFIsOpen isOpen:item.actionCode childFunctionArr:self.childFunctionArr];
        @weakify(self);
        callVoiceItem.clickedBlock = ^ () {
            @strongify(self);
            [self forwardCallVoiceVC:item];
        };
        
        [section addItem:callVoiceItem];
    }
    [self.manager addSection:section];
    [self.manager reloadData];
}


- (void)registerCells
{
    [self.manager registerCell:@"TDFDisplayCommonCell" withItem:@"TDFDisplayCommonItem"];
}

#pragma mark -- initData
//创建二级菜单
-(void) initDataArray
{
    TDFFunctionVo *functionVO = [TDFFunctionVo new];
    functionVO.actionCode = [Platform Instance].isChain?@"PHONE_BRAND_MENU_SEND": PAD_PRODUCE_PLAN;
    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVO.actionName = NSLocalizedString(@"传菜方案", nil);
    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVO.iconImageUrl.hUrl = @"ico_transmenu_manage";
    [_dataArray addObject:functionVO];
    
    functionVO = [TDFFunctionVo new];
    functionVO.actionCode = [Platform Instance].isChain?@"PHONE_BRAND_NOTPRINT":PAD_NOTPRINT;
    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVO.actionName = NSLocalizedString(@"不出单商品", nil);
    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVO.iconImageUrl.hUrl = @"ico_transmenu_nolistmenu";
    [_dataArray addObject:functionVO];
    
    if (![Platform Instance].isChain) {
        functionVO = [TDFFunctionVo new];
        functionVO.actionCode = PAD_REPLACE_PRINT;
        functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
        functionVO.actionName = NSLocalizedString(@"备用打印机", nil);
        functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
        functionVO.iconImageUrl.hUrl = @"ico_trans_standbyprinter";
        [_dataArray addObject:functionVO];
        
        functionVO = [TDFFunctionVo new];
        functionVO.actionCode = PHONE_AREA_PRINT;
        functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
        functionVO.actionName = NSLocalizedString(@"点菜单分区域打印", nil);
        functionVO.detail = NSLocalizedString(@"设置不同区域里桌位的点菜单打印到不同的打印机上", nil);
        functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
        functionVO.iconImageUrl.hUrl = @"ico_transmenu_areaprint";
        [_dataArray addObject:functionVO];
    }
    
    functionVO = [TDFFunctionVo new];
    functionVO.actionCode = [Platform Instance].isChain?@"PHONE_BRAND_SUIT_MENU_PRINT":PHONE_SUIT_MENU_PRINT;
    functionVO.isLock = [self.codeArray containsObject:functionVO.actionCode]?NO:YES;
    functionVO.actionName = NSLocalizedString(@"套餐中商品分类打印设置", nil);
    functionVO.detail = NSLocalizedString(@"设置套餐打印时不需要一菜一切的分类", nil);
    functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
    functionVO.iconImageUrl.hUrl = @"ico_transmenu_kindmenuprint";
    [_dataArray addObject:functionVO];
}

#pragma mark 跳转到子页面

- (void)forwardCallVoiceVC:(TDFFunctionVo *)functionVO
{
    if (functionVO.isLock) {
        [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),functionVO.actionName]];
        return ;
    }
    if (![TDFIsOpen isOpen:functionVO.actionCode childFunctionArr:self.childFunctionArr]) {
        for (TDFFunctionVo *item in self.childFunctionArr) {
            if ([item.actionCode isEqualToString:functionVO.actionCode]) {
                [TDFIsOpen goToModuleDetailViewController:item];
                return;
            }
        }
    }
    [self pushViewControllerWithCode:functionVO.actionCode];
}

- (void)pushViewControllerWithCode:(NSString *)actionCode
{
    if ([Platform Instance].isChain) {
        if ([actionCode isEqualToString:@"PHONE_BRAND_SUIT_MENU_PRINT"]) {
            [self swichPlist:actionCode];
            return;
        }
        
        TDFTransPlateViewController *vc = [[TDFTransPlateViewController alloc] init];
        vc.actionCode = actionCode;
        vc.transType = [actionCode isEqualToString:@"PHONE_BRAND_MENU_SEND"]?TDFTransMenu:[actionCode isEqualToString:@"PHONE_BRAND_NOTPRINT"]?TDFITransNoListMenu:0;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self swichPlist:actionCode];
    }
}

- (void) swichPlist:(NSString *)actionCode
{
    NSDictionary *switchU = [Platform Instance].allFunctionSwitchDictionary[actionCode];
    if (switchU[@"mediatorMethod"]) {
        SEL action = NSSelectorFromString(switchU[@"mediatorMethod"]);
        @weakify(self);
        if ([[TDFMediator sharedInstance] respondsToSelector:action]) {
            @strongify(self);
            UIViewController *viewController = [[TDFMediator sharedInstance] performSelector:action withObject:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

@end
