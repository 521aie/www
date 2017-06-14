//
//  AdditionListView.m
//  RestApp
//
//  Created by zxh on 14-7-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIHelper.h"
#import "AlertBox.h"
#import "GridHead.h"
#import "HelpDialog.h"
#import "GridNVCell.h"
#import "MenuModule.h"
#import "GridFooter.h"
#import "FormatUtil.h"
#import "JsonHelper.h"
#import "ObjectUtil.h"
#import "RemoteEvent.h"
#import "XHAnimalUtil.h"
#import "SampleMenuVO.h"
#import "PairPickerBox.h"
#import "SortTableEditView.h"
#import "AdditionListView.h"
#import "KindMenuEditView.h"
#import "NSString+Estimate.h"
#import "KindAdditionEditView.h"
#import "MenuAdditionEditView.h"
#import "TDFMediator+MenuModule.h"
#import "MultiMasterManagerView.h"
#import "TDFMenuService.h"
#import "TDFRootViewController+FooterButton.h"

@implementation AdditionListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent=parentTemp;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNotification];
    [self.footView removeFromSuperview];
    [self initDelegate:self event:@"addition" title:NSLocalizedString(@"加料库管理", nil) foots:nil];
    
    UIImage *backPicture=[UIImage imageNamed:Head_ICON_CANCEL];
    self.titleBox.imgBack.image=backPicture;
   self.titleBox.lblLeft.text=NSLocalizedString(@"关闭", nil);
    self.title = NSLocalizedString(@"加料库管理", nil);
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"关闭", nil)];
    [self createData];

    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd | TDFFooterButtonTypeSort];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.mainGrid.frame;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = SCREEN_HEIGHT-64;
    self.mainGrid.frame = frame;
}

- (void)createData
{
    if ([ObjectUtil isNotEmpty:self.dic]) {
        BOOL isLoading  = [NSString stringWithFormat:@"%@",self.dic [@"isLoading"]].boolValue;
        if (isLoading) {
            [self loadDatas];
        }
        else {
        id data = self.dic [@"data"] ;
        id dic  = self.dic [@"dic"];
        [self loadData:data dic:dic];
        }
    }
}

#pragma 数据加载
-(void) onNavigateEvent:(NSInteger)event
{
    if (event==1) {
        if (self.backIndex == TDFCHAINMWNU) {
            self.menuAdditionslistCallBack(YES);
        }else{
            [parent showView:MULTI_HEAD_CHECK_VIEW];
            [parent.multiHeadCheckView reLoadData:self.headList detalMap:self.detailMap];
            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
        }
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)loadDatas
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[TDFMenuService new] listMenuAdditions:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hideAnimated:YES];
        NSArray* menuKindAdditions = [NSArray yy_modelArrayWithClass:[AdditionKindMenuVo class] json:data[@"data"]];
        self.headList=[NSMutableArray arrayWithArray:menuKindAdditions];
        self.detailMap=[NSMutableDictionary new];
        if(menuKindAdditions!=nil && menuKindAdditions.count>0){
            for (AdditionKindMenuVo* kind in menuKindAdditions) {
                if ([ObjectUtil isEmpty:kind.additionMenuList]) {
                     [self.detailMap setObject:[[NSMutableArray alloc]init] forKey:kind.kindMenuId];
                }else{
                      [self.detailMap setObject:kind.additionMenuList forKey:kind.kindMenuId];
                }

            }
        }
        for (UIViewController  *viewController in self.navigationController.viewControllers) {
            if ([viewController  isKindOfClass:[KindMenuEditView  class]]) {
                KindMenuEditView *kindMenuEditView   = (KindMenuEditView *)viewController ;
                [kindMenuEditView  refreshAdditionChange:self.headList ];
            }
            if ([viewController  isKindOfClass:[MultiMasterManagerView class]]) {
                MultiMasterManagerView *multiHeadCheckView  = (MultiMasterManagerView *)viewController;
                [multiHeadCheckView  reLoadData:self.headList detalMap:self.detailMap];
            }
        }
