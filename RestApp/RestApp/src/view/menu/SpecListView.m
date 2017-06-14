//
//  SpecListView.m
//  RestApp
//
//  Created by zxh on 14-5-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "SpecListView.h"
#import "MenuModule.h"
#import "ServiceFactory.h"
#import "NavigateTitle2.h"
#import "MakeEditView.h"
#import "RemoteEvent.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "RemoteResult.h"
#import "NSMutableArray+DeepCopy.h"
#import "NSString+Estimate.h"
#import "NameValueCell.h"
#import "UIHelper.h"
#import "SpecEditView.h"
#import "GridColHead.h"
#import "SelectSpecView.h"
#import "MenuEditView.h"
#import "XHAnimalUtil.h"
#import "MakeEditView.h"
#import "MenuService.h"
#import "AlertBox.h"
#import "MBProgressHUD.h"
#import "MenuModuleEvent.h"
#import "MultiCheckManageView.h"
#import "MenuMake.h"
#import "FormatUtil.h"
#import "SortTableEditView.h"
#import "FooterListView.h"
#import "UIView+Sizes.h"
#import "Make.h"
#import "YYModel.h"
#import "TDFRootViewController+FooterButton.h"
@implementation SpecListView

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
    [self initNotification];
    NSArray* arr=[[NSArray alloc] initWithObjects:@"add",@"del",@"sort", nil];
    [self initDelegate:self event:@"spec" title:NSLocalizedString(@"规格库管理", nil) foots:arr];
    self.footView.hidden = YES;
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp|TDFFooterButtonTypeAdd|TDFFooterButtonTypeSort];
    
    UIImage *backPicture=[UIImage imageNamed:Head_ICON_CANCEL];
    self.titleBox.imgBack.image=backPicture;
    self.titleBox.lblLeft.text=NSLocalizedString(@"关闭", nil);
    self.title  = NSLocalizedString(@"规格库管理", nil);
    [self initDataSource];
    
}

#pragma 数据加载

- (void)initCurrentView
{
    hud  = [[MBProgressHUD alloc] initWithView:self.view];
}
- (void)initDataSource
{
    if ([ObjectUtil isNotEmpty: self.dic]) {
        BOOL isRefresh   = [NSString stringWithFormat:@"%@",self.dic [@"isRefresh"]].boolValue;
        if (isRefresh) {
            [self reLoadData];
        }
        else  {
        id  data  =  self.dic [@"headListTemp"];
        id  delegate =  self.dic [@"delegate"];
        self.popDelegate  = delegate ;
        [self  loadDatas:data];
        }
    }
}

-(void)loadDatas:(NSMutableArray*) makes
{
    self.datas=[makes deepCopy];
    [self.mainGrid reloadData];
}

-(void)reLoadData
{

    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    @weakify(self);
    [[TDFMenuService new] listSpec:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        @strongify(self);
        [hud  hide:YES];
        self.datas = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[SpecDetail class] json:data[@"data"]]];
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[MenuEditView class]]) {
                MenuEditView *menuEdit  =  (MenuEditView *)viewController;
                menuEdit.specDetailList  = self.datas;
                
            }
        }
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[SelectSpecView class]]) {
                [(SelectSpecView *)viewController  reLoadData:self.datas];
            }
        }
//        parent.menuEditView.specDetailList = self.datas;
//        [parent.selectSpecView reLoadData:self.datas];
        [self.mainGrid reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        @strongify(self);
        [hud  hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==1) {
        if (self.backIndex == TDFCHAINMWNU) {
            self.menuSpecslistCallBack(YES);
        }else{
            [parent showView:SELECT_SPEC_VIEW];
            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
        }
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    if ( self.popDelegate) {
        [self.popDelegate navitionToPushBeforeJump:nil data:nil];
    }
    [self.navigationController popViewControllerAnimated: YES];
    if (self.backIndex == TDFCHAINMWNU) {
        self.menuSpecslistCallBack(YES);
    }
}
#pragma 实现协议 ISampleListEvent
-(void) closeListEvent:(NSString*)event
{
    [parent showView:SPEC_LIST_VIEW];
    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
}

-(void) footerAddButtonAction:(UIButton *)sender
{
//    [parent showView:SPEC_EDIT_VIEW];
//    [parent.specEditView loadData:nil action:ACTION_CONSTANTS_ADD];
//    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromTop];
    UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_specEditViewControllerWthData:nil action:ACTION_CONSTANTS_ADD delegate:self];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) initIndexWithIndex:(NSInteger)index AndCallBack:(void (^)(BOOL ))menuSpecslistCallBack
{
    self.menuSpecslistCallBack = menuSpecslistCallBack;
    self.backIndex = index;
}


