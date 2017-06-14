//
//  NavigateMenuView.m
//  RestApp
//
//  Created by zxh on 14-5-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertBox.h"
#import "Platform.h"
#import "XHButton.h"
#import "QuickStep.h"
#import "SeatModule.h"
#import "MainModule.h"
#import "MenuModule.h"
#import "RemoteEvent.h"
#import "ViewFactory.h"
#import "KabawModule.h"
#import "ViewFactory.h"
#import "UIView+Sizes.h"
#import "PropertyList.h"
#import "NavigateMenu.h"
#import "GlobalRender.h"
#import "UIMenuAction.h"
#import "MarketModule.h"
#import "RestConstants.h"
#import "DataSingleton.h"
#import "SettingModule.h"
#import "RestConstants.h"
#import "AppController.h"
#import "SuitMenuModule.h"
#import "ActionConstants.h"
#import "BackgroundHelper.h"
#import "NavigateMenuCell.h"
#import "NSString+Estimate.h"
#import "FuctionActionData.h"
#import "NavigateMenuEndCell.h"
#import "NavigateMenuFristCell.h"
#import "TDFMediator+EmployeeModule.h"
#import "TDFMediator+SettingModule.h"
#import "TDFMediator+LoanModule.h"
#import "TDFMediator+SeatModule.h"
#import "TDFMediator+MenuModule.h"

#define HANGZHOUCITYID 78 //杭州的cityId
@implementation NavigateMenu

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)mainModuleTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mainModule = mainModuleTemp;
        billservice =[ServiceFactory Instance].billModifyService;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        self.OtTArr =[[NSMutableArray alloc]init];
        self.openSArr =[[NSMutableArray alloc]init];
        self.BuSUArr =[[NSMutableArray alloc]init];
        self.PaTSArr =[[NSMutableArray alloc]init];
        self.EnSSArr =[[NSMutableArray alloc]init];
        self.cashireArr =[[NSMutableArray alloc]init];
        self.arry =[[NSMutableArray alloc]init];
        self.arrT =[[NSMutableArray alloc]init];
        self.arrS =[[NSMutableArray alloc]init];
        self.arrF =[[NSMutableArray alloc]init];
        self.arrM =[[NSMutableArray alloc]init];
        self.arryO= [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
     [super viewDidLoad];
     self.isDetailFlag = NO;
     steps = [[NSMutableArray alloc] init];
     dataArr =[[NSMutableArray alloc] init];
     
     [self initMainGrid];
     [self loadImagData];
     [self initNotifaction];
}

- (UINavigationController *)rootController
{
    if (!_rootController) {
        UIViewController* viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            _rootController = (UINavigationController *)viewController;
        }else if ([viewController isKindOfClass:[UIViewController class]])
        {
            _rootController = viewController.navigationController;
        }
    }
    return _rootController;
}

- (void)initMainGrid
{
    [self.mainGrid setBackgroundView:nil];
    self.mainGrid.backgroundColor=[UIColor clearColor];
    self.mainGrid.delegate =self;
    self.mainGrid.dataSource =self;
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainGrid setTableFooterView:[ViewFactory generateFooter:80]];
    self.mainGrid.showsVerticalScrollIndicator=NO;
    [self loadNavigationView];
}

- (void)reload
{
    for (NSMutableArray *obj in steps) {
        for (QuickStep *step in obj) {
            step.isLock = [[Platform Instance] lockAct:step.actCode];
        }
    }
    [self.mainGrid reloadData];
}

#pragma 导航页
- (void)loadNavigationView
{
    NSString *str =[[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLancunes"];
    if (![str isEqualToString:@"11"]) {
        
        [self hideguiviewwithiflag:NO];
        [[NSUserDefaults standardUserDefaults]setObject:@"11" forKey:@"FirstLancunes"];
    } else {
        [self hideguiviewwithiflag:YES];
    }
}

- (void)hideguiviewwithiflag:(BOOL)flag
{
    [self.guiview setHidden:flag];

    if (!flag) {
        [self.showFuview setHidden:NO];
        CAShapeLayer *border = [CAShapeLayer layer];
        border.strokeColor = [UIColor redColor].CGColor;
        border.fillColor = nil;
        border.path = [UIBezierPath bezierPathWithRect:self.FuBtn.bounds].CGPath;
        border.frame = self.FuBtn.bounds;
        border.lineWidth = 2;
        border.lineCap = @"square";
        border.lineDashPattern = @[@2, @4];
        [self.FuBtn.layer addSublayer:border];
         self.FuBtn.layer.masksToBounds=YES;
         self.FuBtn.layer.cornerRadius=3;
    } else {
        [self.Clickbutton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.showFuview setHidden:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.guiview.hidden) {
        [[NSUserDefaults standardUserDefaults]setObject:@"11" forKey:@"FirstLancun"];
        [self hideguiviewwithiflag:YES];
    }
}

- (void)initNotifaction
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseALlAction:) name:ALL_CODE_ACTION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInfoData) name:LODATA object:nil];
}

- (void)loadInfoData
{
    
   
    [self loadGrid:self.isDetailFlag?0:1 wxEnabled:self.isWxEnabled];
   
    [self reload];

}

- (void)parseALlAction:(NSNotification *)notifation
{
    self.navigateActionArr =[[NSMutableArray alloc]init];
    [self.navigateActionArr removeAllObjects];
    if([notifation.object isKindOfClass:[NSMutableArray class]]) {
        self.navigateActionArr =[notifation.object copy];
        [self getBillData];
    }else if([notifation.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = notifation.object;
        self.navigateActionArr = [dic[@"actionArr"] copy];
        self.Billindex = [dic[@"useBillHide"] boolValue];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInfoData) name:LODATA object:nil];
    }
    
}

- (NSMutableArray *)removesameiteaminarry:(NSMutableArray *)arry
{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    for (NSInteger i=0 ;i<arry.count;i++) {
        QuickStep *menu =arry[i];
//        NSString *str = menu.actCode;
        [dic setObject:menu forKey:menu.actCode];
    }
    
    return [[dic allValues] mutableCopy];
}

