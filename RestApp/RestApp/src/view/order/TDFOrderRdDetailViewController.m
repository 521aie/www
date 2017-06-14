//
//  TDFOrderRdDetailViewController.m
//  RestApp
//
//  Created by iOS香肠 on 16/9/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOrderRdDetailViewController.h"
#import "NavigateTitle2.h"
#import "SmartOrderModel.h"
#import "DHTTableViewManager.h"
#import "TDFTextfieldItem.h"
#import "UIView+Sizes.h"
#import "NameItemVO.h"
#import "TDFSwitchItem.h"
#import "TDFEditViewHelper.h"
#import "UIHelper.h"
#import "ViewFactory.h"
#import "TDFOrderItem.h"
#import "UIHelper.h"
#import "TDFBaseEditView.h"
#import "YYModel.h"
#import "TDFOrderService.h"
#import "ObjectUtil.h"
#import "OrderRdData.h"
#import "orderSaveData.h"
#import "HelpDialog.h"
#import "FuctionCustomAlertView.h"
#import "TDFOptionPickerController.h"
#import "DHTTableViewSection+InitHeaderView.h"
#import "OptionPickerClient.h"
#import "ISampleListEvent.h"
#import "orderRecommendView.h"
#import "BackgroundHelper.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFFooterButton.h"

@interface TDFOrderRdDetailViewController ()<INavigateEvent,OptionPickerClient>
{
    SmartOrderModel *parent;
    UILabel *selectLabel;
   
}
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *alphaView;
@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) DHTTableViewManager *manager;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong)  NavigateTitle2 *titleBox;
@property (nonatomic, strong) NSMutableArray *selectArry;
@property (nonatomic, strong)  NSMutableArray * shopArry;
@property (nonatomic, strong) FooterListView *footListView;
//数据
@property (nonatomic ,strong) NSMutableArray *foodListArry;
@property (nonatomic ,strong) NSMutableArray *majorListArry;
@property (nonatomic ,strong) NSMutableArray *minorListArry;
@property (nonatomic ,strong) FuctionCustomAlertView *tanchView;
@property (nonatomic ,strong) NSString *mealscount;
@property (nonatomic ,strong) NSString *planId;
@property (nonatomic ,strong) NSString *recommendType;//1 标识按具体主料提醒与推荐  0标识按主料大类提醒与推荐
@property (nonatomic ,assign) BOOL isChange;
//@property (nonatomic ,assign) id<ISampleListEvent>delegate;


@end

@implementation TDFOrderRdDetailViewController


- (id)initWithparent:(SmartOrderModel*)parentm
{
    if (self =[super init]) {
        parent =parentm;
    }
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self  createSourceData];
    [self createBackView];
    self.view.backgroundColor =[UIColor clearColor];

   // [self configBackgroundView];
   // [self initNavigate];

    [self createTabview];
    [self addFooterView];
    [self configureManager];
    [self initNotifaction];


}


- (void)createSourceData
{
    if ([ObjectUtil   isNotEmpty:self.dic]) {
        NSString *plantName = self.dic[@"plantName"];
        NSString *plantId = self.dic[@"plantId"];
        [self  getHttpData:plantId WithTitle:plantName];
        id delegate  = self.dic [@"delegate"];
        if ([ObjectUtil  isNotNull:delegate]) {
            self.delegate =  delegate;
        }
    }
}

