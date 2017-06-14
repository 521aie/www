//
//  SettingSecondView.m
//  RestApp
//
//  Created by zxh on 14-7-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SettingSecondView.h"
#import "SettingModule.h"
#import "NavigateTitle2.h"
#import "SecondMenuCell.h"
#import "Platform.h"
#import "DHHeadItem.h"
#import "NSString+Estimate.h"
#import "UIMenuAction.h"
#import "SystemUtil.h"
#import "ObjectUtil.h"
#import "ActionConstants.h"
#import "ViewFactory.h"
#import "XHAnimalUtil.h"
#import "NavigatorCell.h"
//#import "KindPayEditView.h"
#import "TimeArrangeEditView.h"
#import "TimeArrangeListView.h"
#import "LinkManListView.h"
#import "LinkManEditView.h"
#import "ShopTemplateListView.h"
#import "ShopTemplateEditView.h"
#import "PrinterParasEditView.h"
#import "KindMenuStyleListView.h"
#import "AlertBox.h"
#import "TailDealEditView.h"
#import "DicItemEditView.h"
#import "FeePlanListView.h"
#import "FeePlanEditView.h"
#import "DiscountPlanListView.h"
#import "DiscountPlanEditView.h"
#import "DiscountDetailEditView.h"
#import "SysParaEditView.h"
#import "OpenTimePlanView.h"
#import "BackgroundHelper.h"
#import "DicItemConstants.h"
#import "SignBillListView.h"
#import "SignBillEditView.h"
#import "DataClearView.h"
#import "CancelBindView.h"
#import "NameItemVO.h"

@implementation SettingSecondView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SettingModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigate];
    [self initNotification];
    [self initMainView];
    [self initDataView];
}

- (void)initMainView
{
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:36];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    [SystemUtil hideKeyboard];
}

#pragma navigateBar
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"营业设置", nil) backImg:Head_ICON_BACK moreImg:nil];
}

#pragma 通知相关.
- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(permissionChange:) name:Notification_Permission_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDataInit:) name:UI_COUNTDATA_INIT object:nil];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [parent backMenu];
    }
}

#pragma data初始化.
- (void)initDataView
{
    self.headList = [NSMutableArray array];
    NameItemVO* item = [[NameItemVO alloc] initWithVal:NSLocalizedString(@"基础设置", nil) andId:BASE_SETTING];
    [self.headList addObject:item];
    item = [[NameItemVO alloc] initWithVal:NSLocalizedString(@"收银设置", nil) andId:CASH_SETTING];
    [self.headList addObject:item];
    item = [[NameItemVO alloc] initWithVal:NSLocalizedString(@"其他设置", nil) andId:EXTRA_SETTING];
    [self.headList addObject:item];

    [self initDetailItem];
}

- (void)refreshDataView
{
    [self initDataDetailInfo];
}

- (void)initDetailItem
{
    self.detailMap = [NSMutableDictionary dictionary];
    
    //基础设置.
    NSMutableArray* details=[NSMutableArray array];
    UIMenuAction *action=[[UIMenuAction alloc] init:NSLocalizedString(@"系统参数", nil) detail:NSLocalizedString(@"收银使用基础设置", nil) img:@"ico_nav_xitongcanshu" code:PAD_SETTING];
    [details addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"店家信息", nil) detail:NSLocalizedString(@"设置本店基础信息", nil) img:@"ico_nav_dianjiaxinxi" code:PAD_SHOPINFO];
    [details addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"营业结束时间", nil) detail:NSLocalizedString(@"设置营业结束时间", nil) img:@"ico_nav_yingyejieshushijian" code:PAD_OPEN_TIME];
    [details addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"营业班次", nil) detail:NSLocalizedString(@"设置一天的班次", nil) img:@"ico_nav_yingyebanci" code:PAD_TIME_ARRANGE];
    [details addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"付款方式", nil) detail:NSLocalizedString(@"设置付款方式", nil) img:@"ico_nav_fukuanfangshi" code:PAD_KIND_PAY];
    [details addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"挂账设置", nil) detail:NSLocalizedString(@"管理挂账人,本店签字确认人等", nil) img:@"ico_nav_guazhangshezhi" code:PAD_SIGN_PERSON];
    [details addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"收银单据", nil) detail:NSLocalizedString(@"管理各类单据的打印格式", nil) img:@"ico_nav_dayindanjumuban" code:PAD_BILL_TEMPLATE];
    [details addObject:action];
    
