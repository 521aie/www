//
//  MenuListView.m
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Menu.h"
#import "XHAnimalUtil.h"
#import "JSONKit.h"
#import "TreeNode.h"
#import "KindMenu.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "DateUtils.h"
#import "HelpDialog.h"
#import "ObjectUtil.h"
#import "MenuModule.h"
#import "JsonHelper.h"
#import "SystemUtil.h"
#import "RemoteEvent.h"
#import "TreeBuilder.h"
#import "MenuItemCell.h"
#import "UIView+Sizes.h"
#import "SampleMenuVO.h"
#import "MBProgressHUD.h"
#import "TreeNodeUtils.h"
#import "BatchMenuListView.h"
#import "TDFOptionPickerController.h"
#import "MenuModuleEvent.h"
#import "TDFOptionPickerController.h"
#import "NSString+Estimate.h"
#import "SortTableEditView.h"
#import "TDFMenuService.h"
#import "YYModel.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFMediator+UserAuth.h"
#import "TDFMenuListPanel.h"
#import "TDFMediator+MenuModule.h"
#import <ReactiveObjC.h>
#import "MenuListView.h"
#import "TDFSidebarViewController.h"

@interface MenuListView()<TDFSidebarViewControllerDelegate,SingleCheckHandle>
@property(nonatomic, strong) TDFMenuListPanel *listPanel;
@property(nonatomic, assign) BOOL addible;  //可以添加自己的数据
@property(nonatomic, assign) BOOL chainDataManageable;  //可以管理连锁下发的数据
@end

@implementation MenuListView

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
    [self configRightNavigationBar:nil rightButtonName:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isShowSelectPancel   = NO ;
    
    self.title = NSLocalizedString(@"商品与套餐", nil);

    [self.view addSubview:self.listPanel];
    [self.view addSubview:self.btnBg];
    self.listPanel.delegate = self;
     [self initMainView];
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] takeUntil:[self rac_willDeallocSignal]]subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if(self.navigationController.viewControllers.lastObject != self) return;
        self.listPanel.searchBigButton.hidden = NO;
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] takeUntil:[self rac_willDeallocSignal]]subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if(self.navigationController.viewControllers.lastObject != self) return;
        self.listPanel.searchBigButton.hidden = YES;
    }];
    
     hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self initNotification];
    self.kindMenuList = [[NSMutableArray alloc] init];
    self.detailList = [[NSMutableArray alloc] init];
    self.itemShopTopSwitch = NO;
    [[TDFMediator sharedInstance] TDFMediator_showShopKeepConfigurableAlertWithCode:@"PAD_MENU_EDIT"];

    [self  loadMenus];
}

- (void)initMainView
{
    [self.managerButton removeFromSuperview];
    
    self.managerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.managerButton.center = CGPointMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT /2.0 - 20);
    self.managerButton.bounds = CGRectMake(0, 0, 40, 70);
    [self.managerButton setImage:[UIImage imageNamed:@"Ico_Kind_Menu.png"] forState:UIControlStateNormal];
    [self.managerButton setBackgroundImage:[UIImage imageNamed:@"Ico_Crile.png"] forState:UIControlStateNormal];
    [self.managerButton setTitleEdgeInsets:UIEdgeInsetsMake(25, -25, 0, -12)];
    self.managerButton.imageEdgeInsets = UIEdgeInsetsMake(-14, 0, 0, -32);
    self.managerButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.managerButton setTitle:NSLocalizedString(@"分类", nil) forState:UIControlStateNormal];
    [self.managerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.managerButton addTarget:self action:@selector(selectPanel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.managerButton];
    selectKindMenuPanel = [[SelectKindMenuPanel alloc]initWithNibName:@"SelectKindMenuPanel" bundle:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:selectKindMenuPanel.view];
    
    CGRect selectKindPanelFrame = selectKindMenuPanel.view.frame;
    selectKindPanelFrame.origin.x = SCREEN_WIDTH;
    selectKindMenuPanel.view.frame = selectKindPanelFrame;
}

- (void)selectPanel:(UIButton *)button
{
    [SystemUtil hideKeyboard];
    self.isOpen = !self.isOpen;
}