//        [parent.kindMenuEditView refreshAdditionChange: self.headList];
//        [parent.multiHeadCheckView reLoadData: self.headList detalMap:self.detailMap];
        [self.mainGrid reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        
        [AlertBox show:error.localizedDescription];
    }];
}

-(void)loadData:(NSMutableArray*)headList dic:(NSMutableDictionary*)detailMap
{
    self.headList=headList;
    self.detailMap=detailMap;
    [self.mainGrid reloadData];
}

#pragma 实现协议 ISampleListEvent
-(void) closeListEvent:(NSString*)event
{
    if ([event isEqualToString:@"sort"]) {
        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
    } else {
        [parent showView:ADDITION_LIST_VIEW];
        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
    }
}

-(void) footerAddButtonAction:(UIButton *)sender
{
    UIViewController *viewController  =  [[TDFMediator sharedInstance] TDFMediator_kindAdditionEditViewControllerWithData:nil action:ACTION_CONSTANTS_ADD delegate:self];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) showAddEvent:(NSString*)event obj:(id)obj;
{
     KindMenu* kind=(KindMenu*)obj;
    UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_menuAdditionEditViewControllerWithData:nil kind:kind action:ACTION_CONSTANTS_ADD delegate:self];
    [self.navigationController pushViewController:viewController animated:YES];

}

