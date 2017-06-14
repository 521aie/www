//
//  TDFCallVoiceViewController.m
//  RestApp
//
//  Created by happyo on 16/10/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFCallVoiceViewController.h"
#import "TDFTakeMealService.h"
#import "TDFRootViewController+TableViewManager.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFResponseModel.h"
#import "DHTTableViewManager.h"
#import "DHTTableViewSection.h"
#import "TDFPickerItem.h"
#import "TDFPickerItem+Chainable.h"
#import "TDFShowPickerStrategy.h"
#import "NameItemVO.h"
#import "TDFCustomStrategy.h"
#import "HelpDialog.h"
#import "TDFBaseEditView.h"
#import "TDFEditViewHelper.h"

@interface TDFCallVoiceViewController ()

@property (nonatomic, strong) TDFPickerItem *sexItem;

@property (nonatomic, strong) TDFPickerItem *numItem;

@property (nonatomic, strong) TDFPickerItem *suffixItem;

@property (nonatomic, strong) DHTTableViewSection *commonVoiceSection;

@property (nonatomic, strong) NSMutableArray<INameItem> *sexItemList;

@property (nonatomic, strong) NSMutableArray<INameItem> *numItemList;

@property (nonatomic, strong) DHTTableViewSection *moreVoiceSection;

@property (nonatomic, strong) TDFPickerItem *moreSexItem;

@property (nonatomic, strong) TDFPickerItem *lineVoiceSuffixItem;


@end

@implementation TDFCallVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"叫号语音", nil);
    [self configureBackground];
    [self configDefaultManager];
    [self registerCells];

    [self addDefaultSections];
    [self fetchCallVoiceSetting];
    
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
    DHTTableViewSection *sexAndNumSectionHeader = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"二维火取餐叫号、排队共用语音", nil)];
    
    DHTTableViewSection *sexAndNumSection = [DHTTableViewSection section];
    
    self.sexItem = [[TDFPickerItem alloc] init];
    self.sexItem.title = NSLocalizedString(@"叫号语音性别", nil);
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
        [self updateLineVoiceListWithSex:textValue];
        NSString *text = [self getCommonVoiceValueWithSex:textValue];
        self.suffixItem.requestValue = text;
        self.suffixItem.textValue = text;
        self.lineVoiceSuffixItem.requestValue = text;
        self.lineVoiceSuffixItem.textValue = text;
        [self.manager reloadData];
        
        return YES;
    };
    
    [sexAndNumSection addItem:self.sexItem];
    
    self.numItem = [[TDFPickerItem alloc] init];
    self.numItem.title = NSLocalizedString(@"叫号重复次数", nil);
    TDFShowPickerStrategy *numStrategy = [[TDFShowPickerStrategy alloc] init];
    numStrategy.pickerName = self.numItem.title;
    numStrategy.pickerItemList = self.numItemList;
    NameItemVO *numSelectedItem = self.numItemList.firstObject;
    numStrategy.selectedItem = numSelectedItem;
    self.numItem.strategy = numStrategy;
    self.numItem.textValue = numSelectedItem.itemName;
    self.numItem.preValue = numSelectedItem.itemName;
    
    [sexAndNumSection addItem:self.numItem];
    
    [self.manager addSection:sexAndNumSectionHeader];
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
    for (int i = 0; i < 10; i++) {
        TDFPickerItem *commonItem = [[TDFPickerItem alloc] init];
        commonItem.title = [NSString stringWithFormat:NSLocalizedString(@"叫号语音：%i", nil), i];
        commonItem.strategy = commonStrategy;
        commonItem.textValue = [self getCommonVoiceValueWithSex:self.sexItem.textValue];
        commonItem.preValue = commonItem.textValue;
        
        [self.commonVoiceSection addItem:commonItem];
    }

    [self.manager addSection:self.commonVoiceSection];
    
    DHTTableViewSection *moreSettingSectionHeader = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"二维火取餐叫号更多设置", nil)];
    
    DHTTableViewSection *moreSettingSection = [DHTTableViewSection section];
    
    self.suffixItem = [[TDFPickerItem alloc] init];
    self.suffixItem.title = NSLocalizedString(@"叫号语音后缀：请取餐", nil);
    self.suffixItem.strategy = commonStrategy;
    self.suffixItem.textValue = [self getCommonVoiceValueWithSex:self.sexItem.textValue];
    self.suffixItem.preValue = self.suffixItem.textValue;
    self.suffixItem.detail = NSLocalizedString(@"语音播放内容包括单号和此处上传的语音文件，例如：20号请取餐。点击默认语音，跳转到语音上传页面。", nil);
    
    [moreSettingSection addItem:self.suffixItem];
    
    [self.manager addSection:moreSettingSectionHeader];
    [self.manager addSection:moreSettingSection];
    [self addMoreVoiceSection];
}