- (void)loadFinish:(RemoteResult *)result
{
    [hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self parseResult:result.content];
}

- (void)parseResult:(NSString *)result
{
//    [self.stepTemps removeAllObjects];
//    NSDictionary *map = [JsonHelper transMap:result];
//    ShopInfoVO *shopInfoVO = [[ShopInfoVO alloc] initWithDictionary:map[@"data"]];
//    if (shopInfoVO.displayWxPay == 1) {
//        self.isWxEnabled = YES;
//    } else {
//        self.isWxEnabled = NO;
//    }
//    [self loadGrid:self.isDetailFlag?0:1 wxEnabled:self.isWxEnabled];
//    [self reload];
    
}

-(void)getBillData
{
    [billservice queryBillModifyInfoWithtaskType:self callback:@selector(getshopData:)];
}
-(void)getshopData:(RemoteResult *)result
{
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    NSDictionary *map = [JsonHelper transMap:result.content];
    self.Billindex = [map[@"data"] boolValue];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInfoData) name:LODATA object:nil];
    
}

- (IBAction)btnVideoClick:(id)sender
{
    [self showHelpVideo];
}

- (IBAction)btnshowFunction:(id)sender {
    
    isnavigatemenupush =YES;
    [mainModule hideView];
//    [mainModule.navigateBtn setHidden:NO];
    [mainModule loadSettingModule];
    mainModule.settingModule.view.hidden=NO;
    [mainModule.settingModule showFuctionViewWithdata:self.navigateActionArr];
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_HIDDEN_NOTIFICATION object:nil];
    
}
- (IBAction)btnPopBtn:(id)sender {
    isnavigatemenupush =YES;
    [self.guiview setHidden:YES];
    [mainModule hideView];
//    [mainModule.navigateBtn setHidden:NO];
    [mainModule loadSettingModule];
    mainModule.settingModule.view.hidden=NO;
    [mainModule.settingModule showFuctionViewWithdata:self.navigateActionArr];
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_HIDDEN_NOTIFICATION object:nil];
}



- (void)loadGrid:(int)isShowAll wxEnabled:(BOOL)enable
{
   // [self loadNavigationView];
    NSMutableArray *allSteps = [self createSteps];
    if (enable) {
        [self creatWXStep:allSteps];
        [self creatEvaluateStep:allSteps stepNum:7];
    } else {
        [self creatEvaluateStep:allSteps stepNum:6];
    }
    [steps removeAllObjects];
    [self.openSArr removeAllObjects];
    [self.BuSUArr removeAllObjects];
    [self.cashireArr removeAllObjects];
    [self.EnSSArr removeAllObjects];
    [self.PaTSArr removeAllObjects];
    [self.OtTArr removeAllObjects];
    [self.arry removeAllObjects];
    [self.arryO removeAllObjects];
    [self.arrT removeAllObjects];
    [self.arrS removeAllObjects];
    [self.arrF removeAllObjects];
    [self.arrM removeAllObjects];
    self.titilArr =@[NSLocalizedString(@"开店设置", nil),NSLocalizedString(@"收银设置", nil),NSLocalizedString(@"营业设置", nil),NSLocalizedString(@"传菜设置", nil),NSLocalizedString(@"供应链", nil),NSLocalizedString(@"其他工具", nil)];
    NSArray *arry1 =@[NSLocalizedString(@"系统参数", nil),NSLocalizedString(@"店家信息", nil),NSLocalizedString(@"营业结束时间", nil),NSLocalizedString(@"营业班次", nil),NSLocalizedString(@"付款方式", nil),NSLocalizedString(@"挂账设置", nil),NSLocalizedString(@"收银单据", nil)];
    [self.arry addObjectsFromArray:arry1];
    NSArray *arry2 =@[NSLocalizedString(@"收银打印", nil),NSLocalizedString(@"零头处理方式", nil),NSLocalizedString(@"客单备注", nil),NSLocalizedString(@"特殊操作原因", nil),NSLocalizedString(@"附加费", nil),NSLocalizedString(@"打折方案", nil),NSLocalizedString(@"商品促销", nil),NSLocalizedString(@"电子菜谱排版", nil)];
    [self.arryO addObjectsFromArray:arry2];
//    NSArray *arr3 =@[NSLocalizedString(@"商品", nil),NSLocalizedString(@"员工", nil),NSLocalizedString(@"桌位", nil),NSLocalizedString(@"套餐", nil),NSLocalizedString(@"传菜", nil)];
     NSArray *arr3 =@[NSLocalizedString(@"员工", nil),NSLocalizedString(@"桌位", nil),NSLocalizedString(@"传菜", nil)];
    [self.arrS addObjectsFromArray:arr3];
    NSArray *arr4 =@[NSLocalizedString(@"传菜方案", nil),NSLocalizedString(@"不出单菜单", nil),NSLocalizedString(@"备用打印机", nil)];
    [self.arrT addObjectsFromArray:arr4];
    NSArray *arr5 =@[NSLocalizedString(@"二维火供应链", nil)];
    [self.arrF addObjectsFromArray:arr5];
    NSArray *arr6;
    if (self.Billindex) {
       arr6 =@[NSLocalizedString(@"我要贷款", nil),NSLocalizedString(@"更换收银机", nil),NSLocalizedString(@"排队设置", nil), NSLocalizedString(@"更换排队机", nil),NSLocalizedString(@"营业数据清理", nil),NSLocalizedString(@"账单优化", nil)];
    }
    else
    {
        arr6 =@[NSLocalizedString(@"我要贷款", nil),NSLocalizedString(@"更换收银机", nil),NSLocalizedString(@"排队设置", nil), NSLocalizedString(@"更换排队机", nil),NSLocalizedString(@"营业数据清理", nil)];
    }
    [self.arrM addObjectsFromArray:arr6];
    self.openSArr =[self createCategStep:allSteps categorty:self.arry];
    [steps addObject:self.openSArr];
    self.cashireArr =[self createCategStep:allSteps categorty:self.arryO];
    [steps addObject:self.cashireArr];
    self.BuSUArr =[self createCategStep:allSteps categorty:self.arrS];
    [steps addObject:self.BuSUArr];
    self.PaTSArr =[self createCategStep:allSteps categorty:self.arrT];
    [steps addObject:self.PaTSArr];
    self.EnSSArr =[self createCategStep:allSteps categorty:self.arrF];
    [steps addObject:self.EnSSArr];
    self.OtTArr = [self createCategStep:allSteps categorty:self.arrM];
    [steps addObject:self.OtTArr];
    
}

