//
//  SuitMenuEditView.m
//  RestApp
//
//  Created by zxh on 14-8-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SuitMenuEditView.h"
#import "MenuModule.h"
#import "ServiceFactory.h"
#import "MBProgressHUD.h"
#import "FooterListView.h"
#import "NSString+Estimate.h"
#import "UIHelper.h"
#import "RemoteEvent.h"
#import "RemoteResult.h"
#import "TDFOptionPickerController.h"
#import "JSONKit.h"
#import "JsonHelper.h"
#import "SuitMenuSample.h"
#import "XHAnimalUtil.h"
#import "NavigateTitle2.h"
#import "MenuModuleEvent.h"
#import "UIView+Sizes.h"
#import "AlertBox.h"
#import "ZmTableCell.h"
#import "ItemEndNote.h"
#import "SuitMenuDetailTable.h"
#import "ItemTitle.h"
#import "EditItemList.h"
#import "MenuDetailEditView.h"
#import "EditItemRadio.h"
#import "TDFMenuService.h"
#import "YYModel.h"
#import "EditItemRadio2.h"
#import "EditItemText.h"
#import "SystemEvent.h"
#import "EventConstants.h"
#import "SuitMenuModuleEvent.h"
#import "MenuService.h"
#import "HelpDialog.h"
#import "TreeNodeUtils.h"
#import "SystemService.h"
#import "TreeNode.h"
#import "GlobalRender.h"
#import "FormatUtil.h"
#import "SuitUnitListView.h"
#import "SuitMenuDetail.h"
#import "SuitMenuChange.h"
#import "Platform.h"
#import "MenuRender.h"
#import "RestConstants.h"
#import "SortTableEditView.h"
#import "TreeBuilder.h"
#import "TDFMediator+SuitMenuModule.h"
#import "SuitMenuChangeEditView.h"
#import "SelectMenuListView.h"
#import "MenuCodeView.h"
#import "KabawModuleEvent.h"
#import "SettingService.h"
#import "TDFSuitMenuService.h"
#import "YYModel.h"
#import "UIView+Sizes.h"
#import "TDFMenuHitRuleVo.h"
#import "TDFSuitMenuService.h"
#import "TDFMenuService.h"
#import "TDFMenuService.h"
#import "TDFGoodsService.h"
#import "TDFLoginService.h"
#import "TDFMediator+MenuModule.h"
#import "TDFMediator+SmartModel.h"
#import "TDFChainMenuService.h"
#import "TDFChainService.h"
#import "TDFRootViewController+FooterButton.h"
@interface SuitMenuEditView () <UIScrollViewDelegate, SuitUnitListViewDelegate>
@property (nonatomic, strong)NSMutableArray *detailArray;
@property (nonatomic, copy) NSString *codeType;
@property (nonatomic, assign) CGPoint scrollViewLocation;
@property (nonatomic, strong) TDFMenuHitRuleVo * menuHitRule;
@property (nonatomic, strong) SuitMenuDetail *suitMenuDetail;
@property (nonatomic, assign) BOOL menuhit_version;
@property (assign, nonatomic)  BOOL  isCashierVersion;   //版本判断标识
@end

@interface SuitMenuEditView ()
@property (nonatomic, assign) BOOL chainDataManageable;
@end

@implementation SuitMenuEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        menuService = [ServiceFactory Instance].menuService;
        settingService = [ServiceFactory Instance].settingService;
        systemService = [ServiceFactory Instance].systemService;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    hud  = [[MBProgressHUD alloc] initWithView:self.view];
    self.scrollView.delegate = self;
    self.changed=NO;
    [self initNotifaction];
    [self initNavigate];
    
    [self initMainView];
    [self.footView initDelegate:self btnArrs:nil];
    
    self.footView.hidden = YES;
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    
    self.menuDetails = [[NSMutableArray alloc] init];
    self.suitMenuDetailList = [[NSMutableArray alloc] init];
    [self createDataSource];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}
#pragma mark -- UIScrollViewDelegate --

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        self.scrollViewLocation = scrollView.contentOffset;
    }
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"商品", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

- (void)createDataSource
{
    if ([ObjectUtil  isNotEmpty: self.sourceDic]) {
        id delegate  = self.sourceDic [@"delegate"];
        self.delegate  = delegate ;
        id  data  =  self.sourceDic [@"data"];
        id  treeNodes   = self.sourceDic [@"treeNodes"];
        self.chainDataManageable = [self.sourceDic[@"chainDataManageable"] boolValue];
        NSString *actionStr  =   [NSString stringWithFormat:@"%@",self.sourceDic [@"action"]];
        id detail  = self.sourceDic [@"detailArry"];
        if([@"1" isEqualToString:[[Platform Instance]getkey:IS_BRAND]]){
            self.isCashierVersion  = YES; //连锁不添加权限判断
            [self  loadData:data kindTrees:treeNodes action:actionStr.integerValue withDetailArray:detail];
        }else{
        [[[TDFLoginService alloc] init ] cashierVersionWithParams:@{@"cashier_version_key":@"cashVersion4N6"} sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull dataSource) {
            id obj = [dataSource objectForKey:@"data"];
            self.isCashierVersion = obj !=nil && [obj boolValue];
            [self  loadData:data kindTrees:treeNodes action:actionStr.integerValue withDetailArray:detail];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [AlertBox show:error.localizedDescription];
        }];
     }
    }
    
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
    } else if (event==DIRECT_RIGHT) {
        self.isContinue=NO;
        [self save];
    }
}

- (void)rightNavigationButtonAction:(id)sender
{
    self.isContinue=NO;
    [self save];
}

- (void)leftNavigationButtonAction:(id)sender
{

    [self alertChangedMessage: [UIHelper currChange:self.container]];
}

- (void)closeListEvent:(NSString *)event
{
}


