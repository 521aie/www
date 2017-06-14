 //
//  orderDetailsView.m
//  RestApp
//
//  Created by iOS香肠 on 16/3/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "orderDetailsView.h"
#import "ServiceFactory.h"
#import "JsonHelper.h"
#import "NameItemVO.h"
#import "ViewFactory.h"
#import "UIView+Sizes.h"
#import "TDFOptionPickerController.h"
#import "OptionPickerBox.h"
#import "OrderDetailLblVoList.h"
#import "OrderDetailAdviseView.h"
#import  "OrderDetailAcridView.h"
#import "OrderDetailSpecialView.h"
#import "OrderDetailWeight.h"
#import "OrderDetailCell.h"
#import "OrderDetailMoreCell.h"
#import "orderSetView.h"
#import "orderIteamTitle.h"
#import "MenuListView.h"
#import "orderIteamTitle.h"
#import "NSString+Estimate.h"
#import "MenuEditView.h"
#import "HelpDialog.h"
#import "MenuModuleEvent.h"
#import "SpecialTagListView.h"
#import "JSONKit.h"
#import "TDFOptionPickerController.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFMediator+SmartModel.h"
#define restrainCount  5 //需要多选的有序类型个数（类型个数从0开始有顺序）
#define hideSelectCount 1 //推荐指数为不设定时隐藏大图置顶开关
#define restrainLabelId  3 //用来判断是否选择主料的labelId
#import "RNNativeActionManager.h"
#import "TagLibraryRNModel.h"
#import "RNRootURL.h"
#import "TDFOrderMaterialCollectionViewCell.h"
#import "TDFOrderMaterialCollectionViewHeader.h"
#import "TDFOrderMaterialVoModel.h"
#import "TDFRootViewController+FooterButton.h"

static NSString * const kOrderDetailsViewMaterialCellId = @"orderDetailsViewMaterialCell";
static NSString * const kOrderDetailsViewMaterialHrderId = @"orderDetailsViewMaterialHesder";

typedef NS_ENUM(NSInteger, viewTag) {
    BigTag  =1,
    MidTag ,
    SmallTag,
    OtherTag,
};

@interface orderDetailsView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)TagLibraryRNModel *RNTagLibrary;
@end

@implementation orderDetailsView

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SmartOrderModel *)controller
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        model =controller;
         self.isReturnType =NO;
    }
    return self;
}


- (id)initWithMenuNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parent
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        mainmodel =parent;
        self.isReturnType =YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setWidth:SCREEN_WIDTH];

    self .isTitleChange  = NO;
    [self initCurrentView];
    [self  initService];
    [self initNotication];
    [self initGrid];
    [self initMainView];
    [self createData];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

- (void)initCurrentView
{
    hud  = [[MBProgressHUD  alloc] initWithView:self.view];
}

- (void)initService
{
     service  = [ServiceFactory Instance].orderService;
}

- (void) initNotication
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RNDidMount:) name:RNDidMountNotification object:nil];
}
- (void)onNavigateEvent:(NSInteger)event
{
    if (event ==DIRECT_LEFT ) {
        if (self.isReturnType) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
           [self.navigationController popViewControllerAnimated:YES];
//        [model showView:SMART_ORDER_SET_VIEW];
        }
    }
    else
    {
           [self save];
    }
}


- (void)leftNavigationButtonAction:(id)sender
{
    if (self.isTitleChange) {
        [self alertChangedMessage:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
   
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self save];
}

- (void)initdata:(NSString *)title menuId:(NSString *)menuId action:(NSInteger)action
{
   self.headTitle =title;
    self.action = action;
    self.IdStr =menuId;
    self.title = self.headTitle;
    self.menuId =menuId;
   [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud ];
   [service getShopLblList:menuId target:self callback:@selector(getShopLblData:)];
   [self celarDo];

}

-(void)initdata:(NSString *)title  action:(NSInteger)action
{
    [self celarDo];
    self.headTitle =title;
    self.title = title;
    self.IdStr = @"";
    self.action =action;
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud ];
    [service getEmptyShopLblList:self callback:@selector(getShopLblData:)];
    
}

-(void)celarDo
{

    self.meattag =nil;
    self.vdTag =nil;
    self.waterTag =nil;
}

-(void)getShopLblData:(RemoteResult *)result
{

    [hud  hide:YES];
//    if (!self.isFirstLoad) {
//        [self.progressHud hide:YES];
//    }//待定
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    [self parseData:result.content];
}

-(void)parseData:(NSString *)result
{
    NSDictionary *map = [JsonHelper transMap:result];
    NSDictionary *data =map[@"data"];
    self.labelVolist =[JsonHelper transList:data[@"labelVoList"] objName:@"OrderDetailLblVoList"];
    self.showTop =[NSString stringWithFormat:@"%@",data[@"showTop"]];
    self.topIndex =self.showTop.integerValue;
    self.labelMaterialVoList = [NSMutableArray arrayWithCapacity:1];
    
    NSArray *materialArr = [data objectForKey:@"labelMaterialVoList"] ?: @[];
    
    [materialArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.labelMaterialVoList addObject:[TDFOrderMaterialVoModel modelWithDictionary:obj]];
    }];
    
    [self.materialView reloadData];
    
    [self.materialList removeAllObjects];
    self.labelMaterialId = @"".mutableCopy;
    
    [self configureMajorMaterialHeight];

    self.editmainStr = @"";
    self.shopTag = 99;
    
    
    for (TDFOrderMaterialVoModel * mainMaterial in self.labelMaterialVoList) {
        for (TDFOrderDetailMaterialVoModel * material in mainMaterial.mainMaterialLabelList) {
         
            if (material.isSelected) {
                
                NSString *labelMaterial = [NSString stringWithFormat:@"%d", [mainMaterial.labelMaterialId intValue]];
                
                self.labelMaterialId = [NSMutableString stringWithString:labelMaterial];
                
                [self.materialList addObject:material];
            }

        }
        
    }
  
    self.acridList =[JsonHelper transList:data[@"acridList"] objName:@"OrderDetailAcridView"];
    self.specialList =[JsonHelper transList:data[@"specialList"] objName:@"OrderDetailSpecialView"];
    self.recommendList =[JsonHelper transList:data[@"recommendList"] objName:@"OrderDetailAdviseView"];
    NSDictionary *menuWeightVo =data[@"menuWeightVo"];
    self.menuWeightVo =[JsonHelper transList:menuWeightVo[@"menuSpecWeightVoList"] objName:@"OrderDetailWeight"];
    self.defautstr =menuWeightVo[@"hasSpec"];
    self.defautWeightStr = [NSString stringWithFormat:@" %@",menuWeightVo[@"defaultWeight"]];
    [self fillModel];

}

