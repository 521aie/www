//
//  BatchMenuListView.h
//  RestApp
//
//  Created by zxh on 14-6-20.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterMultiView.h"
#import "ISampleListEvent.h"
#import "SelectMenuHandle.h"
#import "DHListSelectHandle.h"
#import "OptionPickerClient.h"
#import "MenuListView.h"
#import "KindMenu.h"
#import "TreeNode.h"
#import "TDFRootViewController.h"
#import <objc/runtime.h>
@class NavigateTitle2,SelectMultiMenuListPanel,MBProgressHUD,MenuModule,MenuService;
@interface BatchMenuListView : TDFRootViewController<INavigateEvent,ISampleListEvent,DHListSelectHandle,UIActionSheetDelegate,OptionPickerClient,FooterMultiEvent>
{
    MenuModule *parent;
    
    MenuService *service;
    
    MBProgressHUD *hud;
}

@property (nonatomic, strong) id<SelectMenuHandle> delegate;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet SelectMultiMenuListPanel *dhListPanel;

@property (nonatomic, strong) NSMutableArray *headList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) NSMutableArray *allNodeList;

@property (nonatomic, strong) NSString* titleStr;
@property (nonatomic, strong) NSMutableArray *selectMenuIds;

@property (nonatomic, strong) NSString* kindId;
@property (nonatomic, assign) BOOL isChain;
@property (nonatomic, strong) NSMutableArray *oldMenus;
@property (nonatomic, strong) NSDictionary *oldMap;
@property (nonatomic, strong) NSMutableArray *menuKindArr;
@property (nonatomic, strong) NSMutableArray *suitMenuKindArr;
@property (nonatomic) NSInteger batchAction;
@property (nonatomic ,strong)MenuListView *menulist;
@property (nonatomic ,strong)NSDictionary *dic;
@property (nonatomic, strong) NSString *type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parent;

- (void)loadMenus:(NSMutableArray *)headList menus:(NSMutableDictionary *)detailMap nodes:(NSMutableArray *)allNodeList delegate:(id<SelectMenuHandle>) delegate;

@end
