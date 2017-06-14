//
//  MakeListView.m
//  RestApp
//
//  Created by zxh on 14-5-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MakeListView.h"
#import "MenuModule.h"
#import "NavigateTitle2.h"
#import "MakeEditView.h"
#import "RemoteEvent.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "RemoteResult.h"
#import "NSMutableArray+DeepCopy.h"
#import "NSString+Estimate.h"
#import "GridNVCell2.h"
#import "UIHelper.h"
#import "MenuEditView.h"
#import "XHAnimalUtil.h"
#import "MakeEditView.h"
#import "AlertBox.h"
#import "MBProgressHUD.h"
#import "MenuModuleEvent.h"
#import "MultiCheckManageView.h"
#import "MenuMake.h"
#import "SortTableEditView.h"
#import "FooterListView.h"
#import "MakeRender.h"
#import "Make.h"
#import "YYModel.h"
#import "TDFRootViewController+FooterButton.h"
@implementation MakeListView

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
    NSArray* arr=[[NSArray alloc] initWithObjects:@"add",@"del",@"sort", nil];
    [self initDelegate:self event:@"make" title:NSLocalizedString(@"做法库管理", nil) foots:arr];
    self.footView.hidden = YES;
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp|TDFFooterButtonTypeAdd|TDFFooterButtonTypeSort];
    UIImage *backPicture=[UIImage imageNamed:Head_ICON_CANCEL];
    self.titleBox.imgBack.image=backPicture;
    self.titleBox.lblLeft.text=NSLocalizedString(@"关闭", nil);
    self.title = NSLocalizedString(@"做法库管理", nil);
    [self createDataSource];
}


- (void)createDataSource
{
    if ([ObjectUtil isNotEmpty: self.dic]) {
        id  headListTemp  =  self.dic [@"headListTemp"];
        [self loadDatas:headListTemp];
    }
    else
    {
        [self reLoadData];
    }
}

#pragma 数据加载
-(void)loadDatas:(NSMutableArray*) makes
{
    self.datas=[makes deepCopy];
    [self.mainGrid reloadData];
}

-(void)reLoadData
{
//    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD: self.progressHud ];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[TDFMenuService new] listMake:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self finishLoadData:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void) initIndexWithIndex:(NSInteger)index AndCallBack:(void (^)(BOOL ))menuMakelistCallBack
{
    self.menuMakelistCallBack = menuMakelistCallBack;
    self.backIndex = index;
}

-(void) onNavigateEvent:(NSInteger)event{
    
    if (event==1) {
        if (self.backIndex == TDFCHAINMWNU) {
            self.menuMakelistCallBack(YES);
        }else{
            [parent showView:MULTI_CHECK_MANAGER_VIEW];
            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
        }
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.backIndex == TDFCHAINMWNU) {
        self.menuMakelistCallBack(YES);
    }
}
#pragma 实现协议 ISampleListEvent

-(void) closeListEvent:(NSString*)event
{
    [parent showView:MAKE_LIST_VIEW];
    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
}

-(void) footerAddButtonAction:(UIButton *)sender
{

    UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_makeEditViewControllerWthData:nil action:ACTION_CONSTANTS_ADD delegate:self];
    [self.navigationController pushViewController: viewController animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
//        [UIHelper showHUD:NSLocalizedString(@"正在删除", nil) andView:self.view andHUD:self.progressHud];
        [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"make_id"] = [self.currObj obtainItemId];
        //        @weakify(self);
        [[TDFMenuService new] removeMakeWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            //            @strongify(self);
            [self.progressHud hide:YES];
            [self reLoadData];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(void) delObjEvent:(NSString*)event obj:(id) obj
{
    self.currObj=obj;
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]这个做法吗？如果有商品选了这个做法,将会全部取消关联.", nil),[self.currObj obtainItemName]]];
}

-(void) sortEventForMenuMoudle:(NSString*)event menuMoudleMap:(NSMutableDictionary*)menuMoudleMap
{
    if (self.datas==nil || self.datas.count<2) {
        [AlertBox show:NSLocalizedString(@"请至少添加两条内容,才能进行排序.", nil)];
        return;
    }
    if ([event isEqualToString:@"sortinit"]) {
//        [parent showView:SORT_TABLE_EDIT_VIEW];
//        [parent.sortTableEditView initDelegate:self event:@"makesort" action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil)];
//        [parent.sortTableEditView reload:self.datas error:nil];
//        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromTop];
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_sortTableEditViewControllerWithData:self.datas error:nil event:@"makesort" action:ACTION_CONSTANTS_SORT  title:NSLocalizedString(@"排序", nil) delegate:self];
        [self.navigationController pushViewController: viewController animated:YES];
    } else {
        if (menuMoudleMap.allKeys.count == 0) {
            [self reLoadData];

        }else{
//            [UIHelper showHUD:NSLocalizedString(@"正在排序", nil) andView:self.view andHUD:self.progressHud];
            [self showProgressHudWithText:NSLocalizedString(@"正在排序", nil)];
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            param[@"make_sort_str"] = [JsonHelper dictionaryToJson:menuMoudleMap];
            
            [[TDFMenuService new] sortMakesWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                
                [self.progressHud hide:YES];
                [self reLoadData];
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                
                [self.progressHud hide:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
    }
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"basemenucook"];
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    
}

#pragma 消息处理部分.
-(void) initNotification
{
  
}

-(void) finishLoadData:(NSMutableDictionary *) data
{
//    NSArray *list = [data objectForKey:@"data"];
//    self.datas=[JsonHelper transList:list objName:@"Make"];
    self.datas = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[Make class] json:data[@"data"]]];
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController  isKindOfClass:[MenuEditView class]]) {
            MenuEditView *menuEdit  = (MenuEditView *)viewController;
            menuEdit.makeList  = self.datas;
        }
    }
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController  isKindOfClass:[MultiCheckManageView class]]) {
            [(MultiCheckManageView *)viewController reLoadData:self.datas];
        }
    }
//    parent.menuEditView.makeList=self.datas;
//    [parent.multiCheckManageView reLoadData:self.datas];
    [self.mainGrid reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GridNVCell2 *detailItem = (GridNVCell2 *)[self.mainGrid dequeueReusableCellWithIdentifier:GridNVCell2Indentifier];
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GridNVCell2" owner:self options:nil].lastObject;
    }
    
    if (self.datas!=nil) {
        Make* item=[self.datas objectAtIndex: indexPath.row];
        [detailItem initDelegate:self obj:item title:@"" event:@""];
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailItem;
}

- (void) footerSortButtonAction:(UIButton *)sender
{
    [self sortEventForMenuMoudle:@"sortinit" menuMoudleMap:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"关闭", nil)];
    [self configRightNavigationBar:nil rightButtonName:nil];
}

- (void)navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
    [self reLoadData];
}

@end