- (void)initMainView
{
    self.baseTitle.lblName.text=NSLocalizedString(@"基本设置", nil);
    [self.lsKindName initLabel:NSLocalizedString(@"套餐分类", nil) withHit:nil isrequest:YES delegate:self];
    [self.txtName initLabel:NSLocalizedString(@"套餐名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtCode initLabel:NSLocalizedString(@"套餐编码", nil) withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.suitMenuCode initLabel:NSLocalizedString(@"菜肴二维码", nil) withHit:NSLocalizedString(@"注:您可下载并打印菜肴二维码，顾客扫码后可直接点菜。此方式多适用于明档餐厅。", nil) delegate:self];
    self.suitMenuCode.imgMore.image =[UIImage imageNamed:@"ico_next"];
    self.suitMenuCode.lblVal.text = @"";
    [self.lsPrice initLabel:NSLocalizedString(@"套餐单价(元)", nil) withHit:nil isrequest:YES delegate:self];

    [self.lsAccount initLabel:NSLocalizedString(@"结账单位", nil) withHit:nil delegate:self];
    [self.rdoIsRatio initLabel:NSLocalizedString(@"允许打折", nil) withHit:nil delegate:nil];
     [self.isRatioView initLabel:NSLocalizedString(@"允许打折", nil) withHit:nil];
    [self.allowCashierAmendPrice  initLabel:NSLocalizedString(@"允许收银员在收银时修改单价", nil) withHit:nil delegate:nil];
    [self.isBrandAllowCashierAmend  initLabel:NSLocalizedString(@"允许收银员在收银时修改单价", nil) withHit:nil];

    [self.rdoIsAuth initLabel:NSLocalizedString(@"退菜时需要权限验证", nil) withHit:nil delegate:nil];
      [self.isBackAuthView initLabel:NSLocalizedString(@"退菜时需要权限验证", nil) withHit:nil];
    [self.rdoIsSelf initLabel:NSLocalizedString(@"商品已上架", nil) withHit:nil delegate:self];
    [self.txtNote initHit:NSLocalizedString(@"提示:套餐内商品的做法或加料有加价时,会在套餐单价的基础上进行累加", nil)];
    
    self.titleKabaw.lblName.text=NSLocalizedString(@"顾客端套餐展示设置", nil);
    self.titleDetail.lblName.text=NSLocalizedString(@"套餐内商品", nil);

    self.titleAddDetail.lblName.text=NSLocalizedString(@"套餐内商品", nil);
    [self.rdoIsSelf.line setHidden:YES];
    NSArray *arr = [[NSArray alloc] initWithObjects:@"add", @"sort", nil];
    [self.titleDetail initDelegate:self event:0 btnArrs:arr];
    [self.detailGrid initDelegate:self event:SUITMENU_DEDTAIL_EVENT  addName:NSLocalizedString(@"添加此分组内商品", nil) itemMode:ITEM_MODE_DEL];
    
    self.titleValuation.lblName.text = NSLocalizedString(@"套餐内商品组合计价规则", nil);
    [self.titleValuation initDelegate:self event:5 btnArrs:nil];
    [self.valuationTable initDelegate:self event:SUITMENU_VALUATION_EVENT kindName:@"" addName:NSLocalizedString(@"添加商品组合计价规则", nil) itemMode:ITEM_MODE_EDIT isWaring:NO];
    self.valuationTip.text = NSLocalizedString(@"提示：请先添加套餐分组内商品，然后添加商品组合计价规则，此功能适用于套餐内同时点两份商品时有加价、减价或者第二份半价的情况。", nil);
    [self.valuationTip sizeToFit];
    [self.valuationTable.addImg setLeft:86];
    [self.valuationTable.lblName setLeft:111];
    [self.valuationTable loadData:nil detailCount:0];
    [self isShowMenuRuleList:NO];
    self.lsKindName.tag=SUITMENU_KIND;
    self.lsAccount.tag=SUITMENU_ACCOUNT;
    self.lsPrice.tag=SUITMENU_PRICE;
    self.suitMenuCode.tag = SUITMENU_CODE;
    [self.lsPrice setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
    self.lsPrice.tdf_delegate = self;
    [self.lsMemberPrice initLabel:NSLocalizedString(@"会员价(元)", nil) withHit:nil delegate:self];
    [self.lsLeastNum initLabel:NSLocalizedString(@"起点份数", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsAcridLevel initLabel:NSLocalizedString(@"辣椒指数图标", nil) withHit:nil signImg:@"ico_chilli.png" delegate:self];
    [self.lsApproveLevel initLabel:NSLocalizedString(@"店家推荐图标", nil) withHit:nil signImg:@"ico_approve.png" delegate:self];
    [self.lsCharacters initLabel:NSLocalizedString(@"商品特色标签", nil) withHit:nil delegate:self];
    [self.rdoIsReserve initLabel:NSLocalizedString(@"堂食可点此套餐", nil) withHit:nil delegate:self];
    [self.rdoIsTakeout initLabel:NSLocalizedString(@"外卖可点此套餐", nil) withHit:nil delegate:self];
    [self.txtMemo initLabel:NSLocalizedString(@"套餐介绍", nil) isrequest:NO delegate:self];
    [self.boxPic initLabel:NSLocalizedString(@"套餐图片", nil) delegate:self];
    [self.gusBuyGoodView initLabel:NSLocalizedString(@"顾客端可点此商品", nil) withHit:nil];
    [self.goodForOutView initLabel:NSLocalizedString(@"外卖时可点此商品", nil) withHit:nil];
    self.boxPic.model = ImageUrlCapture;
    [self.footView initDelegate:self btnArrs:nil];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.lsMemberPrice.tag=KABAWMENU_MEMBERPRICE;
    self.lsLeastNum.tag=KABAWMENU_LEASTNUM;
    self.lsAcridLevel.tag=KABAWMENU_ACRIDLEVEL;
    self.lsApproveLevel.tag=KABAWMENU_APPROVELEVEL;
    self.lsCharacters.tag=KABAWMENU_CHARACTER;
    
    self.rdoIsReserve.tag=KABAWMENU_ISRESERVE;
    self.rdoIsTakeout.tag=KABAWMENU_ISTAKEOUT;
    
    [self.lsMemberPrice setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
    [self.lsLeastNum setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeInteger hasSymbol:NO];
}

- (void)editItemListValueDidChanged:(EditItemList *)editItem{
    //      NSString *val = [NSString stringWithFormat:@"%.2f",editItem.currentVal.doubleValue];
    if (editItem.tag == 10000 || editItem.tag == 8) {
        NSArray *arr = [editItem.currentVal componentsSeparatedByString:@"."];
        NSString *str = [arr firstObject];
        
        if (arr.count >1) {
            if ([[arr lastObject] length] > 2) {
                NSString *str2 = [[arr lastObject] substringToIndex:2];
                [editItem changeData:[NSString stringWithFormat:@"%@.%@",str,str2] withVal:[NSString stringWithFormat:@"%@.%@",str,str2]];
            }else{
                [editItem changeData:editItem.currentVal withVal:editItem.currentVal];
            }
        }
        
    }
}

- (void)editItemListDidFinishEditing:(EditItemList *)editItem
{
    if (editItem.isChange || self.action == ACTION_CONSTANTS_ADD) {
        [self.titleBox initWithName:self.titleBox.lblTitle.text backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    }else{
        [self.titleBox initWithName:self.titleBox.lblTitle.text backImg:Head_ICON_BACK moreImg:nil];
    }
    
      NSString *val = editItem.currentVal;
     if (self.lsPrice == editItem) {
        [self.lsPrice changeData:val withVal:val];
        if (self.action == ACTION_CONSTANTS_ADD) {
            if (!self.isFristPrice) {
                [self.lsMemberPrice initData:val withVal:val];
            }
        }
        else
        {
            if ([self.oldMemberPrice isEqualToString: self.oldPrice] && [NSString isNotBlank:self.oldMemberPrice] && [NSString isNotBlank:self.oldPrice]) {
                if (!self.isFristPrice) {
                    [self.lsMemberPrice initData:val withVal:val];
                }
            }
            
        }
    }else if (self.lsMemberPrice == editItem)
    {
        [self.lsMemberPrice changeData:val withVal:val];
        self.isFristPrice =YES;
    }
}

-(void) sortEventForMenuMoudle:(NSString*)event menuMoudleMap:(NSMutableDictionary*)menuMoudleMap{
    
    if ([event isEqualToString:REMOTE_SUITMENUDETAIL_SORT]) {
        if (menuMoudleMap.allKeys.count == 0) {
            [self loadSuitDetails:self.suitMenuSample._id];
//            [parent showView:SUITMENU_EDIT_VIEW];
//            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
        }else{
            [self showProgressHudWithText:NSLocalizedString(@"正在排序", nil)];
            NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
            parma[@"sort_str"] = [menuMoudleMap yy_modelToJSONString];
            parma[@"suit_menu_id"] = self.suitMenuSample.id;
            @weakify(self);
            [[TDFSuitMenuService new] sortSuitMenuDetailsWithParam:parma suscess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                @strongify(self);
                [self.progressHud setHidden:YES];
                [self loadSuitDetails:self.suitMenuSample._id];
//                [parent showView:SUITMENU_EDIT_VIEW];
//                [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud setHidden:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
    }else if([event isEqualToString:REMOTE_SUITMENU_CHANGE_SORT]){
        if (menuMoudleMap.allKeys.count == 0) {
            [self loadSuitDetails:self.suitMenuSample._id];
//            [parent showView:SUITMENU_EDIT_VIEW];
//            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
        }else{
            [self showProgressHudWithText:NSLocalizedString(@"正在排序", nil) ];
            NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
            parma[@"suit_menu_detail_id"] = self.menuDetailId;
            parma[@"sort_str"] = [menuMoudleMap yy_modelToJSONString];
            @weakify(self);
            [[TDFSuitMenuService new] sortSuitMenuChangesWithParam:parma suscess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                @strongify(self);
                [self.progressHud setHidden:YES];
                [self loadSuitDetails:self.suitMenuSample._id];
//                [parent showView:SUITMENU_EDIT_VIEW];
//                [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud setHidden:YES];
                [AlertBox show:error.localizedDescription];
            }];

        }
    }
}

#pragma SuitMenuChange(套餐子菜)删除事件.
-(void) delObjEvent:(NSString *)event obj:(id)obj
{
    if ([event isEqualToString:SUITMENU_DEDTAIL_EVENT]) {
        SuitMenuChange* change=(SuitMenuChange*)obj;
        self.delChangeId=change._id;
        [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)  ];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"change_id"] = self.delChangeId;
        @weakify(self);
        [[TDFSuitMenuService new] removeSuitMenuChangeWithParam:parma suscess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            @strongify(self);
            [self.progressHud setHidden:YES];
            NSString* delAction=[NSString stringWithFormat:@"%d",ACTION_CONSTANTS_DEL];
            NSMutableDictionary* dic=[NSMutableDictionary dictionary];
            [dic setObject:self.delChangeId forKey:@"changeId"];
            [dic setObject:delAction forKey:@"action"];
            [[NSNotificationCenter defaultCenter] postNotificationName:SuitModule_Detail_Menu_Change object:dic];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud setHidden:YES];
            [AlertBox show:error.localizedDescription];
        }];

    }
}

#pragma remote
- (void)reloadData
{
    [self loadData:self.suitMenuSample kindTrees:self.treeNodes action:ACTION_CONSTANTS_EDIT withDetailArray:nil];
    
}

- (void)loadData:(SampleMenuVO*)menuTemp kindTrees:(NSMutableArray*)treeNodes action:(NSInteger)action withDetailArray:(NSMutableArray *)detail
{
    self.action=action;
    self.oldMemberPrice =nil;
    self.oldPrice =nil;
    self.isFristPrice =NO;
    self.suitMenuSample=menuTemp;
 
    if (detail.count>0) {
        self.detailArray = detail;
    }
   
    [self.titleBox editTitle:NO act:self.action];
    if (self.action  == ACTION_CONSTANTS_ADD) {
         [self.txtNote setHeight: 30] ;
    }
    else
    {
        [self.txtNote setHeight: 10] ;
    }
    if (action == ACTION_CONSTANTS_ADD) {
         [self clearDo];
        [self.suitMenuCode visibal:NO];
    }else{
        if ([self isChain]) {
             [self.suitMenuCode visibal:NO];
        }else{
            [self.suitMenuCode visibal:YES];
        }
    }
  
    [self clearDo];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];

    @weakify(self);
    //版本控制
    [[[TDFLoginService alloc] init]cashierVersionWithParams:@{@"cashier_version_key":@"cashVersion4MenuHit" }
                                                     sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                                         @strongify(self);
                                                         [self.progressHud setHidden:YES];
                                                         id obj = [data objectForKey:@"data"];
                                                         self.menuhit_version  = obj !=nil && [obj boolValue];
                                                         [self isShowMenuRuleList:self.menuhit_version];
                                                         if (action==ACTION_CONSTANTS_ADD) {
                                                             self.titleBox.lblTitle.text=NSLocalizedString(@"添加套餐", nil);
                                                             self.title  = NSLocalizedString(@"添加套餐", nil);
                                                             [self getDefultSuitMenuProp];
                                                              [self initEnaBleView];
                                                             [self.detailGrid loadData:nil details:nil detailCount:0];
                                                             [self showAddUI:YES];
                                                             [UIHelper refreshPos:self.container scrollview:self.scrollView];
                                                             [UIHelper refreshUI:self.container scrollview:self.scrollView];
                                                         } else {
                                                             [self showAddUI:NO];
                                                             [self getDefultSuitMenuProp];
                                                             [self loadSuitDetails:self.suitMenuSample._id];
                                                             [self loadMenuImg:self.suitMenuSample.id];
                                                         }                        [UIHelper refreshPos:self.container scrollview:self.scrollView];
                                                         [UIHelper refreshUI:self.container scrollview:self.scrollView];
                                                           [self updateSize];
                                                         
                                                     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                                         [self.progressHud setHidden:YES];
                                                         [AlertBox show:error.localizedDescription];
                                                     }];
//     [self.scrollView setContentOffset:CGPointMake(0,0)];
    if (self.action  == ACTION_CONSTANTS_ADD) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }
}