- (void)initStatusDic
{
    self.statusOldDic =[[NSMutableDictionary alloc]init];
    self.statusDic =[[NSMutableDictionary alloc]init];
}

- (void)fillModel
{
     self.defautWeight =nil;
    [self createTabViewData];
    self.editDic =[[NSMutableDictionary alloc]init];
    [self createIteams];
    [self.customSetView initData:self.showTop];
    [self  initSelectStr];
    [self reloadView];
    [self adjustrecommend];
    [self whetherRestView];
    [UIHelper refreshTop:self.ScrollView];
    [self createSpecialData] ;
}

- (void)createTabViewData
{
    if ([ObjectUtil isEmpty:self.menuWeightVo]) {
        self.defautWeight =[[NSMutableArray alloc]init];
        OrderDetailWeight* models =[[OrderDetailWeight alloc]init];
        models.specName =NSLocalizedString(@"自定义规格", nil);
        models.specWeight =self.defautWeightStr.integerValue;
        [self.defautWeight addObject:models];
        [self.tabview setHeight:140 *self.defautWeight.count+180];
        [self.tabview reloadData];
    }
    else
    {
        [self.tabview setHeight:140* self.menuWeightVo.count+180];
        [self.tabview reloadData];
    }

}

- (void)whetherRestView
{
    NSInteger  indexPatch =self.labelVolist.count +1;
    for (NSInteger i=0; i<self.labelVolist.count; i++) {
        OrderDetailLblVoList *vo =self.labelVolist[i];
        if (vo.isSelected) {
            indexPatch =i;
        }
    }
    if (indexPatch <=restrainCount)
    {
        [self intputView];
    }
    else
    {
        [self resetView];
    }
}

- (void)createIteams
{
    self.fManageView.backgroundColor =[UIColor clearColor];
    if ([ObjectUtil isNotEmpty:self.labelVolist]) {
        [self.typeView createTypeViewWithCount:self.labelVolist imgcolor:RGBA(255, 204, 0, 1) Bgcolor:RGBA(255, 160, 40, 1) tag:0];
    }
    if ([ObjectUtil isNotEmpty:self.acridList]) {
        [self.chiliIndexView initMuluSelectBox:self.acridList imgcolor:RGBA(209, 19,21 , 1) Bgcolor:RGBA(209, 19,21 , 1) tag:3];
    }
    if ([ObjectUtil isNotEmpty:self.specialList]) {
//        [self.fManageView  createViewWithCount:self.specialList imgcolor:RGBA(24, 166, 47, 1) Bgcolor:RGBA(24, 166, 47, 1) tag:2];
        [self.fManageView  createViewWithArry:self.specialList Imgcolor:RGBA(24, 166, 47, 1) Bgcolor:RGBA(24, 166, 47, 1) tag:2 hideColor:RGBA(255, 153, 0, 1)];
        
    }
    if ([ObjectUtil isNotEmpty:self.recommendList]) {
        [self.rIndexView initMuluSelectBox:self.recommendList imgcolor:RGBA(22, 141, 203, 1) Bgcolor:RGBA(22, 141, 203, 1) tag:1];
    }
}

/**
 计算主料选择View的高度
 */
- (void) configureMajorMaterialHeight {
    
    __block CGFloat totalH = 0.0f;
    
    [self.labelMaterialVoList enumerateObjectsUsingBlock:^(TDFOrderMaterialVoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totalH += (obj.mainMaterialLabelList.count / 4) * ((UICollectionViewFlowLayout *)self.materialView.collectionViewLayout).itemSize.height;
        totalH += (obj.mainMaterialLabelList.count / 4 - 1) * ((UICollectionViewFlowLayout *)self.materialView.collectionViewLayout).minimumLineSpacing;
    }];

    totalH += ((UICollectionViewFlowLayout *)self.materialView.collectionViewLayout).headerReferenceSize.height * self.labelMaterialVoList.count;
    
    CGRect rect = self.materialView.frame;
    rect.size.height = totalH;
    self.materialView.frame = rect;
    
    totalH += 44 + 10;
    
    majorMaterialHeight = totalH;
}
    
- (void)isHideWithView:(BOOL)isHide {
	 self.imgNext .hidden =isHide;
    self.btnClick.hidden = isHide;
    self.specialLabelManagerLab.hidden  = isHide;
}

- (void)createSpecialData
{
   
    self.specialTagDataList =[[NSMutableArray alloc]init];
    if ([ObjectUtil isNotEmpty:self.specialList]) {
        for (OrderDetailSpecialView *iteam in self.specialList) {
            NSString *specialTagId = iteam.specialTagId;
            NSString *specialTagName = iteam.specialTagString;
            NSInteger sortCode =iteam.isSelected;
            short tagSource = iteam.tagSource;
            SpecialTagVO *specialTagItem = [[SpecialTagVO alloc]initWithData:specialTagId name:specialTagName sortCode:sortCode source:tagSource];
            [ self.specialTagDataList addObject:specialTagItem];
            
        }
    }

    [UIHelper refreshTop:self.ScrollView];
    [self updateSize];
    
}

//-(void)getHeight
//{
//
//    meatHeight =self.meatView.height;
//    vdHeight =self.vDishesView.height;
//    aqHeight =self.aquaticView.height
//}

