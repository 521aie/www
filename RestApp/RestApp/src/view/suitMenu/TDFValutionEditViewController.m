//
//  TDFValutionEditViewController.m
//  RestApp
//
//  Created by xueyu on 16/9/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "YYModel.h"
#import "TDFPickerItem.h"
#import "TDFTextfieldItem.h"
#import "SelectMenuClient.h"
#import "TDFCustomStrategy.h"
#import "TDFBaseEditView.h"
#import "TDFSuitMenuService.h"
#import "TDFEditViewHelper.h"
#import "NSString+Estimate.h"
#import "EditItemList.h"
#import "DHTTableViewManager.h"
#import "TDFMediator+SuitMenuModule.h"
#import "TDFValutionEditViewController.h"
#import "TDFRootViewController+AlertMessage.h"
#import "EditItemText.h"
#import "UIHelper.h"
@interface TDFValutionEditViewController ()
@property (nonatomic, strong) DHTTableViewManager *manager;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TDFPickerItem *menuItem;
@property (nonatomic, strong) TDFPickerItem *secondMenuItem;
@property (nonatomic, strong) TDFTextfieldItem *premiumItem;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) TDFSuitMenuService *service;
@property (nonatomic, strong) TDFMenuItem *menu;
@property (nonatomic, strong) TDFMenuItem *menuSec;


@end

