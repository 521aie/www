//
//  SroresView.h
//  RestApp
//
//  Created by iOS香肠 on 16/1/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListView.h"
#import "INavigateEvent.h"
#import "ShopVO.h"
#import "SelectRolePanel.h"
#import "FooterMultiView.h"
#import "OptionSelectView.h"
#import "TDFChainService.h"
#import "BranchShopVo.h"
#import "TDFRootViewController.h"
#import "TDFMediator+StoresModule.h"
#import "TDFMediator+BranchCompanyModule.h"


typedef NS_ENUM(NSInteger, ViewMode) {
    ListMode,
    BatchMode,
};

@class NavigateTitle2;
@interface StoresView : TDFRootViewController<INavigateEvent,FooterListEvent,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,SingleCheckHandle,UIActionSheetDelegate,FooterMultiEvent,OptionSelectClient>
{
    BOOL isRefresh;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, assign) BOOL select;
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UITextField *txtKey;
@property (strong, nonatomic) UITableView *storeTab;
@property (strong, nonatomic) SelectRolePanel *selectRolePanel;
@property (nonatomic, assign) BOOL  isSearchMode;
@property (nonatomic, strong) NSMutableArray *headerItems;
@property (nonatomic, strong) NSMutableArray *headList;
@property (nonatomic, strong) NSMutableArray *backHeadList;
@property (nonatomic, strong) NSMutableArray *selectList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) NSMutableDictionary *backDetailMap;
@property (nonatomic, strong) UIButton *btnBg;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (nonatomic, assign) NSInteger viewMode;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, assign) BOOL isHasChain;

@property (nonatomic,assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *branchCompanyList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (IBAction)cancleSearch:(id)sender;
- (IBAction)filtBtnClick:(id)sender;
- (IBAction)btnBgClick:(id)sender;
- (void)loadData;
@end