- (void)initGrid
{
    self.tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabview.delegate =self;
    self.tabview.dataSource =self;
    UIView *view =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    view.backgroundColor =[UIColor clearColor];
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10, -10, SCREEN_WIDTH-20,180)];
    label.backgroundColor =[UIColor clearColor];
    label.numberOfLines=0;
     label.text =NSLocalizedString(@"1.极小份的菜，指一人份或者不太吃得饱的菜，比如按只点的扇贝、每人一盅的鱼翅羹，或者花蛤，螺蛳，羊肉串等小零食。\n2.标准菜量的菜，指店内一般量的普通菜，例如鱼香肉丝、番茄炒蛋等。\n3.特大量的菜，指菜量特别大的菜肴，例如烤全羊、大盘鸡等单人肯定无法吃完的菜品。\n4.设置菜量为智能提醒与推荐时计算菜品数量提供依据。设为“极小份”的菜，按0份计算，标准菜量按1份计算，“特大量”菜相当于普通菜几份就按照几份来计算。", nil);
    label.font =[UIFont systemFontOfSize:12];
    label.textColor =[UIColor darkGrayColor];
    [view addSubview:label];
    self.tabview.tableFooterView = view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger i =self.menuWeightVo.count;
    if (i==0) {
        return self.defautWeight.count;
    }
    return self.menuWeightVo.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([ObjectUtil isNotEmpty:self.menuWeightVo]) {
         OrderDetailWeight* models =self.menuWeightVo[section];
        if (models.specWeight>1) {
            return 2;
        }
       else
           return 1;
    }
    else
    {
        OrderDetailWeight* models =self.defautWeight[section];
        if (models.specWeight>1) {
            return 2;
        }
        else
            return 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    OrderDetailMoreCell *cell =[tableView dequeueReusableCellWithIdentifier:@"str"];
    if (cell ==nil) {
        cell =[[NSBundle mainBundle]loadNibNamed:@"OrderDetailMoreCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    if ([ObjectUtil isNotEmpty:self.menuWeightVo]) {
     OrderDetailWeight* models =self.menuWeightVo[indexPath.section];
     
    if (models.specWeight >1) {
    if (indexPath.row ==0) {
        [cell initarry:models delegate:self tag:indexPath.row iteamTag:indexPath.section];
    }
    if (indexPath.row ==1) {
            [cell initmorearry:models delegate:self tag:indexPath.row iteamTag:indexPath.section];
        }
    }
    else
    {
        
     [cell initarry:models delegate:self tag:indexPath.row iteamTag:indexPath.section];
        
    }
        return cell;
    }
    else
    {
        OrderDetailWeight* models =self.defautWeight[indexPath.section];
        if (models.specWeight >1) {
            if (indexPath.row ==0) {
                [cell initarry:models delegate:self tag:indexPath.row iteamTag:indexPath.section];
            }
            if (indexPath.row ==1) {
                [cell initmorearry:models delegate:self tag:indexPath.row iteamTag:indexPath.section];
            }
        }
        else
        {
            [cell initarry:models delegate:self tag:indexPath.row iteamTag:indexPath.section];
        }
        
        return cell;
    }
    return  nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    orderIteamTitle *iteam =[[orderIteamTitle alloc]init];
    [iteam awakeFromNib];
    if([ObjectUtil isNotEmpty:self.menuWeightVo])
    {
    OrderDetailWeight* models =self.menuWeightVo[section];
    iteam.lblname.text =models.specName;
    }
    else
    {
        iteam.lblname.text = NSLocalizedString(@"规格", nil);
        
    }
    return iteam;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     if([ObjectUtil isEmpty:self.menuWeightVo])
     {
         return 0;
     }
    
    return 48;
}
        
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (IBAction)BtnFeaturesView:(id)sender {
   
}

#pragma initView
- (void)initMainView
{
   self.TitleIteam.lblName.text =NSLocalizedString(@"类型  (必选)", nil);
    self.TitleIteam.lblName.font =[UIFont systemFontOfSize:13];
    NSMutableAttributedString *str =[[NSMutableAttributedString alloc]initWithString:self.TitleIteam.lblName.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,5)];
    self.TitleIteam.lblName.attributedText =str;
    
    [self.typeView initDelegate:self];

//    [self.meatView buildTheDelegate:self title:NSLocalizedString(@"*  荤菜", nil)];
//    [self.vDishesView buildTheDelegate:self title:NSLocalizedString(@"*  蔬菜", nil)];
//    [self.aquaticView buildTheDelegate:self title:NSLocalizedString(@"*  水产", nil)];
//    self.mainTitle.lblName.attributedText =str1;

   self.chiliView.lblName.text =NSLocalizedString(@"辣椒指数", nil);
    self.chiliView.lblName.font =[UIFont systemFontOfSize:13];
    [self.chiliIndexView initDelegate:self];
    self.recommendView.lblName.text =NSLocalizedString(@"推荐指数", nil);
    self.recommendView.lblName.font =[UIFont systemFontOfSize:13];
    [self.fManageView initDelegate:self];
    [self.rIndexView initDelegate:self];
   [self.customSetView initLabel:NSLocalizedString(@"在客户端置顶并大图显示", nil) withHit:NSLocalizedString(@"注：开启此项后， “火小二”应用以及微信账单中增加“店家推荐” 分组， 此分组置顶并且以大图置顶方式显示菜品", nil) delegate:self];
    self.customSetView.lblDetail.textColor =[UIColor lightGrayColor];
    self.customSetView.lblDetail.font =[UIFont systemFontOfSize:12];
    self.customSetView.line.hidden =YES;
    [self.featuresView initDelegate:self event:1 btnArrs:@[@"add",@"sort"]];
    self.featuresView.imgAdd.image =nil;
    self.featuresView.imgSort.image =nil;
    [self.featuresView visibal:YES];
    [self.customSetView visibal:YES];
    [self.customSetView initData:@"0"];
    self.componentView.lblName.text =NSLocalizedString(@"份量", nil);
    self.componentView.lblName.font =[UIFont systemFontOfSize:13];
    self.customSetView.tag =BigTag;
    [self.rnMajorMaterial addSubview:self.materialView];

    self.typeView.tag = ORDER_TYPE ;
    self.chiliIndexView.tag = ORDER_CHILIINDEX;
    self.fManageView.tag = ORDER_FMANAGE;
    self.rIndexView.tag = ORDER_RINDEX;

    [self isHideWithBrand];
    [self reloadView];

}

-(void)isHideWithBrand
{
    if ([[[Platform Instance] getkey:IS_BRAND]  isEqualToString:@"1"]) {
        [self isHideWithView:YES];
    }
    else {
        [self isHideWithView: NO];
    }
}

- (void) updateSize{
    for (UIView *view in self.container.subviews) {
        if ([view isKindOfClass:[ItemTitle class]] || [EditItemRadio class]) {
            CGRect frame = view.frame;
            frame.size.width = SCREEN_WIDTH;
            view.frame = frame;
        }
    }
}

- (void)createData
{
    if ([ObjectUtil isNotEmpty:self.dic]) {
        id  delegate  = self.dic[@"delegate"];
        if ([ObjectUtil isNotNull:delegate]) {
            self.delegate  = delegate ;
        }
        NSString *actionStr   = self.dic [@"action"];
        NSInteger action = actionStr.integerValue;
        NSString  *menuId  = self.dic [@"menuId"] ;
        NSString *title  = self.dic [@"title"];
        if (action == TDFActionOrderSet) {
            [self  initdata:title menuId:menuId action:actionStr.integerValue];
        }
        if (action  == TDFActionAddMenuSet) {
            [self initdata:title action:action];
        }
        if (action ==  TDFActionEditMenuSet) {
            [self initdata:title menuId:menuId action:action];
        }
    }
}