-(void) sortEventForMenuMoudle:(NSString*)event menuMoudleMap:(NSMutableDictionary*)menuMoudleMap
{
    if (self.datas==nil || self.datas.count<2) {
        [AlertBox show:NSLocalizedString(@"请至少添加两条内容,才能进行排序.", nil)];
        return;
    }
    if ([event isEqualToString:@"sortinit"]) {

//        [parent showView:SORT_TABLE_EDIT_VIEW];
//        [parent.sortTableEditView initDelegate:self event:@"specsort" action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil)];
//        [parent.sortTableEditView reload:self.datas error:nil];
//        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromTop];
        UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_sortTableEditViewControllerWithData:self.datas error:nil event:@"specsort" action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil) delegate:self];
        [self.navigationController pushViewController: viewController animated:YES];

    /*    [parent showView:SORT_TABLE_EDIT_VIEW];
        [parent.sortTableEditView initDelegate:self event:@"specsort" action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil)];
        [parent.sortTableEditView reload:self.datas error:nil];
        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromTop];*/

    } else {
        if (menuMoudleMap.allKeys.count == 0) {
//            [parent showView:SPEC_LIST_VIEW];
            [self reLoadData];
//            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
        }else{

            [UIHelper showHUD:NSLocalizedString(@"正在排序", nil) andView:self.view andHUD:hud];
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            param[@"spec_detail_sort_str"] = [JsonHelper dictionaryToJson:menuMoudleMap];
            
            @weakify(self);
            [[TDFMenuService new] sortSpecWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                @strongify(self);
                [hud  hide:YES];
//                [parent showView:SPEC_LIST_VIEW];
                [self reLoadData];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                //        @strongify(self);
                [hud  hide:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
    }
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"basemenuspec"];
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
//    [parent showView:SPEC_EDIT_VIEW];
    SpecDetail* editObj=(SpecDetail*)obj;
//   [parent.specEditView loadData:editObj action:ACTION_CONSTANTS_EDIT];    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromRight];
    UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_specEditViewControllerWthData:editObj action:ACTION_CONSTANTS_EDIT delegate:self];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 消息处理部分.
-(void) initNotification
{
   
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueCell *detailItem = (NameValueCell *)[self.mainGrid dequeueReusableCellWithIdentifier:NameValueCellIdentifier];
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell" owner:self options:nil].lastObject;
    }
    
    if (self.datas!=nil) {
        SpecDetail* item=[self.datas objectAtIndex: indexPath.row];
        detailItem.lblName.text=item.name;
        double scale=item.priceScale;
        NSString* priceScale=[FormatUtil formatDouble4:scale];
        detailItem.lblVal.text=[NSString stringWithFormat:@"%@",priceScale];
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailItem;
}

#pragma table head
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead *headItem = (GridColHead *)[self.mainGrid dequeueReusableCellWithIdentifier:GridColHeadIndentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    }
    [headItem initColHead:NSLocalizedString(@"规格名称", nil) col2:NSLocalizedString(@"价格是基准商品价格的几倍", nil)];
    [headItem initColLeft:15 col2:134];
    [headItem.lblVal setWidth:173];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(void) footerSortButtonAction:(UIButton *)sender
{
    [self sortEventForMenuMoudle:@"sortinit" menuMoudleMap:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"关闭", nil)];
    [self configRightNavigationBar:nil rightButtonName:nil];
}

- (void)navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
    [self  reLoadData];
}
@end
