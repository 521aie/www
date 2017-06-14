//
//  TDFChainShopReleaseViewController.m
//  RestApp
//
//  Created by iOS香肠 on 2016/10/19.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFChainShopReleaseViewController.h"
#import "ShopReleaseTableViewCell.h"
#import "TDFMediator+ChainMenuModule.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFChainMenuService.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "YYModel.h"
#import "ObjectUtil.h"
#import "TDFPlatePublishVo.h"
#import "HelpDialog.h"
#import "NavigationToJump.h"
#import "ViewFactory.h"
@interface TDFChainShopReleaseViewController ()<UITableViewDelegate,UITableViewDataSource,NavigationToJump>

@property (nonatomic ,strong) UITableView *tabView;
@property (nonatomic , strong) NSMutableArray *dataSource;
@end

@implementation TDFChainShopReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title   = NSLocalizedString(@"选择品牌", nil);
    [self configRightNavigationBar:@"Ico_Nav_Edit.png" rightButtonName:NSLocalizedString(@"发布记录", nil)];
    [self initMainView];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [self getDataList];
}


- (void)initMainView
{
    self.tabView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tabView.delegate  = self ;
    self.tabView.dataSource  = self;
    [self.tabView registerClass:[ShopReleaseTableViewCell class] forCellReuseIdentifier:ShopReleaseTableViewCellDefine];
    self.tabView.tableFooterView  = [ViewFactory generateFooter:100];
    
}
//右侧发布记录
- (void)rightNavigationButtonAction:(id)sender
{
    UIViewController *viewController  =  [[TDFMediator sharedInstance] TDFMediator_TDFChainPublishRecordViewControllerWithData:nil delegate:self];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (UITableView *)tabView
{
    if (!_tabView) {
        _tabView  = [[UITableView  alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _tabView.backgroundColor  = [UIColor clearColor];
        [self.view addSubview: _tabView] ;
        
    }
    return _tabView;
}

#pragma tabview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopReleaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ShopReleaseTableViewCellDefine];
     [cell initMainView];
    if ([ObjectUtil  isNotEmpty: self.dataSource]) {
        TDFPlatePublishVo *vo  = self.dataSource [indexPath.row];
        [cell initFillWithData:vo];
    }
    
     cell.backgroundColor=[UIColor clearColor];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  78;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([ObjectUtil  isNotEmpty: self.dataSource]) {
        TDFPlatePublishVo *vo  = self.dataSource [indexPath.row];
        if (!vo.hasMenu) {
            [AlertBox show:NSLocalizedString(@"该品牌下没有添加过商品，请先添加商品。", nil)];
            return;
        }
        if (!vo.hasShop) {
            [AlertBox show:NSLocalizedString(@"该品牌下没有添加过门店，请先添加门店。", nil)];
            return;
        }
        BOOL  isNormal  = [TDFPlatePublishVo isWaitWithStatus:vo.publishStatus];
        if (! isNormal ) {
            UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_TDFChainShopWaitReleaseViewControllerWithData:vo delegate:self];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else
        {
            UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_TDFChainShopPublishGoodsViewControllerWithData:vo delegate:self];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    
}

//获取数据
- (void)getDataList
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD: self.progressHud ];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
       @weakify(self);
    [[TDFChainMenuService new]  chainShopReleaseList:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self remoteLoadDataFinish:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)remoteLoadDataFinish:(NSMutableDictionary *)data
{
    self.dataSource= [[NSArray yy_modelArrayWithClass:[TDFPlatePublishVo class] json:data[@"data"]] mutableCopy] ;
    if ([ObjectUtil isEmpty: self.dataSource]) {
        [self configRightNavigationBar:@"" rightButtonName:@""];
        CGFloat labelWidth = 200;
        UILabel *label   = [[UILabel  alloc]  initWithFrame:CGRectMake((SCREEN_WIDTH - labelWidth)/2, (SCREEN_HEIGHT-64-60)/2, labelWidth, 60)];
        label.text  = NSLocalizedString(@"连锁总部还没有任何品牌。到连锁首页品牌下添加一个吧！", nil);
        label.textAlignment  = NSTextAlignmentCenter;
        label.numberOfLines =0;
        label.textColor  = [UIColor whiteColor];
        label.font  = [UIFont systemFontOfSize:18];
      
        [self.view addSubview:label];
    }
    [self.tabView  reloadData];
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource  = [NSMutableArray  array];
    }
    return _dataSource;
}

//帮助按钮
- (void)footerHelpButtonAction:(UIButton *)sender
{
    [self showHelpEvent];
}


- (void)showHelpEvent
{
    [HelpDialog show:@"ChainShopRelease"];
}

//协议刷新数据
- (void)navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
    [self getDataList];
}

@end
