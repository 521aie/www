//
//  SelectMenuListView.m
//  RestApp
//
//  Created by zxh on 14-5-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectMenuListView.h"
#import "SelectMenuListPanel.h"
#import "ServiceFactory.h"
#import "MenuService.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "RemoteEvent.h"
#import "SampleMenuVO.h"
#import "RemoteResult.h"
#import "AlertBox.h"
#import "TreeBuilder.h"
#import "TreeNodeUtils.h"
#import "SelectSingleMenuHandle.h"
#import "JsonHelper.h"

@implementation SelectMenuListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service=[ServiceFactory Instance].menuService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.titleStr=NSLocalizedString(@"选择商品", nil);
    self.title = NSLocalizedString(@"选择商品", nil);
    [self initNavigate];
    [self initNotification];

    [self.dhListPanel initDelegate:self headChange:MenuModule_Kind_Select detailChange:MenuModule_Data_Select];
    [self.dhListPanel setBackgroundColor:[UIColor clearColor]];

   
    [self createData];
}

- (void)createData
{
    if ([ObjectUtil isNotEmpty:self.sourceDic]) {
        id  delegate  = self.sourceDic [@"delegate"];
        id  data  = self.sourceDic [@"data"];
        id nodes  = self.sourceDic [@"node"];
        id  sourceData  = self.sourceDic [@"sourceData"];
        id  dic  = self.sourceDic [@"dic"];
        [self loadData:data nodes:nodes datas:sourceData dic:dic delegate: delegate];
    }

    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"关闭", nil)];

}

-(void) initView:(int)backView
{
    
}

#pragma navigateBar
-(void) initNavigate{
    
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:self.titleStr backImg:Head_ICON_CANCEL moreImg:nil];
    self.titleBox.lblLeft.text=NSLocalizedString(@"关闭", nil);
}

-(void) onNavigateEvent:(NSInteger)event{
    
    if (event==DIRECT_LEFT) {
        [self.delegate closeView];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
     [self.delegate closeView];
    
    
}
#pragma 数据加载.
#pragma edit
-(void) selectObj:(id<IImageDataItem>) item
{
    SampleMenuVO* menu=(SampleMenuVO*)item;
    [self.delegate finishSelectMenu:menu];
}

#pragma 实现 ISampleListEvent 协议
-(void) closeListEvent:(NSString*)event{
    [self.delegate closeView];
}

#pragma 通知相关.
-(void) initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:MenuModule_Data_Select object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kindChange:) name:MenuModule_Kind_Select object:nil];
}

-(void)loadData:(NSMutableArray*)headList nodes:(NSMutableArray*)nodes datas:(NSMutableArray*)datas dic:(NSMutableDictionary*)dic delegate:(id<SelectMenuClient>) delegate
{
    self.delegate=delegate;
    self.headList=headList;
    self.allNodeList=nodes;
    self.detailList=datas;
    self.detailMap=dic;
    [self pushNotification];
}

-(void) pushNotification
{
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic setObject:self.headList forKey:@"head_list"];
    [dic setObject:self.detailMap forKey:@"detail_map"];
    [dic setObject:self.allNodeList forKey:@"allNode_list"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuModule_Data_Select object:dic] ;
}

-(void) dataChange:(NSNotification*) notification{
    
}

-(void)kindChange:(NSNotification*) notification{
    NSMutableDictionary* dic= notification.object;
    self.headList=[dic objectForKey:@"head_list"];
    self.allNodeList=[dic objectForKey:@"allNode_list"];
}

- (void)viewWillAppear:(BOOL)animated
{
     [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"关闭", nil)];
     [self configRightNavigationBar:nil rightButtonName:nil];
}
@end