#pragma 数据加载
- (void)loadKindMenuData
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)  ];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"types_str"] = [[NSArray arrayWithObjects:@"1", nil] yy_modelToJSONString];
    @weakify(self);
    [[TDFChainMenuService new] listKindMenuForTypesWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        NSArray *list = [data objectForKey:@"data"];
        NSMutableArray *arr = [JsonHelper transList:list objName:@"KindMenu"];
        self.treeNodes = [TreeBuilder buildTree:arr];
        if (self.action == ACTION_CONSTANTS_ADD) {
            [self clearDo];
        }else{
            [self fillModel];
        }
    }failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        @strongify(self);
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void) getDefultSuitMenuProp
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)  ];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];

//    @weakify(self);
    [[TDFChainMenuService new] getDefaultSuitMenuPropWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud setHidden:YES];
        self.menuProp=[MenuProp yy_modelWithDictionary:data[@"data"]];
//        self.menuProp.acridLevel=self.menu.acridLevel;
        [self prepareOptionDataList:data[@"data"]];
        [self fillMenuPropData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

//辣度和推荐指数排序
static NSInteger suitMenuKabawNameItemCompare(id obj1, id obj2,void *context)
{
    NameItemVO *item1 = (NameItemVO *)obj1;
    NameItemVO *item2 = (NameItemVO *)obj2;
    if ([item1.itemId caseInsensitiveCompare:item2.itemId]==NSOrderedDescending) {
        return 1;
    }
    return -1L;
}

-(void)prepareOptionDataList:(NSDictionary *)dataMap
{
    self.acridDataList = [[NSMutableArray alloc]init];
    NSDictionary *acridData = [dataMap objectForKey:@"acridMap"];
    if ([ObjectUtil isNotEmpty:acridData]) {
        for (NSString *key in acridData) {
            NameItemVO *nameItem = [[NameItemVO alloc]initWithVal:[acridData objectForKey:key] andId:key];
            [self.acridDataList addObject:nameItem];
        }
    }
    self.acridDataList = [[NSMutableArray alloc]initWithArray:[self.acridDataList sortedArrayUsingFunction:suitMenuKabawNameItemCompare context:nil]];
    
    self.recommendDataList = [[NSMutableArray alloc]init];
    NSDictionary *recommendData = [dataMap objectForKey:@"recommendMap"];
    if ([ObjectUtil isNotEmpty:recommendData]) {
        for (NSString *key in recommendData) {
            NameItemVO *nameItem = [[NameItemVO alloc]initWithVal:[recommendData objectForKey:key] andId:key];
            [self.recommendDataList addObject:nameItem];
        }
    }
    self.recommendDataList = [[NSMutableArray alloc]initWithArray:[self.recommendDataList sortedArrayUsingFunction:suitMenuKabawNameItemCompare context:nil]];
    
    self.specialTagDataList = [[NSMutableArray alloc]init];
    self.specialTagDataMap = [[NSMutableDictionary alloc]init];
    [self.specialTagDataList addObject:[[SpecialTagVO alloc]initWithData:@"" name:NSLocalizedString(@"不设定", nil) sortCode:1 source:1]];
    NSArray *specialTagList = [dataMap objectForKey:@"specialTagList"];
    if ([ObjectUtil isNotEmpty:specialTagList]) {
        for (NSDictionary *specialTagDic in specialTagList) {
            NSString *specialTagId = [specialTagDic objectForKey:@"specialTagId"];
            NSString *specialTagName = [specialTagDic objectForKey:@"specialTagName"];
            NSInteger sortCode = [[specialTagDic objectForKey:@"sortCode"] integerValue];
            short tagSource = [[specialTagDic objectForKey:@"tagSource"] integerValue];
            
            SpecialTagVO *specialTagItem = [[SpecialTagVO alloc]initWithData:specialTagId name:specialTagName sortCode:sortCode source:tagSource];
            [self.specialTagDataList addObject:specialTagItem];
            [self.specialTagDataMap setObject:specialTagItem forKey:specialTagItem.specialTagId];
        }
    }
}

- (void)showAddUI:(BOOL)show
{
    [self.titleAddDetail visibal:show];
    [self.detailAddBox setHidden:!show];
    [self.detailAddBox setHeight:show?44:0];
    [self.titleDetail visibal:!show];
    [self.detailGrid setHidden:show];
    [self.detailGrid setHeight:0];
}

- (void)loadSuitDetails:(NSString*)menuId
{
    [self loadKindMenuData];
     [self.menuDetails removeAllObjects]; 
//    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil) ];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"menu_id"] = [NSString isBlank:menuId]?@"":menuId;
    @weakify(self);
    [[TDFChainMenuService new] getSuitMenuInfoWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        NSMutableDictionary *dictionary = data[@"data"];
        self.menu= [Menu yy_modelWithJSON:dictionary[@"suitMenuBaseVo"]];
        NSMutableArray* suitMenuChangeArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[SuitMenuChange class] json:dictionary[@"suitMenuChanges"]]];;
        self.menuProp=[MenuProp yy_modelWithDictionary:dictionary[@"suitMenuPropVo"]];
        self.suitMenuDetailList  = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[SuitMenuDetail class] json:dictionary[@"suitMenuDetails"]]];
        
        self.suitMenuChangeList= suitMenuChangeArr;
     
        [self fillModel];
        [self initDetail];
        [self initEnaBleView];
        [self.detailGrid loadData:self.suitMenuDetailList details:self.detailMap detailCount:self.suitMenuChangeList.count];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [self.scrollView setContentOffset:self.scrollViewLocation animated:NO];
        
        [[TDFMenuService new] listSpec:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            @strongify(self);
            self.detailGrid.metricList = [NSArray arrayWithArray:[NSArray yy_modelArrayWithClass:[SpecDetail class] json:data[@"data"]]];
            [self.detailGrid reloadData];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
           [AlertBox show:error.localizedDescription];
        }];
    }
 failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
    if (self.menuhit_version) {
        [[TDFSuitMenuService new] getSuitMenuValuationRuleList:menuId callBack:^(TDFResponseModel * _Nonnull response) {
            @strongify(self);
            if (response.error) {
                [AlertBox show:response.error.localizedDescription];
                return ;
            }
            NSArray *data = [response.responseObject objectForKey:@"data"];
            NSArray *rules = [NSArray yy_modelArrayWithClass:[TDFMenuHitRuleVo class] json:data];
            
            self.arr = [NSMutableArray arrayWithArray:rules];
            [self.valuationTable loadData:[NSMutableArray arrayWithArray:rules] detailCount:rules.count];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [self.scrollView setContentOffset:self.scrollViewLocation animated:NO];
        }];

    }
  
}

- (void) initEnaBleView
{
    if (![self isChain]) {
        if (self.suitMenuSample.chain && !self.chainDataManageable) {
            [self enableText:NO];
            self.boxPic.isHideDelImgBtn = YES;
            [self.boxPic initImgObject:self.menuDetails];
        }else{
            [self enableText:YES];
            self.boxPic.isHideDelImgBtn = NO;
            [self.boxPic initImgList:self.menuDetails];
        }
    }else{
        [self enableText:YES];
        [self.boxPic initImgList:self.menuDetails];
    }
    
}

- (void) enableText:(BOOL)show{
    [self orShowEdititemView:show];
    EditItemText *baseViewText;
    EditItemList *baseViewList;
    EditItemView *baseView;
    EditItemMemo *baseMenmoView;
    EditItemSignList *signListView;
    for (UIView *view in self.container.subviews) {
        if ([view isKindOfClass:[EditItemText class]]) {
            baseViewText = (EditItemText *)view;
            [baseViewText setEnabled:show];
        }else if ([view isKindOfClass:[EditItemList class]])
        {
            baseViewList = (EditItemList *)view;
            baseViewList.userInteractionEnabled = show;
            if (!show) {
                baseViewList.lblVal.frame = CGRectMake(68, 0, SCREEN_WIDTH - 68-10, 44);
                baseViewList.lblVal.textColor = [UIColor grayColor];
            }else{
                baseViewList.lblVal.frame = CGRectMake(68, 0, SCREEN_WIDTH - 68-31, 44);
                if ([baseViewList.lblVal.text isEqualToString:NSLocalizedString(@"必填", nil)]) {
                    baseViewList.lblVal.textColor = [UIColor redColor];
                }else if([baseViewList.lblVal.text isEqualToString:NSLocalizedString(@"必填", nil)])
                {
                    baseViewList.lblVal.textColor = [UIColor grayColor];
                }else{
                    baseViewList.lblVal.textColor = [ColorHelper getBlueColor];
                }
            }
            baseViewList.imgMore.hidden = !show;
        }else if ([view isKindOfClass:[EditItemView class]])
        {
            baseView = (EditItemView *)view;
            baseView.userInteractionEnabled = !show;
            if (!show) {
                baseView.lblVal.textColor = [UIColor grayColor];
            }else{
                baseView.lblVal.textColor = [ColorHelper getBlueColor];
            }
        }
        else if ([view isKindOfClass:[EditItemMemo class]])
        {
            baseMenmoView = (EditItemMemo *)view;
            baseMenmoView.userInteractionEnabled = show;
            if (!show) {
                baseMenmoView.lblVal.textColor = [UIColor grayColor];
            }else{
                baseMenmoView.lblVal.textColor = [ColorHelper getBlueColor];
            }
        }
        else if ([view isKindOfClass:[EditItemSignList class]])
        {
            signListView = (EditItemSignList *)view;
            signListView.userInteractionEnabled = show;
            signListView.imgMore.hidden = !show;
            if (!show) {
                signListView.lblVal.frame = CGRectMake(SCREEN_WIDTH-100, 10, 88, 21);
                signListView.lblVal.textColor = [UIColor grayColor];
            }else{
                signListView.lblVal.frame = CGRectMake(SCREEN_WIDTH-100-22, 10, 88, 21);
                signListView.lblVal.textColor = [ColorHelper getBlueColor];
            }
        }
    }
    self.suitMenuCode.userInteractionEnabled = YES;
     self.suitMenuCode.imgMore.hidden = NO;
}