//    action=[[UIMenuAction alloc] init:NSLocalizedString(@"营业短信接收人", nil) detail:NSLocalizedString(@"短信接收人每天会按时收到营业汇总短信", nil) img:@"ico_nav_duanxinlianxiren" code:PAD_ZM_SMS];
//    [details addObject:action];
    
    [self.detailMap setObject:details forKey:BASE_SETTING];
   
    //收银设置.
    details=[NSMutableArray array];
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"收银打印", nil) detail:NSLocalizedString(@"打印相关的设置", nil) img:@"ico_nav_shouyindayinmuban" code:PAD_CASH_OUTPUT];
    [details addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"零头处理方式", nil) detail:NSLocalizedString(@"结账时的抹零,尾数逢4减1等设置", nil) img:@"ico_nav_lingtouchulifangshi" code:PAD_ZERO_PARA];
    [details addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"客单备注", nil) detail:NSLocalizedString(@"添加一些备注内容,开单时可快速选择", nil) img:@"ico_nav_kedanbeizhu" code:PAD_TABLE_ITEM];
    [details addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"特殊操作原因", nil) detail:NSLocalizedString(@"退货,打折,反结账等操作原因", nil) img:@"ico_nav_teshucaozuoyuanyin" code:PAD_SPECIAL_OPERATE];
    [details addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"附加费", nil) detail:NSLocalizedString(@"设置服务费或者最低消费", nil) img:@"ico_nav_fujiafei" code:PAD_FEE_PLAN];
    [details addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"打折方案", nil) detail:NSLocalizedString(@"设置多种折扣方案，供收银使用", nil) img:@"ico_nav_dazhefangan" code:PAD_DISCOUNT_PLAN];
    [details addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"电子菜谱排版", nil) detail:NSLocalizedString(@"电子菜谱上的商品展示方式设置", nil) img:@"ico_nav_dianzicaipupaiban" code:MARKET_EMENU_STYLE];
    [details addObject:action];
    
    [self.detailMap setObject:details forKey:CASH_SETTING];
    
    //其他设置.
    details=[NSMutableArray array];
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"账单优化", nil) detail:NSLocalizedString(@"可自动或人工优化账单", nil) img:@"ico_nav__color_zhangdanyouhua" code:PAD_ACCOUNT_OPERATION];
    [details addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"营业数据清理", nil) detail:NSLocalizedString(@"清理账单,报表等营业数据", nil) img:@"ico_nav_shujuqingli" code:PAD_DATA_CLEAR];
    [details addObject:action];
    
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"更换排队机", nil) detail:NSLocalizedString(@"使用另一台排队机进行排队", nil) img:@"ico_nav_genghuanpaiduiji" code:PAD_CHANGE_QUEUE];
    [details addObject:action];
    
    UIMenuAction *actionOne=[[UIMenuAction alloc] init:NSLocalizedString(@"店内屏幕广告", nil) detail:NSLocalizedString(@"清理账单,报表等营业数据", nil) img:@"ico_nav_shujuqingli" code:PHONE_SCREEN_ADVERTISEMENT];
    [details addObject:actionOne];
    
    UIMenuAction *actionTwo=[[UIMenuAction alloc] init:NSLocalizedString(@"叫号语音设置", nil) detail:NSLocalizedString(@"使用另一台排队机进行排队", nil) img:@"ico_nav_genghuanpaiduiji" code:PHONE_VOICE_SET];
    [details addObject:actionTwo];
    
    
    
    [self.detailMap setObject:details forKey:EXTRA_SETTING];
}

- (void)countDataInit:(NSNotification *)notification
{
    [self initDataDetailInfo];
}

- (void)initDataDetailInfo
{
    NSMutableArray *details=nil;
    for (NSString *key in [self.detailMap allKeys]) {
        details=[self.detailMap objectForKey:key];
        for (UIMenuAction* act in details) {
            if ([act.code isEqualToString:PAD_OPEN_TIME]) {
                act.detail = [[Platform Instance] countObject:@"openTimeStr"];
            }
            
            if ([act.code isEqualToString:PAD_KIND_PAY]) {
                act.detail = [NSString stringWithFormat:NSLocalizedString(@"已添加%@种付款方式", nil), [[Platform Instance] countObject:@"kindPayCount"]];
            }
        }
    }
    [self.mainGrid reloadData];
}

- (void)permissionChange:(NSNotification *)notification
{
    [self.mainGrid reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NavigatorCell *navigatorCell = (NavigatorCell *)[tableView dequeueReusableCellWithIdentifier:NavigatorCellIdentifier];
    if (navigatorCell==nil) {
        navigatorCell = [NavigatorCell getInstance];
    }
    
    navigatorCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NameItemVO* head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *details = [self.detailMap objectForKey:head.itemId];
        if ([ObjectUtil isNotEmpty:details]) {
            UIMenuAction* menuAction=(UIMenuAction*)[details objectAtIndex: indexPath.row];
            [navigatorCell initWithData:menuAction];
            return navigatorCell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameItemVO *item = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:item]) {
        NSMutableArray *details = [self.detailMap objectForKey:item.itemId];
        if ([ObjectUtil isNotEmpty:details]) {
            UIMenuAction *item=(UIMenuAction*)[details objectAtIndex: indexPath.row];
            BOOL isLockFlag=[[Platform Instance] lockAct:item.code];
            if (isLockFlag) {
                [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),item.name]];
                return;
            }
            [parent showActionCode:item.code];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NameItemVO* item = [self.headList objectAtIndex:section];
    if ([ObjectUtil isNotNull:item]) {
        NSMutableArray *details = [self.detailMap objectForKey:item.itemId];
        if ([ObjectUtil isNotEmpty:details]) {
            return details.count;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NameItemVO *item = [self.headList objectAtIndex:section];
    DHHeadItem *headItem = [[[NSBundle mainBundle]loadNibNamed:@"DHHeadItem" owner:self options:nil]lastObject];
    [headItem initWithData:item];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.headList!=nil?self.headList.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MAVIGATOR_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return DH_HEAD_HEIGHT;
}

@end