- (void)createBackView
{
    UIView *bgView  =[[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor =[UIColor whiteColor];
    bgView.alpha=0.6;
    [self.view addSubview:bgView];

}

- (void)configBackgroundView {
    NSString *backgroundImageName = [BackgroundHelper getBackgroundImage];
    UIImage *backgroundImage = [UIImage imageNamed:backgroundImageName];
    UIImageView  *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    self.alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.alphaView.backgroundColor = [UIColor whiteColor];
    self.alphaView.alpha = 0.7;
    [self.view insertSubview:self.alphaView atIndex:1];
}

- (MBProgressHUD *)hud
{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return _hud;

}

- (void)createTabview
{
    self.tabView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) ];
    [self.view addSubview:self.tabView];
    self.tabView.backgroundColor=[UIColor clearColor];
    self.tabView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tabView.tableFooterView =[ViewFactory generateFooter:60];
    
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavigationButtonAction:(id)sender
{
     [self save];
}


- (void)initNavigate
{
    if (!self.titleBox) {
        self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
        [self.view addSubview:self.titleBox.view];
        self.titleBox.view.frame =CGRectMake(0, 0, self.view.frame.size.width, 64);
    }

//    [self.titleBox initWithName:NSLocalizedString(@"提醒与推荐", nil) backImg:Head_ICON_BACK moreImg:Head_ICON_OK];
}

- (DHTTableViewManager *)manager
{
    if (!_manager) {
        _manager =[[DHTTableViewManager alloc] initWithTableView:self.tabView];
        
    }
    return _manager;
}


- (void)onNavigateEvent:(NSInteger)event
{
    if (event ==DIRECT_LEFT) {

//        [parent showView: SMARAT_ORDER_RECOMMEND_VIEW];
//        [parent.orderRecommendView  preData];
        [self.navigationController popViewControllerAnimated:YES];

//        [parent showView: SMARAT_ORDER_RECOMMEND_VIEW];
//        [parent.orderRecommendView  preData];

    }
    else
    {
        [self save];
    }
}

- (void)configureManager
{

    [self.manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
    [self.manager registerCell:@"TDFSwitchCell" withItem:@"TDFSwitchItem"];
    [self.manager registerCell:@"TDFLabelCell" withItem:@"TDFLabelItem"];
    [self.manager registerCell:@"TDFOrderCell" withItem:@"TDFOrderItem"];
}

- (void)getHttpData:(NSString *)plantId WithTitle:(NSString *)title
{
    self.title  =  [NSString stringWithFormat:@"%@",title];
    [self.titleBox initWithName:title backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:self.progressHud];

     [TDFOrderService orderGetplanPlantId:plantId CompleteBlock:^(TDFResponseModel * _Nullable response ) {
         [self.progressHud hide: YES];
        NSDictionary *dic =response.responseObject;
        if (response.error) {
            [AlertBox show:response.error.localizedDescription];
            return ;
        }
        if ( ![NSString stringWithFormat:@"%@",dic[@"code"]].integerValue) {
            [AlertBox show:[NSString stringWithFormat:@"%@",dic[@"message"]]];
            return ;
        }
         self.isChange =NO;
        [self.foodListArry removeAllObjects];
        [self.minorListArry removeAllObjects];
        [self.majorListArry removeAllObjects];
        [self.manager  removeAllSections];
        [self.selectArry removeAllObjects];
        NSDictionary *data =dic[@"data"];
        self.planId =data[@"planId"];
        NSDictionary *planItemVo =data[@"planItemVo"];
        self.recommendType= planItemVo[@"recommendType"];
        self.mealscount =[NSString stringWithFormat:@"%@",data[@"mealsCount"]];
        for (NSDictionary *plantData in planItemVo[@"foodTypeSettingList"]) {
            OrderRdData *vo  =[OrderRdData yy_modelWithDictionary:plantData];
            [self.foodListArry addObject:vo];
            
        }
        for (NSDictionary *plantData in planItemVo[@"majorSettingList"]) {
            OrderRdData *vo  =[OrderRdData yy_modelWithDictionary:plantData];
            [self.majorListArry addObject:vo];

        }
        for (NSDictionary *plantData in planItemVo[@"minorSettingList"]) {
            OrderRdData *vo  =[OrderRdData yy_modelWithDictionary:plantData];
            [self.minorListArry addObject:vo];

        }
         [self addBaseSettingSection];
         if ([ObjectUtil isNotEmpty:self.foodListArry]) {
             for (NSInteger i=0; i<self.foodListArry.count; i++) {
                 [self addRemindSettingSectionWithtag:i];
             }
             
         }
         [self addCaiLiaoSetting];
         if (self.recommendType.integerValue ==TDFOrderSpecificMainType) {
             selectLabel.text =NSLocalizedString(@"按具体主料提醒与推荐", nil);
         }
         else
         {
             selectLabel.text =NSLocalizedString(@"按主料大类提醒与推荐", nil);
         }
         if (self.recommendType.integerValue==TDFOrderSpecificMainType) {
             if ([ObjectUtil isNotEmpty:self.minorListArry]) {
                 for (NSInteger i=0; i<self.minorListArry.count; i++) {
                     [self addSpecificMain:i With:self.minorListArry];
                 }
             }
         }
         else {
             if ([ObjectUtil isNotEmpty:self.majorListArry]) {
                 for (NSInteger i=0; i<self.majorListArry.count; i++) {
                     [self addMainIngredientTag:i With:self.majorListArry];
                 }
             }
         }
        [self reload];
    }];
}

- (FuctionCustomAlertView *)tanchView
{
    if (!_tanchView) {
        _tanchView =[[FuctionCustomAlertView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/12,SCREEN_HEIGHT-124, SCREEN_WIDTH*5/6,60)];
        _tanchView.hidden =YES;
        [self.view addSubview:_tanchView];
    }
    return _tanchView;
}

- (NSMutableArray *)selectArry
{
    if (!_selectArry) {
        _selectArry =[[NSMutableArray alloc] init];
    }
    return _selectArry;
}

- (NSMutableArray *)foodListArry
{
    if (!_foodListArry) {
        _foodListArry =[[NSMutableArray alloc] init];
    }
    return _foodListArry;
}

- (NSMutableArray *)majorListArry
{
    if (!_majorListArry) {
        _majorListArry =[[NSMutableArray alloc] init];
    }
    return  _majorListArry;
}

-(NSMutableArray *)minorListArry
{
    if (!_minorListArry) {
        _minorListArry =[[NSMutableArray alloc] init];
    }
    return _minorListArry;
}

- (void)addBaseSettingSection
{
    
    DHTTableViewSection *baseSettingSection = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"按菜肴类型提醒与推荐", nil) font:15];
    DHTTableViewSection *section = [DHTTableViewSection section];
    section.footerView =[self setFootView:NSLocalizedString(@"注：此处设置的类型提醒最小建议份数，在”一键智能点餐“设置模块中同样适用。如果您希望修改模板中的推荐菜肴份数，请在此处修改最小建议份数。", nil)];
    section.footerHeight = [self textHeight:NSLocalizedString(@"注：此处设置的类型提醒最小建议份数，在”一键智能点餐“设置模块中同样适用。如果您希望修改模板中的推荐菜肴份数，请在此处修改最小建议份数。", nil) withSize:12]+30;

    [self.manager addSection:baseSettingSection];
    [self.manager addSection:section];
    
    
}