- (void)setIsOpen:(BOOL)isOpen
{
    selectKindMenuPanel.view.hidden = NO;
    _isOpen = isOpen;
    self.isShowSelectPancel  = NO ;
    if (isOpen == YES) {
        [self showSelectKindView];
        [self animationMoveIn:self.managerButton backround:self.btnBg];
    }else
    {
        
        [XHAnimalUtil animationMoveOut:selectKindMenuPanel.view backround:self.btnBg];
        [self animationMoveOut:self.managerButton backround:self.btnBg];
    }
}

-(void)animationMoveIn:(UIView *)view backround:(UIView *)background
{
    background.hidden = NO;
    [UIView beginAnimations:@"view moveIn" context:nil];
    [UIView setAnimationDuration:0.2];
    view.frame = CGRectMake(SCREEN_WIDTH - view.frame.size.width - selectKindMenuPanel.view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    background.alpha = 0.5;
    [UIView commitAnimations];
    
}

- (void)animationMoveOut:(UIView *)view backround:(UIView *)background
{
    [UIView beginAnimations:@"view moveOut" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    view.frame = CGRectMake(SCREEN_WIDTH - view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    background.alpha = 0.0;
    [UIView commitAnimations];
    background.hidden = YES;
}

#pragma 通知相关.
- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:MenuModule_Data_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kindChange:) name:MenuModule_ALLKind_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuEditChange:) name:MenuModule_Menu_EDIT_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuBatchChange:) name:MenuModule_Menu_Batch_Change object:nil];
}

- (void) leftNavigationButtonAction:(id)sender
{
    [XHAnimalUtil animationMoveOut:selectKindMenuPanel.view backround:self.btnBg];
    [self animationMoveOut:self.managerButton backround:self.btnBg];
    [self.navigationController  popViewControllerAnimated: YES];

}

- (void) initFootView
{
    [self.bgView removeFromSuperview];
    [self removeAllFooterButtons];
    [self.view addSubview:self.chainFooterView];
}

#pragma 数据加载.
- (void)loadMenus
{
    [self.bgView removeFromSuperview];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil) ];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        @weakify(self);
        [[TDFChainMenuService new] listAllMenuSampleWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud  setHidden:YES];
            NSMutableDictionary *dic = data[@"data"];
            self.addible = [dic[@"addible"] boolValue];
            self.chainDataManageable = [dic[@"chainDataManageable"] boolValue];
            self.itemShopTopSwitch = [[dic objectForKey:@"itemShopTopSwitch"] boolValue];
            self.kindMenuList = [NSMutableArray arrayWithArray:[NSMutableArray yy_modelArrayWithClass:[KindMenu class] json:dic[@"kindMenuList"]]];
            self.detailList = [NSMutableArray arrayWithArray:[NSMutableArray yy_modelArrayWithClass:[SampleMenuVO class] json:dic[@"simpleMenuDtoList"]]];
            
            if (self.detailList.count == 0) {
                   [self initPlaceHolderView];
            }else{
                [self.bgView removeFromSuperview];
            }
            
            self.allNodeList = [TreeBuilder buildTree:self.kindMenuList];
            for (TreeNode *node in self.allNodeList) {
                for (KindMenu *kind in self.kindMenuList) {
                    if ([node.itemId isEqualToString:kind.id]) {
                        node.isInclude = kind.isInclude;
                    }
                }
            }
            self.kindList = [TreeNodeUtils convertEndNode:self.allNodeList];
            [self buildDataMap];
            if (self.isShowSelectPancel) {
                self.isShowSelectPancel = NO;
                [self showSelectKindView];
            }
          
            if (self.addible) {
            self.listPanel.headView.hidden = YES;
                [self.listPanel.headView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                    make.top.equalTo(self.listPanel.mas_top);
                    make.left.equalTo(self.listPanel.mas_left);
                    make.right.equalTo(self.listPanel.mas_right);
                }];
            [self initFootView];
               NSArray *array = [[NSArray alloc] initWithObjects:@"batch",@"sort",@"addmenu",@"addsuitmenu", nil];
                [self.chainFooterView initDelegate:self btnArrs:array  withGoodsTitle:@"商品" withPackageTitle :@"套餐" withFontSize:12.];
            }else{
                self.listPanel.headView.hidden = NO;
                [self.listPanel.headView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(31);
                    make.top.equalTo(self.listPanel.mas_top);
                    make.left.equalTo(self.listPanel.mas_left);
                    make.right.equalTo(self.listPanel.mas_right);
                }];
                [self.chainFooterView removeFromSuperview];
                [self generateFooterButtonWithTypes:TDFFooterButtonTypeBatch | TDFFooterButtonTypeSort];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud  setHidden:YES];
            [AlertBox show:error.localizedDescription];
        }];
}

