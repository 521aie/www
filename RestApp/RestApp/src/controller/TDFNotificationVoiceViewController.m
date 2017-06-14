//
//  TDFNotificationVoiceViewController.m
//  RestApp
//
//  Created by happyo on 16/10/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFNotificationVoiceViewController.h"
#import "TDFRootViewController+TableViewManager.h"
#import "TDFRootViewController+AlertMessage.h"
#import "DHTTableViewManager.h"
#import "DHTTableViewSection.h"
#import "TDFPickerItem.h"
#import "TDFShowPickerStrategy.h"
#import "NameItemVO.h"
#import "TDFCustomStrategy.h"
#import "HelpDialog.h"
#import "TDFTakeMealService.h"
#import "TDFResponseModel.h"
#import "TDFEditViewHelper.h"
#import "TDFBaseEditView.h"

@interface TDFNotificationVoiceViewController ()

@property (nonatomic, strong) TDFPickerItem *sexItem;

@property (nonatomic, strong) TDFPickerItem *numItem;

@property (nonatomic, strong) NSMutableArray<INameItem> *sexItemList;

@property (nonatomic, strong) NSMutableArray<INameItem> *numItemList;

@property (nonatomic, strong) DHTTableViewSection *commonVoiceSection;

@end
@implementation TDFNotificationVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"广播语音", nil);
    [self configureBackground];
    [self configDefaultManager];
    [self registerCells];
    
    [self addDefaultSections];
    [self fetchNotificationVoiceSetting];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeNavTitles:) name:kTDFEditViewIsShowTipNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureBackground
{
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha = 0.7;
    [self.view insertSubview:alphaView atIndex:1];
}

- (void)registerCells
{
    [self.manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
}

- (void)addDefaultSections
{
    DHTTableViewSection *sexAndNumSection = [DHTTableViewSection section];
    
    self.sexItem = [[TDFPickerItem alloc] init];
    self.sexItem.title = NSLocalizedString(@"广播语音性别", nil);
    TDFShowPickerStrategy *sexStrategy = [[TDFShowPickerStrategy alloc] init];
    sexStrategy.pickerName = self.sexItem.title;
    sexStrategy.pickerItemList = self.sexItemList;
    NameItemVO *sexSelectedItem = self.sexItemList.firstObject;
    sexStrategy.selectedItem = sexSelectedItem;
    self.sexItem.strategy = sexStrategy;
    self.sexItem.textValue = sexSelectedItem.itemName;
    self.sexItem.preValue = sexSelectedItem.itemName;
    @weakify(self);
    self.sexItem.filterBlock = ^ (NSString *textValue,id requestValue) {
        @strongify(self);
        [self updateCommonVoiceListWithSex:textValue];
        [self.manager reloadData];
        
        return YES;
    };
    
    [sexAndNumSection addItem:self.sexItem];
    
    self.numItem = [[TDFPickerItem alloc] init];
    self.numItem.title = NSLocalizedString(@"叫号时随机播放", nil);
    TDFShowPickerStrategy *numStrategy = [[TDFShowPickerStrategy alloc] init];
    numStrategy.pickerName = self.numItem.title;
    numStrategy.pickerItemList = self.numItemList;
    NameItemVO *numSelectedItem = self.numItemList.firstObject;
    numStrategy.selectedItem = numSelectedItem;
    self.numItem.strategy = numStrategy;
    self.numItem.textValue = numSelectedItem.itemName;
    self.numItem.preValue = numSelectedItem.itemName;
    self.numItem.detail = NSLocalizedString(@"提示：二维火取餐叫号或排队将根据此处的设置随机播放以下1-5段广播语音。", nil);
    
    [sexAndNumSection addItem:self.numItem];
    
    [self.manager addSection:sexAndNumSection];
    
    [self addCommonVoiceSections];
}

- (void)addCommonVoiceSections
{
    self.commonVoiceSection = [DHTTableViewSection section];
    
    TDFCustomStrategy *commonStrategy = [[TDFCustomStrategy alloc] init];
    commonStrategy.btnClickedBlock = ^ () {
        // 显示提示页面
        [HelpDialog show:@"uploadVoice"];
    };
    for (int i = 1; i < 6; i++) {
        TDFPickerItem *commonItem = [[TDFPickerItem alloc] init];
        commonItem.title = [NSString stringWithFormat:NSLocalizedString(@"广播语音%i：", nil), i];
        commonItem.strategy = commonStrategy;
        commonItem.textValue = [self getCommonVoiceValueWithSex:self.sexItem.textValue];
        commonItem.preValue = commonItem.textValue;
        
        if (i == 1) {
            commonItem.detail = NSLocalizedString(@"欢迎光临本店", nil);
        } else if (i == 2) {
            commonItem.detail = NSLocalizedString(@"排队人数较多，请保管好您的随身财物", nil);
        } else if (i == 3) {
            commonItem.detail = NSLocalizedString(@"为了您和他人的身体健康，请勿在店内吸烟", nil);
        } else if (i == 4) {
            commonItem.detail = NSLocalizedString(@"排队人数较多，请照看好您的小孩儿", nil);
        } else if (i == 5) {
            commonItem.detail = NSLocalizedString(@"现在是用餐高峰期，请取号排队", nil);
        }
        
        [self.commonVoiceSection addItem:commonItem];
    }
    
    [self.manager addSection:self.commonVoiceSection];
}

- (void)fetchNotificationVoiceSetting
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFTakeMealService fetchNotificationVoiceSettingWithCompleteBlock:^(TDFResponseModel *response) {
        [self.progressHud hide:YES];
        NSString *msg = response.error.localizedDescription;
        if ([response isSuccess]) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                //
                NSDictionary *dic =response.responseObject;
                
                NSDictionary *dataDict = dic[@"data"];
                
                NSNumber *sex = dataDict[@"sex"];
                NSNumber *intervalNum = dataDict[@"num"];
                NSArray *commonVoiceList = dataDict[@"voices"];

                [self updateSexItemWithSexNum:sex];
                [self updateNumItemWithIntervalNum:intervalNum];
                [self updateCommonVoicesWithList:commonVoiceList];
                
                [self.manager reloadData];
            }
        } else {
            [self showMessageWithTitle:msg message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }
    }];

}

