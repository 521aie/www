
//
//  MenuEditView.m
//  RestApp
//
//  Created by zxh on 14-5-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuEditView.h"
#import "MenuModule.h"
#import "MenuService.h"
#import "MBProgressHUD.h"
#import "ServiceFactory.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "NavigateTitle2.h"
#import "EditItemText.h"
#import "ItemTitle.h"
#import "EditItemRadio.h"
#import "EditItemRadio2.h"
#import "EditMultiList.h"
#import "EditItemList.h"
#import "Menu.h"
#import "Platform.h"
#import "RestConstants.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"
#import "MenuSpecDetail.h"
#import "RemoteEvent.h"
#import "NSString+Estimate.h"
#import "RemoteResult.h"
#import "MenuListView.h"
#import "TreeNodeUtils.h"
#import "TreeBuilder.h"
#import "JsonHelper.h"
#import "ZMTable.h"
#import "SelectSpecView.h"
#import "AlertBox.h"
#import "TreeNode.h"
#import "NumberUtil.h"
#import "SampleMenuVO.h"
#import "MenuRender.h"
#import "GlobalRender.h"
#import "TDFOptionPickerController.h"
#import "MenuModuleEvent.h"
#import "FormatUtil.h"
#import "ZmTableCell.h"
#import "TableEditView.h"
#import "Platform.h"
#import "KindMenuListView.h"
#import "MenuMakeEditView.h"
#import "RatioPickerBox.h"
#import "MakeListView.h"
#import "SpecListView.h"
#import "SystemEvent.h"
#import "EventConstants.h"
#import "MenuSpecDetailEditView.h"
#import "TDFMediator+MenuModule.h"
#import "TDFMediator+SmartModel.h"
#import "XHAnimalUtil.h"
#import "RestConstants.h"
#import "MultiCheckManageView.h"
#import "UnitListView.h"
#import "TreeNodeUtils.h"
#import "HelpDialog.h"
#import "KabawModuleEvent.h"
#import "MemoInputBox.h"
#import "MenuDetail.h"
#import "orderDetailsView.h"
#import "JSONKit.h"
#import "ObjectUtil.h"
#import "MenuCodeView.h"
#import "SettingService.h"
#import "MenuIdViewController.h"
#import "TDFBoxSelectViewController.h"
#import "TDFMenuService.h"
#import "YYModel.h"
#import "TDFGoodsService.h"
#import "TDFDataCenter.h"
#import "TDFRootViewController+FooterButton.h"
@interface MenuEditView ()<EditItemListDelegate, UnitListViewDelegate>
@property (nonatomic, assign) BOOL chainDataManageable;
@end

@implementation MenuEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        parent = parentTemp;
        service = [ServiceFactory Instance].menuService;
        systemService =[ServiceFactory Instance].systemService;
        settingService = [ServiceFactory Instance].settingService;
        orderservice =[ServiceFactory Instance].orderService;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self  initCurrentView];
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    self.menuDetails = [[NSMutableArray alloc] init];
    [self createData];
 
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [self updateSize];
}

- (void) initCurrentView
{
    hud  = [[MBProgressHUD alloc] initWithView:self.view];
}
#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"商品", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
    } else if (event==DIRECT_RIGHT) {
        self.isContinue = NO;
        [self save];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self  alertChangedMessage:[UIHelper currChange:self.container]];
  
}

- (void)rightNavigationButtonAction:(id)sender
{
    self.isContinue = NO;
    [self save];
}