- (void)initPlaceHolderView
{
    self.bgView=[[UIView alloc]initWithFrame:CGRectMake(0,200, SCREEN_WIDTH-80,  160)];
    self.bgView.backgroundColor=[UIColor clearColor];
    [self.view insertSubview:self.bgView atIndex:1];
    
    CGFloat labelWidth = 200;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - labelWidth)/2, 0, labelWidth, 120)];
    label.text = NSLocalizedString(@"连锁总部还未添加过任何商品,赶快添加一个吧！", nil);
    label.textAlignment = NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    label.numberOfLines=0;
    [self.bgView addSubview:label];
}

#pragma 实现 FooterListEvent 协议
#pragma 添加商品.
- (void)showBatchEvent
{
    [self batchEvent];
}

- (void) footerBatchButtonAction:(UIButton *)sender
{
  [self batchEvent];
}

- (void) batchEvent{
    NSMutableDictionary *detailMapCopy = [self.detailMap mutableCopy];
    NSMutableArray *arr = [detailMapCopy objectForKey:@"SHOP_RECOMMAND"];
    for (SampleMenuVO *menu in arr) {
        for (NSString *str in detailMapCopy.allKeys) {
            if ([menu.kindMenuId isEqualToString:str]) {
                NSMutableArray *menuArr = [detailMapCopy objectForKey:menu.kindMenuId];
                [menuArr addObject:menu];
            }
        }
    }
    NSMutableArray *headList = [[NSMutableArray alloc] init];
    for (TreeNode *node in self.kindList) {
        KindMenu *kind = [[KindMenu alloc] init];
        kind._id = node.itemId;
        kind.id = node.itemId;
        kind.name = node.itemName;
        NSMutableArray *arr = [detailMapCopy objectForKey:kind._id];
        if ([ObjectUtil isNotEmpty:arr]) {
            [headList addObject:kind];
        }
        
    }
    UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_batchMenuListViewControllerwWthHeadMenu:headList  menu:detailMapCopy nodes:self.allNodeList addible:self.chainDataManageable delegate:self] ;
    [self.navigationController pushViewController:viewController animated:YES];
    [XHAnimalUtil animationMoveOut:selectKindMenuPanel.view backround:self.btnBg];
    [self animationMoveOut:self.managerButton backround:self.btnBg];
}

- (void) footerSortButtonAction:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择排序操作", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"商品分类排序", nil),NSLocalizedString(@"商品排序", nil),nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showAddEvent
{
    UIViewController  *viewController  =[[TDFMediator  sharedInstance] TDFMediator_menuEditViewControllerwWthData:nil kindTrees:self.allNodeList chainDataManageable:YES action:ACTION_CONSTANTS_ADD  isContinue:NO delegate:self] ;
    [self.navigationController pushViewController:viewController animated:YES];

}

- (void)showSortEvent
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择排序操作", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"商品分类排序", nil),NSLocalizedString(@"商品排序", nil),nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)selectKind:(id<IImageDataItem>)obj
{
    SampleMenuVO *sampleMenu = (SampleMenuVO *)obj;

    UIViewController  *viewController  =[[TDFMediator  sharedInstance] TDFMediator_menuEditViewControllerwWthData:sampleMenu kindTrees:self.allNodeList chainDataManageable:self.chainDataManageable action:ACTION_CONSTANTS_EDIT  isContinue:NO delegate:self] ;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)selectObj:(id<IImageDataItem>)item
{
    SampleMenuVO *sampleMenu=(SampleMenuVO *)item;
    if (sampleMenu.isInclude == 0) {
        UIViewController  *viewController  =[[TDFMediator  sharedInstance] TDFMediator_menuEditViewControllerwWthData:sampleMenu kindTrees:self.allNodeList chainDataManageable:self.chainDataManageable action:ACTION_CONSTANTS_EDIT  isContinue:NO delegate:self] ;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_suitMenuEditViewControllerWithData:sampleMenu kindTrees:self.allNodeList chainDataManageable:self.chainDataManageable action:ACTION_CONSTANTS_EDIT  detailArray:nil delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
    }

}

