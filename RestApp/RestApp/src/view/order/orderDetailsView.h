//
//  orderDetailsView.h
//  RestApp
//
//  Created by iOS香肠 on 16/3/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemTitle.h"
#import "EditItemRadio.h"
#import "EditItemList.h"
#import "orderMuluSelect.h"
#import "SmartOrderModel.h"
#import "orderMuluSelect.h"
#import "orderHideMuluSelect.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "OrderService.h"
#import "OrderGuiGeView.h"
#import "OptionPickerClient.h"
#import "OrderBox.h"
#import "MenuModule.h"
#import "OrderDetailMoreCell.h"
#import "MBProgressHUD.h"
#import "IItemTitleEvent.h"
#import "OrderHideSelectView.h"
#import "TDFRootViewController.h"
#import "NavigationToJump.h"
#import "RCTRootView.h"
#import "RCTBundleURLProvider.h"
#import "RCTLinkingManager.h"
typedef NS_ENUM(NSInteger,ActionType) {
    
    TDFActionAddMenuSet  = 1 ,
    
    TDFActionEditMenuSet  ,
    
    TDFActionOrderSet,
};

@class TDFOrderMaterialVoModel;
@class TDFOrderDetailMaterialVoModel;
@interface orderDetailsView : TDFRootViewController<IEditItemRadioEvent,changeIteamImg,OptionPickerClient,UITableViewDataSource,UITableViewDelegate,OnITeamListView ,IItemTitleEvent,NavigationToJump>

{
    SmartOrderModel *model;
    
    MenuModule *mainmodel;
    
    OrderService *service ;
    
    MBProgressHUD *hud ;
    
//    NSInteger equalindex;
//    
//    NSInteger selectIndex;

    CGFloat  majorMaterialHeight;

}
@property (strong, nonatomic) IBOutlet UIView *bgview;

@property (nonatomic, strong) NSString *headTitle;
@property (strong, nonatomic) IBOutlet OrderHideSelectView *typeView;


@property (strong, nonatomic) IBOutlet ItemTitle *TitleIteam;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong, nonatomic) IBOutlet UIView *container;

@property (strong, nonatomic) IBOutlet ItemTitle *chiliView;
@property (strong, nonatomic) IBOutlet orderHideMuluSelect *chiliIndexView;
@property (strong, nonatomic) IBOutlet ItemTitle *featuresView;
@property (strong, nonatomic) IBOutlet OrderHideSelectView *fManageView;
@property (strong, nonatomic) IBOutlet ItemTitle *recommendView;
@property (strong, nonatomic) IBOutlet orderHideMuluSelect *rIndexView;
@property (strong, nonatomic) IBOutlet EditItemRadio *customSetView;
@property (strong, nonatomic) IBOutlet ItemTitle *componentView;

@property (strong, nonatomic) IBOutlet UITableView *tabview;

@property (strong, nonatomic) NSDictionary *dic;
@property (assign, nonatomic) id <NavigationToJump> delegate ;

@property (weak, nonatomic) IBOutlet UILabel *specialLabelManagerLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgNext;

@property (strong, nonatomic) IBOutlet UIView *rnMajorMaterial;
@property (strong, nonatomic) UICollectionView *materialView;
@property (strong, nonatomic) IBOutlet UIButton *btnClick;

@property (nonatomic ,strong)NSArray *labelVolist;
@property (nonatomic ,strong)NSMutableArray<TDFOrderMaterialVoModel *> *labelMaterialVoList;
@property (nonatomic ,strong)NSArray *acridList;
@property (nonatomic ,strong)NSArray *specialList;
@property (nonatomic ,strong)NSArray *recommendList;
@property (nonatomic ,strong)NSArray *meatList;
@property (nonatomic ,strong)NSArray *vDishesViewList;
@property (nonatomic ,strong)NSArray *aquaticViewList;
@property (nonatomic ,strong)NSArray *menuWeightVo;
@property (nonatomic ,strong)NSMutableArray *specialTagDataList;
@property (nonatomic ,strong)NSString *meatTitle;
@property (nonatomic ,strong)NSString *vDishesViewTitle;
@property (nonatomic ,strong)NSString *aquaticViewTitle;
@property (nonatomic ,strong)NSString *menuId;
@property (nonatomic ,strong)NSString *nameIndex;
@property (nonatomic ,strong)NSString *recommendLevel;
@property (nonatomic ,strong)NSString *recommendLevelstring;
@property (nonatomic ,strong)NSString *acridLevel;
@property (nonatomic ,strong)NSString *acridlevelstring;
@property (nonatomic ,strong)NSString *specialTagId;
@property (nonatomic ,strong)NSString *specialTagIdstring;
@property (nonatomic ,strong)NSString *tagSource;
@property (nonatomic ,strong)NSString *showTop;
@property (nonatomic ,strong)NSString  *buttonTag;
@property (nonatomic ,strong)NSString  *meattag;
@property (nonatomic ,strong)NSString *vdTag;
@property (nonatomic ,strong)NSString *waterTag;
@property (nonatomic ,assign)NSInteger topIndex;
@property (nonatomic ,strong)NSString *defautstr;
@property (nonatomic ,assign)BOOL  isReturnType;
@property (nonatomic ,strong)NSMutableArray *empty;
@property (nonatomic ,assign)NSInteger action;
@property (nonatomic ,assign)BOOL ischange;
@property (nonatomic ,strong)NSMutableArray *defautWeight;
@property (nonatomic ,strong)NSString *defautWeightStr;
@property (nonatomic ,strong) NSMutableDictionary *editDic;

@property (nonatomic ,strong) NSString *editmainStr;
@property (nonatomic ,assign) NSInteger shopTag;
@property (nonatomic ,strong) NSString *IdStr;
@property (nonatomic, strong) NSMutableString *labelMaterialId;
@property (nonatomic, strong) NSMutableSet<TDFOrderDetailMaterialVoModel *> *materialList;


//保存状态
@property (nonatomic ,strong) NSMutableDictionary *statusOldDic;
@property (nonatomic ,strong) NSMutableDictionary *statusDic;
@property (nonatomic ,strong) NSString *munuDicJsonStr;
@property (nonatomic ,assign) BOOL isTitleChange;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SmartOrderModel *)controller;

- (id)initWithMenuNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parent;
- (IBAction)BtnFeaturesView:(id)sender;
-(void)initdata:(NSString *)title menuId:(NSString *)menuId action:(NSInteger)action;
-(void)initdata:(NSString *)title action:(NSInteger)action;


@end