- (void)initMainView
{
    self.baseTitle.lblName.text=NSLocalizedString(@"基本设置", nil);
    [self.lsKindName initLabel:NSLocalizedString(@"商品分类", nil) withHit:nil isrequest:YES delegate:self];
    [self.txtName initLabel:NSLocalizedString(@"商品名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtCode initLabel:NSLocalizedString(@"商品编码", nil) withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.menuCode initLabel:NSLocalizedString(@"菜肴二维码", nil) withHit:NSLocalizedString(@"注:您可下载并打印菜肴二维码，顾客扫码后可直接点菜。此方式多适用于明档餐厅。", nil) delegate:self];
    
    self.menuCode.imgMore.image =[UIImage imageNamed:@"ico_next"];
    self.menuCode.lblVal.text = @"";
    
    [self.lsMenuID initLabel:NSLocalizedString(@"商品ID", nil) withHit:@"" delegate:self];
    [self.lsMenuID setPlaceholder:@""];
    self.lsMenuID.imgMore.image =[UIImage imageNamed:@"ico_next"];
    
    [self.lsPrice initLabel:NSLocalizedString(@"单价(元)", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsAccount initLabel:NSLocalizedString(@"结账单位", nil) withHit:nil delegate:self];
    [self.rdoIsRatio initLabel:NSLocalizedString(@"允许打折", nil) withHit:nil delegate:nil];
    [self.isRatioView initLabel:NSLocalizedString(@"允许打折", nil) withHit:nil];
    self.titleAdvance.lblName.text=NSLocalizedString(@"高级设置", nil);
    [self.mlsMake initLabel:NSLocalizedString(@"做法", nil) delegate:self];
    [self.mlsSpec initLabel:NSLocalizedString(@"规格", nil) delegate:self];
    [self.mlsMake initSortChangeFlag:YES];
    [self.mlsSpec initSortChangeFlag:YES];
    [self.rdoIsSameUnit initLabel:NSLocalizedString(@"点菜单位与结账单位相同", nil) withHit:nil delegate:self];
    [self.isSameUnitView initLabel:NSLocalizedString(@"点菜单位与结账单位相同", nil) withHit:nil];
    [self.lsUnit initLabel:NSLocalizedString(@"▪︎ 点菜单位", nil) withHit:nil delegate:self];
    [self.lsConsume initLabel:NSLocalizedString(@"加工耗时(分钟)", nil) withHit:nil delegate:self];
    
    [self.lsDeductKind initLabel:NSLocalizedString(@"销售提成", nil) withHit:nil delegate:self];
    [self.lsDeduct initLabel:NSLocalizedString(@"▪︎ 提成金额(%)", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsServiceFeeMode initLabel:NSLocalizedString(@"收取服务费", nil) withHit:nil delegate:self];
    [self.lsServiceFee initLabel:NSLocalizedString(@"▪︎ 费用(%)", nil) withHit:nil isrequest:YES delegate:self];
    [self.rdoIsChangePrice initLabel:NSLocalizedString(@"允许收银员在收银时修改单价", nil) withHit:nil delegate:nil];
    [self.orChangePriceView initLabel:NSLocalizedString(@"允许收银员在收银时修改单价", nil) withHit:nil];
    [self.rdoIsBackAuth initLabel:NSLocalizedString(@"退菜时需要权限验证", nil) withHit:nil delegate:nil];
    [self.isBackAuthView initLabel:NSLocalizedString(@"退菜时需要权限验证", nil) withHit:nil];
    [self.rdoIsGive initLabel:NSLocalizedString(@"可作为赠菜", nil) withHit:nil delegate:nil];
    [self.isGiveView initLabel:NSLocalizedString(@"可作为赠菜", nil) withHit:nil];
    [self.rdoViewInMenu initLabel:NSLocalizedString(@"此商品仅在套餐里显示", nil) withHit:NSLocalizedString(@"注：打开后，顾客在菜单里看不见该商品，但在套餐里可以看见。", nil) delegate:self];
    [self.viewInMenuView initLabel:NSLocalizedString(@"此商品仅在套餐里显示", nil) withHit:NSLocalizedString(@"注：打开后，顾客在菜单里看不见该商品，但在套餐里可以看见。", nil)];
    [self.rdoIsSelf initLabel:NSLocalizedString(@"商品已上架", nil) withHit:nil delegate:self];
    [self.rdoIsSelf.line setHidden:YES];
    self.titleMake.lblName.text=NSLocalizedString(@"做法(非必选)", nil);
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"sort", nil];
    [self.titleMake initDelegate:self event:MENU_MAKE btnArrs:arr];
    
    NSArray *arr2 = [[NSArray alloc] init];
    self.titleSpec.lblName.text=NSLocalizedString(@"规格(非必选)", nil);
    [self.titleSpec initDelegate:self event:MENU_SPEC btnArrs:arr2];
    
    [self.makeGrid initDelegate:self event:MENU_MAKE_EVENT kindName:@"" addName:NSLocalizedString(@"添选新做法", nil) itemMode:ITEM_MODE_EDIT];
    [self.specGrid initDelegate:self event:MENU_SPEC_EVENT kindName:@"" addName:NSLocalizedString(@"添选新规格", nil) itemMode:ITEM_MODE_EDIT];
    
    [self.goodLblSet initLabel:NSLocalizedString(@"商品标签设置", nil) withHit:nil isrequest:YES delegate:self];
    self.goodLblSet.imgMore.image =[UIImage imageNamed:@"ico_next"];
    self.cusShowSet.lblName.text =NSLocalizedString(@"顾客端商品展示设置", nil);
    [self.memPrice initLabel:NSLocalizedString(@"会员价(元)", nil) withHit:nil isrequest:NO delegate:self];
    [self.startPart initLabel:NSLocalizedString(@"起点份数", nil) withHit:nil isrequest:NO delegate:self];
    //新增
    self.stepLength = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [self.stepLength awakeFromNib];
//    self.stepLength.frame = self.stepLength.view.frame;
    self.stepLength.tag = MENU_STEP_LENGTH;
    [self.stepLength initLabel:NSLocalizedString(@"顾客端点菜时最小累加单位", nil) withHit:NSLocalizedString(@"注：例如最小累加单位为2，那么顾客在手机端点此商品时，每次点击加号，都会增加2份。以此类推，最小累加单位为3，顾客每次点击加号，都会增加3份。此种方式多适用于生煎、糕点等需要按倍数点菜的情况。如果您希望按照正常情况如1.2.3.4.5.6份累加，请选择最小累加单位为1。", nil) delegate:self];
    [self.container insertSubview:self.stepLength aboveSubview:self.startPart];
  
    [self.cusBuyGood initLabel:NSLocalizedString(@"堂食可点此商品", nil) withHit:nil delegate:self];
    [self.gusBuyGoodView initLabel:NSLocalizedString(@"堂食可点此商品", nil) withHit:nil];
    [self.goodForOut initLabel:NSLocalizedString(@"外卖可点此商品", nil) withHit:nil delegate:self];
    [self.goodForOutView initLabel:NSLocalizedString(@"外卖可点此商品", nil) withHit:nil];
    [self.lsPackingNum initLabel:NSLocalizedString(@"▪︎ 餐盒数量(个)", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsPackingPrice initLabel:NSLocalizedString(@"▪︎ 餐盒规格", nil) withHit:nil isrequest:NO delegate:self];
    [self.introduceGood initLabel:NSLocalizedString(@"商品介绍", nil) detailLabel:NSLocalizedString(@"注：可以在此添加关于菜品的文字介绍，如菜品历史渊源、原料使用情况等，介绍将会展示在微信菜单中供顾客查看。", nil) isrequest:NO delegate:self];
    [self.goodPic initLabel:NSLocalizedString(@"商品图片", nil) delegate:self];
    self.goodPic.model = 1;
    [self.goodPic initImgList:nil];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.rdoViewInMenu.tag = MENU_ONLY;
    self.lsKindName.tag=MENU_KIND;
    self.lsAccount.tag=MENU_ACCOUNT;
    self.lsUnit.tag=MENU_BUYACCOUNT;
    self.mlsMake.tag=MENU_MAKE;
    self.mlsSpec.tag=MENU_SPEC;
    self.rdoIsSameUnit.tag=MENU_IS_TWO_ACCOUNT;
    self.lsDeductKind.tag=MENU_DEDUCT_KIND;
    self.lsDeduct.tag=MENU_DEDUCT;
    self.lsServiceFeeMode.tag=MENU_SERVICE_MODE;
    self.lsServiceFee.tag=MENU_SERVICE;
    self.lsPrice.tag=MENU_PRICE;
    self.lsConsume.tag=MENU_CONSUME;
    self.rdoIsSelf.tag=MENU_ISSELF;
    self.menuCode.tag = MENU_CODE;
    
    self.goodLblSet.tag =MENU_SETLABEL;
    self.memPrice.tag = KABAWMENU_MEMBERPRICE;
    self.startPart.tag =KABAWMENU_LEASTNUM;
    self.cusBuyGood.tag =KABAWMENU_ISRESERVE;
    self.goodForOut.tag= KABAWMENU_ISTAKEOUT;
    self.lsPackingNum.tag = KABAWMENU_PACKINGNUM;
    self.lsPackingPrice.tag = KABAWMENU_PACKINGPRICE;
    self.lsMenuID.tag = MENU_ID;
    [self configKeyboard];
}

- (void)createData
{
    if ([ObjectUtil  isNotEmpty:self.dic]) {
        SampleMenuVO *menuTemp  = self.dic [@"menuTemp"];
        NSString *actionStr  = self.dic [@"action"];
        NSString  *isContinueStr  = self.dic [@"isContinue"];
        id delegate  =self.dic [@"delegate"];
        self.delegate  = delegate ;
        self.chainDataManageable = [self.dic[@"chainDataManageable"] boolValue];
        [self loadData:menuTemp action:actionStr.integerValue isContinue:isContinueStr.integerValue];
    }
  
}
#pragma mark - TDFKeyboard

- (void)configKeyboard {
    
    [self.lsPrice setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
    
    [self.lsConsume setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
    [self.memPrice setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
    [self.startPart setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
    [self.lsPackingNum setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeInteger hasSymbol:NO];
    
    self.lsPrice.tdf_delegate = self;
    self.lsConsume.tdf_delegate = self;
    self.memPrice.tdf_delegate = self;
    self.startPart.tdf_delegate = self;
    self.lsPackingNum.tdf_delegate = self;
}

- (void)editItemListValueDidChanged:(EditItemList *)editItem{
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

- (void)editItemListDidFinishEditing:(EditItemList *)editItem {
    if (editItem.isChange || self.action == ACTION_CONSTANTS_ADD) {
        [self configLeftNavigationBar:Head_ICON_CANCEL
                       leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }else{
        [self configLeftNavigationBar:Head_ICON_BACK
                       leftButtonName:NSLocalizedString(@"返回", nil)];
        [self configRightNavigationBar:nil rightButtonName:nil];
    }
    NSString *val = [NSString stringWithFormat:@"%.2f",editItem.currentVal.doubleValue];
    
    if (editItem == self.lsDeduct) {
        [self.lsDeduct changeData:val withVal:val];
    } else if (self.lsServiceFee == editItem) {
        [self.lsServiceFee changeData:val withVal:val];
    } else if (self.lsPrice == editItem) {
        [self.lsPrice changeData:val withVal:val];
        if (self.action == ACTION_CONSTANTS_ADD) {
            if (!self.isFristPrice) {
                [self.memPrice initData:val withVal:val];
            }
        }
        else
        {
            if ([self.oldMemberPrice isEqualToString: self.oldPrice] && [NSString isNotBlank:self.oldMemberPrice] && [NSString isNotBlank:self.oldPrice]) {
                if (!self.isFristPrice) {
                    [self.memPrice initData:val withVal:val];
                }
            }
            
        }
    }
    else if (self.lsConsume == editItem) {
        [self.lsConsume changeData:val withVal:val];
    }
    else if (self.lsPackingNum == editItem) {
        [self.lsPackingNum changeData:val withVal:val];
    }
    else if (self.memPrice == editItem)
    {
        [self.memPrice changeData:val withVal:val];
        self.isFristPrice =YES;
    }
    else if (self.startPart == editItem)
    {
        [self.startPart changeData:val withVal:val];
    }
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_MenuEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_MenuEditView_Change object:nil];
}

#pragma remote
-(void) loadData:(SampleMenuVO *)menuTemp  action:(NSInteger)action isContinue:(BOOL)isContinue
{
    self.jsonstr =nil;
    self.oldPrice =nil;
    self.menu = nil;
    self.oldMemberPrice =nil;
    self.isFristPrice =NO;
    self.orderDic =[[NSMutableDictionary alloc]init];
    self.action=action;
    self.isContinue=isContinue;
    self.sampleMenuVO=menuTemp;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action == ACTION_CONSTANTS_ADD) {
        [self.menuCode visibal:NO];
      
    }else{
        if ([self isChain]) {
            [self.menuCode visibal:NO];
        }else{
            [self.menuCode visibal:YES];
        }
    }

    [self.lsMenuID visibal:!(action == ACTION_CONSTANTS_ADD)];
    [self.titleBox editTitle:NO act:self.action];
    [self loadKindMenuData];
    if (action==ACTION_CONSTANTS_ADD) {
        [self initEnableView];
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加商品", nil);
        self.title = NSLocalizedString(@"添加商品", nil) ;
        [self.makeGrid loadData:nil detailCount:0];
        [self.specGrid loadData:nil detailCount:0];
        self.menuSpecList = [NSMutableArray array];
        self.menuMakeList = [NSMutableArray array];
        [self.mlsMake visibal:NO];
        [self.mlsSpec visibal:NO];
        self.isFristLoad =YES;
        [self clearDo];
    } else {
        self.titleBox.lblTitle.text=self.sampleMenuVO.name;
        self.title  = self.sampleMenuVO.name ;
        [self loadMenuMakeSpec:self.sampleMenuVO._id];
    }
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self.scrollView setContentOffset:CGPointMake(0,0)];
}

- (void) enableText:(BOOL)show{
    [self orShowEdititemView:show];
    EditItemText *baseViewText;
    EditItemList *baseViewList;
    EditItemView *baseView;
    EditItemMemo *baseMenmoView;
    for (UIView *view in self.container.subviews) {
        if ([view isKindOfClass:[EditItemText class]]) {
            baseViewText = (EditItemText *)view;
            [baseViewText setEnabled:show];
        }else if ([view isKindOfClass:[EditItemList class]])
        {
            baseViewList = (EditItemList *)view;
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
            baseViewList.userInteractionEnabled = show;
            baseViewList.imgMore.hidden = !show;
        }else if ([view isKindOfClass:[EditItemView class]])
        {
            baseView = (EditItemView *)view;
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
    }
    self.menuCode.userInteractionEnabled = YES;
    self.menuCode.imgMore.hidden = NO;
    self.lsMenuID.userInteractionEnabled = YES;
    self.lsMenuID.imgMore.hidden = NO;
}

- (void)loadMenuMakeSpec:(NSString*)menuId
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"menu_id"] = [NSString isBlank:menuId]?@"":menuId;
    @weakify(self);
    [[TDFMenuService new] listMenuMakeSpecsWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [self loadFinsh:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [AlertBox show:error.localizedDescription];
    }];

}

- (void)loadKindMenuData
{
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"type"] = @"0";
    @weakify(self);
    [[TDFMenuService new] listKindMenuWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
 
        NSArray *list = [data objectForKey:@"data"];
        NSMutableArray *kindList = [JsonHelper transList:list objName:@"KindMenu"];
        self.treeNodes = [TreeBuilder buildTree:kindList];
        if (self.action == ACTION_CONSTANTS_ADD) {
            [self clearDo];
        }else{
            [self fillModel];
        }
        [self.mlsMake visibal:NO];
        [self.mlsSpec visibal:NO];
    }failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        //        @strongify(self);
        [AlertBox show:error.localizedDescription];
    }];

}

#pragma 数据层处理
-(void) clearDo
{
    [self orShowEdititemView:YES];
    NSString* lastKindMenu=[[Platform Instance] getkey:DEFAULT_KINDMENU];
    if ([NSString isBlank:lastKindMenu]) {
        TreeNode* root=[TreeNodeUtils getFirstRootKind:self.treeNodes];
        if(root==nil){
            [self.lsKindName initData:nil withVal:nil];
        } else {
            [self.lsKindName initData:[root obtainOrignName] withVal:[root obtainItemId]];
        }
    } else {
        NSMutableArray *allNodes=[TreeNodeUtils convertAllNode:self.treeNodes];
        [self.lsKindName initData:[GlobalRender obtainObjName:allNodes itemId:lastKindMenu] withVal:lastKindMenu];
    }
    [self.stepLength initData:@"1" withVal:@"1"];
    [self.txtName initData:nil];
    [self.txtCode initData:nil];
    [self.lsPrice initData:nil withVal:nil];
    [self.lsPackingNum initData:@"0" withVal:@"0"];
    self.menuProp.packingBoxId = @"";
    [self.lsPackingPrice initData:nil withVal:nil];
    [self.lsAccount initData:NSLocalizedString(@"份", nil) withVal:NSLocalizedString(@"份", nil)];
    [self.rdoIsRatio initData:@"1"];
    [self.mlsMake initData:nil];
    [self.mlsSpec initData:nil];
    [self.goodLblSet initData:nil withVal:nil];
    [self.rdoIsSameUnit initData:@"1"];
    [self.lsUnit visibal:NO];
    [self.lsConsume initData:nil withVal:nil];
    [self.lsDeductKind initData:NSLocalizedString(@"不提成", nil) withVal:[NSString stringWithFormat:@"%d",DEDUCTKIND_NOSET]];
    [self.lsDeduct visibal:NO];
    [self.lsServiceFeeMode initData:NSLocalizedString(@"不收取", nil) withVal:[NSString stringWithFormat:@"%d",SERVICEFEEMODE_NO]];
    [self.lsServiceFee visibal:NO];
    [self.rdoIsChangePrice initData:@"0"];
    [self.rdoIsBackAuth initData:@"1"];
    [self.rdoIsGive initData:@"0"];
    [self.rdoViewInMenu initData:@"0"];
    [self.rdoIsSelf initData:@"1"];
    [self.memPrice initData:@"0" withVal:@"0"];
    [self.startPart initData:@"1" withVal:@"1"];
    [self.cusBuyGood initData:@"1"];
    [self.goodForOut initData:@"1"];
    [self.introduceGood initData:nil];
    [self.goodPic initImgList:nil];
    [self isSelfRender];
    [self serviceFeeRender];
    [self.mlsMake visibal:NO];
    [self.mlsSpec visibal:NO];
       [self updateSize];
}

- (void) orShowEdititemView:(BOOL)show
{
    [self.isRatioView visibal:!show];
    [self.isSameUnitView visibal:!show];
    [self.orChangePriceView visibal:!show];
    [self.isBackAuthView visibal:!show];
    [self.isGiveView visibal:!show];
    [self.viewInMenuView visibal:!show];
    [self.goodForOutView visibal:!show];
    [self.gusBuyGoodView visibal:!show];
    self.makeGrid.footView.hidden = !show;
    self.specGrid.footView.hidden = !show;
     self.titleMake.btnSort.userInteractionEnabled = show;
    self.titleMake.imgSort.hidden = !show;
    if (!show) {
        self.makeGrid.isChain = YES;
        self.specGrid.isChain = YES;
        self.makeGrid.userInteractionEnabled = NO;
        self.specGrid.userInteractionEnabled = NO;
        if ([ObjectUtil isEmpty:self.menuMakeList]) {
            [self.makeGrid setHeight:0];
        }
        if ([ObjectUtil isNotEmpty:self.menuMakeList]){
            [self.makeGrid setHeight:self.menuMakeList.count*48];
        }
        if([ObjectUtil isEmpty:self.menuSpecList]) {
            [self.specGrid setHeight:0];
        }
        if ([ObjectUtil isNotEmpty:self.menuSpecList]){
            [self.specGrid setHeight:self.menuSpecList.count*48];
        }
    }else{
        self.makeGrid.isChain = NO;
        self.specGrid.isChain = NO;
        self.makeGrid.userInteractionEnabled = YES;
        self.specGrid.userInteractionEnabled = YES;
    }
    [self.rdoIsRatio visibal:show];
    [self.mlsMake visibal:NO];
    [self.mlsSpec visibal:NO];
    [self.rdoIsSameUnit visibal:show];
    [self.rdoIsChangePrice visibal:show];
    [self.rdoIsBackAuth visibal:show];
    [self.rdoIsGive visibal:show];
    [self.rdoViewInMenu visibal:show];
    [self.goodForOut visibal:show];
    [self.cusBuyGood visibal:show];
    [self.rdoViewInMenu visibal:show];
    [self.btnDel setHidden:self.action==ACTION_CONSTANTS_ADD];
    if (self.sampleMenuVO.chain && !self.chainDataManageable) {
        self.btnDel.hidden = YES;
    }

    self.goodPic.userInteractionEnabled = show;
}

- (void)isSelfRender
{
    self.rdoIsSelf.lblName.text=[self.rdoIsSelf getVal]?NSLocalizedString(@"商品已上架", nil):NSLocalizedString(@"商品已下架", nil);
    [self.rdoIsSelf initHit:[self.rdoIsSelf getVal]?NSLocalizedString(@"提示:在所有可点单的设备上（包括火小二）显示", nil):NSLocalizedString(@"提示:下架商品在收银设备上仍然显示并可点，在其他点菜设备（火小二、火服务生、微信点餐等）上不显示", nil)];
}

- (void)fillModel
{
    [self.isRatioView initData:self.menu.isRatio == 0?NSLocalizedString(@"不允许", nil):NSLocalizedString(@"允许", nil) withVal:self.menu.isRatio == 0?NSLocalizedString(@"不允许", nil):NSLocalizedString(@"允许", nil)];
    [self.isSameUnitView initData:self.menu.isTwoAccount==1?NSLocalizedString(@"不相同", nil):NSLocalizedString(@"相同", nil) withVal:self.menu.isTwoAccount==1?NSLocalizedString(@"不相同", nil):NSLocalizedString(@"相同", nil)];
    [self.orChangePriceView initData:self.menu.isChangePrice ==1?NSLocalizedString(@"允许", nil):NSLocalizedString(@"不允许", nil) withVal:self.menu.isChangePrice ==1?NSLocalizedString(@"允许", nil):NSLocalizedString(@"不允许", nil)];
    
    [self.isBackAuthView initData:self.menu.isBackAuth ==0?NSLocalizedString(@"不需要", nil):NSLocalizedString(@"需要", nil) withVal:self.menu.isBackAuth ==0?NSLocalizedString(@"不需要", nil):NSLocalizedString(@"需要", nil)];
    [self.isGiveView initData:self.menu.isGive==0?NSLocalizedString(@"不可", nil):NSLocalizedString(@"可以", nil) withVal:self.menu.isGive==0?NSLocalizedString(@"不可", nil):NSLocalizedString(@"可以", nil)];
    [self.viewInMenuView initData:self.menuProp.mealOnly ==0?NSLocalizedString(@"不是", nil):NSLocalizedString(@"是", nil)  withVal:self.menuProp.mealOnly ==0?NSLocalizedString(@"不是", nil):NSLocalizedString(@"是", nil)];
    
    
    
    NSMutableArray *allNodes = [TreeNodeUtils convertAllNode:self.treeNodes];
    [self.lsKindName initData:[GlobalRender obtainObjName:allNodes itemId:self.menu.kindMenuId] withVal:self.menu.kindMenuId];
    [self.txtName initData:self.menu.name];
    [self.txtCode initData:self.menu.code];
    NSString* priceStr = [FormatUtil formatDouble4:self.menu.price];
    [self.lsPrice initData:priceStr withVal:priceStr];
    [self.lsAccount initData:self.menu.account withVal:self.menu.account];
    [self.rdoIsRatio initShortData:self.menu.isRatio];
    [self.rdoIsSameUnit initShortData:(self.menu.isTwoAccount==1)?0:1];
    [self.lsUnit initData:self.menu.buyAccount withVal:self.menu.buyAccount];
    [self.lsUnit visibal:![self.rdoIsSameUnit getVal]];
    NSString* consumeStr=[NSString stringWithFormat:@"%d",self.menu.consume];
    [self.lsConsume initData:consumeStr withVal:consumeStr];
    NSMutableArray* deductKindList=[MenuRender listDeductKind];
    NSString* deductKind=[NSString stringWithFormat:@"%d",self.menu.deductKind ];
    [self.lsDeductKind initData:[GlobalRender obtainItem:deductKindList itemId:deductKind] withVal:deductKind];
    
    [self.lsDeduct initData:[FormatUtil formatDouble4:self.menu.deduct] withVal:[FormatUtil formatDouble4:self.menu.deduct]];
    [self showDeduct:self.menu.deductKind];
    
    NSMutableArray* serviceFeeModeList=[MenuRender listServiceFeeMode];
    NSString* serviceFeeMode=[NSString stringWithFormat:@"%d",self.menu.serviceFeeMode ];
    [self.lsServiceFeeMode initData:[GlobalRender obtainItem:serviceFeeModeList itemId:serviceFeeMode] withVal:serviceFeeMode];
    [self.lsServiceFee initData:[FormatUtil formatDouble4:self.menu.serviceFee] withVal:[FormatUtil formatDouble4:self.menu.serviceFee]];
    [self showServiceFee:self.menu.serviceFeeMode];
    [self.goodLblSet initData:self.menu.tagOfMenu withVal:self.menu.tagOfMenu];
    [self.lsPackingNum initData:[NSString stringWithFormat:@"%ld",(long)self.menuProp.packingBoxNum] withVal:[NSString stringWithFormat:@"%ld",(long)self.menuProp.packingBoxNum]];
    if ((self.menuProp.packingBoxName.length>0)) {
        NSString  *val =  [NSString stringWithFormat:NSLocalizedString(@"%@¥%.2f", nil),self.menuProp.packingBoxName,self.menuProp.packingBoxPrice];
        [self.lsPackingPrice initData:val withVal:val];
    }else{
        [self.lsPackingPrice initData:nil withVal:nil];
    }
    [self.rdoIsChangePrice initShortData:self.menu.isChangePrice];
    [self.rdoIsBackAuth initShortData:self.menu.isBackAuth];
    [self.rdoIsGive initShortData:self.menu.isGive];
    [self.rdoIsSelf initShortData:self.menu.isSelf];
    [self isSelfRender];
    [self serviceFeeRender];
}

-(void)fillMenuProp
{
    [self.goodPic initImgList:nil];
    NSString* memberPriceStr=[FormatUtil formatDouble4:self.menu.memberPrice];
    
    [self.memPrice initData:memberPriceStr withVal:memberPriceStr];
    NSString* leastNumStr=[NSString stringWithFormat:@"%li", (long)self.menuProp.startNum];
    if ([leastNumStr isEqualToString:@"0"]) {
        leastNumStr = @"1";
    }
    [self.startPart initData:leastNumStr withVal:leastNumStr];
    //    [self.startPart initData:leastNumStr ];
    [self.stepLength initData:[NSString stringWithFormat:@"%d",self.menuProp.stepLength] withVal:[NSString stringWithFormat:@"%d",self.menuProp.stepLength]];
    [self.rdoViewInMenu initShortData:self.menuProp.mealOnly];
    
    [self.cusBuyGood initShortData:self.menu.isReserve];
    [self.goodForOut initShortData:self.menuProp.isTakeout];
    
    if (self.menu.isSelf==1) {
        [self.goodForOutView initData:self.menu.isReserve==1?NSLocalizedString(@"可点", nil):NSLocalizedString(@"不可点", nil) withVal:self.menu.isReserve==1?NSLocalizedString(@"可点", nil):NSLocalizedString(@"不可点", nil)];
        [self.gusBuyGoodView initData:self.menuProp.isTakeout==1?NSLocalizedString(@"可点", nil):NSLocalizedString(@"不可点", nil) withVal:self.menuProp.isTakeout==1?NSLocalizedString(@"可点", nil):NSLocalizedString(@"不可点", nil)];
        [self.cusBuyGood initShortData:self.menu.isReserve];
        [self.goodForOut initShortData:self.menuProp.isTakeout];
        if ([self.cusBuyGood getVal]) {
            [self.lsPackingNum initData:[NSString stringWithFormat:@"%ld",(long)self.menuProp.packingBoxNum] withVal:[NSString stringWithFormat:@"%ld",(long)self.menuProp.packingBoxNum]];
        }else{
            [self.lsPackingNum initData:@"0" withVal:@"0"];
        }
    } else {
        //[self.cusBuyGood initShortData:0];
        //[self.goodForOut initShortData:0];
        [self.goodForOutView initData:NSLocalizedString(@"不可点", nil) withVal:NSLocalizedString(@"不可点", nil)];
        [self.gusBuyGoodView initData:NSLocalizedString(@"不可点", nil) withVal:NSLocalizedString(@"不可点", nil)];
    }
    
    [self.introduceGood initData:self.menu.memo];
    [self subVisibal];
    //    [self loadMenuImg:self.menu.id];
}

- (void) saveData
{
    if (self.isContinue) {
        [self proceeResult:self.menu sampleMenu:self.sampleMenu];
        // [parent.menuListView loadMenus];
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[MenuListView class]]) {
                [(MenuListView *)viewController  loadMenus];
            }
        }
        [self loadData:self.sampleMenu  action:ACTION_CONSTANTS_EDIT isContinue:self.isContinue];
        [self continueAdd:self.continueEvent];
        
    }
    else
    {
        if (self.isupdateMenu) {
            [self proceeResult:self.menu sampleMenu:self.sampleMenu];
            self.IdStr =self.sampleMenu._id;
            //        [SystemEvent dispatch:REFRESH_MAIN_VIEW];
            [self loadData:self.sampleMenu  action:ACTION_CONSTANTS_EDIT isContinue:NO];
            [self getPicWithImage:self.imagedata target:self.boxdata];
        }
        else
        {
            [self.navigationController popViewControllerAnimated: YES];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
           
           
        }
    }
}

