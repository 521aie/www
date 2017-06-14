 //
//  orderSetView.m
//  RestApp
//
//  Created by iOS香肠 on 16/3/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "orderSetView.h"
#import "ViewFactory.h"
#import "ServiceFactory.h"
#import "HeadNameItem.h"
#import "OrderSetCell.h"
#import "ObjectUtil.h"
#import "orderDetailsView.h"
#import "OrderSetShopData.h"
#import "orderShopDetaiData.h"
#import "HelpDialog.h"
#import "NSString+Estimate.h"
#import "TDFMediator+SmartModel.h"
#import "TDFIntroductionHeaderView.h"
@implementation orderSetView

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SmartOrderModel *)controller
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
//        model =controller;
        self.dataArry =[[NSMutableArray alloc]init];
        service =[ServiceFactory Instance].orderService;
    }
    return self;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self  initService];
    [self  initNavigate];
    [self  initMainView];
    [self  initFootView];
    [self   preData];
}

- (void)initNavigate
{
    
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    self.titleBox.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    [self.titleDiv addSubview:self.titleBox.view];
  //  [self.titleBox initWithName:NSLocalizedString(@"商品标签设置", nil) backImg:Head_ICON_BACK moreImg:nil];
    self.title = @"商品标签";
}

- (void) initService
{
     service =[ServiceFactory Instance].orderService;

}

- (void)initFootView
{
    if (!self.footview) {
         self.footview = [[FooterListView  alloc]init];
         [self.footview awakeFromNib];
         self.footview.frame =CGRectMake(0,SCREEN_HEIGHT-64 , SCREEN_WIDTH, 64);
         [self.view addSubview:self.footview];
    }
    self.footview.backgroundColor =[UIColor clearColor];
    [self.footview initDelegate:self btnArrs:nil];
    [self.footview showHelp: YES];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event ==DIRECT_LEFT) {
        [model showView:SMART_ORDER_LIST_VIEW];
    }
    
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)click:(BOOL)slelct
{
   [HelpDialog show:@"orderlblset"];
}

#pragma Data
- (void)preData
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    [service getShopSetLblList:self callback:@selector(getShopData:)];
    
}
//获取商品数据
- (void)getShopData:(RemoteResult *)result
{
    [hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
  [self parseData:result.content];
    
}

- (void)parseData:(NSString *)resulst
{
    [self.dataArry removeAllObjects];
    NSDictionary *map =[JsonHelper transMap:resulst];
    NSArray *data =map[@"data"];
    self.dataArry = [JsonHelper transList:data objName:@"OrderSetShopData"];
    [self.tabView reloadData];
    
}

#pragma tabview
- (void)initMainView
{
    self.tabView = [[UITableView  alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT+64)];
    self.tabView.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:self.tabView];
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabView.delegate =self;
    self.tabView.dataSource =self;
    self.tabView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
   
    UIImage *iconImage = [UIImage imageNamed:@"Customer_Recommend.png"];
    NSString *description = @"为每个菜肴正确的设置标签，可以为顾客手机点餐时提供更全面的点菜参考，同时可以作为智能推荐的依据。请尽量准确地为每个菜肴设置标签，提高智能推荐的准确性。商品标签不能作为厨房烧菜依据，厨房不会打印。";
    
    TDFIntroductionHeaderView *headerView;
    headerView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage description:description badgeIcon:[UIImage imageNamed:@"wxoa_wechat_notification_authorization" ]];
    headerView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage description:description badgeIcon:nil detailTitle:@"查看详情" detailBlock:^{
        [HelpDialog show:@"orderlblset"];
    }];

    self.tabView.tableHeaderView =headerView;
    
    self.tabView.tableFooterView = [ViewFactory generateFooter:120];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderSetShopData *Detaimodel =self.dataArry[section];
    NSInteger count =Detaimodel.menuLabelVoList.count;
    return  count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArry.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadNameItem *headNameItem = [[HeadNameItem alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];

    UIView *sectionHeaderBgView = [[UIView alloc] initWithFrame:headNameItem.bounds];
    [sectionHeaderBgView addSubview:headNameItem];
    OrderSetShopData *Detaimodel =self.dataArry[section];
    [headNameItem initWithName:Detaimodel.kindMenuName];
    
    return sectionHeaderBgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    OrderSetShopData *Detaimodel =self.dataArry[section];
    NSInteger count =Detaimodel.menuLabelVoList.count;
    if (count ==0) {
        return 0;
    }
   return  44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderSetCell *cell =[tableView dequeueReusableCellWithIdentifier:ORDERSETCELL];
    if (!cell ) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"OrderSetCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.button.hidden =YES;
    OrderSetShopData *DetailModel  = self.dataArry[indexPath.section];
    if ([ObjectUtil isNotEmpty:DetailModel.menuLabelVoList]) {
        
        orderShopDetaiData *shopModel =DetailModel.menuLabelVoList[indexPath.row];
        [cell setTheGoodsName:shopModel.menuName];
        [cell setTheLblName:shopModel.labelTypeName];
       
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderSetShopData *DetailModel  = self.dataArry[indexPath.section];
    orderShopDetaiData *shopModel =DetailModel.menuLabelVoList[indexPath.row];
//    [model showView:SMART_ORDER_DETAIS_VIEW];
//    [model.orderDetailsView initdata:shopModel.menuName menuId:shopModel.menuId action:3];
    TDFMediator *media = [[TDFMediator alloc] init];
    UIViewController *viewController  = [media TDFMediator_orderDetailsViewControllerTitle:shopModel.menuName menuId:shopModel.menuId  action:TDFActionOrderSet delegate:self];
    [self.navigationController  pushViewController:viewController animated:YES];
}

- (NSMutableArray *)dataArry
{
    if (!_dataArry) {
        _dataArry  = [[NSMutableArray  alloc] init ];
    }
    return _dataArry;
}


- (void)navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
    [self preData];
}

- (void)showHelpEvent
{
     [HelpDialog show:@"orderlblset"];
}

@end
