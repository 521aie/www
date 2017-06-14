//
//  MenuListView.h
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFLabelItem.h"
#import "Role.h"
#import "MenuModule.h"
#import "MenuService.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "INameValueItem.h"
#import "TableIndexView.h"
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "SelectMenuHandle.h"
#import "DHListSelectHandle.h"
#import "OptionPickerClient.h"
#import "NavigationToJump.h"
#import "TDFRootViewController.h"
#import "EventConstants.h"
#import "ChainMenuFooterListView.h"
#import "TDFChainMenuService.h"
#import "ActionConstants.h"
#import "SelectKindMenuPanel.h"

@interface MenuListView : TDFRootViewController<FooterListEvent,ISampleListEvent,SelectMenuHandle,OptionPickerClient,DHListSelectHandle,NavigationToJump,UIActionSheetDelegate>
{
    SelectKindMenuPanel *selectKindMenuPanel;
    MBProgressHUD *hud;
}

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong)  UIButton *btnBg;
@property (nonatomic, strong) UIButton *managerButton;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ChainMenuFooterListView *chainFooterView;
@property (nonatomic, strong) NSMutableArray *headList;
@property (nonatomic, strong) NSMutableArray *kindList;
@property (nonatomic, strong) NSMutableArray *detailList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) NSMutableDictionary *menuMap;

@property (nonatomic, strong) NSMutableArray *kindMenuList;
@property (nonatomic, strong) NSMutableArray *allNodeList;
@property (nonatomic, strong) id<INameValueItem> currentHead;
@property (nonatomic, assign) NSInteger action;
@property (nonatomic, assign) BOOL itemShopTopSwitch;
@property (nonatomic, assign) BOOL  isShowSelectPancel; //添加判断是否加载左侧栏，用于去除多次刷新列表
- (void)loadMenus;


@end