- (void)closeView
{
    [self loadMenus];
}

- (void)finishSelect:(NSMutableArray *)list
{
    
}

#pragma 实现 ISampleListEvent 协议
- (void)closeListEvent:(NSString *)event
{
}


- (void) sortEventForMenuMoudle:(NSString*)event menuMoudleMap:(NSMutableDictionary*)menuMoudleMap
{
    if ([event isEqualToString:REMOTE_KINDMENU_SORT]) {
        if (menuMoudleMap.allKeys.count == 0) {
            [self loadMenus];
        }else{
            [UIHelper showHUD:NSLocalizedString(@"正在排序", nil) andView:self.view andHUD:self.progressHud ];
            NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
            parma[@"kind_menu_str"] = [JsonHelper dictionaryToJson:menuMoudleMap];
            @weakify(self);
            [[TDFMenuService new] sortKindWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                @strongify(self);
                [self.progressHud  setHidden:YES];
                [self loadMenus];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud  setHidden:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
    } else if ([event isEqualToString:REMOTE_MENU_SORT]) {
        if (menuMoudleMap.allKeys.count == 0) {
            [self loadMenus];
        }else{
            [UIHelper showHUD:NSLocalizedString(@"正在排序", nil) andView:self.view andHUD:self.progressHud ];
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            param[@"menu_str"] = [JsonHelper dictionaryToJson:menuMoudleMap];
            @weakify(self);
            [[TDFMenuService new] sortMenuWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                @strongify(self);
                [self.progressHud  setHidden:YES];
                [self loadMenus];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                //            @strongify(self);
                [self.progressHud  setHidden:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }

   }
}


- (void)sortEvent:(NSString *)event ids:(NSMutableArray *)ids
{
    if ([event isEqualToString:REMOTE_KINDMENU_SORT]) {
        if (ids.count == 0) {
            [self loadMenus];
            
        }else{
            [UIHelper showHUD:@"正在排序" andView:self.view andHUD:self.progressHud ];
            NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
            parma[@"kind_menus_str"] = [ids   yy_modelToJSONString];
            @weakify(self);
            [[TDFMenuService new] oldSortKindMenuWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                @strongify(self);
                [self.progressHud  setHidden:YES];
                [self loadMenus];

            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud  setHidden:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
    }
}

#pragma test event
#pragma edititemlist click event.
- (void)showSingleCheckView
{
    NSString *actionStr = (self.action==ACTION_CONSTANTS_DEL?NSLocalizedString(@"删除", nil):NSLocalizedString(@"排序", nil));
    NSString *titleName = [NSString stringWithFormat:NSLocalizedString(@"选择要%@商品的分类", nil), actionStr];

    TDFOptionPickerController *vc = [TDFOptionPickerController pickerControllerWithTitle:titleName
                                                                                 options:self.kindList
                                                                           currentItemId:nil];
    
    __weak __typeof(self) wself = self;
    __weak __typeof(vc) wsvc = vc ;
    vc.competionBlock = ^void(NSInteger index) {
        [wsvc dismissViewControllerAnimated:YES completion:nil];
        [wself pickOption:self.kindList[index] event:wself.action];
    };
    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:vc animated:YES completion:nil];

}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)event
{
    if (event==MENU_KIND_SORT_EVENT) {
        TreeNode* item= (TreeNode*)selectObj;
        NSMutableArray* childNodes=item.children;
        
        for (TreeNode *node in childNodes) {
            for (KindMenu *kind in self.kindMenuList) {
                if ([kind.id isEqualToString:node.itemId]) {
                    node.sortCode = kind.sortCode;
                }
            }
        }
        if ([ObjectUtil isEmpty:childNodes] || childNodes.count<2) {
            [AlertBox show:NSLocalizedString(@"请至少添加两条内容,才能进行排序.", nil)];
            return NO;
        }

        UIViewController *viewController   = [[TDFMediator  sharedInstance] TDFMediator_tableEditViewControllerWithData:childNodes error:nil event:REMOTE_KINDMENU_SORT action:ACTION_CONSTANTS_SORT title:@"商品分类排序" delegate:self];

        [self.navigationController pushViewController:viewController animated:YES];
        return YES;
    } else if (event==MENU_SORT_EVENT) {
        TreeNode *item = (TreeNode*)selectObj;
        NSMutableArray *menus = [self.detailMap objectForKey:[item obtainItemId]];
        if ([ObjectUtil isEmpty:menus] || menus.count<2) {
            [AlertBox show:NSLocalizedString(@"请至少添加两条内容,才能进行排序.", nil)];
            return NO;
        }
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_sortTableEditViewControllerWithData:menus error:nil event:REMOTE_MENU_SORT action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"商品排序", nil) delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
        return YES;
    }
    id<INameValueItem> item = (id<INameValueItem>)selectObj;
    self.currentHead = item;
    NSMutableArray *menus = [self.menuMap objectForKey:[item obtainItemId]];
    if (menus==nil || menus.count==0) {
        NSString *message=[NSString stringWithFormat:NSLocalizedString(@"分类[%@]中没有商品!", nil),[self.currentHead obtainItemName]];
        [AlertBox show:message];
    }
    return YES;
}

#pragma 批量操作，换分类，批量删除.
- (void)menuBatchChange:(NSNotification *) notification
{
    NSDictionary *dic = notification.object;
    NSString *actionStr = [dic objectForKey:@"action"];
    NSArray  *menuIds = [dic objectForKey:@"ids"];
    SampleMenuVO *menuOld = nil;
    NSInteger pos=-1;
    if (actionStr.intValue==0) {     //批量删除
        if (menuIds!=nil && menuIds.count>0) {
            for (NSString* mId in menuIds) {
                menuOld=[self.menuMap objectForKey:mId];
                if (menuOld) {
                    [self.detailList removeObject:menuOld];
                }
            }
        }
        [self menuDataChange];
    } else {
        NSString *kindId = [dic objectForKey:@"kindId"];
        if (menuIds!=nil && menuIds.count>0) {
            for (NSString *mId in menuIds) {
                menuOld = [self.menuMap objectForKey:mId];
                if (menuOld) {
                    NSUInteger index = [self.detailList indexOfObject:menuOld];
                    if (index != NSNotFound) {
                        pos = index;
                    }
                    [self.detailList removeObject:menuOld];
                }
                if (menuOld != nil) {
                    [menuOld setKindMenuId:kindId];
                    [self.detailList insertObject:menuOld atIndex:pos];
                }
            }
        }
        [self menuDataChange];
    }
      NSMutableDictionary *detailMapCopy = [self.detailMap mutableCopy];
    NSMutableArray *headList = [[NSMutableArray alloc] init];
    for (TreeNode *node in self.kindList) {
        KindMenu *kind = [[KindMenu alloc] init];
        kind._id = node.itemId;
        kind.id = node.itemId;
        kind.name = node.itemName;
        NSMutableArray *arr = [detailMapCopy objectForKey:kind._id];
        if ([ObjectUtil isNotEmpty:arr]) {
            [headList addObject:kind];
        }
        
    }
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ( [viewController isKindOfClass:[BatchMenuListView class]]) {
            [(BatchMenuListView *)viewController loadMenus:headList menus:detailMapCopy nodes:self.allNodeList delegate:self];
        }
    }
}

- (void)menuEditChange:(NSNotification*) notification
{
    NSDictionary *dic = notification.object;
    NSString *actionStr = [dic objectForKey:@"action"];
    SampleMenuVO *menu = [dic objectForKey:@"menu"];
    if (menu != nil) {
        if (self.detailList==nil) {
            self.detailList = [NSMutableArray array];
        }
        NSString *editAction = [NSString stringWithFormat:@"%d", ACTION_CONSTANTS_EDIT];
        NSString *delAction = [NSString stringWithFormat:@"%d", ACTION_CONSTANTS_DEL];
        NSInteger pos = 0;
        if ([actionStr isEqualToString:editAction]) {
            SampleMenuVO *menuOld=[self.menuMap objectForKey:menu._id];
            if (menuOld) {
                NSUInteger index = [self.detailList indexOfObject:menuOld];
                if (index != NSNotFound) {
                    pos = index;
                }
                [self.detailList removeObject:menuOld];
            }
            if (menu != nil) {
                [self.detailList insertObject:menu atIndex:pos];
            }
        }else if([actionStr isEqualToString:delAction]){
            NSString* oldMenuId=[dic objectForKey:@"menuId"];
            SampleMenuVO* menuOld=[self.menuMap objectForKey:oldMenuId];
            if (menuOld) {
                [self.detailList removeObject:menuOld];
            }
        } else {
            [self.detailList insertObject:menu atIndex:pos];
        }
    }
    [self menuDataChange];
}

#pragma mark - TDFSidebarViewControllerDelegate

- (void)sidebarViewCellClick:(NSUInteger)location {
    [self.listPanel.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:location] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)sidebarViewManagerClick
{
    UIViewController  *viewController  = [[TDFMediator  sharedInstance] TDFMediator_kindListViewControllerWithDelegate:self backIndex:MENU_LIST_VIEW];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark buildDataMap
- (void)buildDataMap
{
    self.detailMap = [[NSMutableDictionary alloc] init];
    self.menuMap = [[NSMutableDictionary alloc] init];
    NSMutableArray *topMenuList = [NSMutableArray array];
    NSMutableArray *kindMenuList = [NSMutableArray array];
    NSMutableArray *menuList = nil;
    
    if ([ObjectUtil isNotEmpty:self.detailList]) {
        for (TreeNode *kindNode in self.kindList) {
            for (SampleMenuVO *menu in self.detailList) {
                menu._id = menu.id;
                if ([menu.kindMenuId isEqualToString:kindNode.itemId]) {
                    //如果区分
                    if (self.itemShopTopSwitch){
                        if ([menu isTopMenu]) {
                            [topMenuList addObject:menu];
//                            menu.showTop = 0;
                        }
                        menuList = [self.detailMap objectForKey:menu.kindMenuId];
                        if (menuList == nil) {
                            menuList = [NSMutableArray array];
                            [self.detailMap setObject:menuList forKey:menu.kindMenuId];
                        }
                        if ([menuList containsObject:menu]==NO) {
                            [menuList addObject:menu];
                        }
                    
                    } else { //如果不区分
                        if ([menu isTopMenu]) {
                            [topMenuList addObject:menu];
                        } else {
                            menuList = [self.detailMap objectForKey:menu.kindMenuId];
                            if (menuList == nil) {
                                menuList = [NSMutableArray array];
                                [self.detailMap setObject:menuList forKey:menu.kindMenuId];
                            }
                            if ([menuList containsObject:menu]==NO) {
                                [menuList addObject:menu];
                                
                            }
                        }
                    }
                }
            }
            
            if ([self.detailMap objectForKey:kindNode.itemId]!=nil) {
                [kindMenuList addObject:kindNode];
            }
        }
        
        for (SampleMenuVO *menu in self.detailList) {
            [self.menuMap setObject:menu forKey:menu._id];
        }
        
        if ([ObjectUtil isNotEmpty:topMenuList]) {
            KindMenu *topKindMenu = [[KindMenu alloc]initWithData:SHOP_RECOMMAND name:NSLocalizedString(@"店家推荐", nil)];
            TreeNode *topKindNode = [[TreeNode alloc]initWith:topKindMenu];
            [self.detailMap setObject:topMenuList forKey:topKindNode.itemId];
            [kindMenuList insertObject:topKindNode atIndex:0];
        }
    }
    
    self.headList = kindMenuList;
    self.listPanel.headList = self.headList;
    self.listPanel.backHeadList = [self.headList mutableCopy];
    self.listPanel.detailMap = self.detailMap;
    self.listPanel.backDetailMap = [self.detailMap mutableCopy];
    [self.listPanel.tableView reloadData];
}

- (void)menuDataChange
{
    [self buildDataMap];
    
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic setObject:self.detailMap forKey:@"detail_map"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuModule_Menu_Change object:dic];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //获取点击按钮的标题
    if (buttonIndex==0) {    //商品分类排序
        NSMutableArray* list=self.allNodeList==nil?[NSMutableArray array]:[self.allNodeList mutableCopy];
        NSMutableArray* endSortNodes=[TreeNodeUtils convertDotEndNode:list level:3 showAll:YES];
        NSMutableArray* filterNodes=[NSMutableArray array];
        if(endSortNodes!=nil && [endSortNodes count]>0){
            for (TreeNode* node in endSortNodes) {
                if ([node.children count]>=1) {
                    [filterNodes addObject:node];
                }
            }
            TreeNode* rootNode=[TreeNode new];
            rootNode.itemId=@"-99";
            rootNode.itemName=NSLocalizedString(@"全部一级分类", nil);
            rootNode.children=list;
            [filterNodes insertObject:rootNode atIndex:0];
        }

        TDFOptionPickerController *vc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"商品分类排序", nil)
                                                                                     options:filterNodes
                                                                               currentItemId:nil];
        
        __weak __typeof(self) wself = self;
        __weak __typeof(vc) wsvc = vc ;
        vc.competionBlock = ^void(NSInteger index) {
            [wsvc dismissViewControllerAnimated:YES completion:nil];
            [wself pickOption:filterNodes[index] event:MENU_KIND_SORT_EVENT];
        };
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:vc animated:YES completion:nil];

    } else if(buttonIndex==1) {  //商品排序
        NSMutableArray* endSortNodes=[TreeNodeUtils convertMultiEndNode:self.allNodeList level:4 showAll:NO];
        TDFOptionPickerController *vc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"请选择分类", nil)
                                                                                     options:endSortNodes
                                                                               currentItemId:nil];
        
        __weak __typeof(self) wself = self;
        __weak __typeof(vc) wsvc = vc ;
        vc.competionBlock = ^void(NSInteger index) {
            [wsvc dismissViewControllerAnimated:YES completion:nil];
            [wself pickOption:endSortNodes[index] event:MENU_SORT_EVENT];
        };
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:vc animated:YES completion:nil];
    }
}