-(void)findFinish:(RemoteResult *)result{
    
    if (result.isRedo) {
        [self.progressHud setHidden:YES];
        return;
    }
    if (!result.isSuccess) {
        [self.progressHud setHidden:YES];
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary *map = [JsonHelper transMap:result.content];
    BOOL isSetting = [[map objectForKey:@"data"] boolValue];
    [self.menuCode visibal:isSetting];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
}

-(void) subVisibal
{
    BOOL isOpen=[self.goodForOut getVal];
    [self.lsPackingNum visibal:isOpen];
    [self.lsPackingPrice visibal:isOpen];
    
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification *)notification
{
    if (self.action  == ACTION_CONSTANTS_EDIT) {
        [self configNavigationBar: [UIHelper currChange:self.container]];
    }
 //  [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

-(void)remoteFinsh:(NSMutableDictionary*) data
{

    NSMutableDictionary *dic = data[@"data"];
    self.menu = [Menu yy_modelWithJSON:dic[@"menuSimpleVo"]];
    self.menu._id = self.menu.id;
    self.sampleMenu=[self.menu convertVO];
    [self proceeResult:self.menu sampleMenu:self.sampleMenu];
    
    if (self.isContinue) {
        
        if ([NSString isBlank:self.jsonstr]) {
            [self proceeResult:self.menu sampleMenu:self.sampleMenu];
            
            [self loadData:self.sampleMenu action:ACTION_CONSTANTS_EDIT isContinue:self.isContinue];
            [self continueAdd:self.continueEvent];
        }
        else
        {
            [self saveData];
        }
        
    } else {
        if ([NSString isBlank:self.jsonstr]) {
            [self.navigationController popViewControllerAnimated: YES];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
        }
        else
        {
            [self saveData];
        }
    }
}


//保存商品与做法和规格的关系.
-(void)remoteRelationFinish:(RemoteResult*) result
{
    [self.progressHud setHidden:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    self.isContinue=NO;
    [self loadRelation];
}


- (void)savedata:(RemoteResult *)result
{
    
    [self.progressHud setHidden:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    self.isupdateMenu  = NO;
    self.IdStr =self.sampleMenu._id;
    [self loadData:self.sampleMenu action:ACTION_CONSTANTS_EDIT isContinue:NO];
    [self getPicWithImage:self.imagedata target:self.boxdata];
}

- (void)loadRelation
{

    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"menu_id"] = [NSString isBlank:self.sampleMenuVO._id]?@"":self.sampleMenuVO._id;
    @weakify(self);
    [[TDFMenuService new] listMenuMakeSpecsWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud   setHidden:YES];
        [self loadFinsh:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud   setHidden:YES];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [AlertBox show:error.localizedDescription];
    }];


}

-(void)proceeResult:(Menu *)menu sampleMenu:(SampleMenuVO *)sampleMenu
{
    [[Platform Instance] saveKeyWithVal:DEFAULT_KINDMENU withVal:menu.kindMenuId];
}

- (void)initMenuMakeDic
{
    self.menuMakeDic = [NSMutableDictionary dictionary];
    for (MenuMake* mm in self.menuMakeList) {
        [self.menuMakeDic setObject:mm forKey:mm.makeId];
    }
}

- (void)initMenuSpecDic
{
    self.menuSpecDic = [NSMutableDictionary dictionary];
    for (MenuSpecDetail* mm in self.menuSpecList) {
        mm.defaultPrice = mm.menuPrice*mm.priceRatio;
        if (mm.addMode==ADDMODE_AUTO) {
            mm.definePrice = mm.menuPrice*mm.priceRatio;
        } else if (mm.addMode==ADDMODE_HAND) {
            mm.definePrice = mm.priceScale;
        }
        mm.priceScale = mm.definePrice;
        
        [self.menuSpecDic setObject:mm forKey:mm.specItemId];
    }
}

- (void)loadFinsh:(NSMutableDictionary *)data
{

    [self.menuDetails removeAllObjects];
    NSMutableDictionary *dic = data[@"data"];
    self.menu = [Menu yy_modelWithDictionary:dic[@"menuSimpleVo"]];
    self.menu._id = self.menu.id;
    [self.mlsMake initData:nil];
    [self.mlsSpec initData:nil];
    
    self.menuMakeList = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[MenuMake class] json:dic[@"menuMakeList"]]];
    [self initMenuMakeDic];
    self.oldMenuMakeList = [self.menuMakeList mutableCopy];
    [self.mlsMake initData:[self.menuMakeList mutableCopy]];
    [self.mlsMake visibal:NO];
    [self.makeGrid loadData:self.menuMakeList detailCount:self.menuMakeList.count];
    self.IdStr =self.menu.id;
    
    self.menuSpecList = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[MenuSpecDetail class] json:dic[@"menuSpecDetailList"]]];
    [self initMenuSpecDic];
    if ([NSString isNotBlank:self.menu.path]) {
        MenuDetail *detail = [[MenuDetail alloc] init];
        detail.id = self.menu.id;
        detail._id = self.menu.id;
        detail.path = self.menu.path;
        detail.filePath = self.menu.filePath;
        detail.type = @"import";
        [self.menuDetails addObject:detail];
    }
    self.menuProp = [MenuProp yy_modelWithDictionary:dic[@"menuProp"]];
    self.menuProp.acridLevel=self.menu.acridLevel;
    //    self.menuProp.isReserve=self.menu.isReserve;
    self.oldMenuSpecList = [self.menuSpecList mutableCopy];
    [self.mlsSpec initData:[self.menuSpecList mutableCopy]];
    [self.mlsSpec visibal:NO];
    [self.specGrid loadData:self.menuSpecList detailCount:self.menuSpecList.count];
    self.oldPrice =[NSString stringWithFormat:@"%f",self.menu.price];
    self.oldMemberPrice =[NSString stringWithFormat:@"%f",self.self.menu.memberPrice];
    [self.menuDetails addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MenuDetail class] json:dic[@"menuDetailVoList"]]];
    [self fillModel];
    [self fillMenuProp];
    [self initEnableView];
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self updateSize];
   
}

