//
//  Target_MenuModule.m
//  RestApp
//
//  Created by zishu on 16/8/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_MenuModule.h"
#import "TDFBoxSelectViewController.h"
#import "MenuIdViewController.h"
#import "MenuListView.h"
#import "MenuEditView.h"
#import "BatchMenuListView.h"
#import "KindMenuListView.h"
#import "KindMenuEditView.h"
#import "MultiMasterManagerView.h"
#import "TasteListView.h"
#import "KindTasteEditView.h"
#import "TasteEditView.h"
#import "TableEditView.h"
#import "AdditionListView.h"
#import "MultiDetailView.h"
#import "SortTableEditView.h"
#import "MenuAdditionEditView.h"
#import "SystemUtil.h"
#import "KindAdditionEditView.h"
#import "KindMenuListView.h"
#import "SuitMenuEditView.h"
#import "MakeListView.h"
#import "MakeEditView.h"
#import "SuitMenuKindEditView.h"
#import "SpecListView.h"
#import "SpecEditView.h"
#import "MenuCodeView.h"
#import "UnitEditView.h"
#import "MenuMakeEditView.h"
#import "MenuSpecDetailEditView.h"
#import "SelectSpecView.h"

@implementation Target_MenuModule
- (UIViewController *)Action_nativeBoxSelectViewController:(NSDictionary *)params
{
    TDFBoxSelectViewController *boxSelectViewController = [[TDFBoxSelectViewController alloc]init];
    boxSelectViewController.needHideOldNavigationBar = [params[@"needHideOldNavigationBar"] boolValue];
    boxSelectViewController.packingBoxId = params[@"packingBoxId"];
//    boxSelectViewController.packingBoxName = params[@"packingBoxName"];
   if (params[@"callBack"]) {
        boxSelectViewController.callBack = params[@"callBack"];
    }
    return boxSelectViewController;
}


-(UIViewController *)Action_nativeMenuIDViewController:(NSDictionary *)params
{
    MenuIdViewController *menuIdViewController = [[MenuIdViewController alloc] init];
    menuIdViewController.menuName = params[@"menuName"];
    menuIdViewController.menuId = params[@"menuID"];
    return menuIdViewController;
}

- (UIViewController *)Action_nativeMenuListViewController:(NSDictionary *)params
{
    MenuListView *menuList  = [[MenuListView  alloc]  init];
    return menuList;
}

- (UIViewController *)Action_nativeMenuEditViewController:(NSDictionary *)params
{
    MenuEditView *menuEdit  = [[MenuEditView alloc] initWithNibName:@"MenuEditView" bundle:nil parent:nil];
    menuEdit.dic =[NSDictionary  dictionaryWithDictionary:params];
    menuEdit.needHideOldNavigationBar  = YES;
    return menuEdit;
}

- (UIViewController *)Action_nativeBatchMenuListViewController:(NSDictionary *)params
{
    BatchMenuListView *batachMenu  = [[BatchMenuListView alloc] initWithNibName:@"SelectMultiMenuListView" bundle:nil parent:nil];
    batachMenu.dic  = [NSDictionary dictionaryWithDictionary:params];
    return batachMenu;
}