-(void)loadImagData
{
    [dataArr removeAllObjects];
    NSDictionary *dic1 =@{NSLocalizedString(@"系统参数", nil):@"st_cs",NSLocalizedString(@"店家信息", nil):@"dj_xx",NSLocalizedString(@"营业结束时间", nil):@"yy_js_sj",NSLocalizedString(@"营业班次", nil):@"yy_bc",NSLocalizedString(@"付款方式", nil):@"fk_fs",NSLocalizedString(@"挂账设置", nil):@"gz_sz",NSLocalizedString(@"收银单据", nil):@"sy_dj_mb"};
    [dataArr addObject:dic1];
    
    NSDictionary *dic2 =@{NSLocalizedString(@"零头处理方式", nil):@"lt_cl_fs",NSLocalizedString(@"收银打印", nil):@"sy_dy",NSLocalizedString(@"客单备注", nil):@"kd_bz",NSLocalizedString(@"特殊操作原因", nil):@"ts_cz_yy",NSLocalizedString(@"附加费", nil):@"fjf",NSLocalizedString(@"打折方案", nil):@"dz_fa",NSLocalizedString(@"商品促销", nil):@"sp_cx",NSLocalizedString(@"电子菜谱排版", nil):@"dz_cp_pb"};
    [dataArr addObject:dic2];
    
//    NSDictionary *dic3 =@{NSLocalizedString(@"商品", nil):@"sp",NSLocalizedString(@"员工", nil):@"yg",NSLocalizedString(@"套餐", nil):@"tc",NSLocalizedString(@"桌位", nil):@"zw",NSLocalizedString(@"传菜", nil):@"cc_fa"};
     NSDictionary *dic3 =@{NSLocalizedString(@"员工", nil):@"yg",NSLocalizedString(@"桌位", nil):@"zw",NSLocalizedString(@"传菜", nil):@"cc_fa"};
    [dataArr addObject:dic3];
    
    NSDictionary *dic4 =@{NSLocalizedString(@"传菜方案", nil):@"ico_nav_chuan"};
    [dataArr addObject:dic4];
    
    NSDictionary *dic5 =@{NSLocalizedString(@"二维火供应链", nil):@"wl"};
    [dataArr addObject:dic5];
    
    NSDictionary *dic6=@{NSLocalizedString(@"我要贷款", nil):@"loan",NSLocalizedString(@"更换收银机", nil):@"gh_syj",NSLocalizedString(@"更换排队机", nil):@"gh_pdj",NSLocalizedString(@"营业数据清理", nil):@"yy_sj_cl",NSLocalizedString(@"账单优化", nil):@"zd_yh"};
    [dataArr addObject:dic6];
}

-(void)creatWXStep:(NSMutableArray *)list
{
    QuickStep* step=[[QuickStep alloc]init];
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"微信支付", nil);
    step.actCode=PAD_PAYMENT;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=1;
    step.stepNum=6;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=11;
    [list addObject:step];
}