- (void) orShowEdititemView:(BOOL)show
{
    [self.isRatioView visibal:!show];
    [self.isBackAuthView visibal:!show];
    [self.isBrandAllowCashierAmend  visibal:!show];
    if (!self.isCashierVersion) {
       [self.isBrandAllowCashierAmend  visibal:NO];
    }
    
    [self.goodForOutView visibal:!show];
    [self.gusBuyGoodView visibal:!show];
    self.valuationTable.footView.hidden = !show;
    
    if (!show) {
        self.valuationTable.isChain = YES;
        if ([ObjectUtil isEmpty:self.arr]) {
            [self.valuationTable setHeight:0];
        }
        if ([ObjectUtil isNotEmpty:self.arr]){
            [self.valuationTable setHeight:self.arr.count*48];
        }
        self.titleDetail.imgSort.hidden = YES;
        self.titleAddDetail.imgSort.hidden = YES;
        self.titleAddDetail.imgAdd.hidden = YES;
        self.titleDetail.imgAdd.hidden = YES;
        self.detailGrid.isChain = YES;
        if ([ObjectUtil isEmpty:self.suitMenuDetailList]) {
            [self.detailGrid setHeight:0];
        }
        if ([ObjectUtil isNotEmpty:self.suitMenuDetailList]){ 
            [self.detailGrid loadData:self.suitMenuDetailList details:self.detailMap detailCount:self.suitMenuChangeList.count];
        }
    }else{
        self.valuationTable.isChain = NO;
        self.titleDetail.imgSort.hidden = NO;
        self.titleDetail.imgAdd.hidden = NO;
        self.titleAddDetail.imgSort.hidden = NO;
        self.titleAddDetail.imgAdd.hidden = NO;
        self.detailGrid.isChain = NO;
    }
    
    [self.rdoIsRatio visibal:show];
    
    if (self.isCashierVersion) {
        [self.allowCashierAmendPrice visibal:show];
    }else{
    [self.allowCashierAmendPrice visibal:NO];
    }
    [self.rdoIsAuth visibal:show];
    [self.rdoIsReserve visibal:show];
    [self.rdoIsTakeout visibal:show];
    [self.btnDel setHidden:self.action==ACTION_CONSTANTS_ADD];
    if (self.suitMenuSample.chain && !self.chainDataManageable) {
        self.btnDel.hidden = YES;
    }
    self.boxPic.userInteractionEnabled = show;
    if (self.action == ACTION_CONSTANTS_ADD) {
        self.titleAddDetail.imgSort.hidden = YES;
        self.titleAddDetail.imgAdd.hidden = YES;
    }
}

-(void)isShowMenuRuleList:(BOOL)isShow{
    self.valuationTable.hidden = !isShow;
    self.titleValuation.hidden = !isShow;
    self.valuationTip.hidden = !isShow;
    [self.valuationTip setHeight:isShow?70:0];
    if (!isShow) {
        [self.valuationTable setHeight:0];
    }
    [self.titleValuation setHeight:isShow?48:0];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];

}

-(void) loadMenuImg:(NSString*)menuId
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil) ];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"menu_id"] = menuId;
    @weakify(self);
    [[TDFSuitMenuService new] listSuitMenuImgWithParam:parma suscess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [self loadImgFinsh:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}


-(void) loadImgFinsh:(NSMutableDictionary*)data
{
    [self.menuDetails removeAllObjects];
    if ([NSString isNotBlank:self.suitMenuSample.path]) {
        MenuDetail *detail = [[MenuDetail alloc] init];
        detail.id = self.suitMenuSample.id;
        detail._id = self.suitMenuSample.id;
        detail.path = self.suitMenuSample.path;
        detail.type = @"import";
        [self.menuDetails addObject:detail];
    }
    [self.menuDetails addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MenuDetail class] json:data[@"data"]]];
    [self.boxPic initImgList:self.menuDetails];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


#pragma 数据层处理

- (void)clearDo{
    [self orShowEdititemView:YES];
    [self.txtName initData:nil];
    self.suitMenuDetailList = nil;
     NSString* lastKindMenu=[[Platform Instance] getkey:DEFAULT_SUITKINDMENU];
    if ([NSString isBlank:lastKindMenu]) {
        TreeNode* root=[TreeNodeUtils getFirstRootKind:self.treeNodes];
        if(root==nil){
            [self.lsKindName initData:nil withVal:nil];
        }else{
            [self.lsKindName initData:[root obtainOrignName] withVal:[root obtainItemId]];
        }
    }else{
        NSMutableArray *allNodes=[TreeNodeUtils convertAllNode:self.treeNodes];
        [self.lsKindName initData:[GlobalRender obtainObjName:allNodes itemId:lastKindMenu] withVal:lastKindMenu];
    }
    self.suitMenuChangeList = [[NSMutableArray alloc]init];
    [self.valuationTable loadData:nil detailCount:0];
    [self.txtName initData:nil];
    [self.txtCode initData:nil];
    [self.lsPrice initData:nil withVal:nil];
    [self.lsAccount initData:NSLocalizedString(@"份", nil) withVal:NSLocalizedString(@"份", nil)];
    [self.rdoIsRatio initData:@"1"];
    [self.allowCashierAmendPrice  initData:@"0"];
    [self.rdoIsAuth initData:@"1"];
    [self.rdoIsSelf initData:@"1"];
    [self isSelfRender];
    [self.boxPic initImgList:nil];
    [self.lsLeastNum initData:@"1" withVal:@"1"];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)isSelfRender
{
    self.rdoIsSelf.lblName.text=[self.rdoIsSelf getVal]?NSLocalizedString(@"商品已上架", nil):NSLocalizedString(@"商品已下架", nil);
    [self.rdoIsSelf initHit:[self.rdoIsSelf getVal]?NSLocalizedString(@"提示:在所有可点单的设备上（包括火小二）显示", nil):NSLocalizedString(@"提示:下架商品在收银设备上仍然显示并可点，在其他点菜设备（火小二、火服务生、微信点餐等）上不显示", nil)];
}

- (void)fillModel
{
    NSMutableArray *allNodes=[TreeNodeUtils convertAllNode:self.treeNodes];
    [self.lsKindName initData:[GlobalRender obtainObjName:allNodes itemId:self.menu.kindMenuId] withVal:self.menu.kindMenuId];
    [self.txtName initData:self.menu.name];
    [self.txtCode initData:self.menu.code];
    NSString* priceStr=[FormatUtil formatDouble4:self.menu.price];
    [self.lsPrice initData:priceStr withVal:priceStr];
     self.oldMemberPrice =[NSString stringWithFormat:@"%f",self.self.menu.memberPrice];
    self.oldPrice =[NSString stringWithFormat:@"%f",self.menu.price];
    
    [self.lsAccount initData:self.menu.account withVal:self.menu.account];
    [self.rdoIsRatio initShortData:self.menu.isRatio];
     [self.allowCashierAmendPrice  initShortData:self.menu.isChangePrice];
    [self.isRatioView initData:self.menu.isRatio == 0?NSLocalizedString(@"不允许", nil):NSLocalizedString(@"允许", nil) withVal:self.menu.isRatio == 0?NSLocalizedString(@"不允许", nil):NSLocalizedString(@"允许", nil)];
    [self.isBackAuthView initData:self.menu.isBackAuth ==0?NSLocalizedString(@"不需要", nil):NSLocalizedString(@"需要", nil) withVal:self.menu.isBackAuth ==0?NSLocalizedString(@"不需要", nil):NSLocalizedString(@"需要", nil)];
    
    [self.isBrandAllowCashierAmend  initData:self.menu.isChangePrice == 0?NSLocalizedString(@"不允许", nil):NSLocalizedString(@"允许", nil) withVal:self.menu.isChangePrice == 0?NSLocalizedString(@"不允许", nil):NSLocalizedString(@"允许", nil)];
    [self.rdoIsSelf initShortData:self.menu.isSelf];
    [self.rdoIsAuth initShortData:self.menu.isBackAuth];
    [self isSelfRender];
    self.titleBox.lblTitle.text=self.menu.name;
    self.title = self.menu.name ;
    [self fillMenuPropData];
}

- (void) fillMenuPropData
{
    NSString* memberPriceStr=[FormatUtil formatDouble4:self.menuProp.memberPrice];
    NSString* leastNumStr=[NSString stringWithFormat:@"%li", (long)self.menuProp.startNum == 0?1:(long)self.menuProp.startNum];
    [self.lsMemberPrice initData:memberPriceStr withVal:memberPriceStr];
    [self.lsLeastNum initData:leastNumStr withVal:leastNumStr];
    NSString* acridLevel = [NSString stringWithFormat:@"%i", self.menuProp.acridLevel];
    NSString* recommendLevel = [NSString stringWithFormat:@"%i", self.menuProp.recommendLevel];
    NSString* specialTagId = ([NSString isNotBlank:self.menuProp.specialTagId]?self.menuProp.specialTagId:@"");
    [self.lsAcridLevel initData:self.menuProp.acridLevelString withVal:acridLevel];
    [self.lsApproveLevel initData:self.menuProp.recommendLevelString withVal:recommendLevel];
    [self.lsCharacters initData:self.menuProp.specialTagString withVal:specialTagId];
    
    if (self.menu.isSelf==1) {
        [self.goodForOutView initData:self.menuProp.isReserve==1?NSLocalizedString(@"可点", nil):NSLocalizedString(@"不可点", nil) withVal:self.menuProp.isReserve==1?NSLocalizedString(@"可点", nil):NSLocalizedString(@"不可点", nil)];
        [self.gusBuyGoodView initData:self.menuProp.isTakeout==1?NSLocalizedString(@"可点", nil):NSLocalizedString(@"不可点", nil) withVal:self.menuProp.isTakeout==1?NSLocalizedString(@"可点", nil):NSLocalizedString(@"不可点", nil)];

        [self.rdoIsReserve initShortData:self.menuProp.isReserve];
        [self.rdoIsTakeout initShortData:self.menuProp.isTakeout];
    } else {
        [self.rdoIsReserve initShortData:self.menuProp.isReserve];
        [self.rdoIsTakeout initShortData:self.menuProp.isTakeout];
        [self.goodForOutView initData:NSLocalizedString(@"不可点", nil) withVal:NSLocalizedString(@"可点", nil)];
        [self.gusBuyGoodView initData:NSLocalizedString(@"不可点", nil) withVal:NSLocalizedString(@"可点", nil)];
    }
    
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self.rdoIsReserve initShortData:1];
        [self.rdoIsTakeout initShortData:1];
    }
    
    [self.txtMemo initData:self.menuProp.memo];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)uploadImgFinsh:(RemoteResult *)result
{
    [self.progressHud setHidden:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    int kind = [self getImageListKind];
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)  ];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"menu_id"] = [NSString isBlank:self.menu.id]?@"":self.menu.id;
    parma[@"file_path"] = self.imgFilePathTemp;
    parma[@"kind"] = [NSString stringWithFormat:@"%ld",(long)kind];
    @weakify(self);
    [[TDFMenuService new] saveMenuImgWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [self configNavigationBar:NO];
        if ([ObjectUtil isEmpty:self.menuDetails]) {
            self.suitMenuSample.path = data[@"data"];
        }
        [self loadMenuImg:self.menu.id];
//        [parent.menuListView loadMenus];
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[MenuListView class]]) {
                [(MenuListView *)viewController loadMenus];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

-(void) specialTagDataChange:(NSNotification*) notification
{
    if ([NSString isNotBlank:self.suitMenuSample.id]) {
        [self loadSuitDetails:self.suitMenuSample.id];
    }
}

//Demo控件.
-(void) onItemMemoListClick:(EditItemMemo*)obj
{
    [MemoInputBox show:1 delegate:self title:NSLocalizedString(@"套餐介绍", nil) val:[self.txtMemo getStrVal]];
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_SuitMenuEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lsKindNameDataChange:) name:@"typ_change" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_SuitMenuEditView_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailKindChange:) name:SuitModule_Detail_Kind_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailMenuChange:) name:SuitModule_Detail_Menu_Change object:nil];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*)notification
{
    if (self.action  == ACTION_CONSTANTS_EDIT) {
        [self configNavigationBar:[UIHelper currChange:self.container]];
    }
    
}

