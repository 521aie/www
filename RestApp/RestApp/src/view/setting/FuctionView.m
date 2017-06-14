//
//  FuctionViewController.m
//  RestApp
//
//  Created by iOS香肠 on 15/12/15.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "FuctionView.h"
#import "ServiceFactory.h"
#import "GlorenMenuModules.h"
#import "ShopInfoVO.h"
#import "ViewFactory.h"
#import "NSString+Estimate.h"
#import "DataSingleton.h"
#import "HeadNameItem.h"
#import "NSString+Estimate.h"
#import "FuctionPopView.h"
#import "UIMenuDetaiAction.h"
#import "FuctionActionData.h"
#import "ActionConstants.h"
#import "HomeView.h"
#import "XHAnimalUtil.h"
#import "YYModel.h"
#import <TDFDataCenterKit/TDFDataCenter.h>

@implementation FuctionView
@synthesize  delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SettingModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        service = [ServiceFactory Instance].settingService;
        billservice =[ServiceFactory Instance].billModifyService;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        self.weixinArr =[[NSMutableArray alloc]init];
        self.huiyuanArr =[[NSMutableArray alloc]init];
        self.weidianArr =[[NSMutableArray alloc]init];
        self.baobiaoArr =[[NSMutableArray alloc]init];
        self.pinjiaArr =[[NSMutableArray alloc]init];
        self.cleanArr =[[NSMutableArray alloc]init];
        self.kucunArr =[[NSMutableArray alloc]init];
        self.wuliuArr =[[NSMutableArray alloc]init];
        self.dictionary = [[NSMutableDictionary alloc]init];
        self.allStatusArry =[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ischange=NO;
    [self initNavigate];
    [self initMainGrid];
}

- (void)initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.view addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"功能大全", nil) backImg:Head_ICON_BACK moreImg:nil];
}