-(void)creatEvaluateStep:(NSMutableArray *)list stepNum:(NSInteger)stepNum
{
    QuickStep* step=[[QuickStep alloc]init];
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"顾客评价", nil);
    step.actCode=PAD_EVALUATE;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=stepNum;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=11;
    [list addObject:step];
}
- (NSMutableArray *)createCategStep:(NSMutableArray *)list categorty:(NSMutableArray *)category
{
    NSMutableArray *categoryArr =[[NSMutableArray alloc]init];
    for (NSInteger i=0; i<list.count; i++) {
        for (NSInteger j=0; j<category.count; j++) {
            QuickStep *step =list[i];
            if ([step.actName isEqualToString:category[j]]) {
                [categoryArr addObject:step];
            }
        }
    }
    //判断是否显示
    NSMutableArray *arry =[[NSMutableArray alloc]init];
    NSMutableArray *arry1 =[[NSMutableArray alloc]init];
    if (self.navigateActionArr!=nil && self.navigateActionArr.count>0) {
        for (FuctionActionData *data in self.navigateActionArr) {
            NSString *str =[NSString stringWithFormat:@"%@",data.name];
            NSString *userhied =[NSString stringWithFormat:@"%d",data.isUserHide];
            //判断服务器是否显示，
            if (data.status==1) {
                //判断用户是否显设置过
                if ( [userhied isEqualToString:@"3"]) {
                    if (data.isHide ==3) {
                        for ( NSInteger i=0 ;i <categoryArr.count;i++ ) {
                            QuickStep *menu = categoryArr[i];
                            if ([menu.actName isEqualToString:NSLocalizedString(@"营业数据清理", nil)])
                            {
                                if ([data.code isEqualToString:PAD_DATA_CLEAR]) {
                                        [arry addObject:menu];
 
                                }
                            }
                            
                            if ([menu.actName isEqualToString:NSLocalizedString(@"二维火供应链", nil)])
                            {
//                                if ([data.code isEqualToString:PAD_DATA_CLEAR]) {
                                    [arry addObject:menu];
                                    
//                                }
                            }
                            
                            if ([menu.actName isEqualToString:NSLocalizedString(@"我要贷款", nil)])
                            {
                                [arry addObject:menu];
                            }
                            
                            else if ([menu.actName isEqualToString:NSLocalizedString(@"账单优化", nil)])
                            {
                                if ([data.code isEqualToString:PAD_ACCOUNT_OPERATION]) {
                                    [arry addObject:menu];
                                }
                                
                            }
                            else if ([menu.actName isEqualToString:NSLocalizedString(@"传菜", nil)])
                            {
                                if ([data.code isEqualToString:PAD_PRODUCE_PLAN]) {
                                    [arry addObject:menu];
                                    
                                }

                            }
                            else if ([menu.actName isEqualToString:NSLocalizedString(@"营业班次", nil)])
                            {
                                if ([data.code isEqualToString:PAD_TIME_ARRANGE]) {
                                    [arry addObject:menu];
                                }
                            }
                            else if ([menu.actName isEqualToString:NSLocalizedString(@"特殊操作原因", nil)])
                            {
                                if ([data.code isEqualToString:PAD_SPECIAL_OPERATE]) {
                                    [arry addObject:menu];
                                }
                                
                            }
                            else if ([menu.actName isEqualToString:NSLocalizedString(@"附加费", nil)])
                            {
                                if ([data.code isEqualToString:PAD_FEE_PLAN]) {
                                    [arry addObject:menu];
                                }
  
                            }
                            else if ([menu.actName isEqualToString:NSLocalizedString(@"打折方案", nil)])
                            {
                                if ([data.code isEqualToString:PAD_DISCOUNT_PLAN]) {
                                    [arry addObject:menu];
                                }
                            }
                            else if ([menu.actName isEqualToString:NSLocalizedString(@"库存", nil)])
                            {
                                if ([data.code isEqualToString:PAD_STOCK]||[data.code isEqualToString:SUPPLY_STOCK]||[data.code isEqualToString:SUPPLY_CHANGE]||[data.code isEqualToString:SUPPLY_STORE]||[data.code isEqualToString:SUPPLY_WAREHOUSE]) {
                                    [arry addObject:menu];
                                }
                            }
                            else if ([menu.actName isEqualToString:NSLocalizedString(@"物流", nil)])
                            {
                                if ([data.code isEqualToString: PAD_LOGISTIC]||[data.code isEqualToString: SUPPLY_IN]||[data.code isEqualToString:SUPPLY_OUT]||[data.code isEqualToString: SUPPLY_GET]||[data.code isEqualToString:SUPPLY_SUPPLIER]) {
                                    [arry addObject:menu];
                                }

                            }
                            else if ([menu.actName isEqualToString:str]  ) {
                                     [arry addObject:menu];
                                             }
                             //剔除重复数据
                             arry1 =[self removesameiteaminarry:arry];
                        }
                        
                    }
                    if (data.isHide==0) {
                        for ( NSInteger i=0 ;i <categoryArr.count;i++ ) {
                            QuickStep *menu = categoryArr[i];
                            if ([menu.actName isEqualToString:NSLocalizedString(@"营业数据清理", nil)])
                            {
                                if ([data.code isEqualToString:PAD_DATA_CLEAR]) {
                                    [arry addObject:menu];
                                    
                                }
                            }
                            else if ([menu.actName isEqualToString:NSLocalizedString(@"传菜", nil)])
                            {
                                if ([data.code isEqualToString:PAD_PRODUCE_PLAN]) {
                                    [arry addObject:menu];
                                    
                                }
                                
                            }
                            
                            if ([menu.actName isEqualToString:NSLocalizedString(@"二维火供应链", nil)])
                            {
                                //                                if ([data.code isEqualToString:PAD_DATA_CLEAR]) {
                                [arry addObject:menu];
                                
                                //                                }
                            }
                            
                            else if ([menu.actName isEqualToString:NSLocalizedString(@"我要贷款", nil)])
                            {
                                [arry addObject:menu];
                            }
                            
                            
                            else if ([menu.actName isEqualToString:NSLocalizedString(@"营业班次", nil)])
                            {
                                if ([data.code isEqualToString:PAD_TIME_ARRANGE]) {
                                    [arry addObject:menu];
                                }
                            }
                            else if ([menu.actName isEqualToString:NSLocalizedString(@"特殊操作原因", nil)])
                            {
                                if ([data.code isEqualToString:PAD_SPECIAL_OPERATE]) {
                                    [arry addObject:menu];
                                }

                            }
                            else if ([menu.actName isEqualToString:NSLocalizedString(@"打折方案", nil)])
                            {
                                if ([data.code isEqualToString:PAD_DISCOUNT_PLAN]) {
                                    [arry addObject:menu];
                                }
                            }
                            else if ([menu.actName isEqualToString:NSLocalizedString(@"附加费", nil)])
                            {
                                if ([data.code isEqualToString:PAD_FEE_PLAN]) {
                                    [arry addObject:menu];
                                }
                                
                            }

                          else  if ([menu.actName isEqualToString:str]  ) {
                                [arry addObject:menu];
                               
                            }
                            //剔除重复数据
                            arry1 =[self removesameiteaminarry:arry];
                        }
                        
                    }
                }
                else if([userhied isEqualToString:@"0"])
                {
                    
                    for ( NSInteger i=0 ;i <categoryArr.count;i++ ) {
                        QuickStep *menu = categoryArr[i];
                        
                        if ([menu.actName isEqualToString:NSLocalizedString(@"营业数据清理", nil)])
                        {
                            if ([data.code isEqualToString:PAD_DATA_CLEAR]) {
                                [arry addObject:menu];
                            }
                        }
                        
                        if ([menu.actName isEqualToString:NSLocalizedString(@"二维火供应链", nil)])
                        {
                            //                                if ([data.code isEqualToString:PAD_DATA_CLEAR]) {
                            [arry addObject:menu];
                            
                            //                                }
                        }
                        
                       else if ([menu.actName isEqualToString:NSLocalizedString(@"我要贷款", nil)])
                        {
                            [arry addObject:menu];
                        }
                        
                        else if ([menu.actName isEqualToString:NSLocalizedString(@"传菜", nil)])
                        {
                            if ([data.code isEqualToString:PAD_PRODUCE_PLAN]) {
                                [arry addObject:menu];
                                
                            }
                            
                        }
                        else if ([menu.actName isEqualToString:NSLocalizedString(@"营业班次", nil)])
                        {
                            if ([data.code isEqualToString:PAD_TIME_ARRANGE]) {
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.actName isEqualToString:NSLocalizedString(@"特殊操作原因", nil)])
                        {
                            if ([data.code isEqualToString:PAD_SPECIAL_OPERATE]) {
                                [arry addObject:menu];
                            }
                            
                        }
                        else if ([menu.actName isEqualToString:NSLocalizedString(@"附加费", nil)])
                        {
                            if ([data.code isEqualToString:PAD_FEE_PLAN]) {
                                [arry addObject:menu];
                            }
                            
                        }
                        else if ([menu.actName isEqualToString:NSLocalizedString(@"打折方案", nil)])
                        {
                            if ([data.code isEqualToString:PAD_DISCOUNT_PLAN]) {
                                [arry addObject:menu];
                            }
                        }
                       else if ([menu.actName isEqualToString:str]  ) {
                            [arry addObject:menu];
                        }
                        //剔除重复数据
                        arry1 =[self removesameiteaminarry:arry];
                    }
                    
                }
                
                
            }
        }
    }
    //排序
    NSMutableArray *sortArry =[[NSMutableArray alloc]init];
    for (NSInteger i=0; i<category.count; i++) {
        NSString *menu1 =category[i];
        for (QuickStep *obj in arry1) {
            if ([menu1 isEqualToString:obj.actName]) {
                [sortArry addObject:obj];
            }
        }
    }
       return sortArry;
}


