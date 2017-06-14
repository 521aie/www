//
//  SuitMenuKindEditView.h
//  RestApp
//
//  Created by zxh on 14-9-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "MultiCheckHandle.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "IEditMultiListEvent.h"
#import "OptionPickerClient.h"
#import "NumberInputClient.h"
#import "IItemTitleEvent.h"
#import "ISampleListEvent.h"
#import "ZMKindTable.h"
#import "IMultiManagerEvent.h"
#import "KindAndTasteVo.h"
#import "YYModel.h"
#import "NavigationToJump.h"
#import "TDFRootViewController.h"
@class MenuModule,MenuService,NavigateTitle2,MBProgressHUD;
@class ItemTitle,EditItemText,EditItemRadio,EditMultiList,EditItemList;
@class KindMenu,TreeNode;
@interface SuitMenuKindEditView : TDFRootViewController <INavigateEvent,MultiCheckHandle,IEditItemListEvent,IEditItemRadioEvent,IEditMultiListEvent,OptionPickerClient,NumberInputClient,UIActionSheetDelegate,IItemTitleEvent,ISampleListEvent,IMultiManagerEvent,NavigationToJump>{
    MenuModule *parent;
    MenuService *service;
    MBProgressHUD *hud;
}
@property (nonatomic, strong)  UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic, strong)  UIView *container;

@property (nonatomic, strong)  ItemTitle *baseTitle;
@property (nonatomic, strong)  EditItemText *txtName;
@property (nonatomic, strong)  EditItemRadio *rdoIsSecond;
@property (nonatomic, strong)  EditItemList *lsParent;
@property (nonatomic, strong)  UIView *baseDiv;
@property (nonatomic, strong)  UIView *advanceDiv;
@property (nonatomic, strong)  UIView *tasteDiv;
@property (nonatomic, strong)  ItemTitle *titleAdvance;
@property (nonatomic, strong)  EditMultiList *mlsTaste;
@property (nonatomic, strong)  EditItemText *txtCode;
@property (nonatomic, strong)  EditItemRadio *rdoIsGroupOther;
@property (nonatomic, strong)  EditItemList *lsGroup;
@property (nonatomic, strong)  EditItemList *lsDeductKind;
@property (nonatomic, strong)  EditItemList *lsDeduct;

@property (nonatomic, strong)  ItemTitle *memoTitle;
@property (nonatomic, strong)  ZMKindTable* memoGrid;


@property (nonatomic, strong)  UITextView *lblTip;

@property (nonatomic, strong)  UIButton *btnDel;
@property (nonatomic) BOOL changed;
@property (nonatomic) KindMenu* kindMenu;
@property (nonatomic) int action;
@property (nonatomic,retain) NSMutableArray *treeNodes;
@property (nonatomic,retain) NSMutableArray *treeNodesDel;
@property (nonatomic,retain) NSMutableArray* kindTastes;  //与商品分类关联额口味分类集合.
@property (nonatomic,retain) NSMutableArray* tastes;      //口味集合.
@property (nonatomic,retain) NSMutableDictionary* tastesDic;  //加料dic.

@property (nonatomic,retain) NSMutableArray* allKindTastes;  //所有的口味分类集合.
@property (nonatomic,retain) NSMutableDictionary* allTastesDic;  //加料dic.
@property (nonatomic) bool isContinue;
@property (nonatomic,strong) NSString* continueEvent;
@property (nonatomic,strong) NSDictionary * sourceDic;
@property (nonatomic, assign) id<NavigationToJump> delegate;


@property (nonatomic) TreeNode* currTreeNode;

- (void)loadData:(KindMenu*) objTemp node:(TreeNode*)node action:(int)action isContinue:(BOOL)isContinue;

//刷新备注变化.
-(void)refreshMemoChange:(NSMutableArray*) kinds;

-(IBAction)btnDelClick:(id)sender;

@end