- (void)lsKindNameDataChange:(NSNotification *)notification
{
    NSMutableArray* arr= notification.object;
    self.treeNodes = arr;
    NSString* lastKindMenu=[[Platform Instance] getkey:DEFAULT_SUITKINDMENU];
    if ([NSString isBlank:lastKindMenu]) {
        TreeNode* root=[TreeNodeUtils getFirstRootKind:self.treeNodes];
        if(root==nil){
            [self.lsKindName initData:nil withVal:nil];
        }else{
            [self.lsKindName initData:[root obtainOrignName] withVal:[root obtainItemId]];
        }
    }else{
        NSMutableArray *allNodes=[TreeNodeUtils convertAllNode:self.treeNodes];
        [self.lsKindName initData:[GlobalRender obtainObjName:allNodes itemId:lastKindMenu] withVal:lastKindMenu];
    }
}

- (void)remoteFinsh

{
    if(self.isContinue) {
        [self forwardViewController:self.codeType];
        if (self.startUpLoadImg) {
            NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
            NSString *filePath = [NSString stringWithFormat:@"%@/menu/%@.png", entityId, [NSString getUniqueStrByUUID]];
            self.imgFilePathTemp = filePath;
            
            [self showProgressHudWithText:NSLocalizedString(@"正在上传", nil)  ];
            [systemService uploadImage:filePath image:self.imageData width:1280 heigth:1280 Target:self Callback:@selector(uploadImgFinsh:)];
        }
        
    } else {
        
         [self.navigationController popViewControllerAnimated:YES];
        if (self.delegate ) {
            [self.delegate navitionToPushBeforeJump:nil data:nil];
        }
    }
}

- (void)proceeResult:(NSMutableDictionary*)data
{
    NSString* actionStr=[NSString stringWithFormat:@"%ld",(long)self.action];
    NSMutableDictionary *dictionary = data[@"data"];
    self.menu= [Menu yy_modelWithJSON:dictionary[@"suitMenuBaseVo"]];

    self.suitMenuSample = [SampleMenuVO yy_modelWithJSON:dictionary[@"suitMenuBaseVo"]];
    self.action = ACTION_CONSTANTS_EDIT;
    [self loadData:self.menu kindTrees:nil action:ACTION_CONSTANTS_EDIT withDetailArray:self.detailArray];
    [[Platform Instance] saveKeyWithVal:DEFAULT_SUITKINDMENU withVal:self.menu.kindMenuId];
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic setObject:self.suitMenuSample forKey:@"menu"];
    [dic setObject:actionStr forKey:@"action"];
    [[NSNotificationCenter defaultCenter] postNotificationName:SuitModule_Menu_EDIT_Change object:dic] ;
}

- (void)detailKindChange:(NSNotification*)notification
{
    NSDictionary* dic= notification.object;
    NSString* actionStr=[dic objectForKey:@"action"];
    SuitMenuDetail *suitMenuDetail = [dic objectForKey:@"suitMenuDetail"];
    if(self.suitMenuDetailList==nil){
        self.suitMenuDetailList=[NSMutableArray array];
    }
    NSString* editAction=[NSString stringWithFormat:@"%d",ACTION_CONSTANTS_EDIT];
    NSString* delAction=[NSString stringWithFormat:@"%d",ACTION_CONSTANTS_DEL];
    if ([actionStr isEqualToString:editAction]) {
        if ([self.suitMenuChangeList containsObject:suitMenuDetail]) {
            [self.suitMenuChangeList removeObject:suitMenuDetail];
        }
        
        [self.suitMenuDetailList addObject:suitMenuDetail];
    }else if([actionStr isEqualToString:delAction]){
        NSString* detailId=[dic objectForKey:@"detailId"];
        for (SuitMenuDetail* detail in self.suitMenuDetailList) {
            if ([detail._id isEqualToString:detailId]) {
                [self.suitMenuDetailList removeObject:detail];
                break;
            }
        }
    }else{
        [self.suitMenuDetailList addObject:suitMenuDetail];
    }
    [self initDetail];
    [self.detailGrid loadData:self.suitMenuDetailList details:self.detailMap detailCount:self.suitMenuChangeList.count];
    
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)detailMenuChange:(NSNotification*)notification
{
    NSDictionary* dic= notification.object;
    NSString* actionStr=[dic objectForKey:@"action"];
    SuitMenuChange *suitMenuChange = [dic objectForKey:@"suitMenuChange"];
    if(self.suitMenuDetailList==nil){
        self.suitMenuDetailList=[NSMutableArray array];
    }
    NSString* editAction=[NSString stringWithFormat:@"%d",ACTION_CONSTANTS_EDIT];
    NSString* delAction=[NSString stringWithFormat:@"%d",ACTION_CONSTANTS_DEL];
    if ([actionStr isEqualToString:editAction]) {
        
    }else if([actionStr isEqualToString:delAction]){
        NSString* detailId=[dic objectForKey:@"changeId"];
        if(self.suitMenuChangeList!=nil && self.suitMenuChangeList.count>0){
            for (SuitMenuChange* change in self.suitMenuChangeList) {
                if ([change._id isEqualToString:detailId]) {
                    [self.suitMenuChangeList removeObject:change];
                    break;
                }
            }
        }
    }else{
        if (!self.suitMenuChangeList) {
            self.suitMenuChangeList=[NSMutableArray array];
        }
        [self.suitMenuChangeList addObject:suitMenuChange];
    }
    [self initDetail];
    [self.detailGrid loadData:self.suitMenuDetailList details:self.detailMap detailCount:self.suitMenuChangeList.count];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)initDetail
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSMutableArray* arr=nil;
    BOOL hasChild=(self.suitMenuChangeList!=nil && self.suitMenuChangeList.count>0);
    if(self.suitMenuDetailList!=nil && self.suitMenuDetailList.count>0){
        for (SuitMenuDetail* head in self.suitMenuDetailList) {
            arr=[NSMutableArray array];
            if (hasChild) {
                for (SuitMenuChange* menu in self.suitMenuChangeList) {
                    if ([menu.suitMenuDetailId isEqualToString:head._id]) {
                        menu.isRequired = head.isRequired;
                        [arr addObject:menu];
                        [dic setObject:arr forKey:head._id];
                    }
                }
            }
        }
    }
    self.detailMap=dic;
}