- (void) initEnableView
{
    if (self.sampleMenuVO.chain && !self.chainDataManageable) {
        [self enableText:NO];
        self.goodPic.isHideDelImgBtn = YES;
        [self.goodPic initImgObject:self.menuDetails];
    }else{
        [self enableText:YES];
        self.goodPic.isHideDelImgBtn = NO;
        [self.goodPic initImgList:self.menuDetails];
    }
}

#pragma save-data
- (BOOL)isValid
{
    if (self.sampleMenuVO.chain && !self.chainDataManageable) {
        return YES;
    }
    if ([NSString isBlank:[self.lsKindName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"商品分类不能为空!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"商品名称不能为空!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.goodLblSet getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"商品标签设置不能为空!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"单价(元)不能为空!", nil)];
        return NO;
    }
    if (![NSString isFloat:[self.lsPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"单价(元)不是数字!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsAccount getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"结账单位不能为空!", nil)];
        return NO;
    }
    
    if (![self.rdoIsSameUnit getVal] && [NSString isBlank:[self.lsUnit getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"点菜单位不能为空!", nil)];
        return NO;
    }
    
    if ([NSString isNotBlank:[self.lsConsume getStrVal]] && ![NSString isPositiveNum:[self.lsConsume getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"加工耗时不是数字!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsDeductKind getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"请选择【销售提成】!", nil)];
        return NO;
    }
    
    NSString *fixDeduct = [NSString stringWithFormat:@"%d", DEDUCTKIND_FIX];
    NSString *ratioDeduct = [NSString stringWithFormat:@"%d", DEDUCTKIND_RATIO];
    if ([fixDeduct isEqualToString:[self.lsDeductKind getStrVal]] || [ratioDeduct isEqualToString:[self.lsDeductKind getStrVal]]) {
        if ([NSString isBlank:[self.lsDeduct getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"提成金额不能为空!", nil)];
            return NO;
        }
        
        if (![NSString isFloat:[self.lsDeduct getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"提成金额不是数字!", nil)];
            return NO;
        }
    }
    
    NSString *fiexServiceFee = [NSString stringWithFormat:@"%d",SERVICEFEEMODE_FIX];
    NSString *ratioServiceFee = [NSString stringWithFormat:@"%d",SERVICEFEEMODE_RATIO];
    if ([fiexServiceFee isEqualToString:[self.lsServiceFeeMode getStrVal]] || [ratioServiceFee isEqualToString:[self.lsServiceFeeMode getStrVal]]) {
        if ([NSString isBlank:[self.lsServiceFee getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"费用(服务费)不能为空!", nil)];
            return NO;
        }
        
        if (![NSString isFloat:[self.lsServiceFee getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"费用(服务费)不是数字!", nil)];
            return NO;
        }
    }
    if (![NSString isFloat:[self.memPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"会员价不是数字!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.startPart getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"起点份数不能为空!", nil)];
        return NO;
    }
    
    if ([self.cusBuyGood getVal]) {
        
        if ([[self.lsPackingNum getDataLabel] integerValue] >100) {
            [AlertBox show:NSLocalizedString(@"打包盒数量不能超过100!", nil)];
            return NO;
        }
    }
    return YES;
}

#pragma mark 对象处理.
- (Menu *)transMode
{
    Menu *obj = [Menu new];
    obj.id = self.menu.id;
    obj.name = [self.txtName getStrVal];
    obj.kindMenuId = [self.lsKindName getStrVal];
    obj.code = [self.txtCode getStrVal];
    obj.price = [self.lsPrice getStrVal].doubleValue;
    if (self.menu.memberPrice == self.menu.price) {
        obj.memberPrice = obj.price;
    } else {
        obj.memberPrice = self.menu.memberPrice;
    }
    obj.account = [self.lsAccount getStrVal];
    obj.isRatio = [self.rdoIsRatio getVal]?1:0;
    obj.isTwoAccount = [self.rdoIsSameUnit getVal]?0:1;
    if ([self.rdoIsSameUnit getVal]) {
        obj.buyAccount = [self.lsAccount getStrVal];
    } else {
        obj.buyAccount = [self.lsUnit getStrVal];
    }
    if ([NSString isNotBlank:[self.lsConsume getStrVal]]) {
        obj.consume = [self.lsConsume getStrVal].intValue;
    }
    obj.deductKind = [self.lsDeductKind getStrVal].intValue;
    if ([NSString isNotBlank:[self.lsDeductKind getStrVal]]) {
        obj.deduct = [self.lsDeduct getStrVal].doubleValue;
    }
    obj.serviceFeeMode = [self.lsServiceFeeMode getStrVal].intValue;
    if ([NSString isNotBlank:[self.lsServiceFee getStrVal]]) {
        obj.serviceFee = [self.lsServiceFee getStrVal].doubleValue;
    }
    obj.isBackAuth = [self.rdoIsBackAuth getVal]?1:0;
    obj.isChangePrice = [self.rdoIsChangePrice getVal]?1:0;
    obj.isGive = [self.rdoIsGive getVal]?1:0;
    obj.isSelf = [self.rdoIsSelf getVal]?1:0;
    obj.tagOfMenu =[self.goodLblSet getStrVal];
    if ([ObjectUtil isNotEmpty:self.orderDic]) {
        NSString *indexstr =[NSString stringWithFormat:@"%@",self.orderDic[@"acridLevel"]];
        obj.acridLevel =indexstr.intValue;
        NSString *recodIndex =[NSString stringWithFormat:@"%@",self.orderDic[@"recommendLevel"]];
        
        obj.recommendLevel=recodIndex.intValue;
        recodIndex =[NSString stringWithFormat:@"%@",self.orderDic[@"tagSource"]];
        obj.tagSource =recodIndex.intValue;
        obj.specialTagId =[NSString stringWithFormat:@"%@",self.orderDic[@"specialTagId"]];
        obj.specialtagString =[NSString stringWithFormat:@"%@",self.orderDic[@"specialtagString"]];
    }
    
    
    if ([NSString isNotBlank:[self.memPrice getStrVal]]) {
        obj.memberPrice=[self.memPrice getStrVal].doubleValue;
    } else {
        obj.memberPrice=self.menu.price;
    }
    obj.isValid = self.menuProp.isValid;
    obj.memo = [self.introduceGood getStrVal];
    obj.isReserve = [self.cusBuyGood getVal]?1:0;
    return obj;
}

- (NSMutableArray *)getMakeIds
{
    NSMutableArray *idList=[NSMutableArray array];
    NSMutableArray *oldItems=[self.mlsMake getCurrList];
    if (oldItems==nil || [oldItems count]==0) {
        return idList;
    }
    NSMutableString* result=nil;
    for (MenuMake* oldItem in oldItems) {
        result=[NSMutableString string];
        [result appendString:oldItem.makeId];
        [idList addObject:(NSString*)result];
    }
    return idList;
}

- (NSMutableArray *)getSpecIds
{
    NSMutableArray *idList=[NSMutableArray array];
    NSMutableArray *oldItems=[self.mlsSpec getCurrList];
    if (oldItems==nil || [oldItems count]==0) {
        return idList;
    }
    NSMutableString* result=nil;
    for (MenuSpecDetail* oldItem in oldItems) {
        result=[NSMutableString string];
        [result appendString:oldItem.specItemId];
        [idList addObject:(NSString*)result];
    }
    return idList;
}

- (void)save
{
    if (![self isValid]) {
        return;
    }
    Menu *objTemp=[self transMode];
    MenuProp *objMenuprop =[self transModeProp];
    if (self.sampleMenuVO.chain && !self.chainDataManageable) {
        if ([self.rdoIsSelf getVal]) {
            [self showProgressHudWithText:NSLocalizedString(@"正在上架", nil)];
            NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
            parma[@"is_self"] = @"1";
            parma[@"menu_id_str"] = [[NSArray arrayWithObject:self.menu.id] yy_modelToJSONString];
            @weakify(self);
            [[TDFMenuService new] updateIsSelfWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                @strongify(self);
                [self.progressHud  setHidden:YES];
                 [self.navigationController popViewControllerAnimated: YES];
                if (self.delegate) {
                    [self.delegate navitionToPushBeforeJump:nil data:nil];
                }
              
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud  setHidden:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }else{
             [self showProgressHudWithText:NSLocalizedString(@"正在下架", nil)];
            NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
            parma[@"is_self"] = @"0";
            parma[@"menu_id_str"] = [[NSArray arrayWithObject:self.menu.id] yy_modelToJSONString];
            @weakify(self);
            [[TDFMenuService new] updateIsSelfWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                @strongify(self);
                [self.progressHud setHidden:YES];
                 [self.navigationController popViewControllerAnimated: YES];
                if (self.delegate) {
                    [self.delegate navitionToPushBeforeJump:nil data:nil];
                }
//                [XHAnimalUtil animalEdit:parent action:self.action];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    [self.progressHud  setHidden:YES];
                    [AlertBox show:error.localizedDescription];
                }];
            
        }
    }
    else{
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"menu_str"] = [objTemp yy_modelToJSONString];
    parma[@"menu_prop_str"] = [objMenuprop yy_modelToJSONString];
    parma[@"menu_label_str"] = self.jsonstr;
    @weakify(self);
    [[TDFMenuService new] saveOrUpdateMenuWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud  setHidden:YES];
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[MenuListView class]]) {
                [(MenuListView *)viewController  loadMenus];
            }
        }
        [self remoteFinsh:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud  setHidden:YES];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [AlertBox show:error.localizedDescription];
    }];
    }
}

- (void)presave
{
    if (![self isValid]) {
        return;
    }
    Menu *objTemp=[self transMode];
    MenuProp *objMenuprop =[self transModeProp];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"menu_str"] = [objTemp yy_modelToJSONString];
    parma[@"menu_prop_str"] = [objMenuprop yy_modelToJSONString];
    parma[@"menu_label_str"] = self.jsonstr;
    if (self.action == ACTION_CONSTANTS_ADD)  {
        @weakify(self);
        [[TDFMenuService new] saveOrUpdateMenuWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[MenuListView class]]) {
                    [(MenuListView *)viewController  loadMenus];
                }
            }
            [self.progressHud   setHidden:YES];
            NSMutableDictionary *dic = data[@"data"];
            self.menu = [Menu yy_modelWithJSON:dic[@"menuSimpleVo"]];
            self.menu._id = self.menu.id;
            self.sampleMenu=[self.menu convertVO];
            [self proceeResult:self.menu sampleMenu:self.sampleMenu];
            [self saveData];
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud   setHidden:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
        
    }
    else {
        @weakify(self);
        [[TDFMenuService new] saveOrUpdateMenuWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud   setHidden:YES];
            NSMutableDictionary *dic = data[@"data"];
            self.menu = [Menu yy_modelWithJSON:dic[@"menuSimpleVo"]];
            self.menu._id = self.menu.id;
            self.sampleMenu=[self.menu convertVO];
            [self proceeResult:self.menu sampleMenu:self.sampleMenu];
            if ([NSString isNotBlank:self.jsonstr]) {
                [orderservice saveShopSetLblList:self.menu.id menulabelStr:self.jsonstr target:self callback:@selector(savedata:)];
            }else{
                        self.isupdateMenu  = NO;
                        self.IdStr =self.sampleMenu._id;
                        [self loadData:self.sampleMenu action:ACTION_CONSTANTS_EDIT isContinue:NO];
                        [self getPicWithImage:self.imagedata target:self.boxdata];
                    }

        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud  setHidden:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];

   }
}