- (IBAction)btnShowMainClick:(id)sender
{
  
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_MAIN_SHOW_NOTIFICATION object:nil];
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arry =[steps objectAtIndex:section];
    return  arry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 40+NAVIGATE_MENU_CELL_HEIGHT;
    }
    return NAVIGATE_MENU_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arry =[steps objectAtIndex:indexPath.section];
    if (arry.count> 0 && arry !=nil) {
        NSDictionary *imgdic =[dataArr objectAtIndex:indexPath.section];
        QuickStep*step =[arry objectAtIndex:indexPath.row];
        
        if (!indexPath.row ==0) {
            NavigateMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:NavigateMenuCellIndentifier];
            
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"NavigateMenuCell" owner:self options:nil].lastObject;
            }
            
             cell.selectionStyle=  UITableViewCellSelectionStyleNone;
            [cell loadData:step];
            NSString *imgstr =[NSString stringWithFormat:@"%@",[imgdic objectForKey:step.actName]];
           [cell loadImageData:imgstr];
            cell.backgroundColor =[UIColor clearColor];
            return cell;
        }
        else
        {
            NavigateMenuFristCell *cell = [tableView dequeueReusableCellWithIdentifier:NavigateMenuFristCellIndentifier];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"NavigateMenuFristCell" owner:self options:nil].lastObject;
            }
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            [cell loadData:step];
            NSString *imgstr =[NSString stringWithFormat:@"%@",[imgdic objectForKey:step.actName]];
            [cell loadImageData:imgstr];
            NSString *str =[self.titilArr objectAtIndex:indexPath.section];
            [cell loadtablbl:str];
            cell.backgroundColor =[UIColor clearColor];
            return cell;
            
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    QuickStep *step =[[steps objectAtIndex:indexPath.section] objectAtIndex:row];
    if([step.actCode isEqualToString:PAD_SUPPLY_SHOP]){
        NSURL *url = [NSURL URLWithString:@"TDFSupplyChainApp://"];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }else{
            
            BOOL showRestApp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kTDFShowRestApp"] boolValue];
            
            if (!showRestApp) return;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请安装'二维火供应链'", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"下载", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/er-wei-huo-gong-ying-lian/id1124011735?l=zh&ls=1&mt=8"];
                
                [[UIApplication sharedApplication] openURL:url];
            }];
            
            [alertController addAction:confirmAction];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:cancelAction];
            
            UIViewController *viewController = [[UIApplication sharedApplication].delegate window].rootViewController;
            
            [viewController presentViewController:alertController animated:YES completion:nil];
        }

        return;
    }
    [self onMenuSelectHandle:step.actCode name:step.actName];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.titilArr.count;
    
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  0;
    
}
- (void)onMenuSelectHandle:(NSString*)code name:(NSString*)name
{
    if ([[Platform Instance] isNetworkOk]) {
        if ([[Platform Instance] lockAct:code]) {
            [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),name]];
            return;
        }

        if ([code isEqualToString:PAD_SHOPINFO] ) {  //店家信息
//            [self showSetting:code name:name];
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_shopBaseViewController];
            [self.rootController pushViewController:viewController animated:YES];
            return;
        } else if ([code isEqualToString:PAD_SETTING]) {  //系统参数
//            [self showSetting:code name:name];
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_sysParaEditViewController];
            [self.rootController pushViewController:viewController animated:YES];
            return;
        } else if ([code isEqualToString:PAD_OPEN_TIME]) {  //营业结束时间
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_openTimePlanViewController];
            [self.rootController pushViewController:viewController animated:YES];
            return;
        } else if ([code isEqualToString:PAD_TIME_ARRANGE]) {  //营业班次
//            [self showSetting:code name:name];
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_TimeArrangeListViewController];
            [self.rootController pushViewController:viewController animated:YES];
            return;
        } else if ([code isEqualToString:PAD_ZM_SMS]) {  //短信联系人
            [self showSetting:code name:name];
        } else if ([code isEqualToString:PAD_BASE_SETTING]) {  //基础设置
            [self showKabaw:code name:name];
        }  else if ([code isEqualToString:PAD_KIND_PAY]) {  //付款方式
            [self showSetting:code name:name];
        } else if ([code isEqualToString:PAD_SIGN_PERSON]) {  //挂账设置
//            [self showSetting:code name:name];
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_SignBillListView];
            [self.rootController pushViewController:viewController animated:YES];
        } else if ([code isEqualToString:PAD_ZERO_PARA]){ //零头处理方式
//            [self showSetting:code name:name];
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_ZeroListViewController];
            [self.rootController pushViewController:viewController animated:YES];
            return;
        } else if ([code isEqualToString:PAD_CASH_OUTPUT]) {  //收银打印
            //[self showSetting:code name:name];
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_PrinterParasEditViewController];
            [self.rootController pushViewController:viewController animated:YES];
            return;
        } else if ([code isEqualToString:PAD_BILL_TEMPLATE]){ //打印单据模板
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_ShopTemplateListView];
            [self.rootController pushViewController:viewController animated:YES];
        } else if ([code isEqualToString:PAD_TABLE_ITEM]) {  //客单备注
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_CustomerListView];
            [self.rootController pushViewController:viewController animated:YES];        } else if ([code isEqualToString:PAD_SPECIAL_OPERATE]) {  //特殊操作原因
                UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_SpecialReasonListView];
                [self.rootController pushViewController:viewController animated:YES];
        } else if ([code isEqualToString:PAD_FEE_PLAN]) {  //附加费
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_FeePlanListView];
            [self.rootController pushViewController:viewController animated:YES];
        } else if ([code isEqualToString:PAD_DISCOUNT_PLAN]) {  //打折方案
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_DiscountPlanListView];
//            [mainModule.appController.navigationController pushViewController:viewController animated:YES];
        } else if ([code isEqualToString:PAD_MENU]) {  //商品
//            [mainModule hideView];
//            [mainModule loadMenuModule];
            UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_menuListViewController];
            [self.rootController pushViewController:viewController animated:YES];
            
        } else if ([code isEqualToString:PAD_SUIT_MENU]) {  //套餐
            [mainModule hideView];
            [mainModule loadSuitMenuModule];
        } else if ([code isEqualToString:PAD_MENU_TIME]) {  //促销商品
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_MenuTimeListView];
            [mainModule.rootController.navigationController pushViewController:viewController animated:YES];
        } else if ([code isEqualToString:PAD_ACCOUNT_OPERATION]) {  //账单优化
            [mainModule hideView];
            [mainModule loadBillModifyModule];
        } else if ([code isEqualToString:MARKET_EMENU_STYLE]) {  //电子菜谱排版
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_KindMenuStyleListView];
            [self.rootController pushViewController:viewController animated:YES];
        } else if ([code isEqualToString:PAD_EMPLOYEE]) {  //员工
            
            TDFMediator *mediator = [[TDFMediator alloc] init];
            UIViewController *employeeListContoller = [mediator TDFMediator_employeeListViewController];
            [self.rootController pushViewController:employeeListContoller animated:YES];
            
        } else if ([code isEqualToString:PAD_SEAT]) {  //桌位
            TDFMediator *mediator = [[TDFMediator alloc] init];
            UIViewController *employeeListContoller = [mediator TDFMediator_SeatListView];
            [self.rootController pushViewController:employeeListContoller animated:YES];
        } else if ([code isEqualToString:PAD_MARKET]) {  //营销
            [mainModule hideView];
            [mainModule loadMarketModule];
        } else if ([code isEqualToString:PAD_CARD_SHOPINFO]) {  //我的微店（第9步）
            [self showKabaw:code name:name];
        } else if ([code isEqualToString:PAD_SHOP_QRCODE]) {  //微店营销
            [self showKabaw:code name:name];
        } else if ([code isEqualToString:PAD_RESERVER_MENU]) {  //卡包菜单
            [self showKabaw:code name:name];
        } else if ([code isEqualToString:PAD_RESERVE_SETTING]) {  //预订设置
            [self showKabaw:code name:name];
        } else if ([code isEqualToString:PAD_TAKEOUT_SETTING]) {  //外卖设置
            [self showKabaw:code name:name];
        }
        else if ([code isEqualToString:PAD_CANCEL_BIND]) {  //更换服务器
            [self showSetting:code name:name];
        } else if ([code isEqualToString:PAD_CHANGE_QUEUE]) {  //更换排队机
//            TDFMediator *mediator = [[TDFMediator alloc]init];
//            UIViewController *cancelQueuviewController = [mediator TDFMediator_CancelQueuViewController];
//            [mainModule.appController.navigationController pushViewController:cancelQueuviewController animated:YES];
            UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_shopScreenAdViewController];
            [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:vc animated:YES];
            
            return;
        } else if ([code isEqualToString:PAD_DATA_CLEAR]) {  //数据清理
//                    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_DataClearViewController];
//              [mainModule.appController.navigationController pushViewController:viewController animated:YES];
//            return;
            
            UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_callVoiceSettingViewController];
            [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:vc animated:YES];
            
            return;
        } else if ([code isEqualToString:PHONE_SCREEN_ADVERTISEMENT]) {  //店内屏幕广告
            UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_shopScreenAdViewController];
            [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:vc animated:YES];
            
            return;
        } else if ([code isEqualToString:PHONE_VOICE_SET]) {  //叫号语音设置
            UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_callVoiceSettingViewController];
            [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:vc animated:YES];
            
            return;
        } else if ([code isEqualToString:PAD_SMS_MARKET]) {  //短信营销
            [self showMarket:code name:name];
        } else if ([code isEqualToString:PAD_RED_PACKETS]) { //红包
            [self showMarket:code name:name];
        } else if ([code isEqualToString:PAD_ISSUE_INFO]) {  //火小二生活圈
            [self showMarket:code name:name];
        } else if ([code isEqualToString:PAD_PAYMENT]) {     //微信支付
            [self showPayment];
        } else if ([code isEqualToString:PAD_EVALUATE]) {     //顾客评价
            [self showEvaluate];
        } else if ([code isEqualToString:PAD_QUEUE_SEAT]) {  //桌位排队类型
            [self showKabaw:code name:name];
        } else if ([code isEqualToString:PAD_BLACK_LIST]) {  //黑名单
            [self showKabaw:code name:name];
        } else if ([code isEqualToString:PHONE_MENU_PICTURE_PAGE]) { // 商品页首页尾
            [self showKabaw:code name:name];
        } else if ([code isEqualToString:PHONE_CHANGE_SKIN]) { // 个性化换肤
            [self showKabaw:code name:name];
        } else if ([code isEqualToString:PAD_CONSUME_DETAIL]) { //会员消费记录
            [self showMember:code name:name];
        } else if ([code isEqualToString:PAD_MAKE_CARD]) { //会员发电子卡
            [self showMember:code name:name];
        } else if ([code isEqualToString:PAD_KIND_CARD]) { //卡类型设置
           [self showMember:code name:name];
        } else if ([code isEqualToString:PAD_CHARGE_DISCOUNT]) { //充值优惠设置
             [self showMember:code name:name];
        } else if ([code isEqualToString:PAD_DEGREE_EXCHANGE]) { //积分兑换设置
            [self showMember:code name:name];
        }else if ([code isEqualToString:PAD_LOAN_SET]) { //我要贷款
            TDFMediator *mediator = [[TDFMediator alloc] init];
            UIViewController *loanListContoller = [mediator TDFMediator_loanListViewController];
            [self.rootController pushViewController:loanListContoller animated:YES];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_HIDDEN_NOTIFICATION object:nil];
        isnavigatemenupush =YES;
    }
}

