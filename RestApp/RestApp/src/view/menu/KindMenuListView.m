//
//  KindMenuListView.m
//  RestApp
//
//  Created by zxh on 14-5-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindMenuListView.h"
#import "ServiceFactory.h"
#import "KindMenuEditView.h"
#import "TreeNodeSortView.h"
#import "NavigateTitle.h"
#import "NavigateTitle2.h"
#import "RemoteEvent.h"
#import "MenuListView.h"
#import "MenuEditView.h"
#import "XHAnimalUtil.h"
#import "JsonHelper.h"
#import "RemoteResult.h"
#import "TreeNode.h"
#import "HelpDialog.h"
#import "TreeNodeUtils.h"
#import "TDFMediator+MenuModule.h"
#import "TreeBuilder.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "TDFChainMenuService.h"
#import "YYModel.h"
@implementation KindMenuListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        service = [ServiceFactory Instance].menuService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCurrentView];
    NSArray *arr = [[NSArray alloc] initWithObjects:@"add", @"del", nil];
    [self initDelegate:self event:@"kindmenu" title:NSLocalizedString(@"分类管理", nil) foots:arr];
   
    [self initNotification];
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"关闭", nil) ];
    self.title = NSLocalizedString(@"分类管理", nil) ;
    [self initDataSource];
}

- (void)initCurrentView
{
    hud  = [[MBProgressHUD  alloc] initWithView:self.view];
}

- (void)initDataSource
{
    if ([ObjectUtil  isNotEmpty:self.dic]) {
        self.backViewTag  = [NSString stringWithFormat:@"%@",self.dic[@"backIndex"]].integerValue;
    }
    [self loadKindMenuData];


}

- (void)initDelegate:(id<ISampleListEvent>) _delegateTemp event:(NSString*) _eventTemp title:(NSString*) titleName foots:(NSArray*) arr
{
    [self.footView removeFromSuperview];
    self.chainFooterView = [[ChainMenuFooterListView alloc] init];
    [self.chainFooterView awakeFromNib];
    self.chainFooterView.frame = CGRectMake(0, SCREEN_HEIGHT - 75, SCREEN_WIDTH, 60);
    [self.chainFooterView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.chainFooterView];
    NSArray *array = [[NSArray alloc] initWithObjects:@"addmenu",@"addsuitmenu", nil];
    [self.chainFooterView initDelegate:self btnArrs:array  withGoodsTitle:@"商品分类" withPackageTitle :@"套餐分类" withFontSize:10.];
    self.delegate=_delegateTemp;
    self.event=_eventTemp;
    self.titleBox.lblTitle.text=titleName;
    self.title = titleName;
    self.datas=nil;
    [self.mainGrid reloadData];
    [self.mainGrid setEditing:NO animated:NO];
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
}
- (void)initBackView:(NSInteger)backViewTag
{
    self.backViewTag = backViewTag;
}

#pragma 数据加载
- (void)loadKindMenuData
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"types_str"] = [[NSArray arrayWithObjects:@"0",@"1", nil] yy_modelToJSONString];
    @weakify(self);
    [[TDFChainMenuService new] listKindMenuForTypesWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self hideHud];
        [self remoteLoadDataFinish:data];
    }failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self hideHud];
        [self finishSort];
        [AlertBox show:error.localizedDescription];
    }];
}
//新方法
- (void)loadkindata:(NSMutableArray *)data
{
    self.datas =[data mutableCopy];
    if (data.count>0&&data!=nil) {
        for (TreeNode *node in data) {
            if ([node.itemName isEqualToString:NSLocalizedString(@"店家推荐", nil)]) {
                [self.datas removeObject:node];
            }
        }
    }
    [self .mainGrid reloadData];
}

