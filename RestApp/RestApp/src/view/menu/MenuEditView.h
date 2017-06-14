//
//  MenuEditView.h
//  RestApp
//
//  Created by zxh on 14-5-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "MultiCheckHandle.h"
#import "OptionPickerClient.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "IEditMultiListEvent.h"
#import "IEditItemMemoEvent.h"
#import "OptionPickerClient.h"
#import "NumberInputClient.h"
#import "ISampleListEvent.h"
#import "IMultiManagerEvent.h"
#import "IItemTitleEvent.h"
#import "EditImageBox.h"
#import "EditItemMemo.h"
#import "IEditImageBoxClient.h"
#import "MemoInputClient.h"
#import "MenuProp.h"
#import "OrderService.h"
#import "TDFMediator+MenuModule.h"
#import "TDFRootViewController.h"
#import "NavigationToJump.h"
#import <libextobjc/EXTScope.h>
#import "TDFRootViewController.h"
#import "NavigationToJump.h"
#import "TDFRootViewController+AlertMessage.h"
#import "EditItemView.h"
#import "MenuPricePlanDetailVo.h"
#import "TDFMediator+ChainMenuModule.h"
#import "EditItemList.h"
#import "MenuPriceTable.h"
#import "UnitListView.h"
@class MenuModule,MenuService,SystemService,NavigateTitle2,MBProgressHUD,MenuMake,SettingService;
@class EditItemText,EditItemList,EditItemRadio,EditItemRadio2,EditMultiList,ItemTitle,ZMTable;
@class Menu,SampleMenuVO,MenuSpecDetail,SpecDetail;

@interface MenuEditView : TDFRootViewController<INavigateEvent,OptionPickerClient,MultiCheckHandle,IEditItemListEvent,IEditItemRadioEvent,IEditMultiListEvent,OptionPickerClient,NumberInputClient,UIActionSheetDelegate,ISampleListEvent,IMultiManagerEvent,IItemTitleEvent,IEditItemMemoEvent,IEditImageBoxClient,MemoInputClient,EditItemListDelegate,UnitListViewDelegate,NavigationToJump>

{
    MenuModule *parent;
    
    MenuService *service;
    
    SystemService *systemService;
    
    SettingService *settingService;
    
    MBProgressHUD *hud;
    
    OrderService *orderservice ;
}
@property (nonatomic, strong)UINavigationController *rootController;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet ItemTitle *baseTitle;
@property (nonatomic, strong) IBOutlet EditItemList *lsKindName;
@property (nonatomic, strong) IBOutlet EditItemText *txtName;
@property (nonatomic, strong) IBOutlet EditItemText *txtCode;
@property (weak, nonatomic) IBOutlet EditItemList *menuCode;
@property (nonatomic, strong) EditItemList *stepLength;
@property (nonatomic, strong) IBOutlet EditItemList *lsPrice;
@property (nonatomic, strong) IBOutlet EditItemList *lsAccount;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsRatio;
@property (nonatomic, strong) IBOutlet ItemTitle *titleAdvance;
@property (nonatomic, strong) IBOutlet EditMultiList *mlsMake;
@property (nonatomic, strong) IBOutlet EditMultiList *mlsSpec;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsSameUnit;
@property (nonatomic, strong) IBOutlet EditItemList *lsUnit;
@property (nonatomic, strong) IBOutlet EditItemList *lsConsume;
@property (nonatomic, strong) IBOutlet EditItemList *lsDeductKind;
@property (nonatomic, strong) IBOutlet EditItemList *lsDeduct;
@property (nonatomic, strong) IBOutlet EditItemList *lsServiceFeeMode;
@property (nonatomic, strong) IBOutlet EditItemList *lsServiceFee;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsChangePrice;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsBackAuth;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsGive;
@property (nonatomic, strong) IBOutlet EditItemRadio2 *rdoIsSelf;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoViewInMenu;