-(void) showKabaw:(NSString*)code name:(NSString*)name
{
    [mainModule hideView];
    [mainModule loadKabawModule];
    mainModule.kabawModule.view.hidden=NO;
    [mainModule.kabawModule showActionCode:code];
}

- (void)showSetting:(NSString*)code name:(NSString *)name
{
    [mainModule hideView];
    [mainModule loadSettingModule];
    mainModule.settingModule.view.hidden=NO;
    [mainModule.settingModule showActionCode:code];
}

- (void)showMember:(NSString*)code name:(NSString *)name
{
//    [mainModule hideView];
//    [mainModule loadMemberModule];
//    mainModule.memberModule.view.hidden=NO;
//    [mainModule.memberModule showActionCode:code];
}

- (void)showHelpVideo
{
    [mainModule hideView];
//    [mainModule.navigateBtn setHidden:NO];
    [mainModule loadSettingModule];
    mainModule.settingModule.view.hidden=NO;
//    [mainModule.settingModule showHelpVideoView];
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_HIDDEN_NOTIFICATION object:nil];
}

- (void)showPayment
{
    [mainModule hideView];
    [mainModule loadPaymentModule];
}

- (void)showEvaluate
{
//    [mainModule hideView];
//    [mainModule loadEvaluateModule];
}

