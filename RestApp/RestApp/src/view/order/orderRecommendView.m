//
//  orderRecommendViewViewController.m
//  RestApp
//
//  Created by iOS香肠 on 16/4/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "orderRecommendView.h"
#import "HelpDialog.h"
#import "orderRemindView.h"
#import "SmartOrderModel.h"
#import "OrderSetCell.h"
#import "HeadNameItem.h"
#import "ViewFactory.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "OrderRecommendPlantData.h"
#import "TDFMediator+SmartModel.h"
#import "TDFOrderRdDetailViewController.h"
#import "UIHelper.h"
#import "TDFIntroductionHeaderView.h"

#define  RECOMMENDTURN 1
@implementation orderRecommendView

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SmartOrderModel *)controller
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        model =controller;
    }
    return self;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initNavigate];
    [self initMainView];
    [self  initService];
    [self initFootView];
    [self preData];
    [self.footview initDelegate:self btnArrs:nil];
    [self.footview showHelp:YES];
}

-(void)initView
{
    [self.recommendView initLabel:NSLocalizedString(@"开通智能点餐提醒与推荐", nil) withHit:NSLocalizedString(@"1.请设置商品标签和下面的提醒推荐规则后再打开，打开后顾客用手机下单时就可以看到您推荐的菜。\n2.提醒和推荐规则提供了默认项以供参考", nil) delegate:self];
    [self.recommendView initData:@"0"];
    [self.recommendView visibal:YES];
     self.recommendView.line.hidden =YES;

    [self.footview showHelp:YES];
    self.recommendView.tag = RECOMMENDTURN;
    self.recommendView.tag = RECOMMENDTURN;
    CGRect origial = tableHeaderView.frame;
    origial.size.height = self.recommendView.origin.y+self.recommendView.frame.size.height;
    tableHeaderView.frame = origial;

}

- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    self.titleBox.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    [self.titleDiv addSubview:self.titleBox.view];
    self.title = @"点餐提醒与推荐";
 //    [self.titleBox initWithName:NSLocalizedString(@"顾客点餐智能提醒与推荐", nil) backImg:Head_ICON_BACK moreImg:Head_ICON_OK];

    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];

}

- (void)initService
{
     service =[ServiceFactory Instance].orderService;
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event ==DIRECT_LEFT) {
        [model showView:SMART_ORDER_LIST_VIEW];
    }
    else
    {
        [self saveWithTarget:TDFSaveWithPush];
    }
    
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavigationButtonAction:(id)sender
{
  [self saveWithTarget:TDFSaveWithPush];
}

- (void)initMainView
{
    self.tabView = [[UITableView  alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT+64)];
    self.tabView.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:self.tabView];
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabView.opaque=NO;
    self.tabView.delegate =self;
    self.tabView.dataSource =self;
    self.tabView.tableHeaderView  =  [self tableHeaderView];
    self.tabView.tableFooterView = [ViewFactory generateFooter:120];
}

- (void)initFootView
{
    if (!self.footview) {
        self.footview = [[FooterListView  alloc]init];
        [self.footview awakeFromNib];
        self.footview.frame =CGRectMake(0, SCREEN_HEIGHT-64,100, 64);
        [self.view addSubview:self.footview];
    }
    self.footview.backgroundColor =[UIColor clearColor];
    [self.footview initDelegate:self btnArrs:nil];
    [self.footview showHelp: YES];
}

- (UIView *)tableHeaderView
{
    if (!tableHeaderView) {
        [self layoutHeaderView];
    }
    return tableHeaderView;
}

- (void)layoutHeaderView
{
    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 330)];
    tableHeaderView.backgroundColor =[UIColor clearColor];
    
    UIImage *iconImage = [UIImage imageNamed:@"Good_Lbl_Set.png"];
    NSString *description = NSLocalizedString(@"在此按照用餐人数和菜肴类型主料等属性标签设置最佳点菜份数，顾客使用手机扫码点餐时，如果某个标签（类型或主料）下的菜肴点的份数少于此处设置的建议份数，在确认下单页面，系统会提醒顾客并推荐此类菜肴给顾客。您也可以设置菜肴点多时是否提醒顾客。", nil);
    TDFIntroductionHeaderView *headerView;
    headerView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage description:description badgeIcon:nil detailTitle:@"查看详情" detailBlock:^{
        [self showHelpEvent];
    }];
    headerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.65];
    [headerView changeBackAlpha:0.0];
    
    [tableHeaderView addSubview:headerView];
    
    UIView *line  =[[UIView alloc] initWithFrame:CGRectMake(10, headerView.frame.origin.y + headerView.frame.size.height, SCREEN_WIDTH-20, 1)];
    line.backgroundColor =[UIColor blackColor];
    line.alpha =0.1;
    [tableHeaderView addSubview:line];
    
    self.recommendView=[[EditItemRadio alloc] init];
    [self.recommendView awakeFromNib];
    self.recommendView.frame = CGRectMake(0,line.bottom, SCREEN_WIDTH,48 );
    self.recommendView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.65];
    [tableHeaderView addSubview:self.recommendView];
    [self initView];
}