#pragma save-data
-(BOOL)isValid{
    if (self.self.suitMenuSample.chain && !self.chainDataManageable) {
        return YES;
    }
    if ([NSString isBlank:[self.lsKindName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"套餐分类不能为空!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"套餐名称不能为空!", nil)];
        return NO;
    }

    if ([NSString isBlank:[self.lsPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"套餐单价(元)不能为空!", nil)];
        return NO;
    }
    if (![NSString isFloat:[self.lsPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"套餐单价(元)不是数字!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsAccount getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"结账单位不能为空!", nil)];
        return NO;
    }
    if (![NSString isFloat:[self.lsMemberPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"会员价不是数字!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsLeastNum getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"起点份数不能为空!", nil)];
        return NO;
    }

    return YES;
}

- (MenuProp *)transModeProp
{
    SpecialTagVO* specialTag = [self.specialTagDataMap objectForKey:[self.lsCharacters getStrVal]];
    self.menuProp.memo=[self.txtMemo getStrVal];
    self.menuProp.isReserve=[self.rdoIsReserve getVal]?1:0;
    self.menuProp.isTakeout=[[self.rdoIsTakeout getStrVal] intValue];
    self.menuProp.recommendLevel=[[self.lsApproveLevel getStrVal] intValue];
    self.menuProp.specialTagId=(specialTag!=nil?specialTag.specialTagId:@"");
    self.menuProp.tagSource=(specialTag!=nil?specialTag.tagSource:1);
    self.menuProp.startNum=[[self.lsLeastNum getStrVal] intValue];
    self.menuProp.acridLevel=[self.lsAcridLevel getStrVal].intValue;
    if ([NSString isNotBlank:[self.lsMemberPrice getStrVal]]) {
        self.menuProp.memberPrice=[self.lsMemberPrice getStrVal].doubleValue;
    } else {
        self.menuProp.memberPrice=self.menu.price;
    }
    return self.menuProp;
}

- (void)startRemoveImage:(id<IImageData>)imageData target:(EditImageBox *)targat
{
    if ([UIHelper currChange:self.container]) {
        [self save];
        self.isContinue = YES;
    }
    if (imageData!=nil && [imageData isKindOfClass:[MenuDetail class]]) {
        int kind;
        MenuDetail *menuDetail = (MenuDetail *)imageData;
        if ([menuDetail.type isEqualToString:@"import"]) {
            kind = KIND_MAIN_IMAGE;
            self.suitMenuSample.path = nil;
           
        }else{
            kind = KIND_DETAIL_IMAGE;
        }
        
        [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil) ];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"menu_id"] = [NSString isBlank:self.menu.id]?@"":self.menu.id;
        parma[@"menu_detail_id"] = [NSString isBlank:menuDetail.id]?@"":menuDetail.id;;
        parma[@"kind"] = [NSString stringWithFormat:@"%d",kind];
        @weakify(self);
        [[TDFMenuService new] removeMenuImgWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            MenuDetail *item = (MenuDetail *)imageData;
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (MenuDetail *menuDetail in self.menuDetails) {
                if ([menuDetail.id isEqualToString:item.id]) {
                    [arr addObject:menuDetail];
                }
            }
            [self.menuDetails removeObjectsInArray:arr];
            [self.progressHud  hideAnimated:YES];
            [self configNavigationBar:NO];

            if (self.suitMenuSample.path == nil && self.menuDetails.count != 0) {
                MenuDetail *detail = self.menuDetails[0];
                self.suitMenuSample.path = detail.path;
                detail.type = @"import";
            }
        
            [self.boxPic initImgList:self.menuDetails];
            [UIHelper refreshPos:self.container scrollview:self.scrollView];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[MenuListView class]]) {
                    [(MenuListView *)viewController loadMenus];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud  hideAnimated:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }
}


- (void)startUploadImage:(UIImage *)imageData target:(EditImageBox *)targat
{
    self.imageData = imageData;
    //防止新增保存图片时闪退
    if (![self isValid]) {
        return ;
    }
    self.startUpLoadImg = YES;
    if ([UIHelper currChange:self.container]) {
        [self save];
        self.isContinue = YES;
    }else{
        NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
        NSString *filePath = [NSString stringWithFormat:@"%@/menu/%@.png", entityId, [NSString getUniqueStrByUUID]];
        self.imgFilePathTemp = filePath;
        
        [self showProgressHudWithText:NSLocalizedString(@"正在上传", nil)  ];
        [systemService uploadImage:filePath image:imageData width:1280 heigth:1280 Target:self Callback:@selector(uploadImgFinsh:)];
    }
}

#pragma 对象处理.
- (Menu *)transMode
{
    Menu* obj=[Menu new];
    if (self.action == ACTION_CONSTANTS_EDIT) {
       obj.id = self.menu.id;
    }else{
        obj.id = nil;
    }
    
    obj.name=[self.txtName getStrVal];
    obj.kindMenuId=[self.lsKindName getStrVal];
    obj.code=[self.txtCode getStrVal];
 
    obj.price=[self.lsPrice getStrVal].doubleValue;

    if (self.menu.price == self.menu.memberPrice) {
        obj.memberPrice = obj.price;
    }else{
        obj.memberPrice = self.menu.memberPrice;
    }
    obj.account=[self.lsAccount getStrVal];
    obj.buyAccount=[self.lsAccount getStrVal];
    obj.isRatio=([self.rdoIsRatio getVal]?1:0);
    obj.isBackAuth=([self.rdoIsAuth getVal]?1:0);
    obj.consume=0;
    obj.deductKind=0;
    obj.deduct=0;
    obj.isReserve=1;
    obj.isTwoAccount=0;
    obj.serviceFeeMode=0;
    obj.serviceFee=0;
    obj.isChangePrice=0;
    obj.isGive=0;
    obj.isInclude=1;
    obj.isSelf=[self.rdoIsSelf getVal]?1:0;
    if (self.isCashierVersion) {
    obj.isChangePrice  =  ([self.allowCashierAmendPrice  getVal] ? 1:0);
    }
    return obj;
}

//添加套餐内商品.
-(IBAction)btnAddDetailClick:(id)sender
{
    if (![self isValid]) {
        return;
    }
    self.suitMenuDetail = nil;
    self.codeType = SUITMENU_GROUP_ADD;
    [self isSuitMenuChange];
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    
    if (self.self.suitMenuSample.chain && !self.chainDataManageable) {
        if ([self.rdoIsSelf getVal]) {
            [self showProgressHudWithText:NSLocalizedString(@"正在上架", nil)  ];
            NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
            parma[@"is_self"] = @"1";
            parma[@"menu_id_str"] = [[NSArray arrayWithObject:self.menu.id] yy_modelToJSONString];
            @weakify(self);
            [[TDFMenuService new] updateIsSelfWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                @strongify(self);
                [self.progressHud  hideAnimated:YES];
                [self.navigationController popViewControllerAnimated: YES];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud  hideAnimated:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }else{
            [self showProgressHudWithText:NSLocalizedString(@"正在下架", nil)  ];
            NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
            parma[@"is_self"] = @"0";
            parma[@"menu_id_str"] = [[NSArray arrayWithObject:self.menu.id] yy_modelToJSONString];
            @weakify(self);
            [[TDFMenuService new] updateIsSelfWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                @strongify(self);
                [self.progressHud  hideAnimated:YES];
                [self.navigationController popViewControllerAnimated: YES];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud  hideAnimated:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
    }else{
        Menu* objTemp=[self transMode];
        MenuProp *obj = [self transModeProp];
        NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"menu_str"] = [objTemp yy_modelToJSONString];
        parma[@"prop_str"] = [obj yy_modelToJSONString];
        [self showProgressHudWithText:tip  ];
        
        [[TDFChainMenuService new] saveSuitMenuInfoWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud setHidden:YES];
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass: [MenuListView class] ]) {
                    [(MenuListView *)viewController  loadMenus];
                }
            }
           
            if (self.action==ACTION_CONSTANTS_ADD) {
                [self proceeResult:data];
                [self remoteFinsh];
            }else{
                [self.progressHud setHidden:YES];
                [UIHelper clearChange:self.container];
                [self remoteFinsh];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud setHidden:YES];
            [AlertBox show:error.localizedDescription];
        }];

    }
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.menu.name] event:0];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==0) {
        if(buttonIndex==0){
            [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)  ];
            NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
             parma[@"menu_id"] = [NSString isBlank:self.menu.id]?@"":self.menu.id;
            @weakify(self);
            [[TDFMenuService new] removeMenuWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                @strongify(self);
                [self.progressHud setHidden:YES];
                NSString* actionStr=[NSString stringWithFormat:@"%d",ACTION_CONSTANTS_DEL];
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                dic[@"menuId"] = self.menu.id;
                dic[@"action"] = actionStr;
                [[NSNotificationCenter defaultCenter] postNotificationName:SuitModule_Menu_EDIT_Change object:dic] ;
                [self.scrollView setContentOffset:CGPointMake(0,0)];
                self.scrollViewLocation = CGPointZero;
                for (UIViewController *viewController in self.navigationController.viewControllers) {
                    if ([viewController isKindOfClass:[MenuListView class]]) {
                        [(MenuListView *)viewController  loadMenus];
                    }
                }
                [self.navigationController popViewControllerAnimated: YES];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud setHidden:YES];
                [UIHelper refreshUI:self.container scrollview:self.scrollView];
                [AlertBox show:error.localizedDescription];
            }];

        }
    } else {
        if (buttonIndex==0) {    //套餐内分组排序.
            if (self.suitMenuDetailList==nil || self.suitMenuDetailList.count<2) {
                [AlertBox show:NSLocalizedString(@"请至少添加两条内容,才能进行排序.", nil)];
                return;
            }
            UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_sortTableEditViewControllerWithData:self.suitMenuDetailList error:nil event:REMOTE_SUITMENUDETAIL_SORT action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"套餐分组排序", nil) delegate:self];
            [self.navigationController pushViewController:viewController animated:YES];
        } else if (buttonIndex==1) {   //套餐内分组内的商品排序.
            TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"选择分组-套餐内商品排序", nil)
                                                                                          options:self.suitMenuDetailList
                                                                                    currentItemId:nil];
            __weak __typeof(self) wself = self;
            __weak __typeof(pvc) wspvc = pvc;
            pvc.competionBlock = ^void(NSInteger index) {
                [wspvc dismissViewControllerAnimated:YES completion:nil];
                [wself pickOption:self.suitMenuDetailList[index] event:SUITMENU_CHANGE_SORT_EVENT];
            };
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pvc animated:YES completion:nil];

        }
    }
}