#pragma 每个模块的点击事件协议
- (void)changeIteam:(orderMuluSelect *)obj Button:(CusButton *)button isHide:(BOOL)hide
{
    if (obj.tag ==ORDER_TYPE) {
        [button loadRadiusWithcolor:[UIColor whiteColor] isselect:hide bgcolor:RGBA(255, 160, 40, 1) origincolor:RGBA(255, 204, 0, 1)];
        if (hide) {
            for (NSInteger i=0; i<self.labelVolist.count; i++) {
                OrderDetailLblVoList *vo =self.labelVolist[i];
                if (i ==button.tag-1) {
                    vo.isSelected =YES;
                }
                else
                {
                    vo.isSelected =NO;
                }
            }
            self.editmainStr =button.DetailLbl.text;
            if (button.tag > restrainCount) {
                [self resetView];
            }
            else
            {
                [self intputView];
            }
        }
    }
    if (obj.tag == ORDAER_MEAT ) {
        [self SwithHideWithtag:obj.tag];
         [button loadRadiusWithcolor:[UIColor whiteColor] isselect:hide bgcolor:RGBA(253, 103, 32, 1) origincolor:RGBA(255, 51, 0, 1)];
        if (hide) {
            for (NSInteger i=0; i<self.meatList.count; i++) {
                OrderDetailLblVoList *vo =self.meatList[i];
                if (i ==button.tag -100000) {
                    vo.isSelected =YES;
                }
                else
                {
                    vo.isSelected =NO;
                }
            }
            self.meattag=button.DetailLbl.text;
        }
    }
    if (obj.tag == ORDER_VDISHES) {
        [self SwithHideWithtag:obj.tag];
        [button loadRadiusWithcolor:[UIColor whiteColor] isselect:hide bgcolor:RGBA(253, 103, 32, 1) origincolor:RGBA(255, 51, 0, 1)];

        if (hide) {
            for (NSInteger i=0; i<self.vDishesViewList.count; i++) {
                OrderDetailLblVoList *vo =self.vDishesViewList[i];
                if (i ==button.tag -100000) {
                    vo.isSelected =YES;
                }
                else
                {
                    vo.isSelected =NO;
                }
            }
            self.vdTag =button.DetailLbl.text;
        }
    }
    if (obj.tag == ORDER_AQUATIC) {
        
        [self SwithHideWithtag:obj.tag];
         [button loadRadiusWithcolor:[UIColor whiteColor] isselect:hide bgcolor:RGBA(253, 103, 32, 1) origincolor:RGBA(255, 51, 0, 1)];
        if (hide) {
            for (NSInteger i=0; i<self.aquaticViewList.count; i++) {
                OrderDetailLblVoList *vo =self.aquaticViewList[i];
                if (i ==button.tag -1000000) {
                    vo.isSelected =YES;
                }
                else
                {
                    vo.isSelected =NO;
                }
            }
            self.waterTag =button.DetailLbl.text;
           }
       }
    if (obj.tag == ORDER_CHILIINDEX) {
        
        [button loadRadiusWithcolor:[UIColor whiteColor]  isselect:hide bgcolor:RGBA(209, 19,21 , 1) origincolor:RGBA(255, 51, 0, 1) ];
       
        if (hide) {
            for (NSInteger i=0; i<self.acridList.count; i++) {
               OrderDetailAcridView *vo =self.acridList[i];
                if (i ==button.tag ) {
                    vo.isSelected =YES;
                }
                else
                {
                    vo.isSelected =NO;
                 }
            }
        self.acridlevelstring =button.DetailLbl.text;
        }
       }
    if (obj.tag == ORDER_FMANAGE ) {
         [button loadRadiusWithcolor:[UIColor whiteColor] isselect:hide bgcolor:RGBA(24, 166, 47, 1) origincolor:RGBA(68, 163, 20, 1)];
        if (hide) {
            for (NSInteger i=0; i<self.specialList.count; i++) {
                 OrderDetailSpecialView *vo =self.specialList[i];
                if (i ==button.tag -100000) {
                    vo.isSelected =YES;
                }
                else
                {
                    vo.isSelected =NO;
                }
            }
            self.specialTagIdstring =button.DetailLbl.text;
        }
    }
    if (obj.tag == ORDER_RINDEX ) {
         [button loadRadiusWithcolor:[UIColor whiteColor] isselect:hide bgcolor:RGBA(22, 141, 203, 1) origincolor:RGBA(0, 153, 255, 1)];
        if (hide) {
            for (NSInteger i=0; i<self.recommendList.count; i++) {
                 OrderDetailAdviseView *vo =self.recommendList[i];
                if (i ==button.tag ) {
                    vo.isSelected =YES;
                    
                    if (i==0) {
                        [self changeRecommendStatus];
                    }
                   
                }
                else
                {
                    vo.isSelected =NO;
                }
            }
            self.recommendLevelstring = button.DetailLbl.text;
            if (button.tag >hideSelectCount) {
                [self  isHideStickSwitch:YES];
            }
            else
            {
                [self  isHideStickSwitch:NO];
            }
        }
    }
    
    [self configNavigationBar:YES];
    self.isTitleChange  = YES;
  
}

- (void)isHideStickSwitch:(BOOL)isHide
{
    [self.customSetView visibal:isHide];
    [self reloadView];
}


#pragma 当选中为不设定的时候需要改变开关
- (void) changeRecommendStatus
{
    if ([self.customSetView getVal]) {
        [self.customSetView initData:@"0"];
    }
    self.topIndex =  [self.customSetView getVal];
}