#pragma 区分商品分类和套餐分类
- (NSMutableArray *)differenceKindMenuWith:(kindMenu_isInclude_Enum)type
{
    NSMutableArray *kindMenuList  = [[NSMutableArray alloc] init];
    if ([ObjectUtil isNotEmpty:self.datas]) {
        for (TreeNode *node in self.datas) {
            if (node.isInclude  == type) {
                  [kindMenuList   addObject:node];
            }
        }
    }
    return  kindMenuList ;
}
#pragma 实现协议 ISampleListEvent
- (void)closeListEvent:(NSString *)event
{
    if (self.backIndex == TDFCHAINMWNU) {
        self.kindMenulistCallBack(YES);
    }else{
        [self   refreshListAndPopView];
    }
}

- (void)refreshListAndPopView
{
    if (self.backViewTag==MENU_LIST_VIEW) {
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[MenuListView class]]) {
                 [(MenuListView *) viewController setIsShowSelectPancel:YES];
                  [(MenuListView *) viewController  loadMenus];
            }
        }
    }
    if (self.backViewTag  == MENU_EDIT_VIEW) {
        NSMutableArray * kindList   = [self differenceKindMenuWith:ISINCLUDE_COMMON];
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[MenuEditView class]]) {
                [(MenuEditView *) viewController refreshNewKind:kindList];
            }
        }
    }
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) initIndexWithIndex:(NSInteger)index AndCallBack:(void (^)(BOOL ))kindMenulistCallBack
{
    self.kindMenulistCallBack = kindMenulistCallBack;
    self.backIndex = index;
}

- (void)showAddEvent:(NSString *)event
{
    UIViewController *viewController  =  [[TDFMediator sharedInstance]  TDFMediator_kindMenuEditViewControllerwWthData:nil node:nil kindTrees:self.treeNodes action:ACTION_CONSTANTS_ADD isContinue:NO delegate:self];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)delEvent:(NSString*)event ids:(NSMutableArray*) ids
{
    [UIHelper showHUD:NSLocalizedString(@"正在删除", nil) andView:self.view andHUD:hud];
    [service removeKindMenus:[ids firstObject] type:@"0"  Target:self Callback:@selector(delFinish:)];
}

//编辑键值对对象的Obj
- (void)showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    TreeNode *tempNode = (TreeNode *)obj;
    NSLog(@"-----%@---%@",tempNode.itemId,tempNode.itemName);
    if (tempNode.isInclude == 1) {
        KindMenu* editObj=(KindMenu*)tempNode.orign;
        UIViewController *viewController = [[TDFMediator  sharedInstance] TDFMediator_suitMenuKindEditViewControllerWithData:editObj node:tempNode action:ACTION_CONSTANTS_EDIT isContinue:NO delegate:self];
        [self.navigationController pushViewController: viewController animated:YES];
    }else{
         KindMenu *editObj = (KindMenu *)tempNode.orign;//待修改
        UIViewController *viewController  =  [[TDFMediator sharedInstance]  TDFMediator_kindMenuEditViewControllerwWthData:editObj node:tempNode  kindTrees:self.treeNodes action:ACTION_CONSTANTS_EDIT isContinue:NO delegate:self];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma 消息处理部分.
- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:MenuModule_Data_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:MenuModule_ALLKind_Change object:nil];
}

- (void)dataChange:(NSNotification*) notification
{
    NSMutableDictionary *dic= notification.object;
    self.treeNodes = [dic objectForKey:@"allNode_list"];
    self.datas = [TreeNodeUtils convertAllNode:self.treeNodes];
    [self.mainGrid reloadData];
}

- (void)delFinish:(RemoteResult *)result
{
    [self hideHud];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadData:result.content];
    [parent.menuListView loadMenus];
}