-(void) delEvent:(NSString*)event ids:(NSMutableArray*) ids
{
    [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"menu_id"] = [ids firstObject];
    @weakify(self);
    [[TDFMenuService new] removeMenuAdditionWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hideAnimated:YES];
        [self loadDatas];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

-(void) initSortDic
{
    self.sortDic=[NSMutableDictionary dictionary];
    self.sortKeys=[NSMutableArray array];
    [self.sortDic setObject:[NSMutableArray array] forKey:NSLocalizedString(@"分类排序", nil)];
    [self.sortKeys addObject:NSLocalizedString(@"分类排序", nil)];
    if (self.headList!=nil && self.headList.count>0) {
        NSMutableArray* arr=[NSMutableArray array];
        for (AdditionKindMenuVo* kt in self.headList) {
            [arr addObject:kt.kindMenuName];
        }
        [self.sortKeys addObject:NSLocalizedString(@"内容排序", nil)];
        [self.sortDic setObject:[arr mutableCopy] forKey:NSLocalizedString(@"内容排序", nil)];
    }
}
-(void) sortEventForMenuMoudle:(NSString*)event menuMoudleMap:(NSMutableDictionary*)menuMoudleMap
{
    if ([event isEqualToString:@"sortinit"]) {
        [self initSortDic];
        [PairPickerBox initData:self.sortDic keys:self.sortKeys keyPos:0 valPos:0];
        [PairPickerBox show:NSLocalizedString(@"加料库排序", nil) client:self event:0];
    } else if ([event isEqualToString:@"sortkind"]){
        if (menuMoudleMap.allKeys.count == 0) {
            [self loadDatas];
            [parent showView:ADDITION_LIST_VIEW];
            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
        }else{
            [self showProgressHudWithText:NSLocalizedString(@"正在排序", nil)];
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            param[@"kind_menu_str"] = [JsonHelper dictionaryToJson:menuMoudleMap];
            [[TDFMenuService new] sortKindWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                //            @strongify(self);
                [self.progressHud hideAnimated:YES];
                [self loadDatas];
//                [parent showView:ADDITION_LIST_VIEW];
                [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                //        @strongify(self);
                [self.progressHud hideAnimated:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
    } else if ([event isEqualToString:@"sortaddition"]){
        if (menuMoudleMap.allKeys.count == 0) {
            [self loadDatas];
//            [parent showView:ADDITION_LIST_VIEW];
            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
        }else{

            [self showProgressHudWithText:NSLocalizedString(@"正在排序", nil)];
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            param[@"menu_str"] = [JsonHelper dictionaryToJson:menuMoudleMap];
            [[TDFMenuService new] sortMenuWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                //            @strongify(self);
                [self.progressHud hideAnimated:YES];
                [self loadDatas];
//                [parent showView:ADDITION_LIST_VIEW];
                [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                //        @strongify(self);
                [self.progressHud hideAnimated:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
    }
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    if([event isEqualToString:@"kindaddition"]){

//        AdditionKindMenuVo* kindMenu=(AdditionKindMenuVo*)obj;
//        [parent showView:KINDADDITION_EDIT_VIEW];
//        [parent.kindAdditionEditView loadData:kindMenu action:ACTION_CONSTANTS_EDIT];
//        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromRight];

        KindMenu* kindMenu=(KindMenu*)obj;
//     [parent showView:KINDADDITION_EDIT_VIEW];
      // [parent.kindAdditionEditView loadData:kindMenu action:ACTION_CONSTANTS_EDIT];
//        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromRight];
        UIViewController *viewController  =  [[TDFMediator sharedInstance] TDFMediator_kindAdditionEditViewControllerWithData:kindMenu action:ACTION_CONSTANTS_EDIT delegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"basemenuingr"];
}

#pragma 消息处理部分.
-(void) initNotification
{
 
}

-(void) loadFinish:(RemoteResult*) result
{
    [self.progressHud hideAnimated:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadData:result.content];
}

-(void) delFinish:(RemoteResult*) result
{
    [self.progressHud hideAnimated:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        
        [AlertBox show:result.errorStr];
        return;
    }
    [self loadDatas];
}

-(void) sortFinish:(RemoteResult*) result
{
    [self.progressHud hideAnimated:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    [self loadDatas];
//    [parent showView:ADDITION_LIST_VIEW];
//    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
}

-(void) remoteLoadData:(NSString *) responseStr
{
    NSDictionary* map=[JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"menus"];
    NSMutableArray* menuAdditions=[JsonHelper transList:list objName:@"SampleMenuVO"];
    NSArray *kindList = [map objectForKey:@"kindMenus"];
    NSMutableArray* kindAdditions=[JsonHelper transList:kindList objName:@"KindMenu"];
    
    self.headList=kindAdditions;
    self.detailMap=[NSMutableDictionary new];
    NSMutableArray* arr=nil;
    if(menuAdditions!=nil && menuAdditions.count>0){
        for (SampleMenuVO* vo in menuAdditions) {
            arr=[self.detailMap objectForKey:vo.kindMenuId];
            if (!arr) {
                arr=[NSMutableArray array];
            }else{
                [self.detailMap removeObjectForKey:vo.kindMenuId];
            }
            [arr addObject:vo];
            [self.detailMap setObject:arr forKey:vo.kindMenuId];
        }
    }
    for (UIViewController  *viewController  in self.navigationController.viewControllers) {
        if ([viewController  isKindOfClass:[KindMenuEditView class]]) {
           // KindMenuEditView *kindMenuEditView   = (KindMenuEditView *) viewController;
//            [kindMenuEditView   refreshAdditionChange:self.headList details: menuAdditions];
        }
        if ([viewController isKindOfClass:[MultiMasterManagerView class]]) {
            MultiMasterManagerView *multiHeadCheckView  = (MultiMasterManagerView *)viewController;
            [multiHeadCheckView reLoadData:kindAdditions detalMap:self.detailMap];
        }
    }
  //  [parent.kindMenuEditView refreshAdditionChange:kindAdditions details:menuAdditions];
 // [parent.multiHeadCheckView reLoadData:kindAdditions detalMap:self.detailMap];
    [self.mainGrid reloadData];
}


#pragma table部分.
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdditionKindMenuVo *kindMenu = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:kindMenu]) {
        NSMutableArray *temps = [self.detailMap objectForKey:kindMenu.kindMenuId];
        if ([ObjectUtil isEmpty:temps] || indexPath.row==temps.count) {
            GridFooter *footerItem = (GridFooter *)[tableView dequeueReusableCellWithIdentifier:GridFooterCellIndentifier];
            
            if (!footerItem) {
                footerItem = [[NSBundle mainBundle] loadNibNamed:@"GridFooter" owner:self options:nil].lastObject;
            }
            footerItem.selectionStyle = UITableViewCellSelectionStyleNone;
            footerItem.lblName.text=NSLocalizedString(@"添加新料...", nil);
            return footerItem;
        } else {
            GridNVCell *detailItem = (GridNVCell *)[tableView dequeueReusableCellWithIdentifier:GridNVCellIndentifier];
            
            if (!detailItem) {
                detailItem = [[NSBundle mainBundle] loadNibNamed:@"GridNVCell" owner:self options:nil].lastObject;
            }
            if ([ObjectUtil isNotEmpty:temps]) {
                AdditionMenuVo* item=  [temps objectAtIndex: indexPath.row];
                [detailItem initDelegate:self obj:item title:@"" event:@"menuaddition"];
                detailItem.lblVal.text=[NSString stringWithFormat:NSLocalizedString(@"加价:%@元", nil),[FormatUtil formatDouble5:item.menuPrice]];
                detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
                return detailItem;
            }
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdditionKindMenuVo *kindMenu = [self.headList objectAtIndex:indexPath.section];
    self.currKindmenu=kindMenu;
    if ([ObjectUtil isNotNull:kindMenu]) {
        NSMutableArray *temps = [self.detailMap objectForKey:self.currKindmenu.kindMenuId];
        if ([ObjectUtil isEmpty:temps] || indexPath.row==temps.count) {
            [self showAddEvent:@"menuaddition" obj:kindMenu];
        } else {
            [self showEditNVItemEvent:@"menuaddition" withObj:temps[indexPath.row]];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AdditionKindMenuVo *head = [self.headList objectAtIndex:section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.kindMenuId];
        if ([ObjectUtil isNotEmpty:temps]) {
            return temps.count+1;
        } else {
            return 1;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AdditionKindMenuVo *head = [self.headList objectAtIndex:section];
    GridHead *headItem = [GridHead getInstance:tableView];
   
    [headItem initDelegate:self obj:head event:@"kindaddition"];
    [headItem initOperateWithAdd:NO edit:YES];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.headList!=nil?self.headList.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma edititemlist click event.
- (BOOL)pickOption:(NSInteger)keyIndex valIndex:(NSInteger)valIndex event:(NSInteger)eventType
{
    NSMutableArray* datas=nil;
    NSString* sortName=@"";
    NSString* sortEvent=@"sortkind";
    if (keyIndex==0) {
        datas=[self.headList mutableCopy];
        sortName=NSLocalizedString(@"加料分类", nil);
        sortEvent=@"sortkind";
    } else {
        AdditionKindMenuVo* kindMenu=[self.headList objectAtIndex:valIndex];
        NSMutableArray* arrs=[self.detailMap objectForKey:kindMenu.kindMenuId];
        datas=[arrs mutableCopy];
        sortName=[NSString stringWithFormat:NSLocalizedString(@"[%@]加料", nil),kindMenu.kindMenuName];
        sortEvent=@"sortaddition";
    }
    if ([ObjectUtil isEmpty:datas] || datas.count<2) {
        [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"请至少添加两条%@内容,才能进行排序.", nil),sortName]];
        return YES;
    }
//    [parent showView:SORT_TABLE_EDIT_VIEW];
//    [parent.sortTableEditView initDelegate:self event:sortEvent action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil)];
//    [parent.sortTableEditView reload:datas error:nil];
//    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromTop];
    

    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_sortTableEditViewControllerWithData:datas error:nil event:sortEvent action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil) delegate:self];
    [self.navigationController pushViewController:viewController animated:YES];
    return YES;
}

-(void) footerSortButtonAction:(UIButton *)sender
{
    [self sortEventForMenuMoudle:@"sortinit" menuMoudleMap:nil];

}

- (void)navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
    [self loadDatas];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"关闭", nil)];
    [self configRightNavigationBar:nil rightButtonName:@""]; //临时解决导航混乱问题

}

- (void) initIndexWithIndex:(NSInteger)index AndCallBack:(void (^)(BOOL ))menuAdditionslistCallBack
{
    self.menuAdditionslistCallBack = menuAdditionslistCallBack;
    self.backIndex = index;
}

@end