- (void)updateSexItemWithSexNum:(NSNumber *)sexNum
{
    for (NameItemVO *vo in self.sexItemList) {
        if ([vo.itemId isEqualToString:[NSString stringWithFormat:@"%@", sexNum]]) {
            self.sexItem.textValue = vo.itemName;
            self.sexItem.preValue = vo.itemName;
            self.sexItem.requestValue = vo.itemId;
            
            ((TDFShowPickerStrategy *)self.sexItem.strategy).selectedItem = vo;
        }
    }
}

- (void)updateNumItemWithIntervalNum:(NSNumber *)intervalNum
{
    for (NameItemVO *vo in self.numItemList) {
        if ([vo.itemId isEqualToString:[NSString stringWithFormat:@"%@", intervalNum]]) {
            self.numItem.textValue = vo.itemName;
            self.numItem.preValue = vo.itemName;
            self.numItem.requestValue = vo.itemId;
            
            ((TDFShowPickerStrategy *)self.numItem.strategy).selectedItem = vo;
        }
    }
}

- (void)updateCommonVoicesWithList:(NSArray *)commonVoiceList
{
    
    NSArray *array = @[NSLocalizedString(@"欢迎光临本店", nil), NSLocalizedString(@"排队人数较多，请保管好您的随身财物", nil), NSLocalizedString(@"为了您和他人的身体健康，请勿在店内吸烟", nil), NSLocalizedString(@"排队人数较多，请照看好您的小孩儿", nil), NSLocalizedString(@"现在是用餐高峰期，请取号排队", nil)];
    for (NSDictionary *dict in commonVoiceList) {
        //
        NSNumber *code = dict[@"code"];
        NSString *path = dict[@"path"];
        
        NSInteger index = [code integerValue] - 1;
        
        if (index < 0 || index >= self.commonVoiceSection.items.count) {
            return ;
        }
        
        TDFPickerItem *commonVoice = self.commonVoiceSection.items[index];
        NSString *text = [self getVoiceTextWithPath:path];
        
        commonVoice.textValue = text;
        commonVoice.requestValue = text;
        commonVoice.preValue = text;
        NSString *detail = dict[@"text"];
        commonVoice.detail = detail.length == 0 ? array[index] : detail;
    }
}


