//
//  TDFSmartOrderController.m
//  RestApp
//
//  Created by BK_G on 2017/1/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSmartOrderController.h"
#import "DHTTableViewManager.h"
#import "TDFBaseEditView.h"
#import "TDFEditViewHelper.h"
#import "TDFPickerItem.h"
#import "TDFSwitchItem.h"
#import "Masonry.h"
#import "TDFShowPickerStrategy.h"
#import "NameItemVO.h"
#import "INameItem.h"
#import "TDFTagPaperTempleteView.h"
#import "TDFShopTemplateService.h"
#import "TDFSmartOrderModel.h"
#import "YYModel.h"
#import "TDFEditViewHelper.h"
#import "TDFRootViewController+AlertMessage.h"
#import "AlertBox.h"
#import "TDFEditViewHelper.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface TDFSmartOrderController ()

/***模版模型*/
@property (nonatomic, strong) TDFSmartOrderModel *model;

/***表控制者*/
@property (nonatomic, strong) DHTTableViewManager *manager;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *alphaView;

@property (nonatomic, strong) UIView *tipsView;

@property (nonatomic, strong) UIView *footerView;

//预览视图
@property (nonatomic, strong) TDFTagPaperTempleteView *templeteView;

@property (nonatomic, strong) UIView *resumeView;

@property (nonatomic, strong) UIButton *resumeBtn;

@property (nonatomic, assign) BOOL isResumeToDefault;

@property (nonatomic, assign) BOOL isShowSaveBtn;

@end

@implementation TDFSmartOrderController


#pragma mark - lifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeNavTitles:) name:kTDFEditViewIsShowTipNotification object:nil];
    
    self.title = NSLocalizedString(@"智能收银点菜单", nil);
    
    [self configLayout];
    
    [self configConstrains];
    
    [self loadDataWithFieldCode:nil andFieldValue:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - LoadData
//加载数据
- (void)loadDataWithFieldCode:(NSString *)fieldCode andFieldValue:(NSString *)fieldValue {
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFShopTemplateService query_template_function_detailWithCode:self.code andFieldCode:fieldCode andFieldValue:fieldValue CompleteBlock:^(TDFResponseModel * _Nullable response) {
        
        [self.progressHud hide:YES];
        
        NSDictionary *dic = response.responseObject;
        
        if (response.error) {
            
            [AlertBox show:response.error.localizedDescription];
            return ;
        }
        if (![NSString stringWithFormat:@"%@",dic[@"code"]].integerValue) {
            
            [AlertBox show:[NSString stringWithFormat:@"%@",dic[@"message"]]];
            
            return;
        }
        
        
        TDFSmartOrderModel *model = [TDFSmartOrderModel yy_modelWithDictionary:[response.responseObject objectForKey:@"data"]];
        
        [self configModel:model];
        
    }];
}

//根据服务端模版设置界面
- (void)configModel:(TDFSmartOrderModel *)model {
    
    self.title = model.name;
    self.model = model;
    
    [self.manager removeAllSections];
    
    for (TDFSmartOrderGroupModel *groupModel in self.model.functionGroupList) {
        
        DHTTableViewSection *section = [DHTTableViewSection new];
        
        for (TDFSmartOrderFieldModel *fieldModel in groupModel.funcFieldValues) {
            
            if ([fieldModel.type isEqualToString:@"radio"]) {
                
                [self makeSwitchItemWith:fieldModel andSection:section];
                
            }else if ([fieldModel.type isEqualToString:@"select"]) {
                
                [self makePickerItemWith:fieldModel andSection:section];
                
            }else {
                
            }
        }
        if (groupModel.isDisplay) {
            
            if (groupModel.remark) {
                
                DHTTableViewSection *displaySection = [self sectionWithTitleHeader:groupModel.name andRemark:groupModel.remark];
                [self.manager addSection:displaySection];
            }else {
                
                DHTTableViewSection *displaySection = [DHTTableViewSection sectionWithTitleHeader:groupModel.name];
                [self.manager addSection:displaySection];
            }
        }
        [self.manager addSection:section];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.isResumeToDefault = NO;
        
        [self.manager reloadData];
        
        [self configTemplete];
    });
}