- (IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.menu.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){

        [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.menu.name]];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"menu_id"] = [NSString isBlank:self.menu.id]?@"":self.menu.id;
        //        @weakify(self);
        [[TDFMenuService new] removeMenuWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            //            @strongify(self);
            [self.progressHud  setHidden:YES];
            NSString* actionStr=[NSString stringWithFormat:@"%d",ACTION_CONSTANTS_DEL];
            NSMutableDictionary* dic=[NSMutableDictionary dictionary];
            dic[@"menuId"] = self.menu.id;
            dic[@"action"] = actionStr;
            [[NSNotificationCenter defaultCenter] postNotificationName:MenuModule_Menu_EDIT_Change object:dic] ;

            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud setHidden:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (void) serviceFeeRender
{
    NSString *mode=[NSString stringWithFormat:@"%d",SERVICEFEEMODE_NO ];
    BOOL noService=[mode isEqualToString:[self.lsServiceFeeMode getStrVal]];
    [self.lsServiceFeeMode initHit:noService?@"":NSLocalizedString(@"提示：只有在“营业设置>附加费”中添加一个附加费，并将服务费的计费标准设置为“按每个商品的服务费收取”时，此处设置的服务费才会生效.", nil)];
}

#pragma test event
#pragma edititemlist click event.
- (void)onItemListClick:(EditItemList *)obj
{
    if (obj.tag==MENU_KIND) {
        NSMutableArray *endNodes = [TreeNodeUtils convertDotEndNode:self.treeNodes level:4 showAll:NO];
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:self.lsKindName.lblName.text
                                                                                      options:endNodes
                                                                                currentItemId:[self.lsKindName getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
       
        [wself pickOption:endNodes[index] event:self.lsKindName.tag];
    };
    pvc.shouldShowManagerButton = YES;
    pvc.manageTitle = NSLocalizedString(@"分类管理", nil);
    pvc.managerBlock = ^void(){
        [wself dismissViewControllerAnimated:YES completion:nil];
        [wself managerOption:wself.lsKindName.tag];
    };
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:pvc animated:YES completion:nil];
    } else if (obj.tag==MENU_ACCOUNT || obj.tag==MENU_BUYACCOUNT) {
        [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil) ];
        [TDFGoodsService fetchFoodUnitWithCompleteBlock:^(TDFResponseModel *response) {
            if ([response isSuccess]) {
                  [self.progressHud setHidden:YES];
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
                    pvc.competionBlock = ^void(NSInteger index) {
                        
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
                  [self.progressHud  setHidden:YES];
                [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"取消", nil)];
            }
        }];
    } else if (obj.tag==MENU_DEDUCT_KIND) {
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[MenuRender listDeductKind]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[MenuRender listDeductKind][index] event:obj.tag];
        };
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pvc animated:YES completion:nil];
        
        
        
    } else if(obj.tag==MENU_SERVICE_MODE) {
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[MenuRender listServiceFeeMode]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[MenuRender listServiceFeeMode][index] event:obj.tag];
        };
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pvc animated:YES completion:nil];
    } else if(obj.tag==MENU_SERVICE) {
        NSString *fiexServiceFee = [NSString stringWithFormat:@"%d", SERVICEFEEMODE_FIX];
        NSString *ratioServiceFee = [NSString stringWithFormat:@"%d", SERVICEFEEMODE_RATIO];
        if ([fiexServiceFee isEqualToString:[self.lsServiceFeeMode getStrVal]]) {
            
            [self.lsServiceFee setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
            [self.lsServiceFee.lblVal becomeFirstResponder];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.lsServiceFee.lblVal performSelector:NSSelectorFromString(@"removeGesture") withObject:nil];
#pragma clang diagnostic pop
        } else if ([ratioServiceFee isEqualToString:[self.lsServiceFeeMode getStrVal]]) {
            int ratio=100;
            if ([NSString isNotBlank:[obj getStrVal]] && ![@"0" isEqualToString:[obj getStrVal]]) {
                ratio=[obj getStrVal].intValue;
            }
            self.lsServiceFee.lblVal.inputView = nil;
            [RatioPickerBox initData:ratio];
            [RatioPickerBox show:obj.lblName.text client:self event:obj.tag];
        }
    } else if (obj.tag==MENU_DEDUCT) {
        NSString *fixDeduct = [NSString stringWithFormat:@"%d",DEDUCTKIND_FIX ];
        NSString *ratioDeduct = [NSString stringWithFormat:@"%d",DEDUCTKIND_RATIO ];
        if ([fixDeduct isEqualToString:[self.lsDeductKind getStrVal]]) {
            [self.lsDeduct setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
            [self.lsDeduct.lblVal becomeFirstResponder];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.lsDeduct.lblVal performSelector:NSSelectorFromString(@"removeGesture") withObject:nil];
#pragma clang diagnostic pop
        } else if ([ratioDeduct isEqualToString:[self.lsDeductKind getStrVal]]) {
            int ratio = 100;
            if ([NSString isNotBlank:[obj getStrVal]] && ![@"0" isEqualToString:[obj getStrVal]]) {
                ratio = [obj getStrVal].intValue;
            }
            self.lsDeduct.lblVal.inputView = nil;
            [RatioPickerBox initData:ratio];
            [RatioPickerBox show:obj.lblName.text client:self event:obj.tag];
        }
    }else if (obj.tag == MENU_SETLABEL)
    {
        if (self.action ==ACTION_CONSTANTS_ADD) {
            UIViewController  *viewController  = [[TDFMediator  sharedInstance]  TDFMediator_orderDetailsViewControllerTitle:NSLocalizedString(@"商品", nil) menuId:nil action:ACTION_CONSTANTS_ADD delegate:self];
            [self.navigationController pushViewController:viewController animated:YES];

        }
        else
        {
             UIViewController  *viewController  = [[TDFMediator  sharedInstance]  TDFMediator_orderDetailsViewControllerTitle:self.sampleMenuVO.name menuId:self.sampleMenuVO._id  action:ACTION_CONSTANTS_EDIT delegate:self];
            [self.navigationController pushViewController: viewController animated:YES];
        }
        
    } else if (obj.tag == MENU_CODE){
        
        UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_menuCodeViewControllerWthDataData:self.menu kind:Kind_Menu event:5 delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }else if (obj.tag == MENU_ID){
        TDFMediator *meditor = [[TDFMediator alloc] init];
        UIViewController *menuIDViewController = [meditor TDFMediator_menuIDViewControllerWithMenuName:self.menu.name menuID:self.menu.id];
        [self.navigationController pushViewController:menuIDViewController animated:YES];
    }else if (obj.tag == KABAWMENU_PACKINGPRICE){
        TDFMediator *meditor = [[TDFMediator alloc]init];
        __typeof(self) __weak wself = self;
        UIViewController *boxSelectViewController =[meditor TDFMediator_boxSelectViewControllerWithPackingBoxId:self.menuProp.packingBoxId
                                                                                                   withCallBack:^(NSString *menuName,double price,NSString *menuId){
                                                                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                           wself.menuProp.packingBoxName = menuName;
                                                                                                           wself.menuProp.packingBoxId =menuId,
                                                                                                           wself.menuProp.packingBoxPrice = price;
                                                                                                           NSString  *val =  [NSString stringWithFormat:NSLocalizedString(@"%@¥%.2f", nil),self.menuProp.packingBoxName,self.menuProp.packingBoxPrice];
                                                                                                           [self.lsPackingPrice changeData:val withVal:val];                                          });
                                                        }];
        [self.navigationController pushViewController:boxSelectViewController animated:YES];
    } else if (obj.tag == MENU_STEP_LENGTH)
    {
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"顾客端点菜时最小累加单位", nil)
                                                                                      options:[[MenuRender render] menuStepLengthArray]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[[MenuRender render] menuStepLengthArray][index] event:obj.tag];
        };
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pvc animated:YES completion:nil];
    }
}


