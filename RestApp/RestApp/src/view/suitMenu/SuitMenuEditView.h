//
//  SuitMenuEditView.h
//  RestApp
//
//  Created by zxh on 14-8-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "MultiCheckHandle.h"
#import "OptionPickerClient.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "IEditMultiListEvent.h"
#import "OptionPickerClient.h"
#import "NumberInputClient.h"
#import "FooterListEvent.h"
#import "ISampleListEvent.h"
#import "IMultiManagerEvent.h"
#import "IItemTitleEvent.h"
#import "SelectMenuClient.h"
#import "ZMTable.h"
#import "SelectSingleMenuHandle.h"
#import "TDFRootViewController.h"
#import "TDFRootViewController+AlertMessage.h"
#import "MenuPriceTable.h"
#import "MenuPricePlanVo.h"
#import "EditItemView.h"
#import "Menu.h"
#import "MenuProp.h"
#import "EditItemMemo.h"
#import "EditImageBox.h"
#import "EditItemSignList.h"
#import "MenuDetail.h"
#import "MenuListView.h"
#import "MemoInputBox.h"
#import "SpecialTagListView.h"
#import "ColorHelper.h"
#import "EditItemList.h"
#import "KindMenuListView.h"
#import "TDFMediator+ChainMenuModule.h"
#import "NavigationToJump.h"
@class MenuModule,NavigateTitle2,MBProgressHUD,SettingService,SystemService;
@class EditItemText,EditItemList,EditItemRadio,EditItemRadio2,ItemTitle,FooterListView,SuitMenuDetailTable,ItemEndNote;
@class Menu,SuitMenuSample,MenuService,SuitMenuDetail;
@interface SuitMenuEditView : TDFRootViewController<INavigateEvent,OptionPickerClient,MultiCheckHandle,IEditItemListEvent,IEditItemRadioEvent,IEditMultiListEvent,OptionPickerClient,NumberInputClient,UIActionSheetDelegate,FooterListEvent,ISampleListEvent,IMultiManagerEvent,IItemTitleEvent,SelectSingleMenuHandle,SelectMenuClient,IEditItemMemoEvent,IEditImageBoxClient,MemoInputClient,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EditItemListDelegate,NavigationToJump>
{
    MenuModule *parent;
    
    MenuService *menuService;
    
   SettingService *settingService;
    
    SystemService *systemService;
    
    MBProgressHUD *hud;
}

@property (nonatomic, strong) IBOutlet FooterListView *footView;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

@property (nonatomic, strong) IBOutlet ItemTitle *baseTitle;
@property (nonatomic, strong) IBOutlet EditItemList *lsKindName;
@property (nonatomic, strong) IBOutlet EditItemText *txtName;
@property (nonatomic, strong) IBOutlet EditItemText *txtCode;
@property (weak, nonatomic) IBOutlet EditItemList *suitMenuCode;

@property (nonatomic, strong) IBOutlet EditItemList *lsPrice;
@property (nonatomic, strong) IBOutlet EditItemList *lsAccount;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsRatio;
@property (strong, nonatomic) IBOutlet EditItemRadio *allowCashierAmendPrice;

@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsAuth;
@property (nonatomic, strong) IBOutlet EditItemRadio2 *rdoIsSelf;
@property (nonatomic, strong) IBOutlet ItemEndNote *txtNote;

@property (nonatomic, strong) IBOutlet ItemTitle *titleAddDetail;
@property (nonatomic, strong) IBOutlet UIView* detailAddBox;
@property (nonatomic ,strong) NSString *oldMemberPrice;
@property (weak, nonatomic) IBOutlet ItemTitle *titleValuation;
@property (weak, nonatomic) IBOutlet ZMTable *valuationTable;
@property (weak, nonatomic) IBOutlet UITextView *valuationTip;
@property (nonatomic ,assign) BOOL isFristPrice ; //标示是否是第一次设置会员价;
@property (nonatomic ,strong) NSString *oldPrice;
@property (nonatomic, strong) IBOutlet UIView* kabawBox;
@property (nonatomic, strong) IBOutlet ItemTitle *titleKabaw;
@property (strong, nonatomic) NSMutableArray *arr;
@property (nonatomic, strong) IBOutlet ItemTitle *titleDetail;
@property (nonatomic, strong) IBOutlet SuitMenuDetailTable* detailGrid;
@property (weak, nonatomic) IBOutlet EditItemView *isRatioView;
@property (weak, nonatomic) IBOutlet EditItemView *gusBuyGoodView;
@property (weak, nonatomic) IBOutlet EditItemView *goodForOutView;
@property (weak, nonatomic) IBOutlet EditItemView *isBackAuthView;
@property (strong, nonatomic) IBOutlet EditItemView *isBrandAllowCashierAmend;