- (void)updateCommonVoiceListWithSex:(NSString *)sexString
{
    NSString *text = [self getCommonVoiceValueWithSex:sexString];
    for (TDFPickerItem *commonVoice in self.commonVoiceSection.items) {
        if (![commonVoice.textValue isEqualToString:NSLocalizedString(@"自定义语音", nil)]) {
            commonVoice.textValue = text;
            commonVoice.requestValue = text;
        }
    }
}

- (BOOL)isAnyTipsShowed
{
    return [TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections];
}

- (void)saveSetting
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFTakeMealService updateNotificationVoiceSettingWithSex:self.sexItem.requestValue intervalTime:self.numItem.requestValue completeBlock:^(TDFResponseModel *response) {
        [self.progressHud hide:YES];
        NSString *string = response.error.localizedDescription;
        if ([response isSuccess]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showMessageWithTitle:string message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        }
    }];
    
}

#pragma mark -- Actions --

- (void)rightNavigationButtonAction:(id)sender
{
    if ([self isAnyTipsShowed]) {
        [self saveSetting];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[self isAnyTipsShowed]];
}

#pragma mark -- Notifications --

- (void)shouldChangeNavTitles:(NSNotification *)notification
{
    if ([self isAnyTipsShowed]) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    } else {
        [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
        [self configRightNavigationBar:nil rightButtonName:nil];
    }
}

#pragma mark -- Getters && Setters --

- (NSString *)getVoiceTextWithPath:(NSString *)path
{
    if (path) {
        return NSLocalizedString(@"自定义语音", nil);
    } else {
        return [self getCommonVoiceValueWithSex:self.sexItem.textValue];
    }
}

- (NSMutableArray<INameItem> *)sexItemList
{
    if (!_sexItemList) {
        _sexItemList = [NSMutableArray<INameItem> array];
        NameItemVO *valueVO = [[NameItemVO alloc] init];
        valueVO.itemId = @"0";
        valueVO.itemName = NSLocalizedString(@"女声", nil);
        valueVO.itemValue = @"0";
        
        NameItemVO *valueVOOne = [[NameItemVO alloc] init];
        valueVOOne.itemId = @"1";
        valueVOOne.itemName = NSLocalizedString(@"男声", nil);
        valueVOOne.itemValue = @"1";
        
        [_sexItemList addObject:valueVO];
        [_sexItemList addObject:valueVOOne];
    }
    
    return _sexItemList;
}

- (NSMutableArray<INameItem> *)numItemList
{
    if (!_numItemList) {
        _numItemList = [NSMutableArray<INameItem> array];
        NameItemVO *valueVO = [[NameItemVO alloc] init];
        valueVO.itemId = @"0";
        valueVO.itemName = NSLocalizedString(@"不播放", nil);
        valueVO.itemValue = @"0";
        
        NameItemVO *valueVOOne = [[NameItemVO alloc] init];
        valueVOOne.itemId = @"1";
        valueVOOne.itemName = NSLocalizedString(@"每叫1个号播放一段", nil);
        valueVOOne.itemValue = @"1";
        
        NameItemVO *valueVOTwo = [[NameItemVO alloc] init];
        valueVOTwo.itemId = @"3";
        valueVOTwo.itemName = NSLocalizedString(@"每叫3个号播放一段（默认）", nil);
        valueVOTwo.itemValue = @"3";
        
        NameItemVO *valueVOThree = [[NameItemVO alloc] init];
        valueVOThree.itemId = @"5";
        valueVOThree.itemName = NSLocalizedString(@"每叫5个号播放一段", nil);
        valueVOThree.itemValue = @"5";
        
        [_numItemList addObject:valueVO];
        [_numItemList addObject:valueVOOne];
        [_numItemList addObject:valueVOTwo];
        [_numItemList addObject:valueVOThree];
    }
    
    return _numItemList;
}

- (NSString *)getCommonVoiceValueWithSex:(NSString *)sexString
{
    return [NSString stringWithFormat:NSLocalizedString(@"默认语音（%@）", nil), sexString];
}

@end