//多选List控件变换.
- (void)onMultiItemListClick:(EditMultiList *)obj
{
    
}

//Radio控件变换.
- (void)onItemRadioClick:(EditItemRadio *)obj
{
    if (obj.tag==MENU_IS_TWO_ACCOUNT) {
        [self.lsUnit visibal:![obj getVal]];
    } else if (obj.tag==MENU_ISSELF) {
        if (![obj getVal] &&self.menu.isForceMenu) {
            [obj initData:@"1"];
            self.rdoIsSelf.lblName.text=1?NSLocalizedString(@"商品已上架", nil):NSLocalizedString(@"商品已下架", nil);
            [self.rdoIsSelf initHit:1?NSLocalizedString(@"提示:在所有可点单的设备上（包括火小二）显示", nil):NSLocalizedString(@"提示:下架商品在收银设备上仍然显示并可点，在其他点菜设备（火小二、火服务生、微信点餐等）上不显示", nil)];
            [AlertBox show:NSLocalizedString(@"此商品被设定为必选商品了，无法下架，请先解除必选商品。", nil)];
            return;
        }
        [self isSelfRender];
    }else if (obj.tag == MENU_ONLY){
        if ([obj getVal] && self.menu.isForceMenu) {
            [obj initData:@"0"];
            [AlertBox show:NSLocalizedString(@"此商品是必选商品，不能使用此功能。", nil)];
            return;
        }
    }
    
    if (obj.tag== KABAWMENU_ISRESERVE) {
//        if(![self.rdoIsSelf getVal] && [obj getVal]){
//            [obj initShortData:0];
//            [AlertBox show:NSLocalizedString(@"商品已下架,不能开启堂食可点此商品!", nil)];
//            return;
//        }
        if (![obj getVal]&&self.menu.isForceMenu) {
            [obj initData:@"1"];
            [AlertBox show:NSLocalizedString(@"此商品被设定为必选商品了，不能关闭此功能。", nil)];
            return;
        }
    }
    
    if (obj.tag==KABAWMENU_ISTAKEOUT) {
//        if(![self.rdoIsSelf getVal] && [obj getVal]){
//            [obj initShortData:0];
//            [AlertBox show:NSLocalizedString(@"商品已下架,不能开启外卖可点此商品!", nil)];
//            return;}
//        
//        [self subVisibal];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
//Demo控件.
-(void) onItemMemoListClick:(EditItemMemo *)obj
{
    [MemoInputBox show:1 delegate:self title:NSLocalizedString(@"商品介绍", nil) val:[self.introduceGood  getStrVal]];
}

//完成Memo输入
- (void)finishInput:(NSInteger)event content:(NSString *)content
{
    [self.introduceGood changeData:content];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

//开始导入图片
- (void)startUploadImage:(UIImage *)imageData target:(EditImageBox *)targat
{
    self.imagedata =imageData;
    self.boxdata =targat;
    self.isupdateMenu = YES;
    if ([UIHelper currChange:self.container]) {
        [self presave];

    }
    else
    {
        if ([self isValid]) {   //解决原先版本的商品标签未设置的BUG
            [self getPicWithImage:imageData target:targat];
        }
//        [self getPicWithImage:imageData target:targat];
    }
}

-(void)getPicWithImage:(UIImage *)imageData target:(EditImageBox *)target
{
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSString *filePath = [NSString stringWithFormat:@"%@/menu/%@.png", entityId, [NSString getUniqueStrByUUID]];
    self.imgFilePathTemp = filePath;
    
    [self showProgressHudWithText:NSLocalizedString(@"正在上传", nil)];
    [systemService uploadImage:filePath image:imageData width:1280 heigth:1280 Target:self Callback:@selector(uploadImgFinsh:)];
}
//移除图片
- (void)startRemoveImage:(id<IImageData>)imageData target:(EditImageBox *)targat
{
    int kind;
    if (imageData!=nil && [imageData isKindOfClass:[MenuDetail class]]) {
        MenuDetail *menuDetail = (MenuDetail *)imageData;
        if ([menuDetail.type isEqualToString:@"import"]) {
            kind = KIND_MAIN_IMAGE;
        }else{
            kind= KIND_DETAIL_IMAGE;
        }

        [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"menu_id"] = [NSString isBlank:self.menu.id]?@"":self.menu.id;
        parma[@"menu_detail_id"] = [NSString isBlank:menuDetail.id]?@"":menuDetail.id;;
        parma[@"kind"] = [NSString stringWithFormat:@"%d",kind];
        @weakify(self);
        [[TDFMenuService new] removeMenuImgWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud setHidden:YES];
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[MenuListView class]]) {
                    [(MenuListView *)viewController  loadMenus];
                }
            }
            [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
            [self loadMenuMakeSpec:self.menu.id];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud setHidden:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (void)removeMenuImgFinsh:(RemoteResult *)result
{
    [self.progressHud setHidden:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];

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

    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"menu_id"] = [NSString isBlank:self.menu.id]?@"":self.menu.id;
    parma[@"file_path"] = self.imgFilePathTemp;
    parma[@"kind"] = [NSString stringWithFormat:@"%ld",(long)kind];
    @weakify(self);
    [[TDFMenuService new] saveMenuImgWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[MenuListView class]]) {
                [(MenuListView *)viewController  loadMenus];
            }
        }
        [self loadMenuMakeSpec:self.menu.id];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [AlertBox show:error.localizedDescription];
    }];
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
//获取图片路径数组
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

//获取客户端数据
- (void)loadCustomerData:(NSString *)menuId
{
    [self.goodPic initImgList:nil];

    [self loadMenuMakeSpec:menuId];
}

- (BOOL)isCustomerValid
{
    if (self.menu==nil) {
        [AlertBox show:NSLocalizedString(@"请选择商品!", nil)];
        return NO;
    }
    if (![NSString isFloat:[self.memPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"会员价不是数字!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.startPart getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"起点份数不能为空!", nil)];
        return NO;
    }
    
    return YES;
}

- (Menu *)CustomerTransMode
{
    if ([NSString isNotBlank:[self.memPrice getStrVal]]) {
        self.menu.memberPrice=[self.memPrice getStrVal].doubleValue;
    } else {
        self.menu.memberPrice=self.menu.price;
    }
    
    self.menu.memo = [self.introduceGood getStrVal];
    self.menu.isReserve = [self.cusBuyGood getVal]?1:0;
    if ([ObjectUtil isNotEmpty: self.orderDic]) {
        NSString *indexstr =[NSString stringWithFormat:@"%@",self.orderDic[@"acridLevel"]];
        self.menu.acridLevel =indexstr.intValue;
    }
    
    return self.menu;
}

- (MenuProp *)transModeProp
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        self.menuProp =[[MenuProp alloc]init];
    }
    self.menuProp.isTakeout=[[self.goodForOut getStrVal] integerValue];
    self.menuProp.isReserve =[self.cusBuyGood getVal]?1:0 ;
    self.menuProp.mealOnly = [self.rdoViewInMenu getVal]?1:0;
    self.menuProp.stepLength = [[self.stepLength getStrVal] intValue];
    self.menuProp.startNum=[[self.startPart getStrVal] integerValue];
    if ([ObjectUtil isNotEmpty:self.orderDic]) {
        NSString *str =[NSString stringWithFormat:@"%@",self.orderDic[@"showTop"]];
        self.menuProp.showTop =str.intValue;
    }
    if ([self.goodForOut getVal]) {
        
        self.menuProp.packingBoxNum = [[self.lsPackingNum getStrVal] integerValue];
        
    }else{
        self.menuProp.packingBoxPrice = 0.00;
        self.menuProp.packingBoxNum = 0;
    }
    return self.menuProp;
}

-(NSString *)getImagstr
{
    int kind = [self getImageListKind];
    NSDictionary *dict=@{@"id":self.menu.id,@"path":self.imgFilePathTemp,@"kind":[NSString stringWithFormat:@"%ld",(long)kind]};
    NSString *str =[dict JSONString];
    
    return str ;
}

#pragma 刷新分类
- (void)refreshNewKind:(NSMutableArray *)kindList
{
    self.treeNodes   = kindList;
}