//根据item设置view的TDFSwitchItem
- (void)makeSwitchItemWith:(TDFSmartOrderFieldModel *)fieldModel andSection:(DHTTableViewSection *)section{
    
    TDFSwitchItem *item = [TDFSwitchItem new];
    
    item.title = fieldModel.name;
    
    item.isOn = [fieldModel.value boolValue];
    item.editStyle = fieldModel.isEditable?TDFEditStyleEditable:TDFEditStyleUnEditable;
    item.preValue = @(item.isOn);
    
    if (self.isResumeToDefault) {
        
        item.isOn = [fieldModel.defaultValue boolValue];
        
        item.preValue = @([fieldModel.value boolValue]);
        
        fieldModel.value = fieldModel.defaultValue;
    }
    
    item.shouldShow = fieldModel.isDisplay;
    
    [section addItem:item];
    
    __weak typeof(item) weakItem = item;
    
    WS(weakSelf);
    
    item.filterBlock = ^ (BOOL isOn) {
        
        if (isOn) {
            
            if (![weakSelf judgeIsUnderLimitWithModel:fieldModel]) {
                
                return NO;
            }
        }
        weakItem.isOn = isOn;
        
        fieldModel.value = [NSString stringWithFormat:@"%d",isOn];
        
        [weakSelf configTemplete];
        
        return YES;
    };
}
//根据item设置view的TDFPickerItem
- (void)makePickerItemWith:(TDFSmartOrderFieldModel *)fieldModel andSection:(DHTTableViewSection *)section {
    
    TDFPickerItem *item = [TDFPickerItem new];
    
    item.title = fieldModel.name;
    
    item.textValue = fieldModel.value;
    
    item.editStyle = fieldModel.isEditable?TDFEditStyleEditable:TDFEditStyleUnEditable;
  
    /***
     if (self.isResumeToDefault) {
     
     item.textValue = fieldModel.defaultValue;
     }
     ***/
    
    item.preValue = item.textValue;
    
    [section addItem:item];
    
    __weak typeof(item) weakItem = item;
    WS(weakSelf);
    
    TDFShowPickerStrategy *strategy = [TDFShowPickerStrategy new];
    
    strategy.pickerName = item.title;
    
    NSMutableArray<INameItem> *inameItemArr = [NSMutableArray<INameItem> new];
    
    for (NSString *value in fieldModel.optionalValue) {
        
        NameItemVO *itemVo = [NameItemVO new];
        
        itemVo.itemName = value;
        itemVo.itemId = value;
        itemVo.itemValue = value;
        
        [inameItemArr addObject:itemVo];
    }
    
    strategy.pickerItemList = inameItemArr;
    
    for (NameItemVO *itemVo in inameItemArr) {
        
        if ([fieldModel.value isEqualToString:itemVo.itemName]) {
            
            strategy.selectedItem = itemVo;
            
            break;
        }
    }
    
    item.strategy = strategy;
    
    item.filterBlock = ^ (NSString *textValue,id requestValue) {
        
        if (fieldModel.isLinkageField) {
            
            if ([TDFEditViewHelper isAnyTipsShowedInSections:weakSelf.manager.sections]) {
                
                [weakSelf showAlertWithTextValue:textValue];
            }else {
            
                
                [self changeTemplateWithCode:self.model.functionGroupList[0].funcFieldValues[0].code andValue:textValue];
            }
        }
        return NO;
    };
}

- (void)showAlertWithTextValue:(NSString *)textValue {
    
    if ([TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections]) {
        
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"内容有变更尚未保存，确定要切换吗？", nil) cancelBlock:^{
            
        } enterBlock:^{
            
            [self changeTemplateWithCode:self.model.functionGroupList[0].funcFieldValues[0].code andValue:textValue];
        }];
    }
}


//判断是否满足当前组最大item数量限制
- (BOOL )judgeIsUnderLimitWithModel:(TDFSmartOrderFieldModel *)model {
    
    for (TDFSmartOrderGroupModel *groupModel in self.model.functionGroupList) {
        
        if ([groupModel.funcFieldValues containsObject:model]) {
            
            if (!groupModel.isMaxLimited) {
                
                return YES;
            }
            int i = 0;
            
            for (TDFSmartOrderFieldModel *fieldModel in groupModel.funcFieldValues) {
                
                if ([fieldModel.value boolValue]&&fieldModel.isDisplay) {
                    
                    i++;
                }
            }
            if (i+1>groupModel.maxNum) {
                
                [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:@"%@%@",groupModel.name,groupModel.remark] cancelTitle:NSLocalizedString(@"我知道了", nil)];
                
                return NO;
            }
            return YES;
        }
    }
    return YES;
}

#pragma mark - Getter & setter

- (TDFSmartOrderModel *)model {
    
    if (!_model) {
        
        _model = [TDFSmartOrderModel new];
    }
    
    return _model;
}