- (void)onIrdeItemListClick:(OrderDetailMoreCell *)obj
{
    NSInteger row = obj.row;
    if ([ObjectUtil isNotEmpty:self.menuWeightVo]) {
    for (NSInteger i=0; i<self.menuWeightVo.count; i++) {
        if (obj.row ==i) {
        NSMutableArray *shopArry =[[NSMutableArray alloc]init];
               NSArray *arry =@[NSLocalizedString(@"极小份", nil),NSLocalizedString(@"标准菜量", nil),NSLocalizedString(@"特大量", nil)];
                for (NSInteger i=0; i<arry.count; i++) {
                    NameItemVO *vo =[[NameItemVO alloc]init];
                    vo.itemName =arry[i];
                    vo.itemId =[NSString stringWithFormat:@"%@",arry[i]];
                    [shopArry addObject:vo];
                }

            NSString * str =[obj getstr];
            TDFOptionPickerController *vc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"菜肴份额", nil)

                                                                                         options:shopArry
                                                                                   currentItemId:str];
            
            __weak __typeof(self) wself = self;
            vc.competionBlock = ^void(NSInteger index) {
                
                [wself pickOption:shopArry[index] event:row];
            };
            [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:vc animated:YES completion:nil];
        }
    if (obj.row ==1000+i)
    {
        NSMutableArray *shopArry =[[NSMutableArray alloc]init];
        for (NSInteger i=2; i<=100; i++) {
            NameItemVO *vo =[[NameItemVO alloc]init];
            vo.itemName =[NSString stringWithFormat:NSLocalizedString(@"%ld份", nil),i];
            vo.itemId =[NSString stringWithFormat:NSLocalizedString(@"%ld份", nil),i];
            [shopArry addObject:vo];
        }
           NSString * str =[obj getstr];
        TDFOptionPickerController *vc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"菜肴份额", nil)
                                                                                     options:shopArry
                                                                               currentItemId:str];
        __weak __typeof(self) wself = self;
        vc.competionBlock = ^void(NSInteger index) {
            [wself pickOption:shopArry[index] event:row];
        };
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:vc animated:YES completion:nil];
     }
    }
  }
 else
    {
        for (NSInteger i=0; i<self.defautWeight.count; i++) {
            if (obj.row ==i) {
                NSMutableArray *shopArry =[[NSMutableArray alloc]init];
               NSArray *arry =@[NSLocalizedString(@"极小份", nil),NSLocalizedString(@"标准菜量", nil),NSLocalizedString(@"特大量", nil)];
                for (NSInteger i=0; i<arry.count; i++) {
                    NameItemVO *vo =[[NameItemVO alloc]init];
                    vo.itemName =arry[i];
                    vo.itemId =[NSString stringWithFormat:@"%@",arry[i]];
                    [shopArry addObject:vo];
                }
                NSString * str =[obj getstr];
                TDFOptionPickerController *vc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"菜肴份额", nil)
                                                                                             options:shopArry
                                                                                       currentItemId:str];
                
                __weak __typeof(self) wself = self;
                vc.competionBlock = ^void(NSInteger index) {
                    
                    [wself pickOption:shopArry[index] event:row];
                };
                [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:vc animated:YES completion:nil];
            }
            if (obj.row ==1000+i)
            {
                
                NSMutableArray *shopArry =[[NSMutableArray alloc]init];
                
                for (NSInteger i=2; i<=100; i++) {
                    NameItemVO *vo =[[NameItemVO alloc]init];
                    vo.itemName =[NSString stringWithFormat:NSLocalizedString(@"%ld份", nil),i];
                    vo.itemId =[NSString stringWithFormat:NSLocalizedString(@"%ld份", nil),i];
                    [shopArry addObject:vo];
                }
                
                NSString * str =[obj getstr];
                NSString *iteamId  =[self getGoodText:str WithArry:shopArry];
                
                TDFOptionPickerController *vc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"菜肴份额", nil)
                                                                                             options:shopArry
                                                                                       currentItemId:iteamId];
                
                __weak __typeof(self) wself = self;
                vc.competionBlock = ^void(NSInteger index) {
                    
                    [wself pickOption:shopArry[index] event:row];
                };
                [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:vc animated:YES completion:nil];
            }
        }
    }
    [self configNavigationBar:YES];
    self.isTitleChange  = YES;
}


- (NSString *)getGoodText:(NSString *)text  WithArry:(NSMutableArray *)arry
{
    if ([NSString isNotBlank:text]) {
        if ([ObjectUtil isNotEmpty:arry]) {
            for (NameItemVO *iteam in arry) {
                if ([text isEqualToString:iteam.itemName]) {
                    return iteam.itemId;
                }
            }
        }
    }
    return @"";
}

- (void)onItemRadioClick:(EditItemRadio *)obj
{
    if (obj.tag == BigTag) {
        self.topIndex =[self.customSetView getVal];
    }

  [self configNavigationBar:YES];
    self.isTitleChange  = YES;
    
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    if ([ObjectUtil isNotEmpty:self.menuWeightVo]) {
        
    if (eventType<1000) {
    OrderDetailWeight *iteam =[self.menuWeightVo objectAtIndex:eventType];
    NameItemVO *Vo  =(NameItemVO *)selectObj;
    iteam.specName =Vo.itemName;
    if ([iteam.specName isEqualToString:NSLocalizedString(@"特大量", nil)]) {
        iteam.Ismore =YES;
        iteam.specWeight =2;
       
    }
    else if ([iteam.specName isEqualToString:NSLocalizedString(@"标准菜量", nil)])
    {
         iteam.specWeight =1;
    }
    else
    {
         iteam.specWeight =0;
    }
    [self.tabview reloadData];
        
    }
    else if (eventType ==2000) {
        SpecialTagVO *specialTagItem = (SpecialTagVO *)selectObj;
        for (OrderDetailSpecialView *iteam in self.specialList) {
          if ([iteam.specialTagString  isEqualToString:specialTagItem.specialTagName] ) {
                iteam.isSelected =1;
              self.specialTagIdstring = iteam.specialTagString;
          }
        else
        {
            iteam.isSelected =0;
        }
      }
        [self.fManageView createViewWithArry:self.specialList Imgcolor:RGBA(24, 166, 47, 1) Bgcolor:RGBA(24, 166, 47, 1) tag:2 hideColor:RGBA(255, 153, 0, 1)];
        [self configNavigationBar:YES];
        self.isTitleChange  = YES;
    }
   else
    {
       OrderDetailWeight *iteam =[self.menuWeightVo objectAtIndex:eventType-1000];
        NameItemVO *Vo  =(NameItemVO *)selectObj;
        iteam.specWeight =Vo.itemName.integerValue;
        [self.tabview reloadData];
    }
  }
    else
    {
        if (eventType<1000) {
            OrderDetailWeight *iteam =[self.defautWeight objectAtIndex:eventType];
            NameItemVO *Vo  =(NameItemVO *)selectObj;
            iteam.specName =Vo.itemName;
            if ([iteam.specName isEqualToString:NSLocalizedString(@"特大量", nil)]) {
                iteam.Ismore =YES;
                iteam.specWeight =2;
                
            }
            else if ([iteam.specName isEqualToString:NSLocalizedString(@"标准菜量", nil)])
            {
                iteam.specWeight =1;
            }
            else
            {
                iteam.specWeight =0;
            }
            [self.tabview reloadData];
            
        }
        else if (eventType ==2000) {
            SpecialTagVO *specialTagItem = (SpecialTagVO *)selectObj;
            for (OrderDetailSpecialView *iteam in self.specialList) {
                if ([iteam.specialTagString  isEqualToString:specialTagItem.specialTagName] ) {
                    iteam.isSelected =1;
                    self.specialTagIdstring = iteam.specialTagString;
                }
                else
                {
                    iteam.isSelected =0;
                }
            }
            [self.fManageView createViewWithArry:self.specialList Imgcolor:RGBA(24, 166, 47, 1) Bgcolor:RGBA(24, 166, 47, 1) tag:2 hideColor: RGBA(255, 153, 0, 1)];

            [self configNavigationBar:YES];
            self.isTitleChange  = YES;
        }
        else
        {
            OrderDetailWeight *iteam =[self.defautWeight objectAtIndex:eventType-1000];
            NameItemVO *Vo  =(NameItemVO *)selectObj;
            iteam.specWeight =Vo.itemName.integerValue;
            [self.tabview reloadData];
        }
    }
    return YES;
}

