//
//  chainSelectListView.h
//  RestApp
//
//  Created by iOS香肠 on 16/2/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertBox.h"
#import "UIHelper.h"
#import "UIHelper.h"
#import "ViewFactory.h"
#import "JsonHelper.h"
#import "XHAnimalUtil.h"
#import "MBProgressHUD.h"
#import "TreeNodeUtils.h"
#import "ServiceFactory.h"
#import "TDFOptionPickerController.h"
#import "SelectMultiMenuItem.h"
#import "SelectMultiMenuListPanel.h"
#import "ISampleListEvent.h"
#import "SelectMenuClient.h"
#import "DHListSelectHandle.h"
#import "OptionPickerClient.h"
#import "TDFChainService.h"
#import <libextobjc/EXTScope.h>
#import "TDFRootViewController.h"

@class SelectMultiMenuListPanel;
@interface chainSelectListView : TDFRootViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,copy) void (^employeeEditCallBack)(BOOL orRefresh);
@property (nonatomic, strong)  UITableView *dhListPanel;
@property (nonatomic,  strong)  UIView *panel;

@property (nonatomic, retain)  UITextField *txtKey;
@property (strong, nonatomic)  UIView *bgView;

@property (nonatomic ,assign)BOOL isSearchMode;
@property (nonatomic, strong) id<SelectMenuClient> delegate;

@property (nonatomic, strong) NSMutableArray *detailList;

@property (nonatomic, strong) NSMutableDictionary *detailMap;

@property (nonatomic, strong) NSMutableDictionary *menuMap;

@property (nonatomic, strong) NSMutableArray *kindMenuList;

@property (nonatomic, strong) NSMutableArray *allNodeList;

@property (nonatomic, strong) NSString * headTitle;

@property (nonatomic, assign) NSInteger Istarget;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *employeeId;

@property (nonatomic, strong) NSString *entityId;

@property (nonatomic, strong) NSMutableArray *oldListArry;

@property (nonatomic, strong) NSMutableArray *headList;

@property (nonatomic, strong) NSMutableArray *headerItems;

@property (nonatomic ,assign)NSInteger currentAction;

@property (nonatomic, strong) NSMutableArray *backHeadList;

@property (nonatomic, strong) NSMutableArray *oldArrs;

@property (nonatomic, strong) NSMutableDictionary *backDetailMap;
-(void) loadMenus:(NSMutableArray*)oldArrs userId:(NSString *)userIdstr delegate:(id<SelectMenuClient>) delegate targert:(NSInteger)targert issuper:(NSInteger)issuper headList:(NSMutableArray *)headList employeeId:(NSString *)employeeId detailMap:(NSMutableDictionary *)detailMap entityId:(NSString *)entityId;

@end