- (UIView *)footerView {
    
    if (!_footerView) {
        
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    }
    
    return _footerView;
}

- (UIView *)tipsView {
    
    if (!_tipsView) {
        
        _tipsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.14)];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, _tipsView.frame.size.width-10, _tipsView.frame.size.height)];
        
        label.font = [UIFont systemFontOfSize:15];
        
        [_tipsView addSubview:label];
        
        label.text = NSLocalizedString(@"标签纸模板预览", nil);
    }
    return _tipsView;
}

- (UIView *)resumeView {
    
    if (!_resumeView) {
        
        _resumeView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH*0.8, SCREEN_WIDTH, SCREEN_WIDTH*0.2)];
    }
    return _resumeView;
}

- (UIButton *)resumeBtn {
    
    if (!_resumeBtn) {
        
//        _resumeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.82, SCREEN_WIDTH*0.02, SCREEN_WIDTH*0.16, SCREEN_WIDTH*0.16)];
        _resumeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.82, SCREEN_HEIGHT -SCREEN_WIDTH*0.16-70, SCREEN_WIDTH*0.16, SCREEN_WIDTH*0.16)];
        
        [_resumeBtn setBackgroundImage:[UIImage imageNamed:@"resume"] forState:UIControlStateNormal];
        
        [_resumeBtn addTarget:self action:@selector(resumeAll) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resumeBtn;
}

- (TDFTagPaperTempleteView *)templeteView {
    
    if (!_templeteView) {
        
        _templeteView = [[TDFTagPaperTempleteView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH*0.14, SCREEN_WIDTH, SCREEN_WIDTH*0.66)];//
    }
    return _templeteView;
}

- (DHTTableViewManager *)manager
{
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
        [_manager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
        [_manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
        [_manager registerCell:@"TDFSwitchCell" withItem:@"TDFSwitchItem"];
        [_manager registerCell:@"TDFLabelCell" withItem:@"TDFLabelItem"];
        [_manager registerCell:@"TDFBaseEditCell" withItem:@"TDFBaseEditItem"];
        [_manager registerCell:@"TDFStaticLabelCell" withItem:@"TDFStaticLabelItem"];
    }
    return _manager;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]init];
        //        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (UIView *)alphaView {
    if (!_alphaView) {
        _alphaView = [[UIView alloc]init];
        _alphaView.backgroundColor = [UIColor whiteColor];
        _alphaView.alpha           = 0.7;
    }
    return _alphaView;
}

#pragma mark - Delegate & callback

#pragma mark - Nofifacations