- (void)addRemindSettingSectionWithtag:(NSInteger)tag
{
    OrderRdData *vo =self.foodListArry[tag];
    DHTTableViewSection *remindSettingSection  =[DHTTableViewSection sectionWithItemHeader:[NSString stringWithFormat:NSLocalizedString(@"%@提醒与推荐", nil),vo.labelName]];
    DHTTableViewSection *section = [DHTTableViewSection section];
    TDFOrderItem *minIteam =[[TDFOrderItem alloc] init];
    minIteam.title =NSLocalizedString(@"最小建议份数", nil);
    minIteam.numValue =vo.minNumber;
    minIteam.preValue =@(vo.minNumber);
    [section addItem:minIteam];
    
    minIteam.filterBlock = ^(NSInteger newvalue){
        if (newvalue>vo.maxNumber) {
            [self popViewWithcompare];
            return NO;
        }
        BOOL isCountiue =[self limitConditionsWith:newvalue];
        if (!isCountiue) {
            return isCountiue;
        }
        vo.minNumber =newvalue;
        return YES;
    };
    TDFOrderItem *maxIteam =[[TDFOrderItem alloc] init];
    maxIteam .title =NSLocalizedString(@"最大建议份数", nil);
    maxIteam .numValue =vo.maxNumber;
    maxIteam .preValue =@(vo.maxNumber);
    [section addItem:maxIteam ];
    
     maxIteam.filterBlock = ^(NSInteger newvalue){
         if (newvalue<vo.minNumber ) {
             [self popViewWithcompare];
             return NO;
         }
        BOOL isCountiue =[self limitConditionsWith:newvalue];
        if (!isCountiue) {
            return isCountiue;
        }
        vo.maxNumber =newvalue;
        return YES;
    };
    
    TDFSwitchItem *minSwitchIteam =[[TDFSwitchItem alloc] init];
    minSwitchIteam.title = NSLocalizedString(@"点菜少于最小建议份数时提醒并推荐", nil);
    minSwitchIteam.isOn =vo.minSwitch;
    minSwitchIteam.preValue =@(vo.minSwitch);
    minSwitchIteam.filterBlock = ^ (BOOL isOn) {
        vo.minSwitch =isOn;
        return YES;
    };
    [section addItem:minSwitchIteam];
    TDFSwitchItem *maxSwitchItam =[[TDFSwitchItem alloc] init];
    maxSwitchItam .title =NSLocalizedString(@"点菜多于最大建议份数时提醒", nil);
    maxSwitchItam .isOn =vo.maxSwitch;
    maxSwitchItam .preValue =@(vo.maxSwitch);
    [section addItem:maxSwitchItam ];
    maxSwitchItam.filterBlock = ^ (BOOL isOn) {
        vo.maxSwitch =isOn;
        return YES;
    };
    
    [self.manager addSection:remindSettingSection];
    [self.manager addSection:section];
   
}