#pragma test event
#pragma edititemlist click event.
//List控件变换.
-(void) onItemListClick:(EditItemList*)obj {
    if (obj.tag==SUITMENU_KIND) {
        [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil) ];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"types_str"] = [[NSArray arrayWithObjects:@"1", nil] yy_modelToJSONString];
        @weakify(self);
        [[TDFChainMenuService new] listKindMenuForTypesWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud setHidden:YES];
            NSArray *list = [data objectForKey:@"data"];
            NSMutableArray *arr = [JsonHelper transList:list objName:@"KindMenu"];
            self.treeNodes = [TreeBuilder buildTree:arr];
            NSMutableArray* endNodes=[TreeNodeUtils convertMultiEndNode:self.treeNodes level:4 showAll:NO];
            
            TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"套餐分类管理", nil)
                                                                                          options:endNodes
                                                                                    currentItemId:[obj getStrVal]];
            __weak __typeof(self) wself = self;
            __weak __typeof(pvc) wspvc = pvc;
            pvc.competionBlock = ^void(NSInteger index) {
                [wspvc dismissViewControllerAnimated:YES completion:nil];
                [wself pickOption:endNodes[index] event:obj.tag];
            };
            
            pvc.shouldShowManagerButton = YES;
            pvc.manageTitle = NSLocalizedString(@"分类管理", nil);
            pvc.managerBlock = ^void () {
                [wself dismissViewControllerAnimated:YES completion:nil];
                [wself managerEvent:obj.tag];
            };
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pvc animated:YES completion:nil];
        }failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         
            [self.progressHud setHidden:YES];
            [AlertBox show:error.localizedDescription];
        }];
       
    } else if (obj.tag==SUITMENU_ACCOUNT) {
//        NSString* unitStr=[[Platform Instance] getkey:MENU_UNIT];
//         NSString *unitStr= [[NSUserDefaults standardUserDefaults] valueForKey:MENU_UNIT];
//        NSMutableArray* unitList=[MenuRender listMenuUnits:unitStr];

//        [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
         [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil) ];
        [TDFGoodsService fetchFoodUnitWithCompleteBlock:^(TDFResponseModel *response) {
            [self.progressHud setHidden:YES];
            if ([response isSuccess]) {
                if ([response.dataObject isKindOfClass:[NSArray class]]) {
                    NSArray *dataList = response.dataObject;
                    NSMutableArray *unitList = [NSMutableArray array];
                    for (NSDictionary *unitDict in dataList) {
                        NSString *unitDesc = unitDict[@"unitDesc"];
                        NSNumber *unitType = unitDict[@"unitType"];
                        NameItemVO *item = [[NameItemVO alloc] initWithVal:unitDesc andId:unitDesc];
                        item.itemValue = [NSString stringWithFormat:@"%@", unitType];

                        [unitList addObject:item];
                    }
                    
                    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                                  options:unitList
                                                                                            currentItemId:[obj getStrVal]];
                    __weak __typeof(self) wself = self;
                    __weak __typeof(pvc) wspvc = pvc;
                    pvc.competionBlock = ^void(NSInteger index) {
                        [wspvc dismissViewControllerAnimated:YES completion:nil];
                        [wself pickOption:unitList[index] event:obj.tag];
                    };
                    pvc.shouldShowManagerButton = YES;
                    pvc.manageTitle = NSLocalizedString(@"单位库管理", nil);
                    pvc.managerBlock = ^void(){
                        [wself dismissViewControllerAnimated:YES completion:nil];
                        [wself managerOption:obj.tag];
                    };
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pvc animated:YES completion:nil];
                    
                }
            } else {
                [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"取消", nil)];
            }
        }];
        
    } else if (obj.tag == SUITMENU_CODE){
        
//        [parent showView:SUITMENU_CODE_VIEW];
   //    [parent.menuCodeView loadDataWithMenu:self.menu kind:Kind_SuitMenu event:1];
//        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromRight];
        UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_menuCodeViewControllerWthDataData:self.menu kind:Kind_SuitMenu event:1 delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
    }else  if (obj.tag==KABAWMENU_ACRIDLEVEL) {
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"辣度指数", nil)
                                                                                      options:self.acridDataList
                                                                                currentItemId:[self.lsAcridLevel getStrVal]];
        __weak __typeof(self) wself = self;
        __weak __typeof(pvc) wspvc = pvc;
        pvc.competionBlock = ^void(NSInteger index) {
            [wspvc dismissViewControllerAnimated:YES completion:nil];
            [wself pickOption:self.acridDataList[index] event:KABAWMENU_ACRIDLEVEL];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    } else if (obj.tag==KABAWMENU_APPROVELEVEL) {
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"推荐指数", nil)
                                                                                      options:self.recommendDataList
                                                                                currentItemId:[self.lsApproveLevel getStrVal]];
        __weak __typeof(self) wself = self;
        __weak __typeof(pvc) wspvc = pvc;
        pvc.competionBlock = ^void(NSInteger index) {
            [wspvc dismissViewControllerAnimated:YES completion:nil];
            [wself pickOption:self.recommendDataList[index] event:KABAWMENU_APPROVELEVEL];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    } else if (obj.tag==KABAWMENU_CHARACTER) {
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"特色标签", nil)
                                                                                      options:self.specialTagDataList
                                                                                currentItemId:[self.lsCharacters getStrVal]];
        __weak __typeof(self) wself = self;
        __weak __typeof(pvc) wspvc = pvc;
        pvc.competionBlock = ^void(NSInteger index) {
            [wspvc dismissViewControllerAnimated:YES completion:nil];
            [wself pickOption:self.specialTagDataList[index] event:KABAWMENU_CHARACTER];
        };
        if (![self isChain]) {
            pvc.shouldShowManagerButton = YES;
            pvc.manageTitle = NSLocalizedString(@"标签管理", nil);
            pvc.managerBlock = ^void(){
                [wself dismissViewControllerAnimated:YES completion: nil];
                [wself managerOption:KABAWMENU_CHARACTER];
            };
        }
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }

}
//多选List控件变换.
-(void) onMultiItemListClick:(EditMultiList*)obj
{
}

//Radio控件变换.
-(void) onItemRadioClick:(EditItemRadio*)obj
{
#pragma mark 改过的地方
    ///////////////////////
    if (![obj getVal] &&self.menu.isForceMenu) {
        [obj initData:@"1"];
        self.rdoIsSelf.lblName.text=1?NSLocalizedString(@"商品已上架", nil):NSLocalizedString(@"商品已下架", nil);
        [self.rdoIsSelf initHit:1?NSLocalizedString(@"提示:在所有可点单的设备上（包括火小二）显示", nil):NSLocalizedString(@"提示:下架商品在收银设备上仍然显示并可点，在其他点菜设备（火小二、火服务生、微信点餐等）上不显示", nil)];
        [AlertBox show:NSLocalizedString(@"此商品被设定为必选商品了，无法下架，请先解除必选商品。", nil)];
        return;
    }
    
    if (obj.tag==KABAWMENU_ISRESERVE) {
        if (self.action == ACTION_CONSTANTS_EDIT) {
//            if (self.menu.isSelf==0 && [obj getVal]) {
//                [obj initShortData:0];
//                [AlertBox show:NSLocalizedString(@"商品已下架,不能开堂食可点此套餐!", nil)];
//                return;
//            }
            if (![obj getVal]&&self.menu.isForceMenu) {
                [obj initData:@"1"];
                [AlertBox show:NSLocalizedString(@"此商品被设定为必选商品了，不能关闭此功能。", nil)];
                return;
            }
        }
    }
    if (obj.tag==KABAWMENU_ISTAKEOUT) {
//        if (self.action == ACTION_CONSTANTS_EDIT) {
//            if (self.menu.isSelf==0 && [obj getVal]) {
//                [obj initShortData:0];
//                [AlertBox show:NSLocalizedString(@"商品已下架,不能开启外卖可点此套餐!", nil)];
//                return;
//            }
//        }
    }

    [self isSelfRender];
    //////////////////////
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma 变动的结果.
#pragma 单选页结果处理.
- (BOOL)pickOption:(id)selectObj event:(NSInteger)event
{
    if (event==SUITMENU_CHANGE_SORT_EVENT) {
        SuitMenuDetail* item= (SuitMenuDetail*)selectObj;
        NSMutableArray *changes = [self.detailMap objectForKey:[item obtainItemId]];
        
        if (changes==nil || changes.count<2) {
            [AlertBox show:NSLocalizedString(@"请至少添加两条内容,才能进行排序.", nil)];
            return YES;
        }
        self.menuDetailId = item.id;
//        [parent showView:SORT_TABLE_EDIT_VIEW];
//        [parent.sortTableEditView initDelegate:self event:REMOTE_SUITMENU_CHANGE_SORT action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"分组内商品排序", nil)];
//        [parent.sortTableEditView reload:changes error:nil];
//        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromTop];
        UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_sortTableEditViewControllerWithData:changes error:nil event:REMOTE_SUITMENU_CHANGE_SORT action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"分组内商品排序", nil) delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
        return YES;
        
    }
    if(event==SUITMENU_KIND){
        TreeNode* node=(TreeNode*)selectObj;
        if (![node isLeaf]) {
            [AlertBox show:NSLocalizedString(@"当前分类不是末级类，商品可放在当前分类的末级分类中.", nil)];
            return YES;
        }
        id<INameItem> item=(id<INameItem>)selectObj;
        [self.lsKindName changeData:[item obtainOrignName] withVal:[item obtainItemId]];
    }else if(event==SUITMENU_ACCOUNT){
        id<INameItem> item=(id<INameItem>)selectObj;
        [self.lsAccount changeData:[item obtainItemName] withVal:[item obtainItemName]];
    } if (KABAWMENU_ACRIDLEVEL==event) {
        NameItemVO *nameItem = (NameItemVO *)selectObj;
        [self.lsAcridLevel changeData:nameItem.itemName withVal:nameItem.itemId];
    } else if (KABAWMENU_APPROVELEVEL==event) {
        NameItemVO *nameItem = (NameItemVO *)selectObj;
        [self.lsApproveLevel changeData:nameItem.itemName withVal:nameItem.itemId];
    } else if (KABAWMENU_CHARACTER==event) {
        SpecialTagVO *specialTagItem = (SpecialTagVO *)selectObj;
        [self.lsCharacters changeData:[specialTagItem obtainItemName] withVal:[specialTagItem obtainItemId]];
    }

    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

//完成Memo输入.
-(void) finishInput:(NSInteger)event content:(NSString*)content
{
    [self.txtMemo changeData:content];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


#pragma mark -- SuitUnitListViewDelegate --

- (void)suitUnitListView:(SuitUnitListView *)view unitList:(NSArray *)unitList;
{
    if (![self isUnitListContainUnit:[self.lsAccount getStrVal] inUnitList:unitList]) {
        NameItemVO *vo = [unitList firstObject];
        [self.lsAccount changeData:vo.obtainItemName withVal:vo.obtainItemName];
    }
}

- (BOOL)isUnitListContainUnit:(NSString *)unit inUnitList:(NSArray *)unitList
{
    BOOL isContain = NO;
    for (NameItemVO *vo in unitList) {
        if ([[vo obtainItemName] isEqualToString:unit]) {
            isContain = YES;
        }
    }
    
    return isContain;
}

#pragma 选项管理页.
- (void)managerOption:(NSInteger)eventType
{
    if (eventType==SUITMENU_ACCOUNT) {

        UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_unitListViewControllerWthData:eventType delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if (eventType==SUITMENU_KIND) {

        UIViewController *vieController  = [[TDFMediator   sharedInstance] TDFMediator_kindMenuListViewController];
        [self.navigationController pushViewController:vieController animated:YES];
    }else{

        UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_specialTagListViewControllerTitle:nil menuId:nil action:0 data: self.specialTagDataList delegate:self ];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (int)getImageListKind
{
    if ([ObjectUtil isNotEmpty:self.menuDetails]) {
        for (MenuDetail *menuDetail in self.menuDetails) {
            if ([menuDetail.type isEqualToString:@"import"]) {
                return KIND_DETAIL_IMAGE;
            }else{
                return KIND_MAIN_IMAGE;
            }
        }
    }
    return KIND_MAIN_IMAGE;
}

- (NSMutableArray *)getImageFileList
{
    NSMutableArray *imageList = [[NSMutableArray alloc]init];
    if ([ObjectUtil isNotEmpty:self.menuDetails]) {
        for (MenuDetail *menuDetail in self.menuDetails) {
            [imageList addObject:menuDetail.path];
        }
    }
    return imageList;
}


- (void) clientInput:(NSString*)val event:(NSInteger)eventType
{
    if(eventType==SUITMENU_PRICE){
        [self.lsPrice changeData:val withVal:val];
    } else   if (eventType==KABAWMENU_MEMBERPRICE) {
        [self.lsMemberPrice changeData:val withVal:val];
        self.isFristPrice =YES;
    } else if (eventType==KABAWMENU_LEASTNUM) {
        [self.lsLeastNum changeData:val withVal:val];
    }else if (eventType==SUITMENU_PRICE) {
        [self.lsPrice changeData:val withVal:val];
        if (self.action ==ACTION_CONSTANTS_ADD) {
            if (!self.isFristPrice) {
                [self.lsMemberPrice initData:val withVal:val];
            }
        }
        else
        {
            if ([self.oldMemberPrice isEqualToString: self.oldPrice] && [NSString isNotBlank:self.oldMemberPrice] && [NSString isNotBlank:self.oldPrice]) {
                if (!self.isFristPrice) {
                    [self.lsMemberPrice initData:val withVal:val];
                }
            }
            
        }
    }

}

#pragma UI界面逻辑

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"addsuitmenu"];
}

#pragma ItemTitle 添加事件.
-(void) onTitleAddClick:(NSInteger)event
{
    self.suitMenuDetail = nil;
    if (event == 0) {
        self.codeType = SUITMENU_GROUP_ADD;
        [self forwardViewController:self.codeType];
    }else {
            if ([self isRequired]) {
                [AlertBox show:NSLocalizedString(@"请先添加套餐分组内可选商品", nil)];
                return;
            }
            self.codeType = SUITMENU_VALUATION_EVENT;
            self.menuHitRule = nil;
    }
    [self isSuitMenuChange];
//    self.isContinue = YES;
//    [self save];
}

-(void) onTitleSortClick:(NSInteger)event
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择排序操作", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"分组排序", nil),NSLocalizedString(@"分组内商品排序", nil),nil];
    sheet.tag=1;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}
#pragma ISampleListEvent
-(BOOL)isRequired{
    
    for (SuitMenuDetail* head in self.suitMenuDetailList) {
        NSArray *menus = self.detailMap[head._id];
        if (!head.isRequired && [ObjectUtil isNotEmpty:menus]) {
            return NO;
        }
    }
   return YES;
}
-(void) showAddEvent:(NSString*)event
{
    if([event isEqualToString:SUITMENU_VALUATION_EVENT])
    {
        if ([self isRequired]) {
            [AlertBox show:NSLocalizedString(@"请先添加套餐分组内可选商品", nil)];
            return;
        }
        self.codeType = SUITMENU_VALUATION_EVENT;
        self.menuHitRule = nil;
        [self isSuitMenuChange];
        
    }
}

-(void) showSortEvent:(NSString*)event
{
  [self sortEventForMenuMoudle:@"sortinit" menuMoudleMap:nil];
}

//添加此分组内的商品.
-(void) showAddEvent:(NSString*)event obj:(id<INameValueItem>) obj
{
    SuitMenuDetail* head=(SuitMenuDetail*)obj;
    self.currDetail=head;
    self.codeType = SUITMENU_GROUP_MENU_EDIT;
    [self isSuitMenuChange];

}

//编辑组合
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    if ([event isEqualToString:SUITMENU_VALUATION_EVENT]) {
        self.codeType = SUITMENU_VALUATION_EVENT;
        self.menuHitRule = obj;
        
    }else{
        self.codeType = SUITMENU_DEDTAIL_EVENT;
        self.suitMenuDetail = (SuitMenuDetail*)obj;
    }
    [self isSuitMenuChange];

}