@property (nonatomic, strong) IBOutlet ItemTitle *titleMake;
@property (nonatomic, strong) IBOutlet ZMTable *makeGrid;
@property (nonatomic, strong) IBOutlet ItemTitle *titleSpec;
@property (nonatomic, strong) IBOutlet ZMTable *specGrid;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;
@property (strong, nonatomic) IBOutlet EditItemList *goodLblSet;
@property (strong, nonatomic) IBOutlet ItemTitle *cusShowSet;
@property (strong, nonatomic) IBOutlet EditItemList *memPrice;
@property (strong, nonatomic) IBOutlet EditItemList *startPart;
@property (strong, nonatomic) IBOutlet EditItemRadio *cusBuyGood;
@property (strong, nonatomic) IBOutlet EditItemRadio *goodForOut;
@property (strong, nonatomic) IBOutlet EditItemMemo *introduceGood;
@property (strong, nonatomic) IBOutlet EditImageBox *goodPic;

@property (weak, nonatomic) IBOutlet EditItemView *isRatioView;
@property (strong, nonatomic) IBOutlet EditItemList *lsPackingNum;
@property (strong, nonatomic) IBOutlet EditItemList *lsPackingPrice;
@property (weak, nonatomic) IBOutlet EditItemList *lsMenuID;
@property (strong, nonatomic) NSString *imgFilePathTemp; 
@property (strong, nonatomic) NSMutableArray *menuDetails;
@property (assign, nonatomic) BOOL isFristLoad;
@property (assign, nonatomic) BOOL isupdateMenu;
@property (strong, nonatomic) NSString *IdStr;
@property (weak, nonatomic) IBOutlet EditItemView *isSameUnitView;
@property (weak, nonatomic) IBOutlet EditItemView *orChangePriceView;
@property (weak, nonatomic) IBOutlet EditItemView *gusBuyGoodView;
@property (weak, nonatomic) IBOutlet EditItemView *goodForOutView;

@property (weak, nonatomic) IBOutlet EditItemView *isBackAuthView;
@property (weak, nonatomic) IBOutlet EditItemView *viewInMenuView;

@property (weak, nonatomic) IBOutlet EditItemView *isGiveView;
@property (nonatomic, strong) NSMutableArray* treeNodes;
@property (nonatomic, strong) NSMutableArray* allTreeNodes;
@property (nonatomic, strong) NSMutableArray* menuMakeList;
@property (nonatomic, strong) NSMutableArray* menuSpecList;
@property (nonatomic, strong) NSMutableArray* oldMenuMakeList;
@property (nonatomic, strong) NSMutableArray* oldMenuSpecList;
@property (nonatomic, strong) NSMutableArray* makeList;  //做法库集合.
@property (nonatomic, strong) NSMutableDictionary* menuMakeDic; //做法字典项.
@property (nonatomic, strong) NSMutableArray* specDetailList;  //规格库集合.
@property (nonatomic, strong) NSMutableDictionary* menuSpecDic; //规格字典项.
@property (nonatomic, strong) SampleMenuVO* sampleMenuVO;
@property (nonatomic, strong) NSString* continueEvent;
@property (nonatomic, strong) Menu* menu;
@property (nonatomic, strong) MenuProp *menuProp;
@property (nonatomic, assign) NSInteger action;
@property (nonatomic, assign) BOOL isContinue;
@property (nonatomic ,strong) UIImage *imagedata;
@property (nonatomic ,strong) EditImageBox *boxdata;
@property (nonatomic ,strong) SampleMenuVO *sampleMenu;
@property (nonatomic ,strong) NSString *jsonstr;
@property (nonatomic ,assign) BOOL isFristPrice ; //标示是否是第一次设置会员价;
@property (nonatomic ,strong) NSString *oldPrice;
@property (nonatomic ,strong) NSString *oldMemberPrice;


@property (nonatomic, strong) NSMutableArray *detailList;
@property (nonatomic ,strong) NSMutableDictionary *orderDic;
@property  (nonatomic, strong) NSDictionary *dic;
@property (nonatomic , assign) id <NavigationToJump> delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parent;

- (void)loadData:(SampleMenuVO*) MenuModuleTemp action:(NSInteger)action isContinue:(BOOL)isContinue;

- (IBAction)btnDelClick:(id)sender;

//修改规格后，影响到现有的数据变化.
- (void)loadSpecChange:(SpecDetail *)spec isAdjust:(NSInteger)isAdjust;
-(void)getmenuActionstr:(NSMutableDictionary *)str jsonstr:(NSString *)jsonstr;
- (void)loadMenuMakeSpec:(NSString*)menuId;
- (void)refreshNewKind:(NSMutableArray *)kindList;
@end
