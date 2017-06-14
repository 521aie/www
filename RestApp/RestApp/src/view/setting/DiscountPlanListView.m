//
//  DiscountPlanListView.m
//  RestApp
//
//  Created by zxh on 14-4-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "DiscountPlanListView.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "RemoteResult.h"
#import "RemoteEvent.h"
#import "XHAnimalUtil.h"
#import "DiscountPlanEditView.h"
#import "DiscountPlan.h"
#import "GridColHead.h"
#import "HelpDialog.h"
#import "TableEditView.h"
#import "UIHelper.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "ViewFactory.h"
#import "UIView+Sizes.h"
#import "TDFSettingService.h"
#import "ColorHelper.h"
#import "TDFSettingService.h"
#import "TDFRootViewController+FooterButton.h"

@implementation DiscountPlanListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service=[ServiceFactory Instance].settingService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"打折方案", nil);
    self.needHideOldNavigationBar = YES;
    [self initNotification];
    NSArray* arr=[[NSArray alloc] initWithObjects:@"add",@"sort", nil];
    [self initDelegate:self event:@"discountplan" title:NSLocalizedString(@"打折方案", nil) foots:arr];
    self.footView.hidden = YES;
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp|TDFFooterButtonTypeAdd|TDFFooterButtonTypeSort];
    
    [self loadDatas];
}

- (void) leftNavigationButtonAction:(id)sender
{
    if (isnavigatemenupush) {
        isnavigatemenupush =NO;
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_SHOW_NOTIFICATION object:nil] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:LODATA object:nil];
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)initGrid
{
    self.mainGrid.opaque=YES;
    UIView* view=[ViewFactory generateFooter:60];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
     self.mainGrid.tableHeaderView = [self tableHeaderView];
    
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
    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 190)];
    tableHeaderView.backgroundColor =[UIColor clearColor];
    UIView *view =[[UIView alloc] initWithFrame:tableHeaderView.bounds];
    view.backgroundColor =[UIColor whiteColor];
    view.alpha =0.7;
    [tableHeaderView addSubview:view];
    
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, 20,60,60)];
    imageView.image =[UIImage imageNamed:@"ico_nav_color_dazhefangan"];
    [tableHeaderView addSubview:imageView];
    imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    imageView.layer.borderWidth = 1.0f;
    imageView.layer.masksToBounds =YES;
    imageView.layer.cornerRadius = imageView.width/2;
    UILabel *conTentLbl =[[UILabel alloc] initWithFrame:CGRectMake(11, imageView.bottom, SCREEN_WIDTH-11-11, 90)];
    [tableHeaderView addSubview: conTentLbl];
    conTentLbl.backgroundColor =[UIColor clearColor];
    conTentLbl.textAlignment = NSTextAlignmentLeft;
    conTentLbl.textColor =[UIColor grayColor];
    conTentLbl.numberOfLines =0;
    conTentLbl.font =[UIFont systemFontOfSize:15];
    conTentLbl.text =NSLocalizedString(@"打折方案是一种收银机专用的优惠方式，收银员在收银机上开单时可以选择和使用。顾客端（扫码点餐）专用的优惠，请到“会员-会员优惠”中发布促销活动或优惠券、会员卡等。", nil);
    UILabel *detailLabel =[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-80+10, conTentLbl.bottom-20, 80, 40)];
    detailLabel.text =NSLocalizedString(@"查看详情", nil);
    detailLabel.textColor =[ColorHelper getBlueColor];
    detailLabel.font =[UIFont systemFontOfSize:13];
    detailLabel.backgroundColor =[UIColor clearColor];
    [tableHeaderView addSubview:detailLabel];
    UIImageView *picImg =[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40+10, conTentLbl.bottom-20+10, 20, 20)];
    [tableHeaderView addSubview:picImg];
    picImg.image =[UIImage imageNamed:@"ico_next_blue"];
    UIImageView *picImgSe =[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40+4+10, conTentLbl.bottom-20+10, 20, 20)];
    [tableHeaderView addSubview:picImgSe];
    picImgSe.image =[UIImage imageNamed:@"ico_next_blue"];
    
    UIButton *detailBtn =[[UIButton  alloc] initWithFrame:CGRectMake(detailLabel.left, conTentLbl.bottom-20, picImgSe.right, detailLabel.height)];
    [tableHeaderView addSubview:detailBtn];
    detailBtn.backgroundColor =[UIColor clearColor];
    [detailBtn addTarget:self action:@selector(footerHelpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma 数据加载
-(void)loadDatas{

     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFSettingService new] listDiscountPlanSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hide:YES];
        NSArray *list = [data objectForKey:@"data"];
        self.datas=[JsonHelper transList:list objName:@"DiscountPlan"];
        [self.mainGrid reloadData];
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma 实现协议 ISampleListEvent

-(void) closeListEvent:(NSString*)event
{
}

-(void) footerAddButtonAction:(UIButton *)sender
{
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_DiscountPlanEditViewControllerWithData:nil action:ACTION_CONSTANTS_ADD CallBack:^{
        @strongify(self);
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) delEvent:(NSString*)event ids:(NSMutableArray*) ids
{
//    [service removeDiscountPlans:ids Target:self Callback:@selector(delFinish:)];
}

- (void)footerSortButtonAction:(UIButton *)sender {

    [self.delegate sortEvent:@"sortinit" ids:nil];
}

-(void) sortEvent:(NSString*)event ids:(NSMutableArray*)ids
{
    if ([event isEqualToString:@"sortinit"]) {
        if (self.datas==nil || self.datas.count<2) {
            [AlertBox show:NSLocalizedString(@"请至少添加两条内容,才能进行排序.", nil)];
            return;
        }
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_TableEditView:self event:@"sort"  action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil) dataTemps:[self.datas mutableCopy] error:nil needHideOldNavigationBar:YES];
        [self.navigationController pushViewController:viewController animated:YES];
         [self loadDatas];
    } else {

        [self showProgressHudWithText:NSLocalizedString(@"正在排序", nil)];
        [[TDFSettingService new] sortDiscountPlans:ids sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud  hideAnimated:YES];
            NSArray *list = [data  objectForKey:@"data"];
            self.datas=[JsonHelper transList:list objName:@"DiscountPlan"];
            [self.mainGrid reloadData];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hideAnimated:YES];
            [AlertBox show:error.localizedDescription];
        }];

    }
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"discountplan"];
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    DiscountPlan* editObj=(DiscountPlan*)obj;
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_DiscountPlanEditViewControllerWithData:editObj action:ACTION_CONSTANTS_EDIT CallBack:^{
        @strongify(self);
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 消息处理部分.
-(void) initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:REMOTE_DISCOUNTPLAN_LIST object:nil];
}

-(void) dataChange:(NSNotification*) notification
{
     [self configNavigationBar:NO];
}


-(void) delFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
   
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadData:result.content];
}

-(void) sortFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
       if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    [self remoteLoadData:result.content];
}

-(void) remoteLoadData:(NSString *) responseStr
{
    NSDictionary* map=[JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"discountPlans"];
    self.datas=[JsonHelper transList:list objName:@"DiscountPlan"];
    [self.mainGrid reloadData];
}

#pragma table head
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead *headItem = (GridColHead *)[self.mainGrid dequeueReusableCellWithIdentifier:GridColHeadIndentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    }
    [headItem initColHead:NSLocalizedString(@"方案名称", nil) col2:NSLocalizedString(@"优惠方式", nil)];
    [headItem initColLeft:15 col2:137];
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

@end
