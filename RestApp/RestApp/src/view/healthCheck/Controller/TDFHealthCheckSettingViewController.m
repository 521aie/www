//
//  TDFHeathCheckSettingViewController.m
//  RestApp
//
//  Created by xueyu on 2016/12/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "UIHelper.h"
#import "UIColor+Hex.h"
#import "NameItemVO.h"
#import "MobClick.h"
#import "ObjectUtil.h"
#import "GlobalRender.h"
#import "TDFLabelItem.h"
#import "TDFPickerItem.h"
#import "TDFBaseEditView.h"
#import <YYModel/YYModel.h>
#import "NSString+Estimate.h"
#import "TDFEditViewHelper.h"
#import "TDFCustomStrategy.h"
#import "DHTTableViewManager.h"
#import "TDFHealthCheckService.h"
#import "TDFHealthCheckHomePageModel.h"
#import "TDFOptionPickerController.h"
#import "TDFHealthCheckSettingModel.h"
#import "TDFHealthCheckViewController.h"
#import "TDFHealthCheckAlertViewController.h"
#import "TDFHealthCheckSettingViewController.h"
#import "TDFRootViewController+AlertMessage.h"
@interface TDFHealthCheckSettingViewController ()<TDFEditLabelViewDelegate>
@property (nonatomic, strong) DHTTableViewManager *manager;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TDFLabelItem *squareItem;
@property (nonatomic, strong) TDFLabelItem *averageSpendItem;
@property (nonatomic, strong) TDFLabelItem *constantCostItem;
@property (nonatomic, strong) TDFPickerItem *perRateItem;
@property (nonatomic, strong) TDFLabelItem *hallNumItem;
@property (nonatomic, strong) TDFLabelItem *kitchenNumItem;
@property (nonatomic, strong) TDFHealthCheckSettingModel *checkSetting;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) BOOL isChange;

@end

@implementation TDFHealthCheckSettingViewController

#pragma mark life cycle
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"体检设置", nil);
    [self configViews];
    [self configureManager];
    [self addItems];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}
#pragma mark navigate action

-(void)leftNavigationButtonAction:(id)sender{
    [self.view endEditing:YES];
    if ([self isAnyTipsShowed]) {
        __weak typeof(self) weakSelf = self;
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"内容有变更尚未保存，确定要退出吗?", nil) cancelBlock:^(){
        } enterBlock:^(){
            [weakSelf forwardModel];
        }];
    } else {
        [self forwardModel];
    }
}


-(void)rightNavigationButtonAction:(id)sender{
    [super rightNavigationButtonAction:sender];
    [MobClick event:@"click_exam_setting_save"];//埋点:体检设置点击保存
    [self save];
}

-(void)forwardModel{
    if (self.isFirstTime) {
        [MobClick event:@"click_exam_setting_cancel"];//埋点:体检设置点击取消
        TDFHealthCheckViewController *checkVc = [[TDFHealthCheckViewController alloc]init];
//        TDFHealthCheckHomePageModel *model = [TDFHealthCheckHomePageModel new];
//        model.isFirstTime = 1;
        checkVc.homePage = self.homePage;
        [self.navigationController pushViewController:checkVc animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];}
}
#pragma mark layout
-(void)configViews{
  
    [self configRightNavigationBar:@"ico_ok" rightButtonName:NSLocalizedString(@"保存", nil)];
    [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    UIView *backView= ({
        UIView *view = [UIView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        view.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.7];
        view;
    });
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    UILabel *tip= ({
        UILabel *view = [UILabel new];
        [headView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headView).offset(20);
            make.right.equalTo(headView.mas_right).offset(-37);
            make.left.equalTo(headView.mas_left).offset(37);
        }];
        view.numberOfLines = 0;
        view.font =  [UIFont systemFontOfSize:20];
        view.textColor = [UIColor colorWithHexString:@"#E02200"];
        view.textAlignment = NSTextAlignmentCenter;
        view.text = NSLocalizedString(@"为了给您提供最精准的体检分析，请您先设置", nil);
        view;
    });
    UIView *view= ({
        UIView *view = [UIView new];
        [headView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headView.mas_bottom);
            make.right.equalTo(headView.mas_right).offset(-10);
            make.left.equalTo(headView.mas_left).offset(10);
            make.height.mas_offset(@1);
        }];
        view.backgroundColor = [UIColor lightGrayColor];
        view;
    });