#pragma 设置tabview
- (void)initMainGrid
{
    self.ischange = NO;
    //表格初始.
    [self.mainGird setBackgroundView:nil];
    self.mainGird.backgroundColor = [UIColor clearColor];
    self.mainGird.opaque = NO;
    self.mainGird.tableFooterView = [ViewFactory generateFooter:36];
    self.mainGird.dataSource =self;
    self.mainGird.delegate = self;
    //如果想删除cell之间的分割线，设置
    self.mainGird.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initDataView:(NSMutableArray *)data
{
    [self.titleBox initWithName:NSLocalizedString(@"功能大全", nil) backImg:Head_ICON_BACK moreImg:nil];
    self.codeArr =[[NSMutableArray alloc]init];
    [self.dictionary removeAllObjects];
    [self.weixinArr removeAllObjects];
    [self.huiyuanArr removeAllObjects];
    [self.codeArr removeAllObjects];
    [self.weixinArr removeAllObjects];
    [self.huiyuanArr removeAllObjects];
    [self.weidianArr removeAllObjects];
    [self.baobiaoArr removeAllObjects];
    [self.pinjiaArr removeAllObjects];
    [self.cleanArr removeAllObjects];
    [self.kucunArr removeAllObjects];
    [self.wuliuArr removeAllObjects];
    [self.allStatusArry removeAllObjects];
    [self.dictionary removeAllObjects];
    self.codeArr = [data copy];
    for (FuctionActionData *menu in self.codeArr) {
        NSString *str =[NSString stringWithFormat:@"%@",menu.code];
        if ([str isEqualToString:PAD_WEIXIN_SUM]||[str isEqualToString:PAD_WEIXIN_DETAL]) {
            [self.weixinArr addObject:menu];
        }
        if ([str isEqualToString:PAD_CONSUME_DETAIL]||[str isEqualToString:PAD_MAKE_CARD]|| [str isEqualToString: PAD_KIND_CARD] ||[str isEqualToString: PAD_CHARGE_DISCOUNT]|| [str isEqualToString:PAD_DEGREE_EXCHANGE]) {
            [self.huiyuanArr addObject:menu];
        }
        if ([str isEqualToString:PAD_CARD_SHOPINFO]||[str isEqualToString: PAD_BASE_SETTING]|| [str isEqualToString:  PAD_SHOP_QRCODE]||[str isEqualToString:  PAD_RESERVE_SETTING]|| [str isEqualToString: PAD_TAKEOUT_SETTING] ||[str isEqualToString: PAD_QUEUE_SEAT]||[str isEqualToString: PAD_DEGREE_EXCHANGE]||[str isEqualToString:  PAD_BLACK_LIST] || [str isEqualToString: PHONE_CHANGE_SKIN] || [str isEqualToString: PHONE_MENU_PICTURE_PAGE]) {
            [self.weidianArr addObject:menu];
        }
        if ([str isEqualToString:MEMBER_REPORT]||[str isEqualToString: CARD_CONSUME_DETAIL_REPORT] ||[str isEqualToString:PAD_CARD_ACTIVATE_REPORT]||[str isEqualToString: PAD_DETAIL_CARD_REPORT] ||[str isEqualToString: CARD_DISCOUNT_DETAIL_REPORT]||[str isEqualToString:CARD_CHARGE_DETAIL_REPORT]||[str isEqualToString: CARD_DEGREE_DETAIL_REPORT]||[str isEqualToString: CARD_CHANGE_DETAIL_REPORT]||[str isEqualToString: CARD_CHANGE_COUNT_REPORT]) {
            [self.baobiaoArr addObject:menu ];
        }
        if ([str  isEqualToString:PAD_WHOLE_REVIEW]||[str isEqualToString: PAD_SHOP_REVIEW]||[str isEqualToString:  SHOP_WAITER_REVIEW]) {
            [self.pinjiaArr addObject:menu];
        }
        if ([str isEqualToString:PAD_DATA_CLEAR]) {
            [self.cleanArr addObject:menu];
        }
        if ([str isEqualToString:PHONE_SCREEN_ADVERTISEMENT]) {
            [self.cleanArr addObject:menu];
        }
        if ([str isEqualToString:PHONE_VOICE_SET]) {
            [self.cleanArr addObject:menu];
        }
        if ([str isEqualToString:PAD_STOCK]||[str isEqualToString:SUPPLY_STOCK]||[str isEqualToString:SUPPLY_CHANGE]||[str  isEqualToString:SUPPLY_STORE]||[str isEqualToString:SUPPLY_WAREHOUSE]) {
            [self.kucunArr addObject:menu];
        }
        if ([str isEqualToString: PAD_LOGISTIC]||[str isEqualToString: SUPPLY_IN]||[str isEqualToString:SUPPLY_OUT]||[str isEqualToString: SUPPLY_GET]||[str isEqualToString:SUPPLY_SUPPLIER]) {
            [self.wuliuArr addObject:menu];
        }
    }

    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    @weakify(self);
    [[TDFPaymentService new] getShopStatusWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [hud hide:YES];
        self.dataArr =[[NSMutableArray alloc]init];
        ShopStatusVo *shopStatusVO = [ShopStatusVo yy_modelWithDictionary:data[@"data"]];
//        NSMutableArray *arryH =[NSMutableArray array];
//        NSMutableArray *arry0 =[GlorenMenuModules listNavigateIteamDaily:shopStatusVO];
//        arryH =[self isShowAction:self.codeArr inarry:arry0];
//        [self.dataArr addObject:arryH];
        [self getBillData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [hud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
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
    self.Billindex =[NSString stringWithFormat:@"%@",map[@"data"]];
    [self prepareData];
    
    
}


-(void)onNavigateEvent:(NSInteger)event
{
    switch (event) {
        case 1:
        {
            if ([self.titleBox.lblLeft.text isEqualToString:NSLocalizedString(@"取消", nil)]) {
                [MessageBox show:NSLocalizedString(@"内容有变更尚未保存，确定要退出吗?", nil) btnName:NSLocalizedString(@"退出", nil) client:self];
                return;
                
            }else{
                if (isnavigatemenupush) {
                    isnavigatemenupush =NO;
                    [parent backNavigateMenuView];
                }
                [parent backMenu];
            }
        }
            break;
        case 2:
        {
            [self save];
        }
        default:
            break;
    }
}

- (void)confirm
{
    if (isnavigatemenupush) {
        isnavigatemenupush =NO;
        [parent backNavigateMenuView];
    }
    [parent backMenu];
}
- (void)cancel
{
    return;
}
-(void)getBillData
{
    [billservice queryBillModifyInfoWithtaskType:self callback:@selector(getshopData:)];
}
- (void)prepareData
{
    self.titleArr = [[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"日常运维(首页功能)", nil),NSLocalizedString(@"开店设置", nil),NSLocalizedString(@"收银设置", nil),NSLocalizedString(@"营业设置", nil)/*,NSLocalizedString(@"进销存设置", nil)*/,NSLocalizedString(@"其他工具", nil),nil];
    NSMutableArray *arryT = [NSMutableArray array];
    NSMutableArray*arry1 = [GlorenMenuModules listNavigateIteamShop];
    arryT =[self isShowAction:self.codeArr inarry:arry1];
    [self.dataArr addObject:arryT];
    NSMutableArray *arrF = [NSMutableArray array];
    NSMutableArray* arr3 = [GlorenMenuModules listNavigateIteamcashier];
    arrF =[self isShowAction:self.codeArr inarry:arr3];
    [self.dataArr addObject:arrF];
    NSMutableArray *arrS = [NSMutableArray array];
    NSMutableArray* arr2 = [GlorenMenuModules listNavigateIteamMenu];
    arrS =[self isShowAction:self.codeArr inarry:arr2];
    [self.dataArr addObject:arrS];
    NSMutableArray *arrL = [NSMutableArray array];
    NSMutableArray* arr5 = [GlorenMenuModules listNavigateIteamTool:self.Billindex.intValue];
    arrL =[self isShowAction:self.codeArr inarry:arr5];
    [self.dataArr addObject:arrL];
    
    [self.mainGird reloadData];
    
}

- (NSMutableArray *)isShowAction:(NSMutableArray *)actionArr inarry:(NSMutableArray *)allArr
{
    
    NSMutableArray *arry = [[NSMutableArray alloc]init];
    NSMutableArray *arry1 = [[NSMutableArray alloc]init];
    if (actionArr!=nil && actionArr.count>0) {
        for ( NSInteger i=0; i<allArr.count;i++ ) {
            UIMenuDetaiAction *menu = allArr[i];
            for (NSInteger i=0; i<actionArr.count; i++) {
                FuctionActionData *data = actionArr[i];
                NSString *str =[NSString stringWithFormat:@"%@",data.code];
                NSString *nameStr = [NSString stringWithFormat:@"%@",data.name];
                NSString *userhied = [NSString stringWithFormat:@"%d",data.isUserHide];
                //判断服务器否显示
                if (data.status==1) {
                    //判断是否用户设置过为空，标示没有设置
                    if ([userhied isEqualToString:@"3"]) {
                        if ([menu.name isEqualToString:NSLocalizedString(@"电子收款明细", nil)]) {
                            if ([str isEqualToString:PAD_WEIXIN_SUM] || [str isEqualToString:PAD_WEIXIN_DETAL]) {
                                if (data.isHide ==0 || data.isHide ==3) {
                                    menu.selectstatus=YES;
                                }
                                [arry addObject:menu];
                            }
                        } else if ([menu.name isEqualToString:NSLocalizedString(@"会员", nil)]) {
                            if ([str isEqualToString:PAD_CONSUME_DETAIL]||[str isEqualToString:PAD_MAKE_CARD]|| [str isEqualToString: PAD_KIND_CARD] ||[str isEqualToString: PAD_CHARGE_DISCOUNT]|| [str isEqualToString:PAD_DEGREE_EXCHANGE]) {
                                if (data.isHide ==0 ||data.isHide ==3) {
                                    menu.selectstatus=YES;
                                }
                                [arry addObject:menu];
                            }
                        } else if ([menu.name isEqualToString:NSLocalizedString(@"顾客端设置", nil)]) {
                            if ([str isEqualToString:PAD_CARD_SHOPINFO]||[str isEqualToString: PAD_BASE_SETTING]|| [str isEqualToString:  PAD_SHOP_QRCODE]||[str isEqualToString:  PAD_RESERVE_SETTING]|| [str isEqualToString: PAD_TAKEOUT_SETTING] ||[str isEqualToString: PAD_QUEUE_SEAT]||[str isEqualToString: PAD_DEGREE_EXCHANGE]||[str isEqualToString:  PAD_BLACK_LIST] || [str isEqualToString: PHONE_CHANGE_SKIN] || [str isEqualToString: PHONE_MENU_PICTURE_PAGE]) {
                                if (data.isHide ==0 ||data.isHide ==3) {
                                    menu.selectstatus=YES;
                                }
                                [arry addObject:menu];
                            }
                        } else if ([menu.name isEqualToString:NSLocalizedString(@"挂账处理", nil)]) {
                            if ([str isEqualToString:PAD_SIGN_BILL]) {
                                if (data.isHide ==0 ||data.isHide ==3) {
                                    menu.selectstatus =YES;
                                }
                                [arry addObject:menu];
                            }
                        } else if ([menu.name isEqualToString:NSLocalizedString(@"特殊操作原因", nil)]) {
                            if ([data.code isEqualToString:PAD_SPECIAL_OPERATE]) {
                                if (data.isHide ==0 ||data.isHide ==3) {
                                    menu.selectstatus =YES;
                                }
                                [arry addObject:menu];
                            }
                        } else if ([menu.name isEqualToString:NSLocalizedString(@"附加费", nil)]) {
                            if ([data.code isEqualToString:PAD_FEE_PLAN]) {
                                if (data.isHide ==0 ||data.isHide ==3) {
                                    menu.selectstatus =YES;
                                }
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"打折方案", nil)])
                        {
                            if ([data.code isEqualToString:PAD_DISCOUNT_PLAN]) {
                                if (data.isHide ==0 ||data.isHide ==3) {
                                    menu.selectstatus =YES;
                                }
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"库存", nil)])
                        {
                            if ([data.code isEqualToString:PAD_STOCK]||[data.code isEqualToString:SUPPLY_STOCK]||[data.code isEqualToString:SUPPLY_CHANGE]||[data.code isEqualToString:SUPPLY_STORE]||[data.code isEqualToString:SUPPLY_WAREHOUSE]) {
                                if (data.isHide ==0 ||data.isHide ==3) {
                                    menu.selectstatus =YES;
                                }
                                
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"物流", nil)])
                        {
                            if ([data.code isEqualToString: PAD_LOGISTIC]||[data.code isEqualToString: SUPPLY_IN]||[data.code isEqualToString:SUPPLY_OUT]||[data.code isEqualToString: SUPPLY_GET]||[data.code isEqualToString:SUPPLY_SUPPLIER]) {
                                if (data.isHide ==0 ||data.isHide ==3) {
                                    menu.selectstatus =YES;
                                }
                                
                                [arry addObject:menu];
                            }
                            
                        }
                        
                        else if ([menu.name isEqualToString:NSLocalizedString(@"营业班次", nil)])
                        {
                            if ([str isEqualToString:PAD_TIME_ARRANGE]) {
                                if (data.isHide ==0 ||data.isHide ==3) {
                                    menu.selectstatus =YES;
                                }
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"营业数据清理", nil)])
                        {
                            if ([str isEqualToString:PAD_DATA_CLEAR]) {
                                if (data.isHide ==0 ||data.isHide ==3) {
                                    menu.selectstatus=YES;
                                }
                                [arry addObject:menu];
                                
                            }
                            
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"店内屏幕广告", nil)])
                        {
                            if ([str isEqualToString:PHONE_SCREEN_ADVERTISEMENT]) {
                                if (data.isHide ==0 ||data.isHide ==3) {
                                    menu.selectstatus=YES;
                                }
                                [arry addObject:menu];
                                
                            }
                            
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"叫号语音设置", nil)])
                        {
                            if ([str isEqualToString:PHONE_VOICE_SET]) {
                                if (data.isHide ==0 ||data.isHide ==3) {
                                    menu.selectstatus=YES;
                                }
                                [arry addObject:menu];
                                
                            }
                            
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"顾客评价", nil)]){
                            if ([str  isEqualToString:PAD_WHOLE_REVIEW]||[str isEqualToString: PAD_SHOP_REVIEW]||[str isEqualToString:  SHOP_WAITER_REVIEW]) {
                                if (data.isHide==1) {
                                    menu.selectstatus=NO;
                                }
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"报表", nil)]){
                            if ([str isEqualToString:MEMBER_REPORT]||[str isEqualToString:CARD_CONSUME_DETAIL_REPORT] ||[str isEqualToString:PAD_CARD_ACTIVATE_REPORT]||[str isEqualToString: PAD_DETAIL_CARD_REPORT] ||[str isEqualToString: CARD_DISCOUNT_DETAIL_REPORT]||[str isEqualToString:CARD_CHARGE_DETAIL_REPORT]||[str isEqualToString: CARD_DEGREE_DETAIL_REPORT]||[str isEqualToString: CARD_CHANGE_DETAIL_REPORT]||[str isEqualToString: CARD_CHANGE_COUNT_REPORT]){
                                if (data.isHide ==0 ||data.isHide ==3) {
                                    menu.selectstatus=YES;
                                }
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"传菜", nil)]){
                            if ([str isEqualToString:PAD_PRODUCE_PLAN]) {
                                if (data.isHide==0 ||data.isHide==3) {
                                    menu.selectstatus=YES;
                                }
                                [arry addObject:menu];
                            }
                        }

                        else if ([menu.name isEqualToString:NSLocalizedString(@"开通口碑店", nil)]){
                            if ([str isEqualToString:PHONE_KOUBEI_SHOP]) {
                                if (data.isHide==0 ||data.isHide==3) {
                                    menu.selectstatus=YES;
                                }
                                [arry addObject:menu];
                            }

                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"商品与套餐", nil)]){
                            if ([str isEqualToString:PAD_MENU]) {
                                if (data.isHide==0 ||data.isHide==3) {
                                    menu.selectstatus=YES;
                                }
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:nameStr]  ) {
                            if (data.isHide ==0 ||data.isHide ==3) {
                                menu.selectstatus=YES;
                            }
                            [arry addObject:menu];
                        }
                        arry1 =[self removeSameIteamInArry:arry];
                    }
                    else if ([userhied isEqualToString:@"1"]){
                        if ([menu.name isEqualToString:NSLocalizedString(@"电子收款明细", nil)]) {
                            if ([str isEqualToString:PAD_WEIXIN_SUM] || [str isEqualToString:PAD_WEIXIN_DETAL]) {
                                menu.selectstatus =NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"会员", nil)])
                        {
                            if ([str isEqualToString:PAD_CONSUME_DETAIL]||[str isEqualToString:PAD_MAKE_CARD]|| [str isEqualToString: PAD_KIND_CARD] ||[str isEqualToString: PAD_CHARGE_DISCOUNT]||[str isEqualToString:PAD_DEGREE_EXCHANGE]) {
                                menu.selectstatus =NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"顾客端设置", nil)]){
                            if ([str isEqualToString:PAD_CARD_SHOPINFO]||[str isEqualToString: PAD_BASE_SETTING]|| [str isEqualToString:  PAD_SHOP_QRCODE]||[str isEqualToString:  PAD_RESERVE_SETTING]|| [str isEqualToString: PAD_TAKEOUT_SETTING] ||[str isEqualToString: PAD_QUEUE_SEAT]||[str isEqualToString: PAD_DEGREE_EXCHANGE]||[str isEqualToString:  PAD_BLACK_LIST] || [str isEqualToString: PHONE_CHANGE_SKIN] || [str isEqualToString: PHONE_MENU_PICTURE_PAGE]) {
                                menu.selectstatus =NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"挂账处理", nil)]){
                            if ([str isEqualToString:PAD_SIGN_BILL]) {
                                menu.selectstatus =NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"营业班次", nil)]){
                            if ([str isEqualToString:PAD_TIME_ARRANGE]) {
                                menu.selectstatus =NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"特殊操作原因", nil)]){
                            if ([data.code isEqualToString:PAD_SPECIAL_OPERATE]) {
                                menu.selectstatus =NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"附加费", nil)]){
                            if ([data.code isEqualToString:PAD_FEE_PLAN]) {
                                menu.selectstatus =NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"打折方案", nil)]){
                            if ([data.code isEqualToString:PAD_DISCOUNT_PLAN]) {
                                menu.selectstatus =NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"库存", nil)]){
                            if ([data.code isEqualToString:PAD_STOCK]||[data.code isEqualToString:SUPPLY_STOCK]||[data.code isEqualToString:SUPPLY_CHANGE]||[data.code isEqualToString:SUPPLY_STORE]||[data.code isEqualToString:SUPPLY_WAREHOUSE]) {
                                menu.selectstatus =NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"物流", nil)]){
                            if ([data.code isEqualToString: PAD_LOGISTIC]||[data.code isEqualToString: SUPPLY_IN]||[data.code isEqualToString:SUPPLY_OUT]||[data.code isEqualToString: SUPPLY_GET]||[data.code isEqualToString:SUPPLY_SUPPLIER]) {
                                menu.selectstatus =NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"顾客评价", nil)]){
                            if ([str  isEqualToString:PAD_WHOLE_REVIEW]||[str isEqualToString: PAD_SHOP_REVIEW]||[str isEqualToString:  SHOP_WAITER_REVIEW]) {
                                menu.selectstatus =NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"报表", nil)]){
                            if ([str isEqualToString:MEMBER_REPORT]||[str isEqualToString: CARD_CONSUME_DETAIL_REPORT] ||[str isEqualToString:PAD_CARD_ACTIVATE_REPORT]||[str isEqualToString: PAD_DETAIL_CARD_REPORT] ||[str isEqualToString: CARD_DISCOUNT_DETAIL_REPORT]||[str isEqualToString:CARD_CHARGE_DETAIL_REPORT]||[str isEqualToString: CARD_DEGREE_DETAIL_REPORT]||[str isEqualToString: CARD_CHANGE_DETAIL_REPORT]||[str isEqualToString: CARD_CHANGE_COUNT_REPORT]) {
                                menu.selectstatus =NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"营业数据清理", nil)]){
                            if ([str isEqualToString:PAD_DATA_CLEAR]) {
                                menu.selectstatus=NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"店内屏幕广告", nil)]){
                            if ([str isEqualToString:PHONE_SCREEN_ADVERTISEMENT]) {
                                menu.selectstatus=NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"叫号语音设置", nil)]){
                            if ([str isEqualToString:PHONE_VOICE_SET]) {
                                menu.selectstatus=NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"开通口碑店", nil)]){
                            if ([str isEqualToString:PHONE_KOUBEI_SHOP]) {
                                menu.selectstatus=NO;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"商品与套餐", nil)]){
                            if ([str isEqualToString:PAD_MENU]) {
                                menu.selectstatus=NO;
                                [arry addObject:menu];
                            }
                        }
                        else  if ([menu.name isEqualToString:nameStr]) {
                            menu.selectstatus =NO;
                            [arry addObject:menu];
                        }
                        arry1 =[self removeSameIteamInArry:arry];
                    }
                    else if([userhied isEqualToString:@"0"]){
                        if ([menu.name isEqualToString:NSLocalizedString(@"电子收款明细", nil)]) {
                            if ([str isEqualToString:PAD_WEIXIN_SUM] || [str isEqualToString:PAD_WEIXIN_DETAL]) {
                                menu.selectstatus =YES;
                                [arry addObject:menu];
                            }
                        }
                        
                        else if ([menu.name isEqualToString:NSLocalizedString(@"会员", nil)]){
                            if ([str isEqualToString:PAD_CONSUME_DETAIL]||[str isEqualToString:PAD_MAKE_CARD]|| [str isEqualToString: PAD_KIND_CARD] ||[str isEqualToString: PAD_CHARGE_DISCOUNT]|| [str isEqualToString:PAD_DEGREE_EXCHANGE]) {
                                menu.selectstatus =YES;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"顾客端设置", nil)]){
                            if ([str isEqualToString:PAD_CARD_SHOPINFO]||[str isEqualToString: PAD_BASE_SETTING]|| [str isEqualToString:  PAD_SHOP_QRCODE]||[str isEqualToString:  PAD_RESERVE_SETTING]|| [str isEqualToString: PAD_TAKEOUT_SETTING] ||[str isEqualToString: PAD_QUEUE_SEAT]||[str isEqualToString: PAD_DEGREE_EXCHANGE]||[str isEqualToString:  PAD_BLACK_LIST] || [str isEqualToString: PHONE_CHANGE_SKIN] || [str isEqualToString: PHONE_MENU_PICTURE_PAGE]) {
                                menu.selectstatus =YES;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"顾客评价", nil)]){
                            if ([str  isEqualToString:PAD_WHOLE_REVIEW]||[str isEqualToString: PAD_SHOP_REVIEW]||[str isEqualToString:  SHOP_WAITER_REVIEW]) {
                                menu.selectstatus =YES;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"报表", nil)]){
                            if ([str isEqualToString:MEMBER_REPORT]||[str isEqualToString: CARD_CONSUME_DETAIL_REPORT] ||[str isEqualToString:PAD_CARD_ACTIVATE_REPORT]||[str isEqualToString: PAD_DETAIL_CARD_REPORT] ||[str isEqualToString: CARD_DISCOUNT_DETAIL_REPORT]||[str isEqualToString:CARD_CHARGE_DETAIL_REPORT]||[str isEqualToString: CARD_DEGREE_DETAIL_REPORT]||[str isEqualToString: CARD_CHANGE_DETAIL_REPORT]||[str isEqualToString: CARD_CHANGE_COUNT_REPORT]) {
                                menu.selectstatus =YES;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"挂账处理", nil)]){
                            if ([str isEqualToString:PAD_SIGN_BILL]) {
                                menu.selectstatus =YES;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"营业班次", nil)]){
                            if ([str isEqualToString:PAD_TIME_ARRANGE]) {
                                menu.selectstatus =YES;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"特殊操作原因", nil)]){
                            if ([data.code isEqualToString:PAD_SPECIAL_OPERATE]) {
                                menu.selectstatus =YES;
                                [arry addObject:menu];
                            }
                            
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"附加费", nil)]){
                            if ([data.code isEqualToString:PAD_FEE_PLAN]) {
                                menu.selectstatus =YES;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"打折方案", nil)]){
                            if ([data.code isEqualToString:PAD_DISCOUNT_PLAN]) {
                                menu.selectstatus =YES;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"库存", nil)]){
                            if ([data.code isEqualToString:PAD_STOCK]||[data.code isEqualToString:SUPPLY_STOCK]||[data.code isEqualToString:SUPPLY_CHANGE]||[data.code isEqualToString:SUPPLY_STORE]||[data.code isEqualToString:SUPPLY_WAREHOUSE]) {
                                menu.selectstatus =YES;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"物流", nil)]){
                            if ([data.code isEqualToString: PAD_LOGISTIC]||[data.code isEqualToString: SUPPLY_IN]||[data.code isEqualToString:SUPPLY_OUT]||[data.code isEqualToString: SUPPLY_GET]||[data.code isEqualToString:SUPPLY_SUPPLIER]) {
                                menu.selectstatus =YES;
                                [arry addObject:menu];
                            }
                            
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"营业数据清理", nil)]){
                            if ([str isEqualToString:PAD_DATA_CLEAR]) {
                                menu.selectstatus=YES;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"店内屏幕广告", nil)]){
                            if ([str isEqualToString:PHONE_SCREEN_ADVERTISEMENT]) {
                                menu.selectstatus=YES;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"叫号语音设置", nil)]){
                            if ([str isEqualToString:PHONE_VOICE_SET]) {
                                menu.selectstatus=YES;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"开通口碑店", nil)]){
                            if ([str isEqualToString:PHONE_KOUBEI_SHOP]) {
                                menu.selectstatus=YES;
                                [arry addObject:menu];
                            }
                        }
                        else if ([menu.name isEqualToString:NSLocalizedString(@"商品与套餐", nil)]){
                            if ([str isEqualToString:PAD_MENU]) {
                                menu.selectstatus=YES;
                                [arry addObject:menu];
                            }
                        }
                        else if  ([menu.name isEqualToString:nameStr] ) {
                            menu.selectstatus =YES;
                            [arry addObject:menu];
                        }
                        arry1 =[self removeSameIteamInArry:arry];
                    }
                }
            }
        }
    }
    //排序
    NSMutableArray *sortArry = [[NSMutableArray alloc]init];
    for (NSInteger i=0; i<allArr.count;i++) {
        UIMenuDetaiAction *menu1 = allArr[i];
        for (UIMenuDetaiAction *obj in arry1) {
            if ([menu1.name isEqualToString:obj.name]) {
                [sortArry addObject:menu1];
            }
        }
    }
    //判断状态
    for (NSInteger i=0; i<sortArry.count; i++) {
        UIMenuDetaiAction *menu =sortArry[i];
        NSString *str =[NSString stringWithFormat:@"%d",menu.selectstatus];
        [self.dictionary setObject:str forKey:menu.name];
    }
    return sortArry;
}