- (void)showMarket:(NSString *)code name:(NSString *)name
{
    [mainModule hideView];
    [mainModule loadMarketModule];
     mainModule.marketModule.view.hidden = NO;
    [mainModule.marketModule showActionCode:code];
}

- (NSString *)convertStepName:(NSInteger)step
{
    NSArray *stepArr=[[NSArray alloc] initWithObjects:NSLocalizedString(@"一", nil),NSLocalizedString(@"二", nil),NSLocalizedString(@"三", nil),NSLocalizedString(@"四", nil),NSLocalizedString(@"五", nil),NSLocalizedString(@"六", nil),NSLocalizedString(@"七", nil),NSLocalizedString(@"八", nil),NSLocalizedString(@"九", nil),NSLocalizedString(@"十", nil),nil];
    if (step==10) {
        return NSLocalizedString(@"日常使用", nil);
    } else {
        NSString *name=[stepArr objectAtIndex:step];
        return [NSString stringWithFormat:NSLocalizedString(@"第%@步", nil), name];
    }
}

- (NSMutableArray*)createSteps
{
    NSMutableArray* list=[NSMutableArray array];
    QuickStep* step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"系统参数", nil);
    step.actCode=PAD_SETTING;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=1;
    step.stepNum=2;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=1;
    [list addObject:step];
    
    step =[[QuickStep alloc]init];
    step.actName=NSLocalizedString(@"店家信息", nil);
    step.actCode=PAD_SHOPINFO;
    step.actDetail=@"";
    step.isRequire=1;
    step.status=1;
    step.stepNum=1;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=1;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"营业结束时间", nil);
    step.actCode=PAD_OPEN_TIME;
    step.actDetail=@"";
    step.isRequire=1;
    step.status=1;
    step.stepNum=3;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=1;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"营业班次", nil);
    step.actCode=PAD_TIME_ARRANGE;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=4;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=1;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.actName=NSLocalizedString(@"付款方式", nil);
    step.actCode=PAD_KIND_PAY;
    step.actDetail=@"";
    step.isRequire=1;
    step.status=1;
    step.stepNum=1;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=2;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"挂账设置", nil);
    step.actCode=PAD_SIGN_PERSON;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=2;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=2;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"零头处理方式", nil);
    step.actCode=PAD_ZERO_PARA;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=1;
    step.stepNum=3;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=2;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.actName=NSLocalizedString(@"收银打印", nil);
    step.actCode=PAD_CASH_OUTPUT;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=1;
    step.stepNum=1;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=3;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"收银单据", nil);
    step.actCode=PAD_BILL_TEMPLATE;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=2;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=3;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.actName=NSLocalizedString(@"客单备注", nil);
    step.actCode=PAD_TABLE_ITEM;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=1;
    step.stepNum=1;
    step.isRest=YES;
    step.isFast=NO;
    step.isBar=YES;
    step.kind=4;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"特殊操作原因", nil);
    step.actCode=PAD_SPECIAL_OPERATE;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=2;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=4;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.actName=NSLocalizedString(@"附加费", nil);
    step.actCode=PAD_FEE_PLAN;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=1;
    step.isRest=YES;
    step.isFast=NO;
    step.isBar=YES;
    step.kind=5;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"打折方案", nil);
    step.actCode=PAD_DISCOUNT_PLAN;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=2;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=5;
    [list addObject:step];
    
