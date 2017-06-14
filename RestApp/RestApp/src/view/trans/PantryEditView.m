//
//  PantryEditView.m
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "PantryEditView.h"
#import "Area.h"
#import "TransService.h"
#import "MenuService.h"
#import "MBProgressHUD.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "ObjectUtil.h"
#import "NavigateTitle.h"
#import "RemoteEvent.h"
#import "KabawModuleEvent.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "EditItemRadio.h"
#import "EditMultiList.h"
#import "ItemTitle.h"
#import "JsonHelper.h"
#import "ZmTableCell.h"
#import "NSString+Estimate.h"
#import "TDFOptionPickerController.h"
#import "SelectMenuListView.h"
#import "MultiCheckView.h"
#import "UIView+Sizes.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "FormatUtil.h"
#import "PantryListView.h"
#import "AlertBox.h"
#import "SystemUtil.h"
#import "Pantry.h"
#import "XHAnimalUtil.h"
#import "Menu.h"
#import "KindMenu.h"
#import "ZMTable.h"
#import "ColorHelper.h"
#import "PantryPlanArea.h"
#import "MenuProducePlan.h"
#import "NameItemVO.h"
#import "PantryRender.h"
#import "GlobalRender.h"
#import "TransModuleEvent.h"
#import "SelectMultiMenuListView.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "TDFMediator+SupplyChain.h"
#import "TDFMediator+TransModule.h"
#import "TDFSeatService.h"
#import "TDFMenuService.h"
#import "TDFTransService.h"
#import "PantryMenuVO.h"
#import "TDFLoginService.h"
#import "INameValueItem.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFSelectGoodsWithPlateViewController.h"

@interface PantryEditView ()
@property (nonatomic, strong) EditItemRadio *rdoIsPrinter;
@property (nonatomic, strong) EditItemList *lsPantryDevices;
@property (nonatomic, strong) EditItemList *lsTagspec;
@property (nonatomic, assign) BOOL isCashierVersion;
@property (nonatomic ,strong) NSMutableArray *nodeList;
@property (nonatomic ,strong) NSMutableArray *goodList;
@property (nonatomic ,strong) NSMutableArray *areaList;
//@property (nonatomic, strong) NSMutableArray *detailList;

@property (nonatomic, strong) NSMutableArray *originGoodList;
@property (nonatomic, strong) NSMutableArray *originAreaList;
@property (nonatomic, strong) NSMutableArray *originKindList;

@property (nonatomic, strong) NSMutableArray *updateGoodList;
@property (nonatomic, strong) NSMutableArray *updateAreaList;
@property (nonatomic, strong) NSMutableArray *updateKindList;
@property (nonatomic, strong) NSMutableArray *modules;
@end
@implementation PantryEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory Instance].transService;
        menuService = [ServiceFactory Instance].menuService;
        clientSocket = [[AsyncSocket alloc] initWithDelegate:self];
        [clientSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    self.originGoodList = [NSMutableArray array];
    self.originKindList = [NSMutableArray array];
    self.originAreaList = [NSMutableArray array];
    self.updateAreaList = [NSMutableArray array];
    self.updateGoodList = [NSMutableArray array];
    self.updateKindList = [NSMutableArray array];
    self.areaList = [NSMutableArray array];
    self.goodList = [NSMutableArray array];
    self.nodeList = [NSMutableArray array];
    [self layoutViews];
    [self initMainView];
    [self initNavigate];
    [self loadCashierVersion];
//    [self getAllMenuList];
    [self initNotifaction];
    [self.txtName setEnabled:!(!self.chainDataManageable && self.pantry.isChain)];
}
#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    self.titleBox.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"传菜方案", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

-(void)layoutViews{
    
    [self.container insertSubview:self.baseTitle atIndex:0];
    [self.container insertSubview:self.txtName aboveSubview:self.baseTitle];
    [self.container insertSubview:self.rdoIsPrinter aboveSubview:self.txtName];
    [self.container insertSubview:self.lsPantryDevices aboveSubview:self.rdoIsPrinter];
    [self.container insertSubview:self.txtType aboveSubview:self.lsPantryDevices];
    [self.container insertSubview:self.lsTagspec  aboveSubview:self.lsIp];
}
#pragma notification 处理.

- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_PantryEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_PantryEditView_Change object:nil];
    
}

//获取打印机设备的名字
- (void)initPrintTypeName
{
    [self showProgressHudWithText: NSLocalizedString(@"正在加载", nil) ];
    [[TDFTransService new] getPrintTypeNameSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud  setHidden: YES];
        [self parsegetTypeName:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud  setHidden:YES];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [AlertBox show:error.localizedDescription];
    }];
    
}