-(void)preData
{
    self.isChange =NO;
    [self editTitleBoxWithChange:self.isChange];

    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:self.progressHud];
    [service  getCusOrderAndRecommendList:self callback:@selector(getRecommendData:)];
}

-(void)getRecommendData:(RemoteResult *)result
{
    [self.progressHud hide: YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    [self parse:result.content];
}

-(void)parse:(NSString *)content
{
    NSDictionary *dict =[JsonHelper transMap:content];
    NSDictionary *data =dict[@"data"];
    self.isturnon =[NSString stringWithFormat:@"%@",data[@"isTurnOn"]];
    self.dataArry =[JsonHelper transList:data[@"planConfigTypeVos"] objName:@"OrderRecommendPlantData"];
    NSDictionary *dictTYpe =data[@"labelConfigTypeVo"];
    OrderRecommendPlantData *itam =[[OrderRecommendPlantData alloc]init];
    itam.planType =dictTYpe[@"labelType"];
    itam.planName =NSLocalizedString(@"提醒与推荐语设置", nil);
    itam.planId =@"";
    [self.dataArry addObject:itam];
    [self fillModel];
    [self.tabView reloadData];
}

- (void)fillModel
{
    [self.recommendView initData:self.isturnon];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderSetCell *cell =[tableView dequeueReusableCellWithIdentifier:ORDERSETCELL];
    if (!cell ) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"OrderSetCell" owner:self options:nil].lastObject;
    }
    [cell initDelegate:self];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([ObjectUtil isNotEmpty:self.dataArry]) {
        OrderRecommendPlantData *data =self.dataArry[indexPath.row];
        [cell setTheGoodsName:data.planName];
        [cell setTheSetLabel:data.planType];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadNameItem *headNameItem = [[HeadNameItem alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];

    UIView *sectionHeaderBgView = [[UIView alloc] initWithFrame:headNameItem.bounds];
    [sectionHeaderBgView addSubview:headNameItem];
    [headNameItem initWithName:NSLocalizedString(@"按用餐人数提醒与推荐", nil)];
    
    return sectionHeaderBgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  40;
}

//cell的选中方法
-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag
{

    if (self.isChange) {
           [self saveWithTarget:TDFOnlySave];
     }

     NSIndexPath *indexpatch =[self.tabView indexPathForCell:cell];
    if ([ObjectUtil isNotEmpty:self.dataArry]) {
        OrderRecommendPlantData *data =self.dataArry[indexpatch.row];
        
        if ( indexpatch.row  != (self.dataArry.count-1)) {
            UIViewController *viewController  = [[TDFMediator  sharedInstance]  TDFMediator_orderRdDetailViewControllerName:data.planName plantId:data.planId delegate:self];
            [self.navigationController  pushViewController:viewController animated:YES];

          /* if (![data.planName isEqualToString:NSLocalizedString(@"提醒与推荐语设置", nil)]) {
            [model showView:SMARAT_ORDER_RDDETAIL_VITE];
            [model.tdfOrderRd getHttpData:data.planId WithTitle:data.planName];
          

        }*/
        }
        else
        {
            UIViewController *viewController  =[[TDFMediator sharedInstance] TDFMediator_orderRemindViewControllerWithDelegate:self];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (void)saveWithTarget:(NSInteger)saveType
 {
     self.isPush =saveType;

     [UIHelper showHUD:NSLocalizedString(@"正在保存", nil) andView:self.view andHUD:self.progressHud];
     [service saveIntRecommendationTurn:[NSString stringWithFormat:@"%ld",(long)self.istype] target:self callback:@selector(saveTurnOn:)];
 }

- (void)saveTurnOn:(RemoteResult *)result
{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        
        [AlertBox show:result.errorStr];
    }
    if (self.isPush ==  TDFSaveWithPush) {
         [self.navigationController popViewControllerAnimated: YES];
    }
}

-  (void)editTitleBoxWithChange:(BOOL)isChange
{
    [self configNavigationBar:isChange];
}

- (void)showHelpEvent
{
    [HelpDialog show:@"orderRecomendeAndRemind"];
}

-(void)onItemRadioClick:(EditItemRadio *)obj
{
    if (obj.baseChangeStatus) {
        [self configNavigationBar:YES];
     
    }
    else
    {
        [self configNavigationBar:NO];
    }
    if (obj.tag ==RECOMMENDTURN) {
        self.istype =[self.recommendView getVal];
        self.isChange =obj.baseChangeStatus;
        if (self.istype) {
            [service getRemindCount:self callback:@selector(getShopCount:)];
        }
        [self editTitleBoxWithChange:self.isChange];
    }
}

-  (void)getShopCount:(RemoteResult *)result
{
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary *map =[JsonHelper transMap:result.content];
    NSString *data =map[@"data"];
    if (data.integerValue>0) {
        [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您还有%ld个菜未设置商品标签，会导致提醒和推荐不准确，建议您设置完商品标签再打开此开关", nil),(long)data.integerValue]];
    }
}

- (void)navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
    [self preData];
}

- (IBAction)btnClick:(id)sender {
    
    [HelpDialog show:@"orderrecommend"];
}

- (NSMutableArray *)dataArry
{
    if (!_dataArry) {
        _dataArry  = [[NSMutableArray  alloc] init];
    }
    return _dataArry;
}



@end