-(void)addCaiLiaoSetting
{
    DHTTableViewSection *section  =[DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"菜品主料提醒", nil) font:13];
    [self customViewWithView:section.headerView];
    [self.manager addSection:section];
    
}

- (void)addMainIngredientTag:(NSInteger)tag With:(NSMutableArray *)arry
{
    OrderRdData *vo =arry[tag];
    DHTTableViewSection *remindSettingSection  =[DHTTableViewSection sectionWithItemHeader:[NSString stringWithFormat:NSLocalizedString(@"%@提醒与推荐", nil),vo.labelName]];
    DHTTableViewSection *section =[DHTTableViewSection section];
    TDFSwitchItem *iteam  =[[TDFSwitchItem alloc] init];
    iteam.title = NSLocalizedString(@"点菜少于最小建议份数时提醒", nil);
    iteam.isOn =vo.minSwitch;
    iteam.preValue =@(vo.minSwitch);
    [section addItem:iteam];
    
    
    __weak typeof(self) weakSelf = self;
    TDFOrderItem *minSegementItem =[[TDFOrderItem alloc] init];
    minSegementItem.title =NSLocalizedString(@"• 最小建议份数", nil);
    minSegementItem.numValue =vo.minNumber;
    minSegementItem.preValue =@(vo.minNumber);
    [section addItem:minSegementItem];
    iteam.filterBlock =^ (BOOL isOn) {
        vo.minSwitch =isOn;
        minSegementItem.shouldShow =isOn;
        [weakSelf reload];
        return YES;
    };
    minSegementItem.filterBlock = ^(NSInteger newvalue){
        if (newvalue>vo.maxNumber) {
            [weakSelf popViewWithcompare];
            return NO;
        }
        BOOL isCountiue =[weakSelf limitConditionsWith:newvalue];
        if (!isCountiue) {
            return isCountiue;
        }
        vo.minNumber =newvalue;
        return YES;
    };
    
    TDFSwitchItem *maxIteam =[[TDFSwitchItem alloc] init];
    maxIteam.title =NSLocalizedString(@"点菜多于最大建议份数时提醒", nil);
    maxIteam.isOn =vo.maxSwitch;
    maxIteam.preValue =@(vo.maxSwitch);
    
    [section addItem:maxIteam];
    
    TDFOrderItem *maxSegement =[[TDFOrderItem alloc] init];
    maxSegement.title =NSLocalizedString(@"• 最大建议份数", nil);
    maxSegement.numValue =vo.maxNumber;
    maxSegement.preValue =@(vo.maxNumber);
    maxIteam.filterBlock =^ (BOOL isOn) {
        vo.maxSwitch =isOn;
        maxSegement.shouldShow =isOn;
        [weakSelf reload];
        return YES;
    };
    maxSegement.filterBlock = ^(NSInteger newvalue){
        if (newvalue<vo.minNumber ) {
            [weakSelf popViewWithcompare];
            return NO;
        }
        BOOL isCountiue =[weakSelf limitConditionsWith:newvalue];
        if (!isCountiue) {
            return isCountiue;
        }
        vo.maxNumber =newvalue;
        return YES;
    };
    [section addItem:maxSegement];
    [self.manager addSection:remindSettingSection];
    [self.manager addSection:section];
    [self.selectArry addObject:remindSettingSection];
    [self.selectArry addObject:section];
    
}