- (BOOL)isValid
{
    if ([NSString isBlank:self.editmainStr]) {
        [AlertBox show:NSLocalizedString(@"商品类型不能为空!", nil)];
        return NO;
    }
    if (self.shopTag<6) {
        if (self.materialList.count <= 0) {
            [AlertBox show:NSLocalizedString(@"请选择商品主料!", nil)];
            return NO;
        }
    }
    return YES;
}

- (void)save
{
    if (self.action ==1) {
        if ([self.customSetView getVal] ==1) {
            [AlertBox show:NSLocalizedString(@"此商品还没有图片，不可以置顶并大图显示!", nil)];
            return;
        }
    }
    NSString *str =[self getstr];
    
    if (![self isValid]) {
        return;
    }
    NSMutableDictionary *mutdic =[[NSMutableDictionary alloc]init];
    OrderDetailAdviseView *Recommenditeam =[self recommelebel];
    [mutdic setValue:[NSString stringWithFormat:@"%ld",Recommenditeam.recommendLevel] forKey:@"recommendLevel"];
    [self.editDic setObject:[NSString stringWithFormat:@"%ld",Recommenditeam.recommendLevel] forKey:@"recommendLevel"];
    
    
    [mutdic setValue:[NSString stringWithFormat:@"%@",Recommenditeam.recommendLevelString] forKey:@"recommendLevelString"];
    
    [self.editDic setValue:[NSString stringWithFormat:@"%@",Recommenditeam.recommendLevelString] forKey:@"recommendLevelString"];
    OrderDetailAcridView *AcriIteam =[self getarcridIteam];
    [mutdic setValue:[NSString stringWithFormat:@"%ld",AcriIteam.acridLevel] forKey:@"acridLevel"];
    [mutdic setValue:[NSString stringWithFormat:@"%@",AcriIteam.acridLevelString] forKey:@"acridLevelString"];
    [self.editDic setValue:[NSString stringWithFormat:@"%ld",AcriIteam.acridLevel] forKey:@"acridLevel"];
    [self.editDic setValue:[NSString stringWithFormat:@"%@",AcriIteam.acridLevelString] forKey:@"acridLevelString"];
    
    OrderDetailSpecialView *SpeIteam =[self getspecialIteam];
    //不设定的时候不传ID
    if ([NSString isNotBlank:SpeIteam.specialTagId]) {
      [mutdic setValue:[NSString stringWithFormat:@"%@",SpeIteam.specialTagId] forKey:@"specialTagId"];
    }
    
    [mutdic setValue:[NSString stringWithFormat:@"%@",SpeIteam.specialTagString] forKey:@"specialTagString"];
    [self.editDic setValue:[NSString stringWithFormat:@"%@",SpeIteam.specialTagId] forKey:@"specialTagId"];
    [self.editDic setValue:[NSString stringWithFormat:@"%@",SpeIteam.specialTagString] forKey:@"specialTagString"];
    [mutdic setValue:[NSString stringWithFormat:@"%ld",SpeIteam.tagSource] forKey:@"tagSource"];
    [self.editDic setValue:[NSString stringWithFormat:@"%ld",SpeIteam.tagSource] forKey:@"tagSource"];

    [mutdic setValue:str forKey:@"menuAttribute"];
    [mutdic setValue:[NSString stringWithFormat:@"%ld",self.topIndex] forKey:@"showTop"];
    [self.editDic setValue:[NSString stringWithFormat:@"%d",[self.customSetView getVal]] forKey:@"showTop"];
    self.munuDicJsonStr   = [NSString stringWithFormat:@"%@",[mutdic JSONString]];
    if (self.action ==TDFActionAddMenuSet) {
        NSMutableDictionary *params   = [NSMutableDictionary dictionary];
        params [@"editDic"] =  self.editDic;
        params [@"jsonStr"] =   self.munuDicJsonStr;
        NSString *actionStr  = [NSString stringWithFormat:@"%ld",self.action];
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[MenuListView class]]) {
                [(MenuListView *)viewController loadMenus];
            }
        }
        [self.navigationController popViewControllerAnimated: YES];
        if ( self.delegate ) {
            [self.delegate navitionToPushBeforeJump:actionStr data:params];
        }
      
    }
    else if(self.action ==TDFActionEditMenuSet)
    {
         [UIHelper showHUD:NSLocalizedString(@"正在保存", nil) andView:self.view  andHUD:hud ];
        [service saveShopSetLblList:self.menuId menulabelStr: self.munuDicJsonStr target:self callback:@selector(savedata:)];
    }
    else
    {
    [UIHelper showHUD:NSLocalizedString(@"正在保存", nil) andView:self.view  andHUD:hud ];
    [service saveShopSetLblList:self.menuId menulabelStr: self.munuDicJsonStr target:self callback:@selector(savedata:)];
    }
}

- (void)savedata:(RemoteResult *)result
{
    [hud  hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    if (self.action ==ACTION_CONSTANTS_EDIT) {
        
        NSMutableDictionary *params   = [NSMutableDictionary dictionary];
        params [@"editDic"] =  self.editDic;
        params [@"jsonStr"] =   self.munuDicJsonStr;
        NSString *actionStr  = [NSString stringWithFormat:@"%ld",self.action];
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[MenuListView class]]) {
                [(MenuListView *)viewController loadMenus];
            }
        }
         [self.navigationController popViewControllerAnimated: YES];
        if ( self.delegate ) {
            [self.delegate navitionToPushBeforeJump:actionStr data:params];
        }
        
    }
    else
    {
         [self.navigationController popViewControllerAnimated:YES];
        if (self.delegate) {
            [self.delegate navitionToPushBeforeJump:@"" data:nil];
        }
       
    }
}