#pragma clang diagnostic pop
        self.tableView.tableHeaderView = headView;
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeNavTitles:) name:kTDFEditViewIsShowTipNotification object:nil];
}

- (void)configureManager
{
    [self.manager registerCell:@"TDFLabelCell" withItem:@"TDFLabelItem"];
    [self.manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
}

-(void)addItems{
    DHTTableViewSection *section = [DHTTableViewSection section];
    @weakify(self);
    self.squareItem = [TDFLabelItem new];
    self.squareItem.keyboardAppearenceType = TDFLabelItemKeyboardAppearenceTypeNumberic;
    self.squareItem.keyboardType = TDFNumbericKeyboardTypeFloat;
    self.squareItem.labelDelegate = self;
    self.squareItem.title = NSLocalizedString(@"营业面积（平米）", nil);
    self.squareItem.placeholder = NSLocalizedString(@"请输入", nil);
    self.squareItem.isRequired = NO;
    self.squareItem.requestKey = @"businessArea";
    self.squareItem.detail = NSLocalizedString(@"用于为您计算平效。", nil);
    [section addItem:self.squareItem];
    
    self.averageSpendItem = [TDFLabelItem new];
    self.averageSpendItem.keyboardAppearenceType = TDFLabelItemKeyboardAppearenceTypeNumberic;
    self.averageSpendItem.keyboardType = TDFNumbericKeyboardTypeFloat;
    self.averageSpendItem.labelDelegate = self;
    self.averageSpendItem.title = NSLocalizedString(@"人均消费（元）", nil);
    self.averageSpendItem.preValue = nil;
    self.averageSpendItem.placeholder = NSLocalizedString(@"请输入", nil);
    self.averageSpendItem.isRequired = NO;
    self.averageSpendItem.requestKey = @"perCapita";
    self.averageSpendItem.detail = NSLocalizedString(@"您对本店人均消费的预期值。", nil);
    [section addItem:self.averageSpendItem];
    
    
    self.constantCostItem = [TDFLabelItem new];
    self.constantCostItem.keyboardAppearenceType = TDFLabelItemKeyboardAppearenceTypeNumberic;
    self.constantCostItem.keyboardType = TDFNumbericKeyboardTypeFloat;
    self.constantCostItem.labelDelegate = self;
    self.constantCostItem.title = NSLocalizedString(@"每月平均固定成本（元）", nil);
    self.constantCostItem.placeholder = NSLocalizedString(@"请输入", nil);
    self.constantCostItem.isRequired = NO;
    self.constantCostItem.requestKey = @"fixedCost";
    self.constantCostItem.detail = NSLocalizedString(@"包含房租、水电、工资、税费等，用于计算净利率。", nil);
    [section addItem:self.constantCostItem];
    
    
    self.perRateItem = [TDFPickerItem new];
    self.perRateItem.title = NSLocalizedString(@"预期毛利率（%）", nil);
    self.perRateItem.detail = NSLocalizedString(@"您对本店毛利率的预估。", nil);
    self.perRateItem.preValue = NSLocalizedString(@"请选择", nil);
    self.perRateItem.textValue = NSLocalizedString(@"请选择", nil);
    self.perRateItem.requestKey = @"grossProfitRate";
    TDFCustomStrategy *notIncludeStrategy = [[TDFCustomStrategy alloc] init];
    notIncludeStrategy.btnClickedBlock = ^{
        @strongify(self);
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"预期毛利率（%)", nil) options:[GlobalRender listRatios] currentItemId:self.perRateItem.textValue];
        pvc.competionBlock = ^void(NSInteger index) {
            [self pickOption:[GlobalRender listRatios][index] event:0];
        };
        [self.navigationController presentViewController:pvc animated:YES completion:nil];
    };
    self.perRateItem.strategy = notIncludeStrategy;
    [section addItem:self.perRateItem];
    
    
    self.hallNumItem = [TDFLabelItem new];
    self.hallNumItem.keyboardAppearenceType = TDFLabelItemKeyboardAppearenceTypeNumberic;
    self.hallNumItem.keyboardType = TDFNumbericKeyboardTypeInteger;
    self.hallNumItem.title = NSLocalizedString(@"前厅人员数量（人）", nil);
    self.hallNumItem.labelDelegate = self;
    self.hallNumItem.placeholder = NSLocalizedString(@"请输入", nil);
    self.hallNumItem.isRequired = NO;
    self.hallNumItem.requestKey = @"hallNum";
    self.hallNumItem.detail = NSLocalizedString(@"用于计算前厅效率，前厅人员包含店长、经理、收银、迎宾、服务员等。", nil);
    [section addItem:self.hallNumItem];
    
    self.kitchenNumItem = [TDFLabelItem new];
    self.kitchenNumItem.keyboardAppearenceType = TDFLabelItemKeyboardAppearenceTypeNumberic;
    self.kitchenNumItem.keyboardType = TDFNumbericKeyboardTypeInteger;
    self.kitchenNumItem.title = NSLocalizedString(@"后厨人员数量（人）", nil);
    self.kitchenNumItem.labelDelegate = self;
    self.kitchenNumItem.placeholder = NSLocalizedString(@"请输入", nil);
    self.kitchenNumItem.isRequired = NO;
    self.kitchenNumItem.requestKey = @"kitchenNum";
    self.kitchenNumItem.detail = NSLocalizedString(@"用于计算后厨效率，后厨人员包含厨师、切配、洗杀人员等。", nil);
    [section addItem:self.kitchenNumItem];
    
    [self.manager addSection:section];
    
}
#pragma mark network
-(void)loadData{

    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:self.hud];
    __weak typeof (self) weakSelf = self;
    [[TDFHealthCheckService new] getHealthCheckSettingWithCallBack:^(TDFResponseModel * _Nonnull response) {
        [weakSelf.hud hide:YES];
        if (response.error) {
            [weakSelf showMessageWithTitle:NSLocalizedString(@"提示", nil) message:response.error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
            return ;
        }
        id data = response.responseObject[@"data"];
        if ([ObjectUtil isNotEmpty:data]) {
            weakSelf.isChange = NO;
            weakSelf.checkSetting = [TDFHealthCheckSettingModel yy_modelWithJSON:data];
            [weakSelf fillModel];
        }else{
            weakSelf.isChange = YES;
            [weakSelf configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
            [weakSelf configRightNavigationBar:@"ico_ok" rightButtonName:NSLocalizedString(@"保存", nil)];
        }

    }];
}
-(void)save{
    
    TDFHealthCheckSettingModel *vo  = [TDFHealthCheckSettingModel new];
    vo.businessArea = self.squareItem.textValue;
    vo.perCapita = self.averageSpendItem.textValue;
    vo.fixedCost = self.constantCostItem.textValue;
    vo.grossProfitRate = self.perRateItem.textId;
    vo.hallNum = self.hallNumItem.textValue;
    vo.kitchenNum = self.kitchenNumItem.textValue;
    [UIHelper showHUD:NSLocalizedString(@"正在保存", nil) andView:self.view andHUD:self.hud];
    __weak typeof (self) weakSelf = self;
    [[TDFHealthCheckService new] saveHealthCheckSettingWithData:[vo yy_modelToJSONString] callback:^(TDFResponseModel * _Nonnull response) {
        [weakSelf.hud hide:YES];
        if (response.error) {
            [weakSelf showMessageWithTitle:NSLocalizedString(@"提示", nil) message:response.error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
            return ;
        }
        if (weakSelf.isFirstTime) {
            TDFHealthCheckViewController *checkVc = [[TDFHealthCheckViewController alloc]init];
//            TDFHealthCheckHomePageModel *model = [TDFHealthCheckHomePageModel new];
//            model.isFirstTime = 1;
            checkVc.homePage = self.homePage;
            [weakSelf.navigationController pushViewController:checkVc animated:YES];
        }else{
            !weakSelf.callback?:weakSelf.callback();
            [weakSelf.navigationController popViewControllerAnimated:YES];
           
        }
    }];
}
-(void)fillModel{
    self.squareItem.textValue = self.checkSetting.businessArea;
    self.squareItem.preValue = self.checkSetting.businessArea;

    self.averageSpendItem.textValue = self.checkSetting.perCapita;
    self.averageSpendItem.preValue = self.checkSetting.perCapita;

    self.constantCostItem.textValue = self.checkSetting.fixedCost;
    self.constantCostItem.preValue = self.checkSetting.fixedCost;
    
    if ([NSString isBlank:self.checkSetting.grossProfitRate]) {
        self.perRateItem.preValue = NSLocalizedString(@"请选择", nil);
        self.perRateItem.textValue = NSLocalizedString(@"请选择", nil);
    }else{
        self.perRateItem.textId = self.checkSetting.grossProfitRate;
        self.perRateItem.preValue = self.checkSetting.grossProfitRate;
        self.perRateItem.textValue = self.checkSetting.grossProfitRate;
    }
    
    
    self.hallNumItem.textValue = self.checkSetting.hallNum;
    self.hallNumItem.preValue = self.checkSetting.hallNum;

    self.kitchenNumItem.textValue = self.checkSetting.kitchenNum;
    self.kitchenNumItem.preValue = self.checkSetting.kitchenNum;

    [self.manager reloadData];
}
#pragma mark notifation
- (void)shouldChangeNavTitles:(NSNotification *)notification
{
    if ([self isAnyTipsShowed] ||  self.isChange) {
        [self configRightNavigationBar:@"ico_ok" rightButtonName:NSLocalizedString(@"保存", nil)];
        [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
    } else {
        [self configRightNavigationBar:@"" rightButtonName:@""];
        [self configLeftNavigationBar:@"ico_back" leftButtonName:NSLocalizedString(@"返回", nil)];
    }
}
#pragma mark private method

- (BOOL)pickOption:(id)selectObj event:(NSInteger)row
{
     NameItemVO * item = (NameItemVO*)selectObj;
    self.perRateItem.textValue = [item obtainItemName];
    self.perRateItem.textId = [item obtainItemId];
    [self.manager reloadData];
    return YES;
}

- (void)labelDidFinishEditing:(TDFLabel *)label indexPath:(NSIndexPath *)indexPath{
    
    DHTTableViewSection *section = self.manager.sections[indexPath.section];
    
    TDFLabelItem *item = (TDFLabelItem *)section.items[indexPath.row];
    
    item.textValue = [self notRounding:label.text afterPoint:2];

    [self.manager reloadData];

}

-(NSString *)notRounding:(NSString *)price afterPoint:(int)position{
    if (price.length == 0) {
        return nil;
    }
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *ouncesDecimal = [NSDecimalNumber  decimalNumberWithString:price];
    
    NSDecimalNumber *roundedOunces;
    
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
    
}
- (BOOL)isAnyTipsShowed
{
    return [TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections];
}
-(BOOL)isDouble:(NSString *)content {
    return [self validateWithContent:content regExp:@"^[0-9]+(\\.[0-9]{0,2})?$"];
}

-(BOOL)validateWithContent:(NSString *)content regExp:(NSString *)regExp {
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:content];
}



#pragma mark getter setter
- (DHTTableViewManager *)manager
{
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
    }
    return _manager;
}

-(TDFHealthCheckSettingModel *)checkSetting{
    if (!_checkSetting) {
        _checkSetting = [TDFHealthCheckSettingModel new];
    }
    return _checkSetting;
}

-(MBProgressHUD *)hud{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc]initWithView:self.view];
    }
    return _hud;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
@end