- (void)addMoreVoiceSection {

    DHTTableViewSection *moreVoiceHeaderSection = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"二维火排队更多设置", nil)];
    
    TDFCustomStrategy *commonStrategy = [[TDFCustomStrategy alloc] init];
    commonStrategy.btnClickedBlock = ^ () {
        // 显示提示页面
        [HelpDialog show:@"uploadVoice"];
    };
    
    self.moreVoiceSection = [DHTTableViewSection section];
    self.lineVoiceSuffixItem = [[TDFPickerItem alloc] init];
    self.lineVoiceSuffixItem.title = [NSString stringWithFormat:NSLocalizedString(@"叫号语音后缀：请用餐", nil)];
    self.lineVoiceSuffixItem.detail = NSLocalizedString(@"提示：语音播放内容包括排队单号和此处上传的语音文件，例如：C20请用餐", nil);
    self.lineVoiceSuffixItem.strategy = commonStrategy;
    self.lineVoiceSuffixItem.textValue = [self getCommonVoiceValueWithSex:self.sexItem.textValue];
    self.lineVoiceSuffixItem.preValue = self.lineVoiceSuffixItem.textValue;
    [self.moreVoiceSection addItem:self.lineVoiceSuffixItem];
    
    for (int i = 0; i < 4; i++) {
        TDFPickerItem *commonItem = [[TDFPickerItem alloc] init];
        commonItem.title = [NSString stringWithFormat:NSLocalizedString(@"叫号语音：%c", nil), 'A' + i];
        commonItem.strategy = commonStrategy;
        commonItem.textValue = [self getCommonVoiceValueWithSex:self.sexItem.textValue];
        commonItem.preValue = commonItem.textValue;
        
        [self.moreVoiceSection addItem:commonItem];
    }
    
    [self.manager addSection:moreVoiceHeaderSection];
    [self.manager addSection:self.moreVoiceSection];
}