- (NSMutableArray *)removeSameIteamInArry:(NSMutableArray *)arry
{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    for (NSInteger i=0 ;i<arry.count; i++) {
        UIMenuDetaiAction *menu =arry[i];
        
        [dic setObject:menu forKey:menu.code];
    }
    return [[dic allValues] mutableCopy];
}

#pragma tableview delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FuctionViewCell * cell = [tableView dequeueReusableCellWithIdentifier:FUCTIONVIEWCELL];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FuctionViewCell" owner:self options:nil].lastObject;
    }
    if ([ObjectUtil isNotEmpty:self.dataArr] && self.dataArr.count > indexPath.section) {
        NSMutableArray *menuItems =[self.dataArr objectAtIndex:indexPath.section];
        if (menuItems.count > indexPath.row && menuItems !=nil) {
            UIMenuDetaiAction * menuAction = [menuItems objectAtIndex:indexPath.row];
            
            cell.delegate =self;
            //赋值Id //避免重复赋值
            if ([ObjectUtil isEmpty:menuAction.idCollection]) {
                 [self  loaddata:menuAction Cell:cell];
            }
           
            [cell loadData:menuAction];
        }
    }
    cell.backgroundColor=[UIColor clearColor];
    return  cell;
}


- (void)loaddata:(UIMenuDetaiAction *)menuAction Cell:(FuctionViewCell *)cell
{
    if ([menuAction.name isEqualToString:NSLocalizedString(@"电子收款明细", nil)]) {
       [cell fullModelId:menuAction dataArry:self.weixinArr With:1];
    }
    else if ([menuAction.name isEqualToString:NSLocalizedString(@"顾客端设置", nil)])
    {
        [cell fullModelId:menuAction dataArry:self.weidianArr With:1];
    }
    else if ([menuAction.name isEqualToString:NSLocalizedString(@"营业数据清理", nil)])
    {
        [cell fullModelId:menuAction dataArry:self.cleanArr With:1];
    }
    else if ([menuAction.name isEqualToString:NSLocalizedString(@"报表", nil)])
    {
       [cell fullModelId:menuAction dataArry:self.baobiaoArr With:1];
    }
    else if ([menuAction.name isEqualToString:NSLocalizedString(@"物流", nil)])
    {
        [cell fullModelId:menuAction dataArry:self.wuliuArr With:1];
    }
    else if ([menuAction.name isEqualToString:NSLocalizedString(@"会员", nil)])
    {
        [cell fullModelId:menuAction dataArry:self.huiyuanArr With:1];
    }
    else if ([menuAction.name isEqualToString:NSLocalizedString(@"顾客评价", nil)])
    {
        [cell fullModelId:menuAction dataArry:self.pinjiaArr  With:1];
    }
    else if ([menuAction.name isEqualToString:NSLocalizedString(@"库存", nil)])
    {
        [cell fullModelId:menuAction dataArry:self.kucunArr  With:1];
    }
    else
    {
        [cell fullModelId:menuAction dataArry:self.codeArr With:0];
    }
}