- (NSString *)getstr
{
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];

    for (NSInteger i=0; i<self.menuWeightVo.count; i++) {
        OrderDetailWeight *vo =self.menuWeightVo[i];
        if (vo.specWeight ==0) {
            [dict setValue:[NSString stringWithFormat:@"%d",0] forKey:vo.specId];
        }
        else if (vo.specWeight ==1) {
          [dict setValue:[NSString stringWithFormat:@"%d",1] forKey:vo.specId];
        }
        if (vo.specWeight >1) {
            [dict setValue:[NSString stringWithFormat:@"%ld",vo.specWeight] forKey:vo.specId];
        }
       
    }
    if ([ObjectUtil isNotEmpty:self.defautWeight]) {
        OrderDetailWeight *vo =self.defautWeight[0];
        
        self.defautstr =[NSString stringWithFormat:@"%ld",vo.specWeight];
    }
    NSString *spestr =[dict JSONString];
    NSArray *keys =@[@"menu_weight",@"spec_weight",@"label_info"];
    NSInteger  i =0;
    NSString *Astr ;
    NSString *Bstr ;
    for (NSInteger j=0; j<self.labelVolist.count; j++) {
        OrderDetailLblVoList * iteam =self.labelVolist[j];
        if (iteam.isSelected) {
            i++;
            self.shopTag =iteam.labelId;
            self.editmainStr =iteam.labelName;
            Astr =[NSString stringWithFormat:@"%ld",iteam.labelId];
            if (iteam.labelId<6) {
                
                NSMutableArray *strArr = [NSMutableArray arrayWithCapacity:self.materialList.count];
                for (TDFOrderDetailMaterialVoModel *labelModel in self.materialList) {
                    [strArr addObject:[NSString stringWithFormat:@"%@,%@", labelModel.labelMaterialId, labelModel.labelId]];
                  
                }
                
                Bstr = [strArr componentsJoinedByString:@"|"];
                
                NSLog(@"Bstr -- %@",Bstr);
            } else {
                Bstr = @"";
            }
                
        }
        
    }
    if ([NSString isNotBlank:Astr]) {
        NSMutableString *str =[[NSMutableString alloc]init];
        [str appendString:self.editmainStr];
//        if ([NSString isNotBlank:Bstr]) {
//            [str appendString:@", "];
//            [str appendString:self.editdetaiStr];
//           
//        }
        [self.editDic setObject:str forKey:@"tagOfMenu"];
    }
    NSString *lableinfo ;
    if (i==0) {
       lableinfo =@"";
    }
    else
    {
    if ([NSString isNotBlank:Bstr]) {
        lableinfo =[NSString stringWithFormat:@"%@;%@",Astr,Bstr];
    }
    else
    {
         lableinfo =[NSString stringWithFormat:@"%@",Astr];
    }
    }
    NSLog(@"%@",lableinfo);
    NSArray *valuess =@[self.defautstr,spestr,lableinfo];
    NSDictionary *dict1 =[[NSDictionary alloc]initWithObjects:valuess forKeys:keys];
    NSString *str ;
    str=[dict1 JSONString];
    NSLog(@"%@",str);
    return str;
}


- (OrderDetailAdviseView *)recommelebel
{
    if ([ObjectUtil isNotEmpty:self.recommendList]) {
        for (OrderDetailAdviseView *iteam in self.recommendList) {
        if ([iteam.recommendLevelString isEqualToString:self.recommendLevelstring]) {
            return iteam;
            }
        }
    }
    return nil;
}
- (OrderDetailAcridView *)getarcridIteam
{
    if ([ObjectUtil isNotEmpty:self.acridList]) {
        for (OrderDetailAcridView *iteam in self.acridList) {
            if ([iteam.acridLevelString isEqualToString:self.acridlevelstring]) {
                return iteam;
            }
        }
    }
    return nil;
}

- (OrderDetailSpecialView *)getspecialIteam
{
    if ([ObjectUtil isNotEmpty:self.specialList]) {
        for (OrderDetailSpecialView *iteam in self.specialList) {
            if ([iteam.specialTagString isEqualToString:self.specialTagIdstring]) {
                return iteam;
            }
        }
        
    }
    return nil;
}
- (void)SwithHideWithtag:(NSInteger)tag
{
    switch (tag) {
        case  12:
        {
            [self cancelSelect:self.vDishesViewList];
            [self cancelSelect:self.aquaticViewList];
            self.vdTag =nil;
            self.waterTag =nil;
        }
            break;
        case 13:
            {
                [self cancelSelect:self.meatList];
                [self cancelSelect:self.aquaticViewList];
                self.meattag=nil;
                self.waterTag =nil;
            }
                break;
            case 14:
                {
                    [self cancelSelect:self.vDishesViewList];
                    [self cancelSelect:self.meatList];
                    self.vdTag=nil;
                    self.meattag =nil;
                }
                    break;
                default:
                    break;
    }
}

- (void)cancelSelect:(NSArray *)arry
{
    for (OrderDetailLblVoList *VO in arry) {
        VO.isSelected =NO;
    }
}

- (void)reloadView
{
   [UIHelper refreshUI:self.container scrollview:self.ScrollView];
}

- (void)resetView
{
    [self.rnMajorMaterial setHeight:0.0f];
    [self.rnMajorMaterial setHidden:YES];
    [self reloadView];
}

- (void)intputView
{
    [self.rnMajorMaterial setHeight:majorMaterialHeight];
    [self.rnMajorMaterial setHidden:NO];
    [self reloadView];
}

- (void)adjustrecommend
{
    for (OrderDetailAdviseView *vo in self.recommendList) {
        if (vo.isSelected) {
            if ([vo.recommendLevelString isEqualToString:NSLocalizedString(@"不设定", nil)]) {
                [self.customSetView visibal:NO];
                [self reloadView];
            }
            else
            {
                [self.customSetView visibal:YES];
                [self reloadView];
            }
        }
    }
   
}

- (void)onTitleAddClick:(NSInteger)event
{
    if ([[[Platform Instance] getkey:IS_BRAND]  isEqualToString:@"1"]) {
    return;
   }
    [self setmanager];
}

- (void)onTitleSortClick:(NSInteger)event
{
    if ([[[Platform Instance] getkey:IS_BRAND]  isEqualToString:@"1"]) {
    return;
  }
    [self setmanager];
}

- (void)setmanager
{
    [self pushSpecialManagerView];
}


-(void)initSelectStr
{
    
    for (OrderDetailAcridView *iteam in self.acridList) {
        if (iteam.isSelected) {
            self.acridlevelstring = iteam.acridLevelString;
        }
    }
    for (OrderDetailSpecialView *iteam in self.specialList) {
        if (iteam.isSelected) {
            self.specialTagIdstring = iteam.specialTagString;
        }
    }
    for (OrderDetailAdviseView *iteam in self.recommendList) {
        if (iteam.isSelected) {
            self.recommendLevelstring = iteam.recommendLevelString;
        }
    }
    for (OrderDetailLblVoList*iteam in self.labelVolist) {
        if (iteam.isSelected) {
            self.editmainStr =iteam.labelName;
            self.shopTag =iteam.labelId;
        }
    }
}