- (void)addSpecificMain:(NSInteger)tag With:(NSMutableArray *)arry
{
    OrderRdData *vo =arry[tag];
    DHTTableViewSection *remindSettingSection  =[DHTTableViewSection sectionWithItemHeader:[NSString stringWithFormat:NSLocalizedString(@"%@提醒与推荐", nil),vo.labelName]];
    DHTTableViewSection *section =[DHTTableViewSection section];
    TDFSwitchItem *iteam  =[[TDFSwitchItem alloc] init];
    iteam.title = NSLocalizedString(@"顾客未点此主料时提醒并推荐", nil);
    iteam.isOn =vo.minSwitch;
    iteam.preValue =@(vo.minSwitch);
    [section addItem:iteam];
    
    __weak typeof(self) weakSelf = self;
    TDFSwitchItem *maxIteam =[[TDFSwitchItem alloc] init];
    maxIteam.title =NSLocalizedString(@"点菜多于最大建议份数时提醒", nil);
    maxIteam.isOn =vo.maxSwitch;
    maxIteam.preValue =@(vo.maxSwitch);
    
    [section addItem:maxIteam];
    
    TDFOrderItem *maxSegement =[[TDFOrderItem alloc] init];
    maxSegement.title =NSLocalizedString(@"• 建议份数", nil);
    maxSegement.numValue =vo.maxNumber;
    maxSegement.preValue =@(vo.maxNumber);
    maxIteam.filterBlock =^ (BOOL isOn) {
        vo.maxSwitch =isOn;
        maxSegement.shouldShow =isOn;
        [weakSelf reload];
        return YES;
    };
    maxSegement.filterBlock = ^(NSInteger newvalue){
        BOOL isCountiue =[weakSelf limitConditionsWith:newvalue];
        if (!isCountiue) {
            return isCountiue;
        }
        vo.maxNumber =newvalue;
        return YES;
       
    };
    [section addItem:maxSegement];
    [self.manager addSection:remindSettingSection];
    [self.manager addSection:section];
    [self.selectArry addObject:remindSettingSection];
    [self.selectArry addObject:section];
    
}

- (void)customViewWithView:(UIView*)view
{
    selectLabel = [[UILabel  alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30-140, 14,140 , 21)];
    selectLabel.text =NSLocalizedString(@"按主料大类提醒与推荐", nil);
    selectLabel.font =[UIFont systemFontOfSize:13];
    selectLabel.textColor =RGBA(38, 152, 207, 1);
    selectLabel.textAlignment =NSTextAlignmentRight;
    UIImageView *nextIco =[[UIImageView alloc] initWithFrame:CGRectMake(selectLabel.right, 14, 20, 21)];
    nextIco.image =[UIImage imageNamed:@"ico_next_down.png"];
    UIButton *button  =[[UIButton alloc] initWithFrame:CGRectMake(selectLabel.left, 14, nextIco.right, 21)];
    button.backgroundColor =[UIColor clearColor];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:selectLabel];
    [view addSubview:nextIco];
    [view addSubview:button];
    
}

- (BOOL)limitConditionsWith:(NSInteger)newvalue
{
    if (newvalue<1) {

        [self popViewIsBigNum:NO];
        return NO;
    }
    if (newvalue>99) {
        [self popViewIsBigNum:YES];
        return NO;
    }
    return YES;
}

- (void)popViewIsBigNum:(BOOL)isBig
{
    self.tanchView.hidden =NO;
    if (!isBig) {

     [self.tanchView initWithContent:[NSString  stringWithFormat:NSLocalizedString(@"建议份数不能小于1", nil)]];
    }
    else
    {
      [self.tanchView initWithContent:[NSString  stringWithFormat:NSLocalizedString(@"建议份数不能大于99", nil)]];
    }
    [self performSelector:@selector(AlertShow:) withObject:self.tanchView afterDelay:3];
}

- (void)popViewWithcompare
{
    self.tanchView.hidden =NO;
    [self.tanchView initWithContent:[NSString  stringWithFormat:NSLocalizedString(@"最小建议份数不能大于最大建议份数", nil)]];
    [self performSelector:@selector(AlertShow:) withObject:self.tanchView afterDelay:3];
}