- (IBAction)pophideview:(id)sender
{
    [self.hideView setHidden:YES];
}

- (IBAction)pophideviewS:(id)sender
{
    [self.hideView setHidden:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *menuItems = nil;
    if (self.dataArr.count > section) {
        menuItems=[self.dataArr objectAtIndex:section];
    }
    return  menuItems.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MAIN_MENU_ITEM_HEIGHT;
}

//cell的选中方法
-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag
{
    NSIndexPath *indexpatch =[self.mainGird indexPathForCell:cell];
    NSInteger indexsection =[indexpatch section];
    NSMutableArray *menuItems;
    if (indexpatch.section < self.dataArr.count) {
        menuItems =[self.dataArr objectAtIndex:indexpatch.section];
    }
    if (menuItems.count > 0 && menuItems !=nil)
    {
        UIMenuDetaiAction * menuAction = [menuItems objectAtIndex:indexpatch.row];
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[FuctionCustomAlertView class]]) {
                [view removeFromSuperview];
            }
        }
        NSString *str= [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstFuctionLancun"];
        BOOL isExist =[self isExist:str];
        FuctionCustomAlertView *tanchuView =[[FuctionCustomAlertView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4-20,self.view.frame.size.height-92, self.view.frame.size.width*3/4-40,30)];
        tanchuView.hidden=YES;
        [self.view addSubview:tanchuView];
        switch (flag) {
            case 0:
            {
                //只要选中状态改变才出现
                self.ischange=YES;
                if (menuAction.selectstatus) {
                    menuAction.selectstatus = NO;
                    if (isExist) {
                        [tanchuView initWithContent:[NSString  stringWithFormat:NSLocalizedString(@"保存后“%@”功能可从%@移除", nil),menuAction.name,[self getTitlewithsection:indexsection]]];
                        tanchuView.hidden=NO;
                        [self performSelector:@selector(AlertShow:) withObject:tanchuView afterDelay:2];
                    }
                }
                else
                {
                    menuAction.selectstatus = YES;
                    if (isExist) {
                        [tanchuView initWithContent:[NSString  stringWithFormat:NSLocalizedString(@"保存后“%@”功能可添加到%@", nil),menuAction.name,[self getTitlewithsection:indexsection]]];
                        self.seletTaintag=indexsection;
                        tanchuView.hidden=NO;
                        [self performSelector:@selector(AlertShow:) withObject:tanchuView afterDelay:2];
                    }
                }
                
                [self determineCurrentState];
                [self.mainGird reloadRowsAtIndexPaths:@[indexpatch] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
                break;
            case 1:
            {
                [self.hideView setHidden:NO];
                [self.popView loadDatawithMenuAction:menuAction section:indexsection];
                [self.popView.selectButton addTarget:self action:@selector(SelectCick:) forControlEvents:UIControlEventTouchUpInside];
                self.popView.selectButton.tag=indexpatch.row;
                self.seletTaintag =indexsection;
                CGFloat height =[self.popView totalheightwithdata:menuAction];
                CGRect popviewframe =self.popView.frame;
                popviewframe.size.height =height;
                self.popView.frame = popviewframe;
            }
            default:
                break;
        }
        
    }
    
}

- (void)determineCurrentState
{
    NSMutableDictionary *alldic =[[NSMutableDictionary alloc]init];
    NSArray *seletArry =[self.dictionary allValues];
    for (NSInteger i=0; i<self.dataArr.count;i++) {
        NSMutableArray *arry =self.dataArr[i];
        for (NSInteger i=0; i<arry.count; i++) {
            UIMenuDetaiAction *menu =arry[i];
            NSString *str =[NSString stringWithFormat:@"%d",menu.selectstatus];
            [alldic setObject:str forKey:menu.name];
            
        }
    }
    NSArray *oldarry =[alldic allValues];
    for (NSInteger i=0;i<oldarry.count ;i++) {
        NSString *str1 =oldarry[i];
        if ([ObjectUtil isNotEmpty:seletArry]) {
            NSString *str =[NSString stringWithFormat:@"%@",seletArry[i]];
            if ([str isEqualToString:str1]) {
                [self.titleBox initWithName:NSLocalizedString(@"功能大全", nil) backImg:Head_ICON_BACK moreImg:nil];
            }
            else
            {
                [self.titleBox initWithName:NSLocalizedString(@"功能大全", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
                break;
            }
        }
    }
}
-(void)SelectCick:(UIButton *)sender
{
    NSMutableArray *menuItems =[self.dataArr objectAtIndex:self.seletTaintag];
    self.ischange=YES;
    if (menuItems.count > 0 && menuItems !=nil) {
        UIMenuDetaiAction * menuAction = [menuItems objectAtIndex:sender.tag];
        if (menuAction.selectstatus) {
            menuAction.selectstatus=NO;
            self.popView.imgPic.image =[UIImage imageNamed:@"ico_uncheck.png"];
            if (self.seletTaintag==0) {
                self.popView.showlbl.text =[NSString stringWithFormat:@"%@",NSLocalizedString(@"此功能在首页隐藏", nil)];
            } else {
                self.popView.showlbl.text =[NSString stringWithFormat:@"%@",NSLocalizedString(@"此功能在左侧栏隐藏", nil)];
            }
        } else {
            menuAction.selectstatus=YES;
            self.popView.imgPic.image =[UIImage imageNamed:@"ico_check.png"];
            if (self.seletTaintag==0) {
                self.popView.showlbl.text =[NSString stringWithFormat:@"%@",NSLocalizedString(@"此功能在首页显示", nil)];
                
            } else {
                self.popView.showlbl.text =[NSString stringWithFormat:@"%@",NSLocalizedString(@"此功能在左侧栏显示", nil)];
            }
        }
        
        [self determineCurrentState];
    }
    
    [self.mainGird reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadNameItem *headNameItem = [[HeadNameItem alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];

    [headNameItem initWithName:self.titleArr[section]];
    return headNameItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataArr.count > section) {
        NSMutableArray *arry =[self.dataArr objectAtIndex:section];
        if (arry.count >0 && arry !=nil ) {
            return 40;
        }
        return  0;
    }
    return 0;
 }

-(void)AlertShow:( FuctionCustomAlertView*)view
{
    [view removeFromSuperview];
    
}

- (NSString *)getTitlewithsection:(NSInteger)section
{
    if (section ==0) {
        NSString *str =NSLocalizedString(@"首页", nil);
        return str;
    }
    else
    {
        NSString *str =NSLocalizedString(@"左侧设置栏", nil);
        return str;
    }
}

- (void)save
{
    if (self.ischange) {
        self.ischange=NO;
    }
    NSString *str= [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstFuctionLancun"];
    BOOL isExist =[self isExist:str];
    if (isExist) {
        [[NSUserDefaults standardUserDefaults]setObject:@"111" forKey:@"FirstFuctionLancun"];
    }
//    NSString *isShowIds=[self transModewithtag:1];
//    NSString *isHideIds=[self transModewithtag:0];
    [self transModelString];
    [UIHelper showHUD:NSLocalizedString(@"正在保存", nil) andView:self.view  andHUD:hud];
    [service saveisShowIds:self.isShowId isHideIds:self.isHideId Target:self Callback:@selector(getAction:)];
}

- (void)transModelString
{
   
    NSMutableArray *selectArry = [[NSMutableArray alloc] init];
    NSMutableArray *unSelectArry = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<self.dataArr.count; i++) {
         NSMutableArray *arry =self.dataArr[i];
        for (UIMenuDetaiAction *menuAction in arry) {
            if (menuAction.selectstatus) {
                [selectArry addObjectsFromArray:menuAction.idCollection];
                
            }
            else
            {
                [unSelectArry addObjectsFromArray:menuAction.idCollection];
            }
        }
    }
    if ([ObjectUtil isNotEmpty:selectArry]) {
        self.isShowId =[ObjectUtil array2String:selectArry];
    }
    else
    {
        self.isShowId =@"";
    }
    if ([ObjectUtil isNotEmpty:unSelectArry]) {
        self.isHideId =[ObjectUtil array2String:unSelectArry];
    }
    else
    {
        self.isHideId =@"";
    }
    NSLog(@"show:%@",self.isShowId);
    NSLog(@"hide:%@",self.isHideId);
    
}




- (void)getAction:(RemoteResult *)result
{
    [hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self parseUser:result.content];
}

-(void)parseUser:(NSString *)result
{
    [[TDFDataCenter sharedInstance].allCodeItemArray removeAllObjects];
    [service allActionListTarget:self Callback:@selector(allbtn:)];
}

- (void)allbtn:(RemoteResult *)result
{
    [hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self parseallrequest:result.content];
}

- (void)parseallrequest:(NSString *)result
{
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:IsfirstLoadbusiness];
    [TDFDataCenter sharedInstance].allCodeItemArray =[[NSMutableArray alloc]init];
    NSDictionary *map = [JsonHelper transMap:result];
    NSArray *arry =[map objectForKey:@"sampleActions"];
    for (NSDictionary *dic in arry) {
        FuctionActionData *data =[[FuctionActionData alloc]init];
        data.code =[NSString stringWithFormat:@"%@",dic[@"code"]];
        data.id =[NSString stringWithFormat:@"%@",dic[@"id"]];
        data.name =[NSString stringWithFormat:@"%@",dic[@"name"]];
        data.status =[NSString stringWithFormat:@"%@",dic[@"status"]].intValue;
        NSString *str =[NSString stringWithFormat:@"%@",dic[@"isUserHide"]];
        NSString *strhide =[NSString stringWithFormat:@"%@",dic[@"isHide"]];
        if (![strhide isEqualToString:@"<null>"]) {
            data.isHide =[NSString stringWithFormat:@"%@",dic[@"isHide"]].intValue;
        }
        else
        {
            data.isHide =3;
        }
        if (![str isEqualToString:@"<null>"]) {
            data.isUserHide =[NSString stringWithFormat:@"%@",dic[@"isUserHide"]].intValue;
        }
        else
        {
            data.isUserHide =3;
        }
        [[TDFDataCenter sharedInstance].allCodeItemArray addObject:data];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ALL_CODE_ACTION object:[TDFDataCenter sharedInstance].allCodeItemArray] ;
    [parent backMenu];
    
}

- (BOOL)isExist:(NSString *)str
{
    if ([NSString isBlank:str]) {
        
        return YES;
    }
    return NO;
    
}

@end