@implementation TDFValutionEditViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.menu  = [self.menuVo.items firstObject];
    self.menuSec = [self.menuVo.items lastObject];
    [self configureView];
    [self configureManager];
    [self addItems];
     [self loadData];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configRightNavigationBar:@"ico_ok" rightButtonName:NSLocalizedString(@"保存", nil)];
        [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark init view
-(void)configureView{
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 480)];
    CGFloat buttonH = self.action == ACTION_CONSTANTS_ADD ? 0:30;
    UIButton *delButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [footer addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footer).offset(15);
            make.left.equalTo(footer).offset(25);
            make.right.equalTo(footer).offset(-25);
            make.height.mas_equalTo(buttonH);
        }];
        view.backgroundColor = [UIColor colorWithRed:209/255.0 green:0 blue:0 alpha:1];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [view setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        [view addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    UIView *background = ({
        UIView *view = [UIView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        view;
    });
    
    
    UILabel *tip = ({
        UILabel *view = [UILabel new];
        [footer addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(delButton.mas_bottom).offset(25);
            make.left.equalTo(footer).offset(10);
            make.right.equalTo(footer).offset(-10);
        }];
        view.font = [UIFont systemFontOfSize:13];
        view.textColor = [UIColor darkGrayColor];
        view.numberOfLines = 0;
        view.text = NSLocalizedString(@"提示：选择套餐分组内任一可选商品进行两两组合，然后设置商品组合计价规则，计价规则为每两种商品搭配时的加价，当价钱为负数时，则为优惠的价格。\n\n套餐价格计算按照计价规则排序进行，计价规则默认按照单品最优力度自动排序。\n\n举例：如果套餐可以点三个菜，总价为50元，商品A有单独的加价：2元，商品A和商品B同时点有一条计价规则：-3元，商品A和商品C同时点有一条计价规则：-5元，那么顾客点了商品A+商品B+商品C，那么套餐总价应先算商品A的加价，然后根据计价规则排序进行计算，计价规则默认按照单品最优力度自动排序，也就是先按照商品A+商品C计价规则进行计算，即套餐的总价为50+2-5=47元；如果套餐可以点四个菜，计价规则同上，顾客点了商品A*2+商品B+商品C，那么套餐的总价为50+2*2-5-3=46元。", nil);
        view;
    });
#pragma clang diagnostic pop
      self.tableView.tableFooterView = footer;
}

- (void)configureManager
{
    [self.manager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
    [self.manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
}
-(void)addItems{
    DHTTableViewSection *section = [DHTTableViewSection section];
    @weakify(self);
    self.menuItem = [self tdfPickerItemWithTitle:NSLocalizedString(@"选择商品", nil) placeholder:NSLocalizedString(@"必选", nil) isIconDown:NO clickBlcok:^{
       @strongify(self);
        [self isMenuList:self.menuItem menu:self.menu];
    }];
    [section addItem:self.menuItem];
    self.secondMenuItem = [self tdfPickerItemWithTitle:NSLocalizedString(@"选择商品", nil) placeholder:NSLocalizedString(@"必选", nil) isIconDown:NO clickBlcok:^{
        @strongify(self);
        [self isMenuList:self.secondMenuItem menu:self.menuSec];
    }];
    [section addItem:self.secondMenuItem];
    
    self.premiumItem = [TDFTextfieldItem new];
    self.premiumItem.title = NSLocalizedString(@"顾客选择以上两个商品时的加价(元)", nil);
    self.premiumItem.detail = NSLocalizedString(@"价钱为负数时，则为优惠的价格。", nil);
    
    self.premiumItem.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    self.premiumItem.filterBlock = ^(NSString *textValue){
//        @strongify(self);
//        if (![self isPrice:textValue]) {
//            return NO;
//        }
//        return YES;
//    };
    [section addItem:self.premiumItem];
    [self.manager addSection:section];
    
}

-(void)isMenuList:(TDFPickerItem *)pickerItem menu:(TDFMenuItem *)menu{
  
    @weakify(self);
    if (self.datas && self.datas.count > 0) {
        
       [self.navigationController pushViewController:[[TDFMediator sharedInstance] TDFMediator_menuSelectViewControllerWithDatas:self.datas callback:^(id obj) {
           @strongify(self);
           pickerItem.title = @"";
           pickerItem.textValue = [(TDFMenuItem *)obj obtainItemName];
           pickerItem.textId = [(TDFMenuItem *)obj obtainItemId];
           [self.manager reloadData];
       }] animated:YES];
    } else{
        [self.service getSuitMenuValuationItemList:self.suitMenuId callBack:^(TDFResponseModel * _Nonnull response) {
            @strongify(self);
            if (response.error) {
                [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:response.error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
                return ;
            }
            self.datas = [NSArray yy_modelArrayWithClass:[TDFMenuDetailVo class] json:response.responseObject[@"data"]];
            [self.navigationController pushViewController:[[TDFMediator sharedInstance] TDFMediator_menuSelectViewControllerWithDatas:self.datas callback:^(id obj) {
                pickerItem.title = @"";
                pickerItem.textValue = [(TDFMenuItem *)obj obtainItemName];
                pickerItem.textId = [(TDFMenuItem *)obj obtainItemId];
                [self.manager reloadData];
            }] animated:YES];
        }];

    }

}

#pragma mark init data
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = ({
            UITableView *view = [UITableView new];
            [self.view addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            view.separatorStyle= UITableViewCellSeparatorStyleNone;
            view.backgroundColor = [UIColor clearColor];
            view;
        });
    }
    return _tableView;
}
- (DHTTableViewManager *)manager
{
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
    }
    return _manager;
}
-(TDFSuitMenuService *)service{
    if (!_service) {
        _service = [TDFSuitMenuService new];
    }
    return _service;
}
-(NSArray *)datas{
 
    if (!_datas) {
        _datas = [[NSArray alloc]init];
    }
    return _datas;
}

-(TDFPickerItem *)tdfPickerItemWithTitle:(NSString *)title placeholder:(NSString *)placeholder isIconDown:(BOOL)isDown clickBlcok:(void (^)())btnClickedBlock{
    TDFPickerItem *pickerItem = [TDFPickerItem new];
    pickerItem.title = title;
    pickerItem.placeholder = placeholder;
    pickerItem.isIconDown = isDown;
    TDFCustomStrategy *notIncludeStrategy = [[TDFCustomStrategy alloc] init];
    notIncludeStrategy.btnClickedBlock = btnClickedBlock;
    pickerItem.strategy = notIncludeStrategy;
    return pickerItem;
}



#pragma mark load data
-(void)loadData{
    
    if (self.action == ACTION_CONSTANTS_ADD) {
     
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240, 64)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = NSLocalizedString(@"添加商品组合计价规则", nil);
        self.navigationItem.titleView = titleLabel;
    }else{
        self.title = NSLocalizedString(@"商品组合计价规则", nil);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeNavTitles:) name:kTDFEditViewIsShowTipNotification object:nil];
        self.menuItem.textValue = [self.menu obtainItemName];
        self.menuItem.title = @"";
        self.menuItem.preValue = self.menu.menuId;
        self.menuItem.textId = self.menu.menuId;
        
        self.secondMenuItem.textValue = [self.menuSec obtainItemName];
        self.secondMenuItem.title = @"";
        self.secondMenuItem.preValue = self.menuSec.menuId;
        self.secondMenuItem.textId = self.menuSec.menuId;
        
        self.premiumItem.textValue = [NSString stringWithFormat:@"%.1f",self.menuVo.price];
        self.premiumItem.preValue = [NSString stringWithFormat:@"%.1f",self.menuVo.price];
    }
    [self.manager reloadData];
}