#pragma 变动的结果.
#pragma 单选页结果处理.
- (BOOL)pickOption:(id)selectObj event:(NSInteger)event
{
    if (event==MENU_DEDUCT_KIND) {
        id<INameItem> item=(id<INameItem>)selectObj;
        [self.lsDeductKind changeData:[item obtainItemName] withVal:[item obtainItemId]];
        [self showDeduct:[item obtainItemId].intValue];
        [self.lsDeduct changeData:nil withVal:nil];
    } else if (event==MENU_SERVICE_MODE) {
        id<INameItem> item=(id<INameItem>)selectObj;
        [self.lsServiceFeeMode changeData:[item obtainItemName] withVal:[item obtainItemId]];
        [self showServiceFee:[item obtainItemId].intValue];
        [self.lsServiceFee changeData:nil withVal:nil];
        [self serviceFeeRender];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    } else if (event==MENU_KIND) {
        TreeNode* node=(TreeNode*)selectObj;
        if (![node isLeaf]) {
            [AlertBox show:NSLocalizedString(@"当前分类不是末级类，商品可放在当前分类的末级分类中.", nil)];
            return YES;
        }
        id<INameItem> item=(id<INameItem>)selectObj;
        [self.lsKindName changeData:[item obtainOrignName] withVal:[item obtainItemId]];
    } else if (event==MENU_DEDUCT) {
        NSString* result=(NSString*)selectObj;
        [self.lsDeduct changeData:result withVal:result];
    } else if (event==MENU_SERVICE) {
        NSString* result=(NSString*)selectObj;
        [self.lsServiceFee changeData:result withVal:result];
    } else if (event==MENU_ACCOUNT) {
        id<INameItem> item=(id<INameItem>)selectObj;
        [self.lsAccount changeData:[item obtainItemName] withVal:[item obtainItemName]];
    } else if (event==MENU_BUYACCOUNT) {
        id<INameItem> item=(id<INameItem>)selectObj;
        [self.lsUnit changeData:[item obtainItemName] withVal:[item obtainItemName]];
    } else if (event == MENU_STEP_LENGTH)
    {
        id<INameItem> item=(id<INameItem>)selectObj;
        [self.stepLength changeData:[item obtainItemName] withVal:[item obtainItemName]];
        [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

#pragma mark -- UnitListViewDelegate --

- (void)unitListView:(UnitListView *)view unitList:(NSArray *)unitList
{
    if (![self isUnitListContainUnit:[self.lsAccount getStrVal] inUnitList:unitList]) {
        NameItemVO *vo = [unitList firstObject];
        [self.lsAccount changeData:vo.obtainItemName withVal:vo.obtainItemName];
    }
    
    if (![self isUnitListContainUnit:[self.lsUnit getStrVal] inUnitList:unitList]) {
        NameItemVO *vo = [unitList firstObject];
        [self.lsUnit changeData:vo.obtainItemName withVal:vo.obtainItemName];
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
    if (eventType==MENU_ACCOUNT || eventType==MENU_BUYACCOUNT) {

        UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_unitListViewControllerWthData:eventType delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (eventType==MENU_KIND) {
//        [parent showView:KINDMENU_LIST_VIEW];
//        [parent.kindMenuListView initBackView:MENU_EDIT_VIEW];
//        [parent.kindMenuListView loadKindMenuData];
//        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromTop];
          UIViewController  *viewController  = [[TDFMediator  sharedInstance] TDFMediator_kindListViewControllerWithDelegate:self backIndex:MENU_EDIT_VIEW];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


- (void)clientInput:(NSString *)val event:(NSInteger)eventType
{
    if (eventType==MENU_DEDUCT) {
        [self.lsDeduct changeData:val withVal:val];
    } else if (eventType==MENU_SERVICE) {
        [self.lsServiceFee changeData:val withVal:val];
    } else if (eventType==MENU_PRICE) {
        [self.lsPrice changeData:val withVal:val];
        if (self.action ==ACTION_CONSTANTS_ADD) {
            if (!self.isFristPrice) {
                [self.memPrice initData:val withVal:val];
            }
        }
        else
        {
            if ([self.oldMemberPrice isEqualToString: self.oldPrice] && [NSString isNotBlank:self.oldMemberPrice] && [NSString isNotBlank:self.oldPrice]) {
                if (!self.isFristPrice) {
                    [self.memPrice initData:val withVal:val];
                }
            }
            
        }
    }  else if (eventType==MENU_CONSUME) {
        [self.lsConsume changeData:val withVal:val];
    }
    else if (eventType == KABAWMENU_PACKINGNUM) {
        [self.lsPackingNum changeData:val withVal:val];
    }else if (eventType ==KABAWMENU_MEMBERPRICE)
    {
        [self.memPrice changeData:val withVal:val];
        self.isFristPrice =YES;
    }
    else if (eventType == KABAWMENU_LEASTNUM)
    {
        [self.startPart changeData:val withVal:val];
    }
}

- (void)closeListEvent:(NSString *)event
{
//    [parent showView:MENU_EDIT_VIEW];
//    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
}

- (void)sortEvent:(NSString *)event ids:(NSMutableArray *)ids
{
    NSMutableArray* temps;
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[TableEditView class]]) {
//             temps= parent.tableEditView.datas;
            TableEditView *tabEdit  = (TableEditView *)viewController;
            temps  = tabEdit.datas;
        }
    }
//    temps= parent.tableEditView.datas;
    self.menuMakeList=[temps mutableCopy];
    [self initMenuMakeDic];
    [self.mlsMake changeData:self.menuMakeList];
    [self.mlsMake visibal:NO];
    BOOL menuMakeChange=[self checkMenuMakeChange];
    [self.titleBox editTitle:menuMakeChange act:self.action];
    [self.makeGrid loadData:self.menuMakeList detailCount:self.menuMakeList.count];
    [self closeListEvent:event];
}

#pragma UI界面逻辑
- (void)showDeduct:(short)val
{
    if (val==0 || val==1) {
        [self.lsDeduct visibal:NO];
        return;
    }
    [self.lsDeduct visibal:YES];
    self.lsDeduct.lblName.text=[MenuRender getDeductdLabel:val];
}

-(void) showServiceFee:(short)val
{
    if (val==0) {
        [self.lsServiceFee visibal:NO];
        return;
    }
    [self.lsServiceFee visibal:YES];
    self.lsServiceFee.lblName.text=[MenuRender getServiceFeeLabel:val];
}

#pragma ItemTitle 添加事件.
- (void)onTitleAddClick:(NSInteger)event
{
    if (event==MENU_MAKE) {
        [self showAddEvent:MENU_MAKE_EVENT];
    } else {
        [self showAddEvent:MENU_SPEC_EVENT];
    }
}

-(void) onTitleSortClick:(NSInteger)event
{
    if (self.menuMakeList==nil || self.menuMakeList.count<2) {
        [AlertBox show:NSLocalizedString(@"请至少添加两条内容,才能进行排序.", nil)];
        return;
    }
//    [parent showView:TABLE_EDIT_VIEW];
   //  [parent.tableEditView initDelegate:self event:@"menumakesort" action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil)];
    // [parent.tableEditView reload:self.menuMakeList error:nil];
 //   [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromTop];
//    UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_tableEditViewControllerWithData:self.menuMakeList error:nil event:@"menumakesort" action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil) delegate:self];
    UIViewController *viewConroller   = [[TDFMediator  sharedInstance] TDFMediator_sortTableEditViewControllerWithData:self.menuMakeList error:nil event:@"menumakesort" action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil) delegate:self];
    [self.navigationController pushViewController: viewConroller animated:YES];
}

#pragma ISampleListEvent
- (void)showAddEvent:(NSString *)event
{
    if (self.action==ACTION_CONSTANTS_ADD) {
        self.isContinue=YES;
        self.continueEvent=event;
        [self save];
        return;
    } else if (self.action==ACTION_CONSTANTS_EDIT) {
        if ([self hasChanged]) {
            self.isContinue=YES;
            self.continueEvent=event;
            [self save];
        } else {
            self.makeList =[NSMutableArray new];
            self.specDetailList = [[NSMutableArray alloc] init];
            [self continueAdd:event];
        }
    }
}

- (void)continueAdd:(NSString *)event
{
    if ([event isEqualToString:MENU_MAKE_EVENT]) {
        if (self.makeList!=nil && self.makeList.count>0) {
            [self showMultiMake];
        } else {
            [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
            @weakify(self);
            [[TDFMenuService new] listMake:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                @strongify(self);
                [self.progressHud  setHidden:YES];
                 self.makeList = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[Make class] json:data[@"data"]]];
                [self showMultiMake];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud  setHidden:YES];
                [UIHelper refreshUI:self.container scrollview:self.scrollView];
                [AlertBox show:error.localizedDescription];
            }];
        }
    } else {
        if (self.specDetailList!=nil && self.specDetailList.count>0) {
            [self showMultiSpec];
        } else {
            [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
             @weakify(self);
            [[TDFMenuService new] listSpec:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                @strongify(self);
                [self.progressHud  setHidden:YES];
                self.specDetailList = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[SpecDetail class] json:data[@"data"]]];
                [self showMultiSpec];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                @strongify(self);
                [self.progressHud  setHidden:YES];
                [UIHelper refreshUI:self.container scrollview:self.scrollView];
                [AlertBox show:error.localizedDescription];
            }];
        }
    }
}

- (void) showMultiSpec
{
    if ([NSString isBlank:[self.lsPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"单价(元)不能为空!", nil)];
        return;
    }
    if (![NSString isFloat:[self.lsPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"单价(元)不是数字!", nil)];
        return;
    }
    
    NSMutableArray* selIds=[NSMutableArray new];
    if (self.menuSpecList!=nil && self.menuSpecList.count>0) {
        for (MenuSpecDetail* ms in self.menuSpecList) {
            [selIds addObject:ms.specItemId];
        }
    }
    
    NSString *eventStr  =[NSString stringWithFormat:@"%d" ,MENU_SPEC ];
    NSDictionary *constDic  = @{@"event" : eventStr , @"title" : NSLocalizedString(@"选规格", nil) , @"managerName" : NSLocalizedString(@"规格库\n  管理", nil)  };
    UIViewController  *viewController  = [[TDFMediator sharedInstance] TDFMediator_selectSpecViewControllerWthData:self.specDetailList selectList:selIds specDic:constDic detailName:NSLocalizedString(@"规格", nil)  delegate:self];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) showMultiMake
{
    NSMutableArray* selIds=[NSMutableArray new];
    if (self.menuMakeList!=nil && self.menuMakeList.count>0) {
        for (MenuMake* mm in self.menuMakeList) {
            [selIds addObject:mm.makeId];
        }
    }
    [parent.multiCheckManageView loadData:self.makeList  selectList:selIds];
    
    NSString *eventStr  =[NSString stringWithFormat:@"%d" ,MENU_MAKE ];
    NSDictionary *constDic  = @{@"event" : eventStr , @"title" : NSLocalizedString(@"选做法", nil) , @"managerName" : NSLocalizedString(@"做法库\n  管理", nil) };
    UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_multiCheckManageViewControllerWthData:self.makeList selectList:selIds  detailName:NSLocalizedString(@"做法", nil) constDic:constDic delegate:self];
    [self.navigationController  pushViewController:viewController animated:YES];
    [self.progressHud setHidden:YES];
}