#pragma 多选页结果处理.
-(void)managerEvent:(NSInteger)event
{
    if (event==SUITMENU_KIND) {

        UIViewController *viewContreoller  = [[TDFMediator sharedInstance] TDFMediator_kindMenuListViewController];
        [self.navigationController pushViewController:viewContreoller animated:YES];
    }
}

-(void)multiCheck:(NSInteger)event items:(NSMutableArray*) items
{
}

- (void)finishSelectList:(NSArray *)list
{
}

-(void)closeMultiView:(NSInteger)event
{

}

#pragma 显示选择的商品.
-(void) loadServerMenu
{

     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil) ];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"type"] = @"0";
    @weakify(self);
    [[TDFMenuService new] listSampleWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        NSMutableDictionary *dic = data[@"data"];
        self.kindMenuList = [NSMutableArray arrayWithArray:[NSMutableArray yy_modelArrayWithClass:[KindMenu class] json:dic[@"kindMenuList"]]];
        self.detailList = [NSMutableArray arrayWithArray:[NSMutableArray yy_modelArrayWithClass:[SampleMenuVO class] json:dic[@"simpleMenuDtoList"]]];
        
        self.allNodeList = [TreeBuilder buildTree:self.kindMenuList];
        self.headList  = [TreeNodeUtils convertEndNode:self.allNodeList];
        self.detailMenuMap=[[NSMutableDictionary alloc] init];
        self.menuMap=[[NSMutableDictionary alloc] init];
        NSMutableArray* arr=nil;
        
        if (self.detailList!=nil && self.detailList.count>0) {
            for (SampleMenuVO* menu in self.detailList) {
                arr=[self.detailMenuMap objectForKey:menu.kindMenuId];
                if (!arr) {
                    arr=[NSMutableArray array];
                }else{
                    [self.detailMenuMap removeObjectForKey:menu.kindMenuId];
                }
                [arr addObject:menu];
                
                if (arr && menu.kindMenuId && menu.kindMenuId.length > 0) {
                    [self.detailMenuMap setObject:arr forKey:menu.kindMenuId];
                }
                
                [self.menuMap setObject:menu forKey:menu._id];
            }
        }
        UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_selectMenuListViewControllerWthData:self.headList nodes:self.allNodeList sourceData:self.detailList dic:self.detailMenuMap delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

#pragma  SelectSingleMenuHandle delegate
-(void) closeView
{
     // [self reloadData];
     [self loadSuitDetails:self.suitMenuSample._id];
}

- (void)finishSelectMenu:(SampleMenuVO *)menu
{
    UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_suitMenuChangeEditViewControllerWithData:self.currDetail andMenuData:menu callBack:^{
        
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark forward viewController
-(void)isSuitMenuChange{
    if ([UIHelper currChange:self.container] || self.action == ACTION_CONSTANTS_ADD) {
        self.isContinue = YES;
        [self save];
       
    }else{
        [self forwardViewController:self.codeType];
    }

}
-(void)forwardViewController:(NSString *)code{

    BOOL isReload = [UIHelper currChange:self.container] || self.action == ACTION_CONSTANTS_ADD;
    if ([code isEqualToString:SUITMENU_VALUATION_EVENT]) {
        __weak typeof (self) weakSelf = self;
        [self.navigationController pushViewController:[[TDFMediator sharedInstance] TDFMediator_valuationEditViewControllerWithPrice:self.menuHitRule   suitMenuId:self.menu._id isReload:isReload action: self.menuHitRule?ACTION_CONSTANTS_EDIT:ACTION_CONSTANTS_ADD callback:^{
//            [weakSelf reloadData];
              [weakSelf loadSuitDetails:self.suitMenuSample._id];
        }] animated:YES];
    } else if ([code isEqualToString:SUITMENU_DEDTAIL_EVENT]){
        UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_menuDetailEditViewControllerWthData:self.suitMenuDetail suitMenu:self.menu action:ACTION_CONSTANTS_EDIT isContinue:NO dataArray:nil delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if ([code isEqualToString:SUITMENU_GROUP_ADD]){
        UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_menuDetailEditViewControllerWthData:nil suitMenu:self.menu action:ACTION_CONSTANTS_ADD isContinue:NO dataArray:self.suitMenuDetailList delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([code isEqualToString:SUITMENU_GROUP_SORT]){
    
    
    } else if ([code isEqualToString:SUITMENU_GROUP_MENU_DELETE]){
        
    
    } else if([code isEqualToString:SUITMENU_GROUP_MENU_EDIT]){
        if(self.headList!=nil && self.headList.count>0){

            UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_selectMenuListViewControllerWthData:self.headList nodes:self.allNodeList sourceData:self.detailList dic:self.detailMenuMap delegate:self];
            [self.navigationController pushViewController:viewController animated:YES];
        }else{
            [self loadServerMenu];
        }
    } else{
    
    }
    self.codeType  = nil;
}

- (BOOL) isChain{
    if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

- (void) updateSize{
    for (UIView *view in self.container.subviews) {
        if ([view isKindOfClass:[EditItemBase class]]) {
            CGRect frame = view.frame;
            frame.size.width = SCREEN_WIDTH;
            view.frame = frame;
        }
    }
}

- (void)navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
      [self getDefultSuitMenuProp];
      [self loadSuitDetails:self.suitMenuSample._id];
}

@end