#pragma mark button event
-(void)deleteClick:(UIButton *)sender{
    [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
    __weak typeof (self) weakSelf = self;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"rule_id"] = self.menuVo.ruleId;
    parameters[@"suit_menu_id"] = self.suitMenuId;
    parameters[@"last_ver"] = @(self.menuVo.lastVer).stringValue;
    [self.service deleteSuitMenuValuationRule:parameters callBack:^(TDFResponseModel * _Nonnull response) {
        [self.progressHud hide:YES];
        if (response.error) {
            [weakSelf showMessageWithTitle:NSLocalizedString(@"提示", nil) message:response.error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
            return ;
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
        if (self.callback) {
            self.callback();
        }
//        [self.navigationController setNavigationBarHidden:YES animated:YES];

    }];
    
}

#pragma mark navigate action
-(void)leftNavigationButtonAction:(id)sender{
    
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.callback && self.isReload) {
            self.callback();
        }
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        if ([self isAnyTipsShowed]) {
            __weak typeof(self) weakSelf = self;
            [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"内容有变更尚未保存，确定要退出吗?", nil) cancelBlock:^(){
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                
            } enterBlock:^(){
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                if (weakSelf.callback && weakSelf.isReload) {
                    weakSelf.callback();
                }
//                [self.navigationController setNavigationBarHidden:YES animated:YES];
            }];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            if (self.callback&&self.isReload) {
                self.callback();
            }
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
}


-(void)rightNavigationButtonAction:(id)sender{
    if (![self isAvailable]) {
        return;
    }
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    NSMutableDictionary *dict = @{ @"price":self.premiumItem.textValue,
                                   @"suit_menu_id":self.suitMenuId?self.suitMenuId:@"",
                           @"menu_ids":[@[self.menuItem.textId,self.secondMenuItem.textId] yy_modelToJSONString]}.mutableCopy;
    dict[@"rule_id"] = self.menuVo.ruleId;
    dict[@"last_ver"] = self.action == ACTION_CONSTANTS_ADD? nil:[@(self.menuVo.lastVer) stringValue];
    __weak typeof (self) weakSelf = self;
    [self.service saveSuitMenuValuationRule:dict callBack:^(TDFResponseModel * _Nonnull response){
        [weakSelf.progressHud hide:YES];
        if (response.error) {
            
            [weakSelf showMessageWithTitle:NSLocalizedString(@"提示", nil) message:response.error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
            return ;
        }
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        if (self.callback) {
            self.callback();
        }
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
    }];
    
}


- (void)shouldChangeNavTitles:(NSNotification *)notification
{
        if ([self isAnyTipsShowed]) {
            [self configRightNavigationBar:@"ico_ok" rightButtonName:NSLocalizedString(@"保存", nil)];
            [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
        } else {
            [self configRightNavigationBar:@"" rightButtonName:@""];
            [self configLeftNavigationBar:@"ico_back" leftButtonName:NSLocalizedString(@"返回", nil)];
        }
}

- (BOOL)isAnyTipsShowed
{
    return [TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections];
}


-(BOOL)isAvailable{

    if ([NSString isBlank:self.menuItem.textId]) {
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"选择商品不能为空", nil) cancelTitle:NSLocalizedString(@"我知道了", nil)];
        return NO;
    }
    if ([NSString isBlank:self.secondMenuItem.textId]) {
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"选择商品不能为空", nil) cancelTitle:NSLocalizedString(@"我知道了", nil)];
        return NO;
    }
    
    if ([NSString isBlank:self.premiumItem.textValue]) {
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"顾客选择以上两个商品时的加价(元)不能为空 ", nil) cancelTitle:NSLocalizedString(@"我知道了", nil)];
        return NO;
    }
    
    if (![self isPrice:self.premiumItem.textValue] || [self.premiumItem.textValue doubleValue] > 9999 || [self.premiumItem.textValue doubleValue] < -9999) {
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"顾客选择以上两个商品时的加价(元)格式不正确，加价为不超过一位小数的数字并且绝对值不能超过9999", nil) cancelTitle:NSLocalizedString(@"我知道了", nil)];
        return NO;
    }
    
    if ([self.premiumItem.textValue doubleValue] == 0) {
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"顾客选择以上两个商品时的加价(元)不能为0", nil) cancelTitle:NSLocalizedString(@"我知道了", nil)];
        return NO;
    }
    
    return YES;
}

-(BOOL)isPrice:(NSString *)content {
    
    NSString *reg =  @"^(|-|\\+)[0-9]+([.]{0,1}+([0-9]{0,1}))";
    return [self validateWithContent:content regExp:reg];
}
-(BOOL)validateWithContent:(NSString *)content regExp:(NSString *)regExp {
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:content];
}
@end
