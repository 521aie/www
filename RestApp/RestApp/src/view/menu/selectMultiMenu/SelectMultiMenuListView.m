//
//  SelectMenuListView.m
//  RestApp
//
//  Created by zxh on 14-5-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectMultiMenuListView.h"
#import "SelectMultiMenuListPanel.h"
#import "ServiceFactory.h"
#import "MenuService.h"
#import "MBProgressHUD.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "RemoteEvent.h"
#import "MenuTimePrice.h"
#import "RemoteResult.h"
#import "AlertBox.h"
#import "SampleMenuVO.h"
#import "TreeBuilder.h"
#import "TreeNodeUtils.h"
#import "IMenuDataItem.h"
#import "JsonHelper.h"
#import "YYModel.h"
#import "TDFMenuService.h"
#import "ViewFactory.h"
#import "TDFRootViewController+FooterButton.h"


@implementation SelectMultiMenuListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory Instance].menuService;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleStr=NSLocalizedString(@"选择商品", nil);
    [self initNavigate];
    [self initNotification];
    self.view.userInteractionEnabled = YES;
    self.dhListPanel.mainGrid.tableFooterView  = [ViewFactory generateFooter:60];
    [self.dhListPanel initDelegate:self headChange:MenuModule_Kind_Multi_Select detailChange:MenuModule_Data_Multi_Select];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAllCheck | TDFFooterButtonTypeNotAllCheck];
    
    [self.dhListPanel setBackgroundColor:[UIColor clearColor]];
    
}

#pragma navigateBar
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:self.titleStr backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = self.titleStr;
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==1) {
        [self.delegate closeView];
    } else {
        //防止多次点击造成服务端出错
        self.view.userInteractionEnabled =NO;
        [self.delegate finishSelectList:[self.dhListPanel getSelectDatas]];
        
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
//    [self.delegate closeView];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavigationButtonAction:(id)sender
{
    //防止多次点击造成服务端出错
    self.view.userInteractionEnabled =NO;
    [self.delegate finishSelectList:[self.dhListPanel getSelectDatas]];
}

#pragma 数据加载.
-(void) loadMenus:(NSMutableArray*)oldArrs delegate:(id<SelectMenuClient>) delegate
{
     self.view.userInteractionEnabled =YES;
    self.delegate=delegate;
    [self initOld:oldArrs];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"type"] = @"0";
    @weakify(self);
    [[TDFMenuService new] listSampleWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hideAnimated:YES];
        NSMutableDictionary *dic = data[@"data"];
        self.kindMenuList = [NSMutableArray arrayWithArray:[NSMutableArray yy_modelArrayWithClass:[KindMenu class] json:dic[@"kindMenuList"]]];
        self.detailList = [NSMutableArray arrayWithArray:[NSMutableArray yy_modelArrayWithClass:[SampleMenuVO class] json:dic[@"simpleMenuDtoList"]]];
        
        self.allNodeList = [TreeBuilder buildTree:self.kindMenuList];
        self.headList  = [TreeNodeUtils convertEndNode:self.allNodeList];
        if (self.detailList==nil || self.detailList.count==0) {
            return;
        }
        NSMutableArray* arr=nil;
        self.detailMap=[[NSMutableDictionary alloc] init];
        self.menuMap=[[NSMutableDictionary alloc] init];
        for (SampleMenuVO* menu in self.detailList) {
            
            if (menu.kindMenuId == (id)[NSNull null] || menu.kindMenuId == nil) {
                continue;
            }
            
            arr=[self.detailMap objectForKey:menu.kindMenuId];
            if (!arr) {
                arr=[NSMutableArray array];
            }else{
                [self.detailMap removeObjectForKey:menu.kindMenuId];
            }
            [arr addObject:menu];
            [self.detailMap setObject:arr forKey:menu.kindMenuId];
            [self.menuMap setObject:menu forKey:menu._id];
        }
        [self pushNotification];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

-(void) initOld:(NSMutableArray*)oldMenus
{
    [self.dhListPanel initSelectData:oldMenus];
}

#pragma edit
-(void) selectObj:(id<IImageDataItem>) item
{
}

#pragma 实现 ISampleListEvent 协议
-(void) closeListEvent:(NSString*)event
{
}

#pragma 通知相关.
-(void) initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:MenuModule_Data_Multi_Select object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kindChange:) name:MenuModule_Kind_Multi_Select object:nil];
}

#pragma mark checkall notcheckall
- (void)footerAllCheckButtonAction:(UIButton *)sender {
    [self checkVal:YES];
}

- (void)footerNotAllCheckButtonAction:(UIButton *)sender {
    [self checkVal:NO];
}

-(void) checkVal:(BOOL)val
{
    if (self.detailList==nil || self.detailList.count==0) {
        return;
    }
    if (val==YES) {
        [self.dhListPanel initSelectData:self.detailList];
    } else {
        [self.dhListPanel initSelectData:nil];
    }
    [self.dhListPanel refreshDataView];
}

-(void) pushNotification
{
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic setObject:self.headList forKey:@"head_list"];
    [dic setObject:self.detailMap forKey:@"detail_map"];
    [dic setObject:self.allNodeList forKey:@"allNode_list"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuModule_Data_Multi_Select object:dic] ;
    
}

-(void) dataChange:(NSNotification*) notification
{
}

-(void) kindChange:(NSNotification*) notification
{
    NSMutableDictionary* dic= notification.object;
    self.headList=[dic objectForKey:@"head_list"];
    self.allNodeList=[dic objectForKey:@"allNode_list"];
}

@end