- (void)dataChange:(NSNotification *)notification
{
}

- (void)kindChange:(NSNotification *)notification
{
    NSMutableDictionary *dic = notification.object;
    self.headList = [dic objectForKey:@"head_list"];
    self.allNodeList = [dic objectForKey:@"allNode_list"];
}

- (void)showHelpEvent
{
    if ([self isChain]) {
       [HelpDialog show:@"MenuWarehouse"];
    }else{
       [HelpDialog show:@"MenuAndSuit"];
    }
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
    UIViewController *viewController  = [[TDFMediator  sharedInstance] TDFMediator_suitMenuEditViewControllerWithData:nil kindTrees:nil chainDataManageable:YES action:ACTION_CONSTANTS_ADD detailArray:nil delegate:self];
    [self.navigationController pushViewController:viewController animated:YES];
     
}

- (void) navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
    [self loadMenus];
}

#pragma mark - Get Set

- (TDFMenuListPanel *) listPanel
{
    if (!_listPanel) {
        _listPanel = [[TDFMenuListPanel alloc] initWithFrame:self.view.frame];
    }
    return _listPanel;
}

- (UIButton *) btnBg
{
    if (!_btnBg) {
        _btnBg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _btnBg.backgroundColor = [UIColor clearColor];
        [_btnBg addTarget:self action:@selector(btnBgClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBg;
}

- (ChainMenuFooterListView *) chainFooterView
{
    if (!_chainFooterView) {
        _chainFooterView = [[ChainMenuFooterListView alloc] init];
        [_chainFooterView awakeFromNib];
        _chainFooterView.frame = CGRectMake(0, SCREEN_HEIGHT - 126, SCREEN_WIDTH, 60);
        [_chainFooterView setBackgroundColor:[UIColor clearColor]];
    }
    return _chainFooterView;

}

#pragma sigleView
- (void)singleCheck:(NSInteger)event item:(id<INameItem>)item
{
    TreeNode *node = (TreeNode *)item;
    [self.listPanel scrocll:node];
    self.isOpen = NO;
}


- (void)closeSingleView:(NSInteger)event
{
    self.isShowSelectPancel  = NO;
    UIViewController  *viewController  = [[TDFMediator  sharedInstance] TDFMediator_kindListViewControllerWithDelegate:self backIndex:MENU_LIST_VIEW];
    [self.navigationController pushViewController:viewController animated:YES];
    [XHAnimalUtil animationMoveOut:selectKindMenuPanel.view backround:self.btnBg];
    [self animationMoveOut:self.managerButton backround:self.btnBg];
}

- (void)showSelectKindView
{
    [selectKindMenuPanel initDelegate:self event:11];
    [selectKindMenuPanel loadData:self.kindMenuList nodes:self.allNodeList endNodes:self.kindList];
    [self animationMoveIn:self.managerButton backround:self.btnBg];
    [XHAnimalUtil animationMoveIn:selectKindMenuPanel.view backround:self.btnBg];
}

- (void)btnBgClick:(id)sender
{
    self.isOpen = NO;
}

@end