-(void)AlertShow:( FuctionCustomAlertView*)view
{
     view.hidden =YES;
}
- (void)btnClick:(UIButton *)button
{
    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"菜肴份额", nil)
                                                                              options:self.shopArry
                                                                        currentItemId:selectLabel.text];
    __weak __typeof(self) wself = self;
    pvc.competionBlock = ^void(NSInteger index) {

    [wself pickOption:wself.shopArry[index] event:1];
    
    };
    [self presentViewController:pvc animated:YES completion:nil];
}


#pragma PickViewDelegate
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
   
     NameItemVO *Vo  =(NameItemVO *)selectObj;
    if (![selectLabel.text isEqualToString:Vo.itemName]) {
         selectLabel.text =Vo.itemName;
        [self.manager removeSectionWithIteamArry:self.selectArry];
        [self.selectArry removeAllObjects];
        [self changeDataWithTitle];
         self.isChange=YES;
    }
   
    return YES;
}


- (void)changeDataWithTitle
{
    if (![selectLabel.text isEqualToString:NSLocalizedString(@"按主料大类提醒与推荐", nil)]) {
        
        [self changeDataSourceWithArry:self.minorListArry WithTag:NO];
        self.recommendType =@"1";
    }
    else
    {
        self.recommendType =@"0";
        [self changeDataSourceWithArry:self.majorListArry WithTag:YES];
    }
   
}

- (void)changeDataSourceWithArry:(NSMutableArray *)arry WithTag:(BOOL)isShow
{
    if ([ObjectUtil isNotEmpty:arry]) {
        for (NSInteger i=0; i<arry.count; i++) {
            if (isShow) {
                [self addMainIngredientTag:i With:arry];
            }
           else
           {
               [self addSpecificMain:i With:arry];
           }
        }
      
    }
    [self reload];
}

- (NSMutableArray *)shopArry
{
    if (!_shopArry) {
        _shopArry =[[NSMutableArray alloc] init];
        [self createShopArr:_shopArry];
    }
    return _shopArry;
}

- (void)createShopArr:(NSMutableArray *)dataArry
{
    NSArray *arry =@[NSLocalizedString(@"按主料大类提醒与推荐", nil),NSLocalizedString(@"按具体主料提醒与推荐", nil)];
    for (NSInteger i=0; i<arry.count; i++) {
        NameItemVO *vo =[[NameItemVO alloc]init];
        vo.itemName =arry[i];
        vo.itemId =[NSString stringWithFormat:@"%@",arry[i]];
        [dataArry addObject:vo];
    }
}



- (void)reload
{
    [self.manager reloadData];
}

#pragma Navigativile
-(void)initNotifaction
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeNavTitles:) name:kTDFEditViewIsShowTipNotification object:nil];
}

-(void)shouldChangeNavTitles:(NSNotification *)notifacion
{
   BOOL ishide = [self isHideTip];
    if (ishide || self.isChange) {
        [self configNavigationBar:YES];
    }
    else
    {

        [self configNavigationBar:NO];
       [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
    }
    
  
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

    
-(BOOL)isHideTip
{
  BOOL ishide = [TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections];
   return ishide;
}

- (void)addFooterView
{
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd];
    NSMutableArray *footButtons = self.footerButtons;
    
    [footButtons enumerateObjectsUsingBlock:^(UIButton *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj isKindOfClass:[TDFFooterButton class]]) {
            TDFFooterButton *addButton = (TDFFooterButton *)obj;
            [addButton setTitle:@"" forState:UIControlStateNormal];
            UIImage *addImage = [UIImage imageNamed:@"Initialize"];
            [addButton setBackgroundImage:addImage forState:UIControlStateNormal];
            [addButton setImage:nil forState:UIControlStateNormal];
        }
    }];
}

- (void)footerAddButtonAction:(UIButton *)sender {
    UIAlertView *altrt =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您希望恢复默认值吗？您设置过的数据将被更改", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    [altrt show];
}

-(void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"orderRecomendeView"];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [self  savefirstView];
    }
}