- (void)fetchCallVoiceSetting
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFTakeMealService fetchCallVoiceSettingWithCompleteBlock:^(TDFResponseModel *response) {
        [self.progressHud hide:YES];
        NSString *msg = response.error.localizedDescription;
        if ([response isSuccess]) {
            if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                //
                NSDictionary *dic =response.responseObject;
                
                NSDictionary *dataDict = dic[@"data"];

                NSNumber *sex = dataDict[@"sex"];
                NSNumber *repeatNum = dataDict[@"num"];
                NSArray *commonVoiceList = dataDict[@"voices"];
                
                NSDictionary *voiceSuffix = dataDict[@"voiceSuffix"];
                NSString *path = voiceSuffix[@"path"];
                [self updateSexItemWithSexNum:sex];
                [self updateNumItemWithRepeatNum:repeatNum];                [self updateCommonVoicesWithList:commonVoiceList];
                [self updateSuffixItemWithPath:path text:dataDict[@"voiceSuffix"][@"text"]];
                [self updateMoreVoicesWithList:dataDict[@"lineVoices"]];
                [self updateLineVoiceSuffixItemWithPath:dataDict[@"lineVoiceSuffix"][@"path"] string:dataDict[@"lineVoiceSuffix"][@"text"]];
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

- (void)updateNumItemWithRepeatNum:(NSNumber *)repeatNum
{
    for (NameItemVO *vo in self.numItemList) {
        if ([vo.itemId isEqualToString:[NSString stringWithFormat:@"%@", repeatNum]]) {
            self.numItem.textValue = vo.itemName;
            self.numItem.preValue = vo.itemName;
            self.numItem.requestValue = vo.itemId;
            
            ((TDFShowPickerStrategy *)self.numItem.strategy).selectedItem = vo;
        }
    }
}

- (void)updateCommonVoicesWithList:(NSArray *)commonVoiceList
{
    for (NSDictionary *dict in commonVoiceList) {
        //
        NSNumber *code = dict[@"code"];
        NSString *path = dict[@"path"];
        
        if ([code integerValue] < 0 || [code integerValue] >= self.commonVoiceSection.items.count) {
            return ;
        }
        
        TDFPickerItem *commonVoice = self.commonVoiceSection.items[[code integerValue]];
        NSString *text = [self getVoiceTextWithPath:path];
        
        commonVoice.textValue = text;
        commonVoice.requestValue = text;
        commonVoice.preValue = text;
    }
}


- (void)updateMoreVoicesWithList:(NSArray *)voiceList
{
    NSInteger count = MIN(voiceList.count, 4);
    for (NSInteger i = 0; i < count; i++) {
        //
        NSDictionary *dict = voiceList[i];
//        NSString *code = dict[@"code"];
        NSString *path = dict[@"path"];
        
//        if ([code integerValue] < 0 || [code integerValue] >= self.moreVoiceSection.items.count) {
//            return ;
//        }
        
        TDFPickerItem *commonVoice = self.moreVoiceSection.items[i + 1];
        NSString *text = [self getVoiceTextWithPath:path];
        commonVoice.title = [NSString stringWithFormat:@"叫号语音：%@", dict[@"code"]];
        
        commonVoice.textValue = text;
        commonVoice.requestValue = text;
        commonVoice.preValue = text;
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

- (void)updateLineVoiceListWithSex:(NSString *)sexString {
    NSString *text = [self getCommonVoiceValueWithSex:sexString];
    for (NSInteger i = 1; i < 5; i++) {
        TDFPickerItem *commonVoice = self.moreVoiceSection.items[i];
        if (![commonVoice.textValue isEqualToString:NSLocalizedString(@"自定义语音", nil)]) {
            commonVoice.textValue = text;
            commonVoice.requestValue = text;
        }
    }
}


- (void)updateLineVoiceSuffixItemWithPath:(NSString *)path string:(NSString *)string {
    NSString *text = [self getVoiceTextWithPath:path];
    
    self.lineVoiceSuffixItem.textValue = text;
    self.lineVoiceSuffixItem.requestValue = text;
    self.lineVoiceSuffixItem.preValue = text;
    self.lineVoiceSuffixItem.title = [NSString stringWithFormat:NSLocalizedString(@"叫号语音后缀：%@", nil), string.length == 0 ? NSLocalizedString(@"请用餐", nil) : string];
}

- (void)updateSuffixItemWithPath:(NSString *)path  text:(NSString *)string
{
    NSString *text = [self getVoiceTextWithPath:path];
    
    self.suffixItem.textValue = text;
    self.suffixItem.requestValue = text;
    self.suffixItem.preValue = text;
    self.suffixItem.title = [NSString stringWithFormat:NSLocalizedString(@"叫号语音后缀：%@", nil), string.length == 0 ? NSLocalizedString(@"请取餐", nil) : string];
}

- (BOOL)isAnyTipsShowed
{
    return [TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections];
}

- (void)saveSetting
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFTakeMealService updateCallVoiceSettingWithSex:self.sexItem.requestValue repeateTime:self.numItem.requestValue completeBlock:^(TDFResponseModel *response) {
        NSString *msg = response.error.localizedDescription;
        [self.progressHud hide:YES];
        if ([response isSuccess]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showMessageWithTitle:msg message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
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
        valueVO.itemName = NSLocalizedString(@"不重复", nil);
        valueVO.itemValue = @"0";
        
        NameItemVO *valueVOOne = [[NameItemVO alloc] init];
        valueVOOne.itemId = @"2";
        valueVOOne.itemName = NSLocalizedString(@"2次（默认）", nil);
        valueVOOne.itemValue = @"2";
        
        NameItemVO *valueVOTwo = [[NameItemVO alloc] init];
        valueVOTwo.itemId = @"3";
        valueVOTwo.itemName = NSLocalizedString(@"3次", nil);
        valueVOTwo.itemValue = @"3";
        
        NameItemVO *valueVOThree = [[NameItemVO alloc] init];
        valueVOThree.itemId = @"5";
        valueVOThree.itemName = NSLocalizedString(@"5次", nil);
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