- (void)showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    if ([event isEqualToString:MENU_MAKE_EVENT]) {
        MenuMake* temp=(MenuMake*)obj;
        UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_menuMakeEditViewControllerWthData:temp menu:self.menu action:ACTION_CONSTANTS_EDIT delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else {
        MenuSpecDetail* temp=(MenuSpecDetail*)obj;
        UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_menuSpecDetailEditViewControllerWthData:temp menu:self.menu action:ACTION_CONSTANTS_EDIT delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
}

#pragma 多选页结果处理.
- (void)managerEvent:(NSInteger)event
{
    if (event==MENU_MAKE) {   //做法库管理.
        UIViewController  *viewController  = [[TDFMediator sharedInstance] TDFMediator_makeListViewControllerWthData:self.makeList delegate:self];
        [self.navigationController pushViewController: viewController animated:YES];
    } else {
        UIViewController *viewController  = [[TDFMediator sharedInstance]  TDFMediator_specListViewControllerWthData:self.specDetailList  isRefresh:NO delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)multiCheck:(NSInteger)event items:(NSMutableArray*)items
{
    if (event==MENU_MAKE) {
        MenuMake* menuMake=nil;
        MenuMake* oldMenuMake=nil;
        NSMutableArray* newList=[NSMutableArray array];
        if (items!=nil && items.count>0) {
            for (Make* temp in items) {
                menuMake=[MenuMake new];
                menuMake.name=temp.name;
                menuMake.makeId=temp._id;
                
                oldMenuMake=[self.menuMakeDic objectForKey:temp._id];
                if (oldMenuMake!=nil) {
                    menuMake._id=oldMenuMake._id;
                    menuMake.makePrice=oldMenuMake.makePrice;
                    menuMake.makePriceMode=oldMenuMake.makePriceMode;
                } else {
                    menuMake.makePrice=0;
                    menuMake.makePriceMode=MAKEPRICE_NONE;
                }
                [newList addObject:menuMake];
            }
        }
        
        self.menuMakeList=newList;
        [self initMenuMakeDic];
        [self.mlsMake changeData:newList];
        [self.mlsMake visibal:NO];
        NSMutableArray* makeIds=[self getMakeIds];
    
        [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil) ];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"menu_id"] = [NSString isBlank:self.menu.id]?@"":self.menu.id;
        parma[@"make_ids_str"] = [makeIds yy_modelToJSONString];
        @weakify(self);
        [[TDFMenuService new] saveMenuMakeListWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud  setHidden:YES];
            self.isContinue=NO;
            [self loadRelation];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud setHidden:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];

    } else if (event==MENU_SPEC) {
        MenuSpecDetail* menuSpecDetail=nil;
        MenuSpecDetail* oldSpecDetail=nil;
        double price;
        price=[self.lsPrice getStrVal].doubleValue;
        
        NSMutableArray* newList=[NSMutableArray array];
        if(items!=nil && items.count>0){
            for (SpecDetail* temp in items) {
                menuSpecDetail=[MenuSpecDetail new];
                menuSpecDetail.specItemId=temp._id;
                menuSpecDetail.specDetailName=temp.name;
                menuSpecDetail.menuPrice=price;
                oldSpecDetail = [self.menuSpecDic objectForKey:temp._id];
                if (oldSpecDetail!=nil) {
                    menuSpecDetail._id=oldSpecDetail._id;
                    menuSpecDetail.priceRatio=oldSpecDetail.priceRatio==0?1:oldSpecDetail.priceRatio;
                    menuSpecDetail.rawScale=oldSpecDetail.rawScale;
                    menuSpecDetail.priceScale=oldSpecDetail.priceScale;
                    menuSpecDetail.addMode=oldSpecDetail.addMode;
                } else {
                    menuSpecDetail.addMode=ADDMODE_AUTO;
                    menuSpecDetail.priceRatio=temp.priceScale==0?1:temp.priceScale;
                    menuSpecDetail.rawScale=temp.rawScale;
                    menuSpecDetail.priceScale=menuSpecDetail.priceRatio*price;
                }
                
                [newList addObject:menuSpecDetail];
            }
        }
        
        self.menuSpecList=newList;
        [self.mlsSpec changeData:newList];
        [self.mlsSpec visibal:NO];
        NSMutableArray* specIds=[self getSpecIds];
        
//        [parent showView:MENU_EDIT_VIEW];
//        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
        [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"menu_id"] = [NSString isBlank:self.menu.id]?@"":self.menu.id;
        parma[@"spec_ids_str"] = [specIds yy_modelToJSONString];
        @weakify(self);
        [[TDFMenuService new] saveMenuSpecDetailListWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud  setHidden:YES];
            self.isContinue=NO;
            [self loadRelation];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud  setHidden:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
   }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)closeMultiView:(NSInteger)event
{
    [self loadMenuMakeSpec:self.menu.id];
}

- (void)menuMakeChange:(MenuMake *)make act:(NSInteger)action
{
    if (self.menuMakeList==nil || self.menuMakeList.count==0) {
        return;
    }
    if (action==ACTION_CONSTANTS_EDIT) {
        int pos=0;
        for (MenuMake* mm in self.menuMakeList) {
            if ([mm.makeId isEqualToString:make.makeId]) {
                break;
            }
            pos++;
        }
        [self.menuMakeList replaceObjectAtIndex:pos withObject:make];
    } else if (action==ACTION_CONSTANTS_DEL) {
        for (MenuMake* mm in self.menuMakeList) {
            if ([mm.makeId isEqualToString:make.makeId]) {
                [self.menuMakeList removeObject:mm];
                break;
            }
        }
    }
    [self initMenuMakeDic];
    [self.mlsMake changeData:self.menuMakeList];
    [self.mlsMake visibal:NO];
    BOOL menuMakeChange=[self checkMenuMakeChange];
    [self.titleBox editTitle:menuMakeChange act:self.action];
    [self.makeGrid loadData:self.menuMakeList detailCount:self.menuMakeList.count];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


- (void)sortEventForMenuMoudle:(NSString*)event menuMoudleMap:(NSMutableDictionary*)menuMoudleMap
{
    [self showProgressHudWithText:NSLocalizedString(@"正在排序", nil) ];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"menu_make_sort_str"] = [JsonHelper dictionaryToJson:menuMoudleMap];
    
    @weakify(self);
    [[TDFMenuService new] sortMenuMakeWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [self loadMenuMakeSpec:self.sampleMenuVO._id];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

//修改规格后，影响到现有的数据变化.
- (void)loadSpecChange:(SpecDetail*)spec isAdjust:(NSInteger)isAdjust
{
    if (self.menuSpecList==nil || self.menuSpecList.count==0) {
        return;
    }
    for (MenuSpecDetail* mn in self.menuSpecList) {
        if ([mn.specItemId isEqualToString:spec._id]) {
            if (isAdjust==1) {
                mn.priceRatio=spec.priceScale;
                mn.priceScale=spec.priceScale*mn.menuPrice;
            } else {
                mn.priceRatio=spec.priceScale;
            }
        }
    }
    [self initMenuSpecDic];
    [self.mlsSpec changeData:self.menuSpecList];
    [self.mlsSpec visibal:NO];
    BOOL menuSpecChange=[self checkMenuSpecChange];
    [self.titleBox editTitle:menuSpecChange act:self.action];
    [self.specGrid loadData:self.menuSpecList detailCount:self.menuSpecList.count];
}

#pragma 检查商品规格是否改变（缺省变化检查不了这个复杂的变化）.
- (BOOL)checkMenuSpecChange
{
    NSInteger count=(self.oldMenuSpecList==nil?0:self.oldMenuSpecList.count);
    NSMutableArray* oldItems=[self.mlsSpec getCurrList];
    NSInteger oldCount=(oldItems==nil?0:oldItems.count);
    if(count!=oldCount){
        return YES;
    }
    BOOL isExist=NO;
    for (MenuSpecDetail* mn in self.oldMenuSpecList) {
        isExist=NO;
        for (MenuSpecDetail* mo in oldItems) {
            if ([mn.specItemId isEqualToString:mo.specItemId]) {
                isExist=YES;
                if(mn.priceScale!=mo.priceScale){
                    return YES;
                }
            }
        }
        if (!isExist) {
            return YES;
        }
    }
    return NO;
}

#pragma 检查商品做法是否改变（缺省变化检查不了这个复杂的变化）.
- (BOOL)checkMenuMakeChange
{
    NSInteger count=(self.oldMenuMakeList==nil?0:self.oldMenuMakeList.count);
    NSMutableArray* oldItems=[self.mlsMake getCurrList];
    NSInteger oldCount=(oldItems==nil?0:oldItems.count);
    if(count!=oldCount){
        return YES;
    }
    MenuMake* mn=nil;
    MenuMake* mo=nil;
    for (int i=0; i<[self.oldMenuMakeList count]; i++) {
        mn=[self.oldMenuMakeList objectAtIndex:i];
        mo =[oldItems objectAtIndex:i];
        if (![mn.makeId isEqualToString:mo.makeId]) {
            return YES;
        }
        if(mn.makePriceMode!=mo.makePriceMode){
            return YES;
        }
        if(mn.makePrice!=mo.makePrice){
            return YES;
        }
    }
    return NO;
}

- (void)footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"basemenu"];
}

- (BOOL)hasChanged
{
    return self.txtName.isChange || self.lsKindName.isChange || self.txtCode.isChange || self.lsPrice.isChange || self.lsAccount.isChange || self.rdoIsRatio.isChange || self.rdoIsSameUnit.isChange || self.lsUnit.isChange || self.lsConsume.isChange || self.lsDeductKind.isChange || self.lsDeduct.isChange ||
    self.lsServiceFeeMode.isChange || self.lsServiceFee.isChange || self. rdoIsChangePrice.isChange || self.rdoIsBackAuth.isChange || self.rdoIsGive.isChange || self.rdoViewInMenu.isChange || self.rdoIsSelf.isChange||self.goodLblSet.isChange;
}

-(void)getmenuActionstr:(NSMutableDictionary*)dic jsonstr:(NSString *)jsonstr
{
    self.orderDic =dic;
    self.jsonstr =jsonstr;
    NSString *str =[NSString stringWithFormat:@"%@",self.orderDic[@"tagOfMenu"]];
    if (self.action == ACTION_CONSTANTS_EDIT) {
        NSString *recommendLevel =dic[@"recommendLevel"];
        NSString *recommendLevelString =dic[@"recommendLevelString"];
        NSString *showTop =dic[@"showTop"];
        NSString *specialTagId =dic[@"specialTagId"];
        NSString *specialTagString=dic [@"specialTagString"];
        NSString *tagSource =dic[@"tagSource"];
        NSString *acridLevel =dic[@"acridLevel"];
        NSString *acridLevelString =dic[@"acridLevelString"];
        self.menuProp.recommendLevel =recommendLevel.integerValue;
        self.menuProp.recommendLevelString =recommendLevelString;
        self.menuProp.showTop =showTop.integerValue;
        self.menuProp.specialTagId =specialTagId;
        self.menuProp.specialTagString =specialTagString;
        self.menuProp.tagSource =tagSource.integerValue;
        self.menuProp.acridLevel =acridLevel.intValue;
        self.menuProp.acridLevelString =acridLevelString;
    }
    if (self.action == ACTION_CONSTANTS_ADD) {
     [self.goodLblSet changeData:str withVal:str];
    }
    else
      {
      [self.goodLblSet initData:str withVal:str];
       }
}

- (void)navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
    NSMutableDictionary *params = obj;
    if ([ObjectUtil  isNotEmpty:params]) {
        NSMutableDictionary *dic  = params [@"editDic"];
        NSString *jsonStr   = params [@"jsonStr"];
        [self getmenuActionstr:dic jsonstr:jsonStr];
    }
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

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    
}

@end