- (UIViewController *)Action_nativeKindMenuListViewController:(NSDictionary *)params
{
    KindMenuListView * kindMenuList  =  [[KindMenuListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:nil];
    kindMenuList.needHideOldNavigationBar  = YES ;
    return kindMenuList ;
}

- (UIViewController *)Action_nativeKindMenuEditViewController:(NSDictionary *)params
{
    KindMenuEditView * kindMenuEdit  =  [[KindMenuEditView alloc] init];
    kindMenuEdit.dic  = [NSDictionary dictionaryWithDictionary:params];
    kindMenuEdit.needHideOldNavigationBar  = YES ;
    return kindMenuEdit ;
}

- (UIViewController *)Action_nativeMultiHeadCheckViewController:(NSDictionary *)params
{
      MultiMasterManagerView *multiView =  [[MultiMasterManagerView alloc] initWithNibName:@"MultiHeadCheckView" bundle:nil];
    multiView.dic  = [NSDictionary dictionaryWithDictionary:params];
    multiView.needHideOldNavigationBar = YES;
    return multiView;
    
}

- (UIViewController *)Action_nativeTasteListViewController:(NSDictionary *)params
{
       TasteListView  * tasteList  =[[TasteListView alloc] initWithNibName:@"SampleListView" bundle:nil parent: nil];
    tasteList.dic = [NSDictionary dictionaryWithDictionary:params];
    tasteList.needHideOldNavigationBar  =YES;
    return tasteList;
}

- (UIViewController *)Action_nativeKindTasteEditViewController:(NSDictionary *)params
{
       KindTasteEditView  *kindTasteEdit = [[KindTasteEditView alloc] initWithNibName:@"KindTasteEditView" bundle:nil parent: nil];
    kindTasteEdit.dic  = [NSDictionary dictionaryWithDictionary:params];
    kindTasteEdit .needHideOldNavigationBar =YES;
    return kindTasteEdit;
}

- (UIViewController *)Action_nativeTasteEditViewController:(NSDictionary *)params
{
    TasteEditView*tasteEditView =  [[TasteEditView alloc] initWithNibName:@"TasteEditView" bundle:nil parent: nil] ;
    tasteEditView.dic  = [NSDictionary dictionaryWithDictionary:params] ;
    tasteEditView.needHideOldNavigationBar  =YES ;
    return tasteEditView;
}

- (UIViewController *)Action_nativeTableEditViewController:(NSDictionary *)params
{
     TableEditView *tabEdit  =[[TableEditView alloc] initWithNibName:@"TableEditView" bundle:nil];
    tabEdit.dic  = [NSDictionary dictionaryWithDictionary:params];
    tabEdit.needHideOldNavigationBar  =YES ;
    return tabEdit;
}

- (UIViewController *)Action_nativeSortTableEditViewController:(NSDictionary *)params
{
    SortTableEditView *tableEdit  = [[SortTableEditView alloc] initWithNibName:@"TableEditView" bundle:nil];
    tableEdit.dic  = [NSDictionary dictionaryWithDictionary:params];
    tableEdit.needHideOldNavigationBar  =YES;
    return tableEdit;
}



- (UIViewController *)Action_nativeMultiDetailViewController:(NSDictionary *)params
{
    MultiDetailView  *multiDetail = [[MultiDetailView alloc] initWithNibName:@"SampleListView" bundle:nil];
    multiDetail.dic  =  [NSDictionary dictionaryWithDictionary:params];
    multiDetail.needHideOldNavigationBar = YES;
    return multiDetail;
}

- (UIViewController *)Action_nativeAdditionListViewController:(NSDictionary *)params
{
     AdditionListView* additionList =[[AdditionListView alloc] initWithNibName:@"SampleListView" bundle:nil parent: nil];
    additionList.dic = [NSDictionary dictionaryWithDictionary:params];
    additionList.needHideOldNavigationBar = YES;
    return additionList;
}

- (UIViewController *)Action_nativeMenuAdditionEditViewController:(NSDictionary *)params
{
  MenuAdditionEditView *menuAddtion = [[MenuAdditionEditView alloc] initWithNibName:@"MenuAdditionEditView" bundle:nil parent:nil];
    menuAddtion.dic  = [NSDictionary dictionaryWithDictionary:params];
    menuAddtion.needHideOldNavigationBar =YES;
    return menuAddtion;
}

- (UIViewController *)Action_nativeKindAdditionEditViewController:(NSDictionary *)params
{
      KindAdditionEditView *kindAddition = [[KindAdditionEditView alloc] initWithNibName:@"KindAdditionEditView" bundle:nil parent: nil];
      kindAddition.dic  = [NSDictionary dictionaryWithDictionary:params];
      kindAddition.needHideOldNavigationBar  = YES;
      return kindAddition;
}

- (UIViewController *)Action_nativeKindListViewController:(NSDictionary *)params
{
     KindMenuListView *menuList  = [[KindMenuListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:nil];
    menuList.dic  = [NSDictionary dictionaryWithDictionary:params];
    menuList.needHideOldNavigationBar = YES;
    return menuList;
}

- (UIViewController  *)Action_nativeSuitMenuEditViewController:(NSDictionary *)params
{
    SuitMenuEditView *suitMenu  = [[SuitMenuEditView alloc] initWithNibName:@"SuitMenuEditView" bundle:nil parent:nil];
    suitMenu.sourceDic   =  [NSDictionary  dictionaryWithDictionary:params];
    suitMenu.needHideOldNavigationBar = YES;
    return suitMenu;
}

- (UIViewController *)Action_nativeSuitMenuKindEditViewController:(NSDictionary *)params
{
    SuitMenuKindEditView * suitKindMenu   =  [[SuitMenuKindEditView alloc] init];
     suitKindMenu.sourceDic  = [NSDictionary  dictionaryWithDictionary:params];
     suitKindMenu.needHideOldNavigationBar  = YES;
     return suitKindMenu;
}

-  (UIViewController *)Action_nativeMultiCheckManageViewController:(NSDictionary *)params
{
      MultiCheckManageView *menuCheckManager=  [[MultiCheckManageView alloc] initWithNibName:@"MultiHeadCheckView" bundle:nil];
    menuCheckManager.dic  = [NSDictionary dictionaryWithDictionary:params];
    menuCheckManager.needHideOldNavigationBar  = YES ;
    return menuCheckManager;
}

- (UIViewController *)Action_nativeMakeListViewController:(NSDictionary *)params
{
    MakeListView *makeList  =  [[MakeListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:nil];
    makeList.dic  =  [NSDictionary  dictionaryWithDictionary:params];
    makeList.needHideOldNavigationBar = YES;
    return makeList;
}

- (UIViewController *)Action_nativeMakeEditViewController:(NSDictionary *)params
{
     MakeEditView *makeEdit  =  [[MakeEditView alloc] init];
    makeEdit.sourceDic  = [NSDictionary dictionaryWithDictionary:params];
    makeEdit.needHideOldNavigationBar = YES;
    return makeEdit ;
}

- (UIViewController *)Action_nativeSelectSpecViewController:(NSDictionary *)params
{
    SelectSpecView *selectSpe  = [[SelectSpecView alloc] initWithNibName:@"MultiHeadCheckView" bundle:nil];
    selectSpe.dic  = [NSDictionary dictionaryWithDictionary:params];
    selectSpe.needHideOldNavigationBar  = YES;
    return selectSpe;
}

- (UIViewController *)Action_nativeSpecListViewController:(NSDictionary *)params
{
     SpecListView * specList=[[SpecListView alloc] initWithNibName:@"SampleListView" bundle:nil parent: nil];
    specList.dic  = [NSDictionary dictionaryWithDictionary:params];
    specList.needHideOldNavigationBar = YES;
    return specList;
}

- (UIViewController *)Action_nativeSpecEditViewController:(NSDictionary *)params
{
    SpecEditView * specEdit=[[SpecEditView alloc] initWithNibName:@"SpecEditView" bundle:nil parent:nil];
    specEdit.sourceDic  = [NSDictionary dictionaryWithDictionary:params];
    specEdit.needHideOldNavigationBar = YES;
    return specEdit;
}

- (UIViewController *)Action_nativeMenuCodeViewController:(NSDictionary *)params
{
      MenuCodeView *menuCode  = [[MenuCodeView alloc] initWithNibName:@"MenuCodeView" bundle:nil parent: nil];
    menuCode.soureDic  = [NSDictionary dictionaryWithDictionary:params];
    menuCode.needHideOldNavigationBar  = YES;
    return menuCode;
}

- (UIViewController *)Action_nativeUnitListViewController:(NSDictionary *)params
{
    UnitListView*unitList = [[UnitListView alloc] initWithNibName:@"SampleListView" bundle:nil parent: nil];
    unitList.dic  = [NSDictionary dictionaryWithDictionary:params];
    unitList.needHideOldNavigationBar = YES;
    return unitList;
}

- (UIViewController *)Action_nativeUnitEditViewController:(NSDictionary *)params
{
    UnitEditView *unitEdit = [[UnitEditView alloc] initWithNibName:@"UnitEditView" bundle:nil parent: nil];
    unitEdit.sourceDic  = [NSDictionary dictionaryWithDictionary:params];
    unitEdit.needHideOldNavigationBar = YES;
    return unitEdit;
}

- (UIViewController *)Action_nativeMenuMakeEditViewController:(NSDictionary *)params
{
        MenuMakeEditView *menuMake  = [[MenuMakeEditView alloc] initWithNibName:@"MenuMakeEditView" bundle:nil parent: nil];
    menuMake.sourceDic  = [NSDictionary dictionaryWithDictionary:params];
    menuMake.needHideOldNavigationBar = YES;
    return menuMake;
}

- (UIViewController *)Action_nativeMenuSpecDetailEditViewController:(NSDictionary *)params
{
    MenuSpecDetailEditView *menuSpec =  [[MenuSpecDetailEditView alloc] initWithNibName:@"MenuSpecDetailEditView" bundle:nil parent:nil];
    menuSpec.sourceDic  = [NSDictionary dictionaryWithDictionary:params];
    menuSpec.needHideOldNavigationBar = YES;
    return menuSpec;
}

- (UIViewController *)Action_nativeSelectMenuListViewController:(NSDictionary *)params
{
    SelectMenuListView*selectMenuList =  [[SelectMenuListView alloc] initWithNibName:@"SelectMenuListView" bundle:nil];
    selectMenuList.sourceDic  = [NSDictionary dictionaryWithDictionary:params];
    selectMenuList.needHideOldNavigationBar  =YES;
    return selectMenuList;
}

- (UIViewController *)Action_nativeMenuDetailEditViewController:(NSDictionary *)params
{
       MenuDetailEditView  *menuDetail=[[MenuDetailEditView alloc] init];
    menuDetail.sourceDic  = [NSDictionary dictionaryWithDictionary:params];
    menuDetail.needHideOldNavigationBar  =YES;
    return menuDetail;
}

- (UIViewController *)Action_nativeSuitMenuChangeEditViewController:(NSDictionary *)params
{
    SuitMenuChangeEditView *suitMenu  = [[SuitMenuChangeEditView alloc] initWithNibName:@"SuitMenuChangeEditView" bundle:nil parent: nil];
    suitMenu.sourceDic  = [NSDictionary dictionaryWithDictionary:params];
    suitMenu.needHideOldNavigationBar  = YES;
    return suitMenu;
}
@end