- (void)parsegetTypeName:(id)data
{
    self.PrintTypeArr =[[NSMutableArray alloc]init];
    NSMutableArray *iteams =[data objectForKey:@"data"];
    for (NSDictionary *obj in iteams) {
        NSString *name =[obj objectForKey:@"name"];
        NSString *val =[obj objectForKey:@"val"];
        NameItemVO*nameIo=[[NameItemVO alloc]initWithVal:name andId:val];
        [self.PrintTypeArr addObject:nameIo];
    }
    if(self.action == ACTION_CONSTANTS_ADD)
    {
        [self clearDo];
    }
    else
    {
        [self fillModel];
    }
}
- (void)initMainView
{
    self.baseTitle.lblName.text=NSLocalizedString(@"基本设置", nil);
    [self.txtType initLabel:NSLocalizedString(@"打印机类型", nil) withHit:nil isrequest:YES delegate:self ];
    [self.txtName initLabel:NSLocalizedString(@"传菜方案名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    
    [self.lsWidth initLabel:NSLocalizedString(@"打印纸宽度", nil) withHit:nil delegate:self];
    
    [self.lsIp initLabel:NSLocalizedString(@"打印机IP", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsCharCount initLabel:NSLocalizedString(@"每行打印字符数", nil) withHit:nil delegate:self];
    [self.lsPrintNum initLabel:NSLocalizedString(@"打印份数", nil) withHit:nil delegate:self];
    
    [self.rdoIsCut initLabel:NSLocalizedString(@"一菜一切", nil) withHit:nil delegate:self];
    [self.rdoIsTotalPrint initLabel:NSLocalizedString(@"▪︎ 同时打印一份总单", nil) withHit:nil delegate:self];
    [self.rdoIsAllArea initLabel:NSLocalizedString(@"全部区域", nil) withHit:nil delegate:self];
    
    self.titleKind.lblName.text=NSLocalizedString(@"使用此设备传菜的分类", nil);
    self.titleMenu.lblName.text=NSLocalizedString(@"使用此设备传菜的商品", nil);
    self.titleArea.lblName.text=NSLocalizedString(@"使用此设备传菜的区域", nil);
    
    [self.kindGrid initDelegate:self event:PANTRY_KIND_EVENT kindName:@"" addName:NSLocalizedString(@"添选分类", nil) itemMode:ITEM_MODE_DEL];
    [self.menuGrid initDelegate:self event:PANTRY_MENU_EVENT kindName:@"" addName:NSLocalizedString(@"添选商品", nil) itemMode:ITEM_MODE_DEL];
    [self.areaGrid initDelegate:self event:PANTRY_AREA_EVENT kindName:@"" addName:NSLocalizedString(@"添选区域", nil) itemMode:ITEM_MODE_DEL];
    self.printHintLib.text=NSLocalizedString(@"提示:\n1.传菜仅支持网口打印机。\n2.火掌柜与打印机需在同一个有线或无线网内才能打印测试页。\n3.请根据您打印机的实际型号选择，若选择错误可能会出现丢单情况。\n4.特别推荐您使用爱普生U220,新款斯普瑞特品牌打印机，二维火对此两款打印机作了适配，可大大降低打印出错风险。\n5.使用新款斯普瑞特时需要注意：一台打印机不能同时作后厨和前台打印机，否则会出现混乱。", nil);
    [self.printHintLib setTextColor:[ColorHelper getTipColor6]];
    self.lblTip.text=NSLocalizedString(@"提示:\n单独关联过传菜设备的商品，无法跟随分类所在的传菜方案进行打印。如：“可乐”单独关联了方案1进行传菜，即使可乐所属的分类“饮料”关联了方案2,“可乐”也只是在方案1的设备上打印。", nil);
    [self.lblTip setTextColor:[ColorHelper getTipColor6]];
    [self.lblTip sizeToFit];
    [self initialValue];
    self.txtType.tag =PANTRY_TYPE;
    self.lsWidth.tag=PANTRY_ISWIDTH;
    self.lsIp.tag=PANTRY_PRINTIP;
    self.lsCharCount.tag=PANTRY_CHARCOUNT;
    self.lsPrintNum.tag=PANTRY_PRINTNUM;
    self.rdoIsCut.tag = PANTRY_IS_CUT_RATIO;
    self.rdoIsTotalPrint.tag = PANTRY_IS_TOTAL_PRINT_RATIO;
    self.rdoIsAllArea.tag = PANTRY_IS_ALL_AREA_RATIO;
    
    [self.lsIp setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeIPAddress hasSymbol:NO];
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void)rightNavigationButtonAction:(id)sender
{
    self.isContinue = NO;
    [self save];
    
}

#pragma remote
- (void)loadData:(Pantry*) tempVO action:(int)action isContinue:(BOOL)isContinue
{
    self.action=action;
    self.pantry=tempVO;
    self.isContinue=isContinue;
    [self initPrintTypeName];
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.title=NSLocalizedString(@"添加传菜方案", nil);
    } else {
        self.title =tempVO.name;
    }
    [self.titleBox editTitle:NO act:self.action];
}

#pragma 数据层处理
- (void)clearDo
{
    [self.txtName initData:nil];
    [self.rdoIsAllArea initShortData:1];
    [self initialValue];
    [self showArea];
    self.pantryPlanAreas = [NSMutableArray array];
    self.kinds = [NSMutableArray array];
    [self.kindGrid loadData:nil  detailCount:0];
    [self.menuGrid loadData:nil detailCount:0];
    [self.areaGrid loadData:nil detailCount:0];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
-(void)initialValue{
    [self.txtType initData:NSLocalizedString(@"请选择", nil) withVal:NSLocalizedString(@"请选择", nil)];
    self.txtType.lblVal.textColor = [UIColor grayColor];
    [self.lsIp initData:nil withVal:nil];
    self.lsIp.lblVal.textColor = [UIColor redColor];
    NSMutableArray* printNums=[PantryRender listPrintNums];
    NameItemVO* vo=[printNums firstObject];
    [self.lsPrintNum initData:vo.itemName withVal:vo.itemId];
    [self.lsWidth initData:@"58mm" withVal:@"58"];
    [self.lsCharCount initData:NSLocalizedString(@"32个字符", nil) withVal:@"32"];
    [self.rdoIsCut initShortData:0];
    [self.rdoIsTotalPrint visibal:NO];
    [self.rdoIsTotalPrint initShortData:0];
    [self.kindGrid loadData:nil  detailCount:0];
    [self.menuGrid loadData:nil detailCount:0];
    [self.areaGrid loadData:nil detailCount:0];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


- (void)fillModel
{
    [self.txtName initData:self.pantry.name];
    [self.rdoIsPrinter initShortData:self.pantry.printerSwitch];
    if ([NSString isBlank:self.pantry.printerType]) {
        [self.txtType initData:NSLocalizedString(@"请选择", nil) withVal:NSLocalizedString(@"请选择", nil)];
        self.txtType.lblVal.textColor = [UIColor grayColor];
        
    }else{
        [self.txtType initData:[[GlobalRender getItem:self.PrintTypeArr withId:self.pantry.printerType] obtainItemName] withVal:self.pantry.printerType];
    }
    if (self.pantry.printerSwitch) {
        [self.lsPantryDevices initData:self.pantry.pantryDevOption withVal:self.pantry.pantryDevOption];
        [self.lsIp initData:self.pantry.printerIp withVal:self.pantry.printerIp];
        if ([self.pantry.pantryDevOption isEqualToString:NSLocalizedString(@"标签打印机", nil)]) {
            [self.lsTagspec initData:[NSString stringWithFormat:NSLocalizedString(@"宽%dmm,高%dmm", nil),self.pantry.paperWidth,self.pantry.paperHeight] withVal:[NSString stringWithFormat:@"%d,%d",self.pantry.paperWidth,self.pantry.paperHeight]];
        }else {
            [self.rdoIsTotalPrint initShortData:self.pantry.isTotalPrint];
            if (self.pantry.isCut==0) {
                [self.rdoIsTotalPrint visibal:NO];
            }
            [self.rdoIsCut initShortData:self.pantry.isCut];
            NSString* paperWidthStr=[NSString stringWithFormat:@"%d",self.pantry.paperWidth];
            NSString* paperWidthNameStr=[NSString stringWithFormat:@"%dmm",self.pantry.paperWidth];
            //修改
            [self.lsWidth initData:paperWidthNameStr withVal:paperWidthStr];
            NSString* charCountStr=[NSString stringWithFormat:@"%d",self.pantry.charCount ];
            NSString* charCountNameStr=[NSString stringWithFormat:NSLocalizedString(@"%d个字符", nil),self.pantry.charCount];
            [self.lsCharCount initData:charCountNameStr withVal:charCountStr];
            NSMutableArray* printNumList=[PantryRender listPrintNums];
            NSString* printNumStr=[NSString stringWithFormat:@"%d",self.pantry.printNum ];
            [self.lsPrintNum initData:[GlobalRender obtainItem:printNumList itemId:printNumStr] withVal:printNumStr];
        }
    }
    [self subViewsViable:[self.rdoIsPrinter getVal]];
    [self loadRelation];
    
}

- (void)loadRelation
{
    [self.originAreaList removeAllObjects];
    [self.originGoodList removeAllObjects];
    [self.originKindList removeAllObjects];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFTransService new] listPantryDetail:self.pantry.pantryId success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud setHidden:YES];
        NSDictionary* map = data [@"data"];
        NSArray *list = [map objectForKey:@"menuKinds"];
        NSString *isAllAreaStr = [map objectForKey:@"isAllArea"];
        self.isAllArea = [isAllAreaStr intValue];
        NSArray *menuList    = [map objectForKey:@"menus"];
        self.kinds=[JsonHelper transList:list objName:@"KindMenu"];
        for (int i=0;i<self.kinds.count;i++) {
            KindMenu *km = self.kinds[i];
            [self.originKindList addObject:km.kindId];
        }
        self.updateKindList = self.originKindList;
        
        self.menus  = [[NSArray  yy_modelArrayWithClass:[PantryMenuVO class] json:menuList] mutableCopy];
        for (PantryMenuVO *menu in self.menus) {
            [self.modules addObject:menu.menuId];
        }

        for (int i=0; i<self.menus.count;i++) {
            PantryMenuVO *vo = self.menus[i];
            [self.originGoodList addObject:vo.menuId];
        }
        self.updateGoodList = self.originGoodList;
        
        self.kindGrid.footView.hidden = !self.chainDataManageable && self.pantry.isChain;
        
        self.kindGrid.isChain = !self.chainDataManageable && self.pantry.isChain;
        if ([ObjectUtil isEmpty:self.kinds] && (!self.chainDataManageable && self.pantry.isChain)) {
            [self.kindGrid setHeight:0];
        }else{
         [self.kindGrid loadData:self.kinds detailCount:self.kinds.count];
        }
        self.menuGrid.footView.hidden = !self.chainDataManageable && self.pantry.isChain;
        self.menuGrid.isChain = !self.chainDataManageable && self.pantry.isChain;
        if ([ObjectUtil isEmpty:self.menus] && (!self.chainDataManageable && self.pantry.isChain)) {
            [self.menuGrid setHeight:0];
        }else{
            [self.menuGrid loadData:self.menus detailCount:self.menus.count];
        }

        NSArray *areaList = [map objectForKey:@"areas"];
        self.pantryPlanAreas=[JsonHelper transList:areaList objName:@"PantryPlanArea"];
        [self.rdoIsAllArea initShortData:self.isAllArea];
        
        for (int i=0;i<self.pantryPlanAreas.count;i++) {
            PantryPlanArea *pa = self.pantryPlanAreas[i];
            [self.originAreaList addObject:pa.areaId];
        }
        self.updateAreaList = self.originAreaList;
        [self.areaGrid loadData:self.pantryPlanAreas detailCount:0];
        [self showArea];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [self.titleBox initWithName:NSLocalizedString(@"传菜方案", nil) backImg:Head_ICON_BACK moreImg:nil];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
    
}

- (void)dataChanged {
    
}


- (void)reFresh
{
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
#pragma mark  cashier version
-(void)loadCashierVersion{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    //版本控制
    [[[TDFLoginService alloc] init]cashierVersionWithParams:@{@"cashier_version_key":@"cashVersion4Pantry" }
                                                     sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                                         @strongify(self);
                                                         [self.progressHud setHidden:YES];
                                                         id obj = [data objectForKey:@"data"];
                                                         self.isCashierVersion = obj !=nil && [obj boolValue];
                                                         [self loadData:self.pantry action:self.action isContinue:self.isContinue];
                                                     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                                         [self.progressHud setHidden:YES];
                                                         [AlertBox show:error.localizedDescription];
                                                     }];
}
#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*) notification
{
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    if ([self.navigationController.viewControllers lastObject] == self) {
        [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
    }

}

- (void)back{
    if (self.callBack) {
        self.callBack();
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)showArea
{
    BOOL isHide = [self.rdoIsAllArea getVal];
    if (!isHide) {
        [self.areaGrid loadData:self.pantryPlanAreas detailCount:[self.pantryPlanAreas count]];
    }
    [self.areaGrid setHeight:isHide?0:self.areaGrid.height];
    [self.areaGrid setHidden:isHide];
}


- (void)loadAreasFinish:(NSError *)error obj:(id) obj
{
    [self.progressHud setHidden:YES];
    
    if (error) {
        [AlertBox show:[error localizedDescription]];
        return;
    }
    
    self.areas = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[Area class] json:obj[@"data"]]];
    [self showAreaMultiCheckView];
}

-(NSMutableArray*) filterType:(int)type
{
    NSMutableArray* list=[NSMutableArray array];
    if (self.datas==nil || self.datas.count==0) {
        return list;
    }
    for (MenuProducePlan* plan in self.datas) {
        if (plan.type==type) {
            [list addObject:plan];
        }
    }
    return list;
}

-(void)remoteFinsh:(id)data
{
    NSDictionary *pantryDic = data [@"data"];
    self.pantry=[JsonHelper dicTransObj:pantryDic obj:[Pantry alloc]];
    if (self.callBack) {
        self.callBack();
    }
    if (self.isContinue) {
        [self loadData:self.pantry action:ACTION_CONSTANTS_EDIT isContinue:self.isContinue];
        [self continueAdd:self.continueEvent];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma test event
#pragma edititemlist click event.
-(void) onItemListClick:(EditItemList*)obj
{
    [SystemUtil hideKeyboard];
    if (obj.tag==PANTRY_ISWIDTH) {
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[PantryRender listWidth]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[PantryRender listWidth][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    } else if (obj.tag==PANTRY_CHARCOUNT) {
        NSString* widthStr=[self.lsWidth getStrVal];
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[PantryRender listLineCounts:widthStr]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[PantryRender listLineCounts:widthStr][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    } else if (obj.tag==PANTRY_PRINTNUM) {
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[PantryRender listPrintNums]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[PantryRender listPrintNums][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }
    else if (obj.tag ==PANTRY_TYPE)
    {
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:self.PrintTypeArr
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:self.PrintTypeArr[index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    } else if(obj.tag == PANTRY_PRINTER_DEVICE){
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[self listPrintDevice]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[wself listPrintDevice][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    } else if (obj.tag == PANTRY_PRINTER_TAGSPEC){
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[PantryRender listTagSpec]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[PantryRender listTagSpec][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    }
    
}

#pragma  mark --edititemRadio click event.
//Radio控件变换.
- (void)onItemRadioClick:(EditItemRadio*)obj
{
    if (obj.tag==PANTRY_IS_CUT_RATIO) {
        [self.rdoIsTotalPrint visibal:[obj getVal]];
        if ([obj getVal] == NO) {
            [self.rdoIsTotalPrint  changeData:[NSString stringWithFormat:@"%d",[obj getVal]]];
        }
        
    } else  if ((obj.tag==PANTRY_IS_ALL_AREA_RATIO)) {
        [self showArea];
    } else if(obj.tag == PANTRY_IS_PRINTER){
        [self subViewsViable:[obj getVal]];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(BOOL)pickOption:(id)item event:(NSInteger)event
{
    NameItemVO* vo=(NameItemVO*)item;
    if (event==PANTRY_ISWIDTH) {
        [self.lsWidth changeData:vo.itemName withVal:vo.itemId];
        NSString *widthStr=[self.lsWidth getStrVal];
        NSMutableArray* arrs=[PantryRender listLineCounts:widthStr];
        NameItemVO* charVo=[arrs firstObject];
        [self.lsCharCount changeData:charVo.itemName withVal:charVo.itemId];
    } else if (event==PANTRY_CHARCOUNT) {
        [self.lsCharCount changeData:vo.itemName withVal:vo.itemId];
    } else if (event==PANTRY_PRINTNUM) {
        [self.lsPrintNum changeData:vo.itemName withVal:vo.itemId];
    }
    else if (event ==PANTRY_TYPE)
    {
        [self.txtType changeData:vo.itemName withVal:vo.itemId];
    }else if(event ==PANTRY_PRINTER_DEVICE){
        [self.lsPantryDevices changeData:vo.itemName withVal:vo.itemId];
        [self subViewsViable:[self.rdoIsPrinter getVal]];
    } else if (event == PANTRY_PRINTER_TAGSPEC){
        [self.lsTagspec changeData:vo.itemName withVal:vo.itemId];
    }
    return YES;
}

- (void) clientInput:(NSString*)val event:(NSInteger)eventType
{
    if (eventType==PANTRY_PRINTIP) {
        [self.lsIp changeData:val withVal:val];
    }
}
#pragma  mark --多选页结果处理.

- (void)compareListWithOriginalList:(NSMutableArray*)originalList withCompareList:(NSMutableArray *)compareList  {
    if (originalList.count!= compareList.count) {
        [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
//        [self configNavigationBar:YES];
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:@"取消"];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:@"保存"];
        
        return;
    } else {
        for (int i=0;i<originalList.count;i++) {
            NSString *originalStr = originalList[i];
            for (int j=0;j<compareList.count;j++) {
                NSString *compareStr = compareList[j];
                if (![compareStr isEqualToString:originalStr]) {
                    [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
                    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:@"取消"];
                    [self configRightNavigationBar:Head_ICON_OK rightButtonName:@"保存"];

                    return;
                }
            }
        }
        
    }
    
}
-(void)multiCheck:(NSInteger)event items:(NSMutableArray*) items
{
    
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
    if (event==PANTRY_KIND) {   //商品分类.
        [self.nodeList removeAllObjects];
        [self.kinds  removeAllObjects];
        self.kinds  =   items;
        if (items!=nil && items.count>0) {
            for (KindMenu* kind in items) {
                [self.nodeList addObject:kind._id];
            }
        }
        self.updateKindList = self.nodeList;
        [self compareListWithOriginalList:self.originKindList withCompareList:self.nodeList];
        [self.kindGrid loadData:self.kinds detailCount:self.kinds.count];
        [self reFresh];
        
    } else if (event==PANTRY_AREA) {
        [self.areaList removeAllObjects];
        [self.pantryPlanAreas removeAllObjects];
        self.pantryPlanAreas = items;
        if (items!=nil && items.count>0) {
            for (Area* area in items) {
                [self.areaList addObject:area._id];
            }
        }
        self.updateAreaList = self.areaList;
        [self.areaGrid loadData:items detailCount:[items count]];
        [self reFresh];
        [self compareListWithOriginalList:self.originAreaList withCompareList:self.areaList];
    }
}

- (void)closeMultiView:(NSInteger)event
{
    
}

-(void) closeView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma save-data
-(BOOL)isValid{
    if ([NSString isBlank:[self.txtName getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"传菜设备名称不能为空!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsIp getStrVal]]&&[self.rdoIsPrinter getVal]) {
        [AlertBox show:NSLocalizedString(@"打印机IP不能为空!", nil)];
        return NO;
    }
    if (![NSString isValidatIP:self.lsIp.lblVal.text]&&[self.rdoIsPrinter getVal]) {
        [AlertBox show:NSLocalizedString(@"打印机IP地址无效!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsCharCount getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"每行打印字符数不能为空!", nil)];
        return NO;
    }
    if (![NSString isFloat:[self.lsCharCount getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"每行打印字符数不是数字!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsPrintNum getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"打印份数不能为空!", nil)];
        return NO;
    }
    if (![NSString isFloat:[self.lsPrintNum getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"打印份数不是数字!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.txtType getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"打印机类型不能为空!", nil)];
        return NO;
    }
    if (![self.rdoIsAllArea getVal]) {
        if (!self.updateAreaList.count) {
            [AlertBox show:@"区域至少需要添加一个才可以保存"];
            return NO;
        }
    }
    if (!self.updateKindList.count && !self.updateGoodList.count) {
        [AlertBox show:@"分类和商品至少需要添加一个才能保存。"];
        return NO;
    }
    return YES;
}

-(Pantry*) transMode
{
    Pantry* tempUpdate=[Pantry new];
    tempUpdate.name=[self.txtName getStrVal];
    tempUpdate.entityId = self.pantry.entityId;
    tempUpdate.printerSwitch = [self.rdoIsPrinter getVal];
    if ([self.rdoIsPrinter getVal]) {
        tempUpdate.pantryDevOption = [self.lsPantryDevices getStrVal];
        tempUpdate.printerIp=[self.lsIp getStrVal];
        if([[self.lsPantryDevices getStrVal] isEqualToString:NSLocalizedString(@"标签打印机", nil)]){
            NSArray *spec = [[self.lsTagspec getStrVal] componentsSeparatedByString:@","];
            tempUpdate.paperWidth = [spec.firstObject intValue];
            tempUpdate.paperHeight = [spec.lastObject intValue];
        }else{
            tempUpdate.isCut=[self.rdoIsCut getVal]?1:0;
            tempUpdate.isTotalPrint=[self.rdoIsTotalPrint getVal]?1:0;
            tempUpdate.charCount=[self.lsCharCount getStrVal].intValue;
            if ([[self.txtType getStrVal] isEqualToString:NSLocalizedString(@"请选择", nil)]) {
                tempUpdate.printerType = @"";
            }else{
                tempUpdate.printerType =[self.txtType getStrVal];
            }
            tempUpdate.printNum=[self.lsPrintNum getStrVal].intValue;
            tempUpdate.paperWidth=[self.lsWidth getStrVal].intValue;
        }
        tempUpdate.isAutoPrint=1;
        tempUpdate.isAllPlan=1;
    }else{
        tempUpdate.pantryDevOption = NSLocalizedString(@"小票打印机", nil);//
        tempUpdate.isAutoPrint=1;
        tempUpdate.isCut=0;//
        tempUpdate.isTotalPrint=0;//
        tempUpdate.charCount= 32;//
        tempUpdate.printerType = @"";
        tempUpdate.printerIp= @"";//
        tempUpdate.printNum= 1;//
        tempUpdate.paperWidth=58;//
        tempUpdate.isAllPlan=1;
    }
    tempUpdate.kindIds  = self.updateKindList;
    tempUpdate.menuIds = self.updateGoodList;
    if (![self.rdoIsAllArea  getVal]) {
        tempUpdate.areaIds  = self.updateAreaList;
    }
   
    return tempUpdate;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    Pantry* objTemp=[self transMode];
    self.isAllArea=[self.rdoIsAllArea getVal]?1:0;
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {
        [[TDFTransService new] savePantry:objTemp isAllArea:self.isAllArea plateEntityId:self.plateEntityId success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hideAnimated: YES];
            [self remoteFinsh:data];
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hideAnimated:YES];
            [AlertBox show:error.localizedDescription];
        }];
    } else {
        objTemp.pantryId  = self.pantry.pantryId;
        [[TDFTransService  new] updatePantry:objTemp isAllArea:self.isAllArea success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hideAnimated: YES];
            [self remoteFinsh:data];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hideAnimated: YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

#pragma delete operate
-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.pantry.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
        [[TDFTransService new] removePantry:self.pantry.pantryId lastVer:self.pantry.lastVer success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hideAnimated: YES];
            [self back];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hideAnimated: YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(IBAction)btnTest:(id)sender
{
    if ([NSString isBlank:[self.lsIp getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"IP不能为空!", nil)];
        return;
    }
    [self showProgressHudWithText:NSLocalizedString(@"正在连接", nil)];
    [self connectHost:[self.lsIp getStrVal]];
}

- (void)connectHost:(NSString *)ip
{
    if ([clientSocket isConnected]) {
        [clientSocket disconnect];
    }
    
    NSError *error = nil;
    [clientSocket connectToHost:ip onPort:9100 withTimeout:30 error:&error];
    if (error) {
        NSLog(@"connectToHost error %@",error);
        [clientSocket disconnect];
    }
}

-(NSString*)getFilePath
{
    NSBundle* bundel=[NSBundle mainBundle];
    NSString* filePath=[bundel pathForResource:@"ep" ofType:@"txt"];
    NSFileManager* fm=[NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        return filePath;
    }
    return nil;
}

-(void) printTestData
{
    NSString* path=[self getFilePath];
    NSData* data=[NSData dataWithContentsOfFile:path];
    [clientSocket writeData:data withTimeout:-1 tag:0];
}

#pragma socket delegate
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    [self.progressHud hideAnimated:YES];
    
    if ([NSString isNotBlank:err.localizedDescription]) {
        [AlertBox show:NSLocalizedString(@"打印出错，原因：打印机不通或IP设置有误！请检查设置、网络及打印机。", nil)];
    }
    
    
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [self.progressHud hideAnimated:YES];
    [self printTestData];
    [sock readDataWithTimeout:-1 tag:0];
}

- (NSString *)dataToString:(NSData *)data
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [self.progressHud hideAnimated:YES];
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"transplan"];
}
//////////////////////////////////////////////////////////////////
///////////                                      /////////////////
///////////       处理分类，商品，区域              /////////////////
///////////                                      /////////////////
//////////////////////////////////////////////////////////////////
- (void)showAddEvent:(NSString *)event
{
    if (self.action==ACTION_CONSTANTS_ADD) {
        self.isContinue=NO;
        self.continueEvent=event;
        [self continueAdd:event];
        //        [self save];
        return;
    } else if (self.action==ACTION_CONSTANTS_EDIT) {
        if ([self hasChanged]) {
            self.isContinue=NO;
            self.continueEvent=event;
            [self continueAdd:event];//            [self save];
        } else {
            [self continueAdd:event];
        }
    }
}

- (void)continueAdd:(NSString *)event
{
    if ([event isEqualToString:PANTRY_KIND_EVENT]) {
        if (self.kindMenus!=nil && self.kindMenus.count>0) {
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:PANTRY_KIND delegate:self title:NSLocalizedString(@"选择分类", nil) dataTemps:self.kindMenus selectList:self.kinds needHideOldNavigationBar:YES];
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
            [[TDFTransService new] endKindPantryList:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                [self.progressHud hideAnimated:YES];
                NSArray *list = data [@"data"];
                self.kindMenus=[JsonHelper transList:list objName:@"KindMenu"];
                
                UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:PANTRY_KIND delegate:self title:NSLocalizedString(@"选择分类", nil) dataTemps:self.kindMenus selectList:self.kinds needHideOldNavigationBar:YES];
                [self.navigationController pushViewController:viewController animated:YES];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud hideAnimated: YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
    }else if([event isEqualToString:PANTRY_MENU_EVENT]){
        TDFSelectGoodsWithPlateViewController *vc = [[TDFSelectGoodsWithPlateViewController alloc] init];
        vc.removeChain = [Platform Instance].isChain?NO:NO;
        vc.plateEntityId = self.plateEntityId;
        vc.oldArr = self.modules;
        vc.rightActionCallBack = ^(NSArray<TDFShopSynchModuleModel *> *models) {
            [self.menus removeAllObjects];
            [self.goodList removeAllObjects];
            [self.modules removeAllObjects];
            NSMutableArray *menuIds = [[NSMutableArray alloc] init];
            for (TDFShopSynchModuleModel *model in models) {
                PantryMenuVO *menu = [[PantryMenuVO alloc] init];
                menu.menuId = model.moduleId;
                menu.name = model.name;
                [self.menus addObject:menu];
                [self.modules addObject:model.moduleId];
                [menuIds addObject:model.moduleId];
//                [self configMenuList:model.moduleId];
            }
            self.goodList  = menuIds;
            self.updateGoodList = menuIds;
            [self compareListWithOriginalList:self.originGoodList withCompareList:self.goodList];
            [self.menuGrid loadData:self.menus detailCount:self.menus.count];
            [self reFresh];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if([event isEqualToString:PANTRY_AREA_EVENT]){     //添加区域,弹窗.
        if (self.areas!=nil && self.areas.count>0) {
            [self showAreaMultiCheckView];
        } else {
            [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
            __weak __typeof(self) wslef = self;
            [[[TDFSeatService alloc] init] areasWithSaleOutFlag:@"true" sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                [wslef loadAreasFinish:nil obj:data];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                
                [wslef loadAreasFinish:error obj:nil];
            }];
        }
    }
}

- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
}

- (void)showAreaMultiCheckView
{
    NSMutableArray* copyAreas=[self.areas mutableCopy];
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:PANTRY_AREA delegate:self title:NSLocalizedString(@"选择区域", nil) dataTemps:copyAreas selectList:self.pantryPlanAreas needHideOldNavigationBar:YES];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

-(void) delObjEvent:(NSString*)event obj:(id)obj
{
    [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:@"取消"];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:@"保存"];
    NSString *introductionId;
    if ([event isEqualToString:PANTRY_KIND_EVENT]) {
        KindMenu* plan=(KindMenu*)obj;
        introductionId  =  plan.obtainItemId;
        for (int i =0;i<self.updateKindList.count;i++) {
            NSString *kindStr = self.updateKindList[i];
            if ([kindStr isEqualToString:introductionId]) {
                [self.kinds removeObjectAtIndex:i];
                [self.updateKindList removeObjectAtIndex:i];
            }
        }
        [self.kindGrid loadData:self.kinds detailCount:self.kinds.count];
    }
    
    if ( [event isEqualToString:PANTRY_MENU_EVENT] ) {
        PantryMenuVO* plan=(PantryMenuVO*)obj;
        [self.modules removeObject:plan.menuId];
        introductionId  = plan.obtainItemId;
        for (int i =0;i<self.updateGoodList.count;i++) {
            NSString *goodStr = self.updateGoodList[i];
            if ([goodStr isEqualToString:introductionId]) {
                [self.menus removeObjectAtIndex:i];
                [self.updateGoodList removeObjectAtIndex:i];
            }
        }
        [self.menuGrid loadData:self.menus
                    detailCount:self.menus.count];
    }
    
    if ([event isEqualToString:PANTRY_AREA_EVENT] ) {
        id<INameValueItem >vo   =  obj;
        introductionId = [vo obtainItemId];
        /*
        PantryPlanArea* ppa = (PantryPlanArea*)obj;
        if ([ppa class] == [PantryPlanArea class] ){
            introductionId = ppa.areaId;
        } else if ([ppa class] == [Area class]) {
            introductionId = ppa._id;
        } else {
            return;
        }*/
        for (int i=0;i<self.updateAreaList.count;i++) {
            NSString *areaStr = self.updateAreaList[i];
            if ([areaStr isEqualToString:introductionId]) {
                [self.updateAreaList removeObjectAtIndex:i];
                [self.pantryPlanAreas removeObjectAtIndex:i];
            }
        }
        [self.areaGrid loadData:self.pantryPlanAreas detailCount:self.pantryPlanAreas.count];
    }
    
    [self reFresh];
}

- (BOOL)hasChanged
{
    return self.txtName.isChange || self.lsWidth.isChange || self.rdoIsCut.isChange || self.lsIp.isChange || self.lsCharCount.isChange || self.txtType.isChange ||
    self.lsPrintNum.isChange || self.rdoIsTotalPrint.isChange || self.rdoIsAllArea.isChange || self.lsPantryDevices.isChange || self.rdoIsPrinter.isChange;
    
}

#pragma mark getter
-(NSMutableArray*) listPrintDevice
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"小票打印机", nil) andId:NSLocalizedString(@"小票打印机", nil)];
    [vos addObject:item];
    
    if (self.isCashierVersion) {
        item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"标签打印机", nil) andId:NSLocalizedString(@"标签打印机", nil)];
        [vos addObject:item];
    }
    
    return vos;
}

-(EditItemRadio *)rdoIsPrinter{
    if (!_rdoIsPrinter) {
        _rdoIsPrinter  = [[EditItemRadio alloc]initWithFrame:self.txtName.frame];
        [_rdoIsPrinter awakeFromNib];
        [_rdoIsPrinter initLabel:NSLocalizedString(@"打印机", nil) withHit:nil delegate:self];
        [_rdoIsPrinter initShortData:1];
        _rdoIsPrinter.tag = PANTRY_IS_PRINTER;
    }
    return _rdoIsPrinter;
}


-(EditItemList *)lsPantryDevices{
    if (!_lsPantryDevices) {
        _lsPantryDevices = [[EditItemList alloc]initWithFrame:self.rdoIsPrinter.frame];
        [_lsPantryDevices awakeFromNib];
        [_lsPantryDevices initLabel:NSLocalizedString(@"传菜设备", nil) withHit:nil delegate:self];
        _lsPantryDevices.tag = PANTRY_PRINTER_DEVICE;
        [_lsPantryDevices initData:NSLocalizedString(@"小票打印机", nil) withVal:NSLocalizedString(@"小票打印机", nil)];
        
    }
    return _lsPantryDevices;
}

-(EditItemList *)lsTagspec{
    if (!_lsTagspec) {
        _lsTagspec = [[EditItemList alloc]initWithFrame:self.lsIp.frame];
        [_lsTagspec awakeFromNib];
        [_lsTagspec initLabel:NSLocalizedString(@"标签纸规格", nil) withHit:nil delegate:self];
        _lsTagspec.tag = PANTRY_PRINTER_TAGSPEC;
        [_lsTagspec visibal:NO];
        [_lsTagspec initData:NSLocalizedString(@"宽40mm,高30mm", nil) withVal:@"40,30"];
    }
    return _lsTagspec;
}

-(void)subViewsViable:(BOOL)isViable{
    self.testDiv.hidden = !isViable;
    [self.testDiv setHeight:isViable?250:0];
    BOOL isTagSpec = [[self.lsPantryDevices getStrVal] isEqualToString:NSLocalizedString(@"标签打印机", nil)];
    [self.lsPantryDevices visibal:isViable];
    [self.txtType visibal:isViable && !isTagSpec];
    [self.lsIp visibal:isViable];
    [self.lsWidth visibal:isViable && !isTagSpec];
    [self.lsCharCount visibal:isViable && !isTagSpec];
    [self.lsPrintNum visibal:isViable && !isTagSpec];
    [self.rdoIsCut visibal:isViable && !isTagSpec];
    [self.rdoIsTotalPrint visibal:isViable && [self.rdoIsCut getVal] && !isTagSpec];
    [self.lsTagspec visibal:isViable && isTagSpec];
    EditItemBase *edititemBase;
    for (UIView *view in self.container.subviews) {
        if ([view isKindOfClass:[EditItemBase class]]) {
            edititemBase = (EditItemBase *)view;
            if ([edititemBase isChange]) {
                [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
            }
        }
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


#pragma mark - UI

- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [_scrollView addSubview:self.container];
    }
    return _scrollView;
}

- (UIView *)container {
    if(!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = [UIColor clearColor];
        _container.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.frame.size.height);
        [_container addSubview:self.baseTitle];
        [_container addSubview:self.txtType];
        [_container addSubview:self.txtName];
        [_container addSubview:self.lsIp];
        [_container addSubview:self.lsWidth];
        [_container addSubview:self.lsCharCount];
        [_container addSubview:self.lsPrintNum];
        [_container addSubview:self.rdoIsCut];
        [_container addSubview:self.rdoIsTotalPrint];
        [_container addSubview:self.testDiv];
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 327,SCREEN_WIDTH, 20);
        view.backgroundColor = [UIColor clearColor];
        [_container addSubview:view];
        
        [_container addSubview:self.titleKind];
        [_container addSubview:self.kindGrid];
        
        view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 327,SCREEN_WIDTH, 20);
        view.backgroundColor = [UIColor clearColor];
        [_container addSubview:view];
        
        [_container addSubview:self.titleMenu];
        [_container addSubview:self.menuGrid];
        [_container addSubview:self.lblTip];
        
        view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 327,SCREEN_WIDTH, 20);
        view.backgroundColor = [UIColor clearColor];
        [_container addSubview:view];
        
        if (![Platform Instance].isChain) {
            [_container addSubview:self.titleArea];
            [_container addSubview:self.rdoIsAllArea];
            [_container addSubview:self.areaGrid];
        }
        
        view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 327,SCREEN_WIDTH, 20);
        view.backgroundColor = [UIColor clearColor];
        [_container addSubview:view];
        
        view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 304,SCREEN_WIDTH, 66);
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:self.btnDel];
        [_container addSubview:view];
        
    }
    return _container;
}

- (ItemTitle *)baseTitle {
    if(!_baseTitle) {
        _baseTitle = [[ItemTitle alloc] init];
        [_baseTitle awakeFromNib];
        _baseTitle.frame = CGRectMake(0, 269, SCREEN_WIDTH, 48);
        _baseTitle.backgroundColor = [UIColor colorWithRed:159/255.0 green:1 blue:67/255.0 alpha:1];
    }
    return _baseTitle;
}

- (EditItemList *)txtType {
    if(!_txtType) {
        _txtType = [[EditItemList alloc] init];
        _txtType.frame = CGRectMake(0, 0, SCREEN_WIDTH, 48);
        _txtType.backgroundColor = [UIColor whiteColor];
    }
    return _txtType;
}

- (EditItemText *)txtName {
    if(!_txtName){
        _txtName = [[EditItemText alloc] init];
        _txtName.frame = CGRectMake(0, 44, SCREEN_WIDTH, 48);
        _txtName.backgroundColor = [UIColor blackColor];
    }
    return _txtName;
}
- (EditItemList *)lsIp {
    if(!_lsIp){
        _lsIp = [[EditItemList alloc] init];
        _lsIp.frame = CGRectMake(0, 93, SCREEN_WIDTH, 48);
        _lsIp.backgroundColor = [UIColor blackColor];
    }
    return _lsIp;
}
- (EditItemList *)lsWidth {
    if(!_lsWidth){
        _lsWidth = [[EditItemList alloc] init];
        _lsWidth.frame = CGRectMake(0, 192, SCREEN_WIDTH, 48);
        _lsWidth.backgroundColor = [UIColor blackColor];
    }
    return _lsWidth;
}
- (EditItemList *)lsCharCount {
    if(!_lsCharCount){
        _lsCharCount = [[EditItemList alloc] init];
        _lsCharCount.frame = CGRectMake(0, 242, SCREEN_WIDTH, 48);
        _lsCharCount.backgroundColor = [UIColor blackColor];
    }
    return _lsCharCount;
}
- (EditItemList *)lsPrintNum {
    if(!_lsPrintNum){
        _lsPrintNum = [[EditItemList alloc] init];
        _lsPrintNum.frame = CGRectMake(0, 291, SCREEN_WIDTH, 48);
        _lsPrintNum.backgroundColor = [UIColor blackColor];
    }
    return _lsPrintNum;
}
- (EditItemRadio *)rdoIsCut {
    if(!_rdoIsCut) {
        _rdoIsCut = [[EditItemRadio alloc] init];
        _rdoIsCut.frame = CGRectMake(0, 142, SCREEN_WIDTH, 48);
        _rdoIsCut.backgroundColor = [UIColor blackColor];
    }
    return _rdoIsCut;
}
- (EditItemRadio *)rdoIsTotalPrint {
    if(!_rdoIsTotalPrint) {
        _rdoIsTotalPrint = [[EditItemRadio alloc] init];
        _rdoIsTotalPrint.frame = CGRectMake(0, 313, SCREEN_WIDTH, 48);
        _rdoIsTotalPrint.backgroundColor = [UIColor blackColor];
    }
    return _rdoIsTotalPrint;
}

- (UIView *)testDiv {
    if(!_testDiv){
        _testDiv = [[UIView alloc] init];
        _testDiv.backgroundColor = [UIColor clearColor];
        _testDiv.frame = CGRectMake(0, 452, SCREEN_WIDTH, 246);
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:NSLocalizedString(@"打印测试页", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.frame = CGRectMake(10, 20, SCREEN_WIDTH-20, 40);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnTest:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
        
        UIImage *image = [UIImage imageNamed:@"ico_trans_print"];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(10.0,
                                                                                                   0.0,
                                                                                                   10.0,
                                                                                                   10.0)];
        [btn setImage:image forState:UIControlStateNormal];
        
        [_testDiv addSubview:btn];
        
        [_testDiv addSubview:self.printHintLib];
    }
    return _testDiv;
}

- (UILabel *)printHintLib {
    if(!_printHintLib){
        _printHintLib = [[UILabel alloc] init];
        _printHintLib.textColor = [UIColor blackColor];
        _printHintLib.font = [UIFont systemFontOfSize:13];
        _printHintLib.numberOfLines = 0;
        _printHintLib.frame = CGRectMake(10, 70, SCREEN_WIDTH-20, 182);
    }
    return _printHintLib;
}

- (ItemTitle *)titleKind {
    if(!_titleKind) {
        _titleKind = [[ItemTitle alloc] init];
        [_titleKind awakeFromNib];
        _titleKind.frame = CGRectMake(0, 313, SCREEN_WIDTH, 48);
        _titleKind.backgroundColor = [UIColor colorWithRed:159/255.0 green:1 blue:67/255.0 alpha:1];
    }
    return _titleKind;
}

- (ZMTable *)kindGrid {
    if(!_kindGrid) {
        _kindGrid = [[ZMTable alloc] init];
        [_kindGrid awakeFromNib];
        _kindGrid.frame = CGRectMake(0, 313, SCREEN_WIDTH, 48);
        _kindGrid.backgroundColor = [UIColor blackColor];
    }
    return _kindGrid;
}

- (ItemTitle *)titleMenu {
    if(!_titleMenu) {
        _titleMenu = [[ItemTitle alloc] init];
        [_titleMenu awakeFromNib];
        _titleMenu.frame = CGRectMake(0, 313, SCREEN_WIDTH, 48);
        _titleMenu.backgroundColor = [UIColor colorWithRed:159/255.0 green:1 blue:67/255.0 alpha:1];
    }
    return _titleMenu;
}

- (ZMTable *)menuGrid {
    if(!_menuGrid) {
        _menuGrid = [[ZMTable alloc] init];
        [_menuGrid awakeFromNib];
        _menuGrid.frame = CGRectMake(0, 313, SCREEN_WIDTH, 48);
        _menuGrid.backgroundColor = [UIColor blackColor];
    }
    return _menuGrid;
}

- (UITextView *)lblTip {
    if(!_lblTip) {
        _lblTip = [[UITextView alloc] init];
        _lblTip.frame = CGRectMake(0, 306, SCREEN_WIDTH, 80);
        _lblTip.font = [UIFont systemFontOfSize:14];
        _lblTip.userInteractionEnabled = NO;
    }
    return _lblTip;
}

- (ItemTitle *)titleArea {
    if(!_titleArea) {
        _titleArea = [[ItemTitle alloc] init];
        [_titleArea awakeFromNib];
        _titleArea.frame = CGRectMake(0, 313, SCREEN_WIDTH, 48);
        _titleArea.backgroundColor = [UIColor colorWithRed:159/255.0 green:1 blue:67/255.0 alpha:1];
    }
    return _titleArea;
}

- (EditItemRadio *)rdoIsAllArea {
    if(!_rdoIsAllArea) {
        _rdoIsAllArea = [[EditItemRadio alloc] init];
        _rdoIsAllArea.frame = CGRectMake(0, 313, SCREEN_WIDTH, 48);
        _rdoIsAllArea.backgroundColor = [UIColor blackColor];
    }
    return _rdoIsAllArea;
}

- (ZMTable *)areaGrid {
    if(!_areaGrid) {
        _areaGrid = [[ZMTable alloc] init];
        [_areaGrid awakeFromNib];
        _areaGrid.frame = CGRectMake(0, 313, SCREEN_WIDTH, 48);
        _areaGrid.backgroundColor = [UIColor blackColor];
    }
    return _areaGrid;
}

- (NSMutableArray *)kinds
{
    if (!_kinds) {
        _kinds  = [[NSMutableArray  alloc] init ];
    }
    return _kinds;
}

- (NSMutableArray *)menus
{
    if (!_menus) {
        _menus  = [[NSMutableArray  alloc]  init ];
    }
    return _menus;
}

- (NSMutableArray *)pantryPlanAreas
{
    if (!_pantryPlanAreas) {
        _pantryPlanAreas = [[NSMutableArray  alloc]  init];
    }
    return _pantryPlanAreas;
}

- (UIButton *)btnDel {
    if(!_btnDel) {
        _btnDel = [[UIButton alloc] init];
        [_btnDel setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        _btnDel.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnDel.frame = CGRectMake(10, 9, SCREEN_WIDTH-20, 44);
        [_btnDel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnDel addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnDel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
    }
    return _btnDel;
}

- (NSMutableArray *)modules
{
    if (!_modules) {
        _modules = [[NSMutableArray alloc] init];
    }
    return _modules;
}

- (void) dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