@property (nonatomic, strong) IBOutlet UIButton *btnDel;
@property (nonatomic, strong) IBOutlet EditItemList *lsMemberPrice;
@property (nonatomic, strong) IBOutlet EditItemList *lsLeastNum;
@property (nonatomic, strong) IBOutlet EditItemSignList *lsAcridLevel;
@property (nonatomic, strong) IBOutlet EditItemSignList *lsApproveLevel;
@property (nonatomic, strong) IBOutlet EditItemList *lsCharacters;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsReserve;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsTakeout;
@property (nonatomic, strong) IBOutlet EditItemMemo *txtMemo;
@property (nonatomic, strong) IBOutlet EditImageBox *boxPic;

@property (nonatomic, strong) NSMutableArray* menuDetails;
@property (nonatomic, strong) NSString *imgFilePathTemp;
@property (nonatomic, strong) NSMutableArray* acridDataList;
@property (nonatomic, strong) NSMutableArray* recommendDataList;
@property (nonatomic, strong) NSMutableArray* specialTagDataList;
@property (nonatomic, strong) NSMutableDictionary* specialTagDataMap;
@property (nonatomic, assign) NSInteger backView;
@property (nonatomic, strong) MenuProp *menuProp;
@property (nonatomic, strong) SampleMenuVO *suitMenuSample;
@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, assign) BOOL changed;
@property (nonatomic, assign) BOOL isContinue;
@property (nonatomic, assign) BOOL startUpLoadImg;
@property (nonatomic, strong)  UIImage *imageData;
@property (nonatomic, assign) int event;
@property (nonatomic, strong) Menu *menu;

@property (nonatomic, strong) NSMutableArray* treeNodes;
@property (nonatomic, strong) NSMutableArray* allTreeNodes;
@property (nonatomic, strong) NSMutableArray* suitMenuDetailList;
@property (nonatomic, strong) NSMutableArray* suitMenuChangeList;

@property (nonatomic, strong) NSMutableDictionary* detailMap;

@property (nonatomic, strong) SuitMenuDetail* currDetail;

//以下变量是添加子菜时，加载商品相关.
@property (nonatomic, strong) NSMutableArray *headList;
@property (nonatomic, strong) NSMutableArray *detailList;
@property (nonatomic, strong) NSMutableDictionary *detailMenuMap;
@property (nonatomic, strong) NSMutableDictionary *menuMap;
@property (nonatomic, strong) NSMutableArray *kindMenuList;
@property (nonatomic, strong) NSMutableArray *allNodeList;

@property (nonatomic, strong) NSString* delChangeId;  //删除的套餐子菜Id.
@property (nonatomic, strong) NSString* menuDetailId;  //删除的套餐子菜Id.
@property (nonatomic, assign) NSInteger action;

@property (nonatomic, strong) NSDictionary *sourceDic;
@property (nonatomic, strong) id <NavigationToJump> delegate;
@property (nonatomic ,assign) BOOL  isAddMenuImg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parent;

- (void)reloadData;  //持续添加

- (void)loadData:(SampleMenuVO*)menuTemp kindTrees:(NSMutableArray*)treeNodes action:(NSInteger)action withDetailArray:(NSMutableArray *)detail;

- (void)loadSuitDetails:(NSString*)menuId;

- (IBAction)btnDelClick:(id)sender;

- (IBAction)btnAddDetailClick:(id)sender;
@end