- (void)remoteLoadData:(NSString *)responseStr
{
    NSDictionary *map = [JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"kindMenus"];
    self.kindList = [JsonHelper transList:list objName:@"KindMenu"];
    self.treeNodes = [TreeBuilder buildTree:self.kindList];
    NSMutableArray *endNodes = [TreeNodeUtils convertEndNode:self.treeNodes];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:endNodes forKey:@"head_list"];
    [dic setObject:self.treeNodes forKey:@"allNode_list"];

    self.datas = [TreeNodeUtils convertAllNode:self.treeNodes];
    for (TreeNode *node in self.datas) {
        for (KindMenu *kind in self.kindList) {
            if ([node.itemId isEqualToString:kind.id]) {
                node.isInclude = kind.isInclude;
            }
        }
    }
    [self.mainGrid reloadData];
}

- (void)remoteLoadDataFinish:(NSMutableDictionary *)data
{
    NSArray *list = [data objectForKey:@"data"];
    self.kindList = [JsonHelper transList:list objName:@"KindMenu"];
    self.treeNodes = [TreeBuilder buildTree:self.kindList];
    NSMutableArray *endNodes = [TreeNodeUtils convertEndNode:self.treeNodes];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:endNodes forKey:@"head_list"];
    [dic setObject:self.treeNodes forKey:@"allNode_list"];
     self.datas = [TreeNodeUtils convertAllNode:self.treeNodes];
    for (TreeNode *node in self.datas) {
        for (KindMenu *kind in self.kindList) {
            if ([node.itemId isEqualToString:kind.id]) {
                node.isInclude = kind.isInclude;
            }
        }
    }
     [self.mainGrid reloadData];
}

- (void)showAddEvent
{
    [self.delegate showAddEvent:self.event];
}

- (IBAction)showDelEvent
{
    self.action=ACTION_CONSTANTS_DEL;
    [self.titleBox btnVisibal:YES direct:DIRECT_RIGHT];
    [self.titleBox.btnUser setTitle:NSLocalizedString(@"全部删除", nil) forState:UIControlStateNormal];
    [self beginEditGrid];
    [self.titleBox navVisibal:NO direct:DIRECT_RIGHT];
}

- (void)batchDelEvent:(NSString*)event ids:(NSMutableArray*)ids
{
    
}

- (void)sortEvent:(NSString*)event ids:(NSMutableArray*)ids
{
}

- (void)showHelpEvent:(NSString*)event
{
    [HelpDialog show:@"basemenukind"];
}

- (IBAction)showSortEvent
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
        NameValueCell * cell = [tableView dequeueReusableCellWithIdentifier:NameValueCellIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell" owner:self options:nil].lastObject;
        }
        if (self.datas.count > indexPath.row) {
            TreeNode *item=(TreeNode *)[self.datas objectAtIndex:indexPath.row];
            cell.lblName.text= item.itemName;
            if ([NSString isBlank:item.parentId] || [item.parentId isEqualToString:@"0"]) {
                if (item.isInclude == 0) {
                    cell.lblVal.text= NSLocalizedString(@"商品分类", nil);
                }else{
                    cell.lblVal.text= NSLocalizedString(@"套餐分类", nil);
                }
            }
        }
        cell.lblVal.textColor = [UIColor grayColor];
        cell.backgroundColor=[UIColor clearColor];
        return cell;
        
    } else {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:YES andLoadOverString:@"" andLoadingString:NSLocalizedString(@"正在加载..", nil) andIsLoading:NO];
    }
}

- (IBAction)showHelpEvent
{
    [self.delegate showHelpEvent:self.event];
}

- (BOOL) isChain
{
    if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

- (void) showAddSuitMenuEvent
{
    UIViewController  *viewController  =  [[TDFMediator  sharedInstance] TDFMediator_suitMenuKindEditViewControllerWithData:nil node:nil action:ACTION_CONSTANTS_ADD isContinue:NO delegate:self];
    [self.navigationController  pushViewController:viewController animated:YES];
}

- (void)navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
    [self loadKindMenuData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"关闭", nil)];
   [self configRightNavigationBar:nil rightButtonName:nil];

}


@end