- (void)footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"orderLabelSet"];
}

-  (void)  pushSpecialManagerView
{
    [self createSpecialDataSource];
//    if (self.isReturnType) {
//        
//        [mainmodel showView:SPECIAL_TAG_LIST_VIEW];
//        [mainmodel.specialTagListView initWithData:self.specialTagDataList backView:MUNU_DETAIL_VIEW];
//        [mainmodel.specialTagListView initWithIdStr:self.IdStr action:self.action title:self.headTitle];
//    }
//    else
//    {
        NSArray *arry =self.specialTagDataList;

        UIViewController *viewController  =  [[TDFMediator sharedInstance] TDFMediator_specialTagListViewControllerTitle:self.headTitle menuId:self.IdStr action:self.action data:arry delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
    //}
}

- (void)createSpecialDataSource
{
    self.specialTagDataList =[[NSMutableArray alloc]init];
    if ([ObjectUtil isNotEmpty:self.specialList]) {
        for (OrderDetailSpecialView *iteam in self.specialList) {
            NSString *specialTagId = iteam.specialTagId;
            NSString *specialTagName = iteam.specialTagString;
            NSInteger sortCode =iteam.isSelected;
            short tagSource = iteam.tagSource;
            SpecialTagVO *specialTagItem = [[SpecialTagVO alloc]initWithData:specialTagId name:specialTagName sortCode:sortCode source:tagSource];
              [ self.specialTagDataList addObject:specialTagItem];
        }
    }
}

- (IBAction)pushMajorMaterial:(UIButton *)sender {
    
    //推到主料标签库页面
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        self.RNTagLibrary = [[TagLibraryRNModel alloc] init];
        
        __weak __typeof(self)weakSelf = self;
        
        self.RNTagLibrary.callBack = ^(BOOL isChange) {
            if (!isChange) {
                NSLog(NSLocalizedString(@"取消", nil));
                 [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            } else {
                NSLog(NSLocalizedString(@"保存", nil));
                  [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [weakSelf reloadMenuData];
              
            }
        };
        
    });
}

- (void)reloadMenuData {
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud ];
    
    if (self.action ==  TDFActionAddMenuSet) {
        [service getEmptyShopLblList:self callback:@selector(getShopLblData:)];
    } else {
        [service getShopLblList:self.menuId target:self callback:@selector(getShopLblData:)];
    }
    
}

- (NSMutableString *)labelMaterialId {
    if (!_labelMaterialId) {
        _labelMaterialId = [NSMutableString stringWithFormat:@""];
    }
    return _labelMaterialId;
}

- (NSMutableSet<TDFOrderDetailMaterialVoModel *> *)materialList {
    
    if (!_materialList) {
        _materialList = [NSMutableSet setWithCapacity:1];
    }
    
    return _materialList;
    
}

- (void)navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
    NSDictionary * dic   = obj ;
    NSString *menuId  =   dic [@"menuId"];
    NSString *action   =  dic [@"action"] ;
    NSString *title   =  dic [@"title"] ;
    if ([NSString  isNotBlank:menuId]) {
          [self  initdata:title menuId:menuId action:action.integerValue];
        }
    else
       {
          [self  initdata:title action:action.integerValue];
        }
}


- (UICollectionView *)materialView {
    
    if (!_materialView) {
        _materialView = ({
            
            UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 300)
                                                              collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
            
            collection.backgroundColor = [UIColor clearColor];
            collection.delegate = self;
            collection.dataSource = self;
            collection.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
            
            UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collection.collectionViewLayout;
            
            int totalW = collection.bounds.size.width - (collection.contentInset.left + collection.contentInset.right);
            int itemW = (totalW - (3 * 10)) / 4;
            int itemH = itemW * 28 / 81;
            flowLayout.itemSize = CGSizeMake(itemW, itemH);
            
            flowLayout.headerReferenceSize = CGSizeMake(0, [TDFOrderMaterialCollectionViewHeader headerHeight]);
            flowLayout.footerReferenceSize = CGSizeZero;
            
            collection.collectionViewLayout = flowLayout;
            
            [collection registerClass:[TDFOrderMaterialCollectionViewCell class]
           forCellWithReuseIdentifier:kOrderDetailsViewMaterialCellId];
            
            [collection registerClass:[TDFOrderMaterialCollectionViewHeader class]
           forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kOrderDetailsViewMaterialHrderId];
            
            collection;
        });
        
        majorMaterialHeight = 0.0f;
    }
    
    return _materialView;
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.labelMaterialVoList.count;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.labelMaterialVoList[section].mainMaterialLabelList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TDFOrderMaterialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kOrderDetailsViewMaterialCellId forIndexPath:indexPath];
    
    [cell configureCellWithModel:self.labelMaterialVoList[indexPath.section].mainMaterialLabelList[indexPath.row]];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        return nil;
        
    } else {
        
        TDFOrderMaterialCollectionViewHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                          withReuseIdentifier:kOrderDetailsViewMaterialHrderId
                                                                                                 forIndexPath:indexPath];
        
        header.titleLabel.text = self.labelMaterialVoList[indexPath.section].labelMaterialName;
        
        return header;
    }
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TDFOrderDetailMaterialVoModel *cellModel = self.labelMaterialVoList[indexPath.section].mainMaterialLabelList[indexPath.row];
    cellModel.isSelected = !cellModel.isSelected;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    [self configNavigationBar:YES];
    self.isTitleChange  = YES;
    
    if (cellModel.isSelected) {
        [self.materialList addObject:cellModel];
    } else {
        [self.materialList removeObject:cellModel];
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return ((UICollectionViewFlowLayout *)collectionViewLayout).itemSize;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return ((UICollectionViewFlowLayout *)collectionViewLayout).headerReferenceSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return ((UICollectionViewFlowLayout *)collectionViewLayout).footerReferenceSize;
}

#pragma mark - RN
- (void)RNDidMount:(NSNotification*)notification {
    
    NSDictionary * notificationDic = (NSDictionary *)[notification object];
    
    if (notificationDic) {
        NSString * helpActionKey = notificationDic[@"mountComponent"];
        
        if (helpActionKey) {
            if ([helpActionKey isEqualToString:@"Did_Mount_TagLibrary"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UINavigationController * nav = (UINavigationController *)[[UIApplication sharedApplication].delegate window].rootViewController;
                    
                    // RN reload会重新加载组件，导致对象push自己
                    if (nav.topViewController == self.RNTagLibrary || !self.view.window) {
                        return ;
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:self.RNTagLibrary animated:YES];
                });
                
                return;
            }
        
        }
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden  = NO;
}

@end