//    step=[[QuickStep alloc]init];
//    step.actName=NSLocalizedString(@"商品", nil);
//    step.actCode=PAD_MENU;
//    step.actDetail=@"";
//    step.isRequire=1;
//    step.status=1;
//    step.stepNum=1;
//    step.isRest=YES;
//    step.isFast=YES;
//    step.isBar=YES;
//    step.kind=6;
//    [list addObject:step];
//    
//    step=[[QuickStep alloc]init];
//    step.stepName=@"";
//    step.actName=NSLocalizedString(@"套餐", nil);
//    step.actCode=PAD_SUIT_MENU;
//    step.actDetail=@"";
//    step.isRequire=0;
//    step.status=0;
//    step.stepNum=2;
//    step.isRest=YES;
//    step.isFast=YES;
//    step.isBar=YES;
//    step.kind=6;
//    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"商品促销", nil);
    step.actCode=PAD_MENU_TIME;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=3;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=6;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"传菜", nil);
    step.actCode=PAD_PRODUCE_PLAN;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=4;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=6;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"电子菜谱排版", nil);
    step.actCode=MARKET_EMENU_STYLE;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=5;
    step.isRest=YES;
    step.isFast=NO;
    step.isBar=YES;
    step.kind=6;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.actName=NSLocalizedString(@"员工", nil);
    step.actCode=PAD_EMPLOYEE;
    step.actDetail=@"";
    step.isRequire=1;
    step.status=0;
    step.stepNum=1;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=7;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=NSLocalizedString(@"第八步", nil);
    step.actName=NSLocalizedString(@"桌位", nil);
    step.actCode=PAD_SEAT;
    step.actDetail=@"";
    step.isRequire=1;
    step.status=0;
    step.stepNum=1;
    step.isRest=YES;
    step.isFast=NO;
    step.isBar=YES;
    step.kind=8;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.actName=NSLocalizedString(@"我的微店", nil);
    step.actCode=PAD_CARD_SHOPINFO;
    step.actDetail=@"";
    step.isRequire=1;
    step.status=0;
    step.stepNum=1;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=9;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"基础设置", nil);
    step.actCode=PAD_BASE_SETTING;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=1;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=9;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"微店营销", nil);
    step.actCode=PAD_SHOP_QRCODE;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=2;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=9;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"火小二菜单", nil);
    step.actCode=PAD_RESERVER_MENU;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=3;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=9;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"预订设置", nil);
    step.actCode=PAD_RESERVE_SETTING;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=4;
    step.isRest=YES;
    step.isFast=NO;
    step.isBar=YES;
    step.kind=9;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"外卖设置", nil);
    step.actCode=PAD_TAKEOUT_SETTING;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=5;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=9;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"排队桌位类型", nil);
    step.actCode=PAD_QUEUE_SEAT;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=6;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=9;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"黑名单", nil);
    step.actCode=PAD_BLACK_LIST;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=7;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=9;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=NSLocalizedString(@"第十步", nil);
    step.actName=NSLocalizedString(@"会员消费记录", nil);
    step.actCode=PAD_CONSUME_DETAIL;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=1;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=10;
    [list addObject:step];

    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"会员发电子卡", nil);
    step.actCode=PAD_MAKE_CARD;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=2;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=10;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"卡类型设置", nil);
    step.actCode=PAD_KIND_CARD;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=3;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=10;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"充值优惠设置", nil);
    step.actCode=PAD_CHARGE_DISCOUNT;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=7;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=10;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"积分兑换设置", nil);
    step.actCode=PAD_DEGREE_EXCHANGE;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=8;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=10;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=NSLocalizedString(@"日常使用", nil);
    
    if ([[[Platform Instance] getkey:IS_REFRESH] isEqualToString:@"0"] && [[[Platform Instance] getkey:USER_IS_SUPER] isEqualToString:@"1"]) {
        if ([[[Platform Instance] getkey:CITY_ID] isEqualToString:[NSString stringWithFormat:@"%d",HANGZHOUCITYID]] || [[[Platform Instance] getkey:@"loanStatus"] isEqualToString:@"1"]) {
            step.actName=NSLocalizedString(@"我要贷款", nil);
            step.actCode=PAD_LOAN_SET;
            step.actDetail=@"";
            step.isRequire=0;
            step.status=0;
            step.stepNum=1;
            step.isRest=YES;
            step.isFast=YES;
            step.isBar=YES;
            step.kind=11;
            [list addObject:step];
        }
    }
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"更换排队机", nil);
    step.actCode=PAD_CHANGE_QUEUE;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=2;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=11;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"营业数据清理", nil);
    step.actCode=PAD_DATA_CLEAR;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=3;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=11;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"账单优化", nil);
    step.actCode=PAD_ACCOUNT_OPERATION;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=4;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=11;
    [list addObject:step];
    
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"短信营销", nil);
    step.actCode=PAD_SMS_MARKET;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=5;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=11;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"红包", nil);
    step.actCode=PAD_RED_PACKETS;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=6;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=11;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"\"火小二\"生活圈", nil);
    step.actCode=PAD_ISSUE_INFO;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=7;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=11;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"二维火供应链", nil);
    step.actCode=PAD_SUPPLY_SHOP;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=8;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=10;
    [list addObject:step];
    
    step=[[QuickStep alloc]init];
    step.stepName=@"";
    step.actName=NSLocalizedString(@"店内屏幕广告", nil);
    step.actCode=PHONE_SCREEN_ADVERTISEMENT;
    step.actDetail=@"";
    step.isRequire=0;
    step.status=0;
    step.stepNum=8;
    step.isRest=YES;
    step.isFast=YES;
    step.isBar=YES;
    step.kind=10;
    [list addObject:step];
    
    
    return list;
}

@end
