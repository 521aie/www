//
//  OrderListView.m
//  RestApp
//
//  Created by iOS香肠 on 16/3/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderListView.h"
#import "ViewFactory.h"
#import "orderSetView.h"
#import "SecondMenuCell.h"
#import "orderRecommendView.h"
#import "NSString+Estimate.h"
#import "UIMenuDetaiAction.h"
#import "GlorenMenuModules.h"
#import "TDFMediator+SmartModel.h"
#import "HelpDialog.h"
#import "SmartOrderSettingRNModel.h"
#import "RNNativeActionManager.h"

@interface OrderListView ()
@property(nonatomic, strong)SmartOrderSettingRNModel * RNSmartOrder;
@end

@implementation OrderListView

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SmartOrderModel *)controller
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNotifaction];
    [self initNavigate];
    [self preData];
    [self initMainView];
}


- (void)initNotifaction
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RNDidMount:) name:RNDidMountNotification object:nil];
}

- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    self.titleBox.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    [self.titleDiv addSubview:self.titleBox.view];
   // [self.titleBox initWithName:NSLocalizedString(@"智能点餐", nil) backImg:Head_ICON_BACK moreImg:nil];
    self.title =NSLocalizedString(@"智能点餐", nil);

  //  [self.titleBox initWithName:NSLocalizedString(@"智能点餐", nil) backImg:Head_ICON_BACK moreImg:nil];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event ==DIRECT_LEFT) {
        [model backMenu];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)RNDidMount:(NSNotification*)notification {
    
    NSDictionary * notificationDic = (NSDictionary *)[notification object];
    
    if (notificationDic) {
        NSString * helpActionKey = notificationDic[@"mountComponent"];
        
        if (helpActionKey) {
            if ([helpActionKey isEqualToString:@"Did_Mount_TemplateHome"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    UINavigationController * nav = (UINavigationController *)[[UIApplication sharedApplication].delegate window].rootViewController;
                    
                    if (nav.topViewController == self.RNSmartOrder || !self.view.window) {
                        return ;
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:self.RNSmartOrder animated:YES];
                });
                
                return;
            }
        }
    }
    
}

#pragma 详情点击事件
- (IBAction)OnClickConfire:(id)sender {
    [HelpDialog show:@"orderlist"];
}

-(void)preData
{
    [self.arry removeAllObjects];
    self.arry =[GlorenMenuModules listOrderIteam];
}

- (void)reloadData
{
    [self.tabView reloadData];
}

-(void)initMainView
{
    self.detailLbl.textColor =[UIColor colorWithRed:0.0/255.0 green:136.0/255.0 blue:204.0/255.0 alpha:1];
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabView.opaque=NO;
    self.tabView.delegate =self;
    self.tabView.dataSource =self;
    self.tabView.tableFooterView = [ViewFactory generateFooter:36];
    [self.footview showHelp:YES];
    [self.footview initDelegate:self btnArrs:nil];
}

#pragma tabView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:SecondMenuCellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SecondMenuCell" owner:self options:nil].lastObject;
    }
    UIMenuDetaiAction *iteam =[self.arry objectAtIndex:indexPath.row];
    cell.lblName.text =iteam.name;
    cell.lblDetail.text =iteam.content;
    [cell.lblName sizeToFit];
    [cell.imgLock setHidden:!([[Platform Instance] isNetworkOk] && [[Platform Instance] lockAct:iteam.code])];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([NSString isNotBlank:iteam.img]) {
        UIImage *img=[UIImage imageNamed:iteam.img];
        cell.imgMenu.image=img;
    } else {
        cell.imgMenu.image=nil;
    }
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIMenuDetaiAction * menuAction = [self.arry objectAtIndex: indexPath.row];
    BOOL isLockFlag=[[Platform Instance] lockAct:menuAction.code];
    if (isLockFlag) {
        [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),menuAction.name]];
        return;
    }
    
    if (indexPath.row==0) {
        TDFMediator *media = [[TDFMediator alloc] init];
        UIViewController *orderSet = [media  TDFMediator_orderSetViewController];
        [self.navigationController pushViewController:orderSet animated:YES];
        
    }
    else if (indexPath.row==1)
    {
        TDFMediator *meida = [[TDFMediator alloc] init];
        UIViewController *orderRecommend =[meida TDFMediator_orderRecommendViewController];
        [self.navigationController pushViewController:orderRecommend animated:YES];
    }
    else if (indexPath.row==2)
    {
        self.RNSmartOrder = [[SmartOrderSettingRNModel alloc] init];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

-(void)showHelpEvent
{
   [HelpDialog show:@"orderlist"];
}

- (NSMutableArray *)arry
{
    if (!_arry) {
        _arry   = [[NSMutableArray  alloc]  init];
    }
    return _arry;
}

@end