-(void)savefirstView
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:self.progressHud];
    [TDFOrderService getPlantId:self.planId mealtcount:self.mealscount CompleteBlock:^(TDFResponseModel * _Nullable response) {
        [self.progressHud hide: YES];
        NSDictionary *dic =response.responseObject;
        if (response.error) {
            [AlertBox show:response.error.localizedDescription];
            return ;
        }
        if ( ![NSString stringWithFormat:@"%@",dic[@"code"]].integerValue) {
            [AlertBox show:[NSString stringWithFormat:@"%@",dic[@"message"]]];
            return ;
        }
        if (self.delegate) {
            [self.delegate navitionToPushBeforeJump:@"" data:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma SAVE
 - (void)save
{
    NSString *str =[self getSettingList];
    [UIHelper showHUD:NSLocalizedString(@"正在保存", nil) andView:self.view andHUD:self.progressHud];
//    [service saverRecommendList:str target:self callback:@selector(saveRecommend:)];
    [TDFOrderService orderPlantSave:str CompleteBlock:^(TDFResponseModel * _Nullable response) {
        [self.progressHud hide:YES];
        NSDictionary *dic =response.responseObject;
        if (response.error) {
            [AlertBox show:response.error.localizedDescription];
            return ;
        }
        if ( ![NSString stringWithFormat:@"%@",dic[@"code"]].integerValue) {
            [AlertBox show:[NSString stringWithFormat:@"%@",dic[@"message"]]];
            return ;
        }
        if (self.delegate) {
            [self.delegate navitionToPushBeforeJump:@"" data:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];

    }];
    
}

-(NSString *)getSettingList
{
    NSMutableArray *savedata=[[NSMutableArray alloc]init];
    NSMutableArray *postdata =[[NSMutableArray alloc]init];
    [savedata addObjectsFromArray:self.foodListArry];
    [savedata addObjectsFromArray:self.majorListArry];
    [savedata addObjectsFromArray:self.minorListArry];
    for (OrderRdData *iteam in savedata) {
        orderSaveData *data =[[orderSaveData alloc]init];
        data.labelId =[NSString stringWithFormat:@"%ld",iteam.labelId];
        data.maxNumber =[NSString stringWithFormat:@"%ld",iteam.maxNumber];
        data.minNumber =[NSString stringWithFormat:@"%ld",iteam.minNumber];
        data.minSwitch =[NSString stringWithFormat:@"%ld",iteam.minSwitch];
        data.maxSwitch =[NSString stringWithFormat:@"%ld",iteam.maxSwitch];
        [postdata addObject:data];
    }
    NSString *newstr;
    newstr =[JsonHelper arrObjArrTransJson:postdata];
    NSMutableString *jsontsr1 =[[NSMutableString alloc]init];
    [jsontsr1 appendString:@"{"];
    [jsontsr1 appendString:@"\""];
    [jsontsr1 appendString:@"planId"];
    [jsontsr1 appendString:@"\""];
    [jsontsr1 appendString:@":"];
    [jsontsr1 appendString:@"\""];
    [jsontsr1 appendString:[NSString stringWithFormat:@"%@",self.planId]];
    [jsontsr1 appendString:@"\""];
    [jsontsr1 appendString:@","];
    [jsontsr1 appendString:@"\""];
    [jsontsr1 appendString:@"recommendType"];
    [jsontsr1 appendString:@"\""];
    [jsontsr1 appendString:@":"];
    [jsontsr1 appendString:[NSString stringWithFormat:@"%@",self.recommendType]];
    [jsontsr1 appendString:@","];
    [jsontsr1 appendString:@"\""];
    [jsontsr1 appendString:@"settingList"];
    [jsontsr1 appendString:@"\""];
    [jsontsr1 appendString:@":"];
    [jsontsr1 appendString:newstr];
    [jsontsr1 appendString:@"}"];
    return jsontsr1;
    
}


#pragma 自定义headView
- (UIView *)setFootView:(NSString *)text
{
    UIView *footview =[[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 1000)];
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 21, 100)];
    [footview addSubview:label];
    label.text = text;
    label.numberOfLines =0;
    label.lineBreakMode =UILineBreakModeCharacterWrap;
    label.font =[UIFont systemFontOfSize:12];
    CGFloat height =[self textHeight:text withSize:12];
    CGRect Frame  =label.frame;
    Frame.size.height =height;
    label.frame = Frame;
    CGRect viewFrame  =footview.frame;
    viewFrame.size.height =label.bottom;
    return footview;
}


-(CGFloat)textHeight:(NSString *)string withSize:(CGFloat)size
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 21, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.height;
}






@end