- (void)shouldChangeNavTitles:(NSNotification *)notification
{
    
    if (self.isShowSaveBtn) {
        
        [self configRightNavigationBar:@"ico_commit" rightButtonName:NSLocalizedString(@"保存", nil)];
        [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
        
        return;
    }
    
    if ([TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections]) {
        
        [self configRightNavigationBar:@"ico_commit" rightButtonName:NSLocalizedString(@"保存", nil)];
        [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
        
    }else {
        
        [self configRightNavigationBar:@"" rightButtonName:@""];
        [self configLeftNavigationBar:@"ico_back" leftButtonName:NSLocalizedString(@"返回", nil)];
    }
}

#pragma mark - NormalFunction

- (void)changeTemplateWithCode:(NSString *)code andValue:(NSString *)value {
    
    [self configRightNavigationBar:@"ico_commit" rightButtonName:NSLocalizedString(@"保存", nil)];
    
    [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
    
    self.isShowSaveBtn = YES;
    
    [self loadDataWithFieldCode:code andFieldValue:value];
}

- (void)resumeAll {
    
    
    [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您确定要恢复此模板的默认值吗？", nil) cancelBlock:^{
        
    } enterBlock:^{
        
        [self configRightNavigationBar:@"ico_commit" rightButtonName:NSLocalizedString(@"保存", nil)];
        
        [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
        
        self.isShowSaveBtn = YES;
        
        self.isResumeToDefault = YES;
        
//        [self changeTemplateWithCode:self.model.functionGroupList[0].funcFieldValues[0].code andValue:self.model.functionGroupList[0].funcFieldValues[0].value];
        [self configModel:self.model];
        
    }];
}

- (void)rightNavigationButtonAction:(id)sender {
    
    [self saveTemplate];
}

- (void)leftNavigationButtonAction:(id)sender {

    if ([TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections]||self.isShowSaveBtn) {
        
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"内容有变更尚未保存，确定要退出吗？", nil) cancelBlock:^{
            
        } enterBlock:^{
            
            [super leftNavigationButtonAction:sender];
        }];
    }else {
    
        [super leftNavigationButtonAction:sender];
    }
}

//保存模版
- (void)saveTemplate {
    
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    
    NSMutableArray *fieldArr = [NSMutableArray new];
    
    for (TDFSmartOrderGroupModel *groupModel in self.model.functionGroupList) {
        
        for (TDFSmartOrderFieldModel *fieldModel in groupModel.funcFieldValues) {
            
            [fieldArr addObject:fieldModel];
        }
    }
    [TDFShopTemplateService save_template_functionWithModel:[fieldArr yy_modelToJSONString] CompleteBlock:^(TDFResponseModel * _Nullable response) {
        
        
        [self.progressHud hide:YES];
        
        NSDictionary *dic = response.responseObject;
        
        if (response.error) {
            
            [AlertBox show:response.error.localizedDescription];
            return ;
        }
        if (![NSString stringWithFormat:@"%@",dic[@"code"]].integerValue) {
            
            [AlertBox show:[NSString stringWithFormat:@"%@",dic[@"message"]]];
            
            return;
        }
        if (self.callBack) {
            
            self.callBack();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

//配置布局
- (void)configLayout {
    
    [self configLeftNavigationBar:@"ico_back" leftButtonName:NSLocalizedString(@"返回", nil)];
    
    [self.view insertSubview:self.alphaView atIndex:1];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = self.footerView;

    [self.footerView addSubview:self.tipsView];
    
    [self.footerView addSubview:self.templeteView];
    
//    [self.footerView addSubview:self.resumeView];
    [self.view addSubview:self.resumeBtn];
}

//layout
- (void)configConstrains {
    
    __weak typeof(self) ws = self;
    
    [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws.view);
    }];
}

//配置最下方动态显示模版
- (void)configTemplete {
    
    if (self.model.functionGroupList.count<=3) {
        
        return;
    }
    
    NSMutableArray *arr1 = [NSMutableArray new];
    
    NSMutableArray *arr2 = [NSMutableArray new];
    
    NSMutableArray *arr3 = [NSMutableArray new];
    
    TDFSmartOrderGroupModel *group1 = self.model.functionGroupList[1];
    for (TDFSmartOrderFieldModel *field in group1.funcFieldValues) {
        
        if (field.isDisplay&&[field.value boolValue]) {
            
            [arr1 addObject:@{field.name:field.example?field.example:@""}];
        }
    }
    
    TDFSmartOrderGroupModel *group2 = self.model.functionGroupList[2];
    for (TDFSmartOrderFieldModel *field in group2.funcFieldValues) {
        
        if (field.isDisplay&&[field.value boolValue]) {
            
            [arr2 addObject:@{field.name:field.example?field.example:@""}];
        }
    }
    
    TDFSmartOrderGroupModel *group3 = self.model.functionGroupList[3];
    for (TDFSmartOrderFieldModel *field in group3.funcFieldValues) {
        
        if (field.isDisplay&&[field.value boolValue]) {
            
            [arr3 addObject:@{field.name:field.example?field.example:@""}];
        }
    }
    
    BOOL isTailCenter = ![self.model.functionGroupList[0].funcFieldValues[0].value isEqualToString:self.model.functionGroupList[0].funcFieldValues[0].optionalValue[3]];
    
    [self.templeteView loadDataWithArray:@[arr1,arr2,arr3] andIsTailCenter:isTailCenter];
}

//配置组头
- (DHTTableViewSection* )sectionWithTitleHeader:(NSString *)title andRemark:(NSString *)remark
{
    DHTTableViewSection *section = [[DHTTableViewSection alloc] init];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 48)];
    sectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, screenWidth, 21)];
    lblTitle.font = [UIFont boldSystemFontOfSize:17];
    
    NSMutableString *mString = [NSMutableString stringWithFormat:@"%@(%@)",title,remark];
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:mString];
    
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(title.length, mString.length-title.length)];
    
    [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(title.length, mString.length-title.length)];
    
    lblTitle.attributedText = attriString;
    
    UIView *spliteTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    spliteTopView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    UIView *spliteBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 47, screenWidth, 1)];
    spliteBottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    [sectionView addSubview:lblTitle];
    [sectionView addSubview:spliteTopView];
    [sectionView addSubview:spliteBottomView];
    
    section.headerView = sectionView;
    section.headerHeight = 48;
    
    return section;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

























