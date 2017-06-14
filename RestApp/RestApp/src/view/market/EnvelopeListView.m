//
//  CustomerListView.m
//  RestApp
//
//  Created by zxh on 14-7-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Coupon.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "ViewFactory.h"
#import "RemoteEvent.h"
#import "RemoteResult.h"
#import "XHAnimalUtil.h"
#import "MarketModule.h"
#import "TableEditView.h"
#import "NavigateTitle2.h"
#import "NavigateTitle2.h"
#import "ServiceFactory.h"
#import "EventConstants.h"
#import "EnvelopeListView.h"
#import "EnvelopeItemCell.h"
#import "ActionConstants.h"
#import "MJRefresh.h"
@implementation EnvelopeListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MarketModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        service = [ServiceFactory Instance].envelopeService;
        self.datas = [NSMutableArray arrayWithCapacity:20];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigate];
    [self initMainGrid];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"add", nil];
    [self initDelegate:self event:@"envelope" title:NSLocalizedString(@"红包", nil) foots:arr];
}

-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"红包", nil) backImg:Head_ICON_BACK moreImg:nil];
    [self.titleBox btnVisibal:NO direct:DIRECT_RIGHT];
}

- (void)initMainGrid
{
    
    __weak typeof(self) weakself = self;
    
    self.mainGrid.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        isRefreshed = YES;
        weakself.page = 1;
        [weakself loadList];
    }];
    self.mainGrid.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        isRefreshed = NO;
        weakself.page = weakself.page + 1;
        [weakself loadList];
    }];
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.mainGrid.footer;
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;


    [self.mainGrid setTableFooterView:[ViewFactory generateFooter:60]];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma 数据加载
- (void)loadDatas
{
    self.isClick = NO;
    self.page = 1;
    [self.datas removeAllObjects];
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:self.progressHud];
    [self loadList];
}

-(void)loadList{
    [service listEnvelopeDatatargetWithPage:self.page target:self callback:@selector(loadFinish:)];

}

-(void)loadEvent:(NSInteger)event
{
    self.eventType =event;
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        if (self.eventType ==1) {
            [parent backToMemberViewView];
        } else if(self.eventType == 2){
            [parent backLastView:PAD_KABAW viewTag:BASE_SETTING_VIEW];
        }
        else
        {
            [parent backToMain];
        }
    }
}

- (void)closeListEvent:(NSString*)event
{
}

- (void)loadFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
    [self.mainGrid.header endRefreshing];
    [self.mainGrid.footer endRefreshing];

    self.noDataTip.hidden = YES;
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        self.page = self.page-1;
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadData:result.content];
}

- (void)showAddEvent
{
    
    
    [AlertBox show:NSLocalizedString(@"二维火掌柜中现有的“红包”功能近期将进行一次升级改造，被“优惠券”功能全面取代。即将发布的“优惠券”功能，分为现金券、打折券等各类券种，为大家提供更全面的营销方案。“红包”功能将停止使用，不可以再发布新的红包。已经领取红包的顾客仍旧可以在店内核销使用该红包。", nil)];
//    [parent showView:ENVELOPE_EDIT_VIEW];
//    [parent.envelopeEditView loadDataAction:ACTION_CONSTANTS_ADD isContinue:NO];
//    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromTop];
}

- (void)showHelpEvent:(NSString *)event
{
    [HelpDialog show:@"envelope"];
}

- (void)remoteLoadData:(NSString *)responseStr
{
    NSDictionary* map = [JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"data"];
    NSArray *coupons = [Coupon convertToCouponList:list];
    
    if (isRefreshed) {
        [self.datas removeAllObjects];
        [self.datas addObjectsFromArray:coupons];
    }else{
        [self.datas addObjectsFromArray:coupons];

    }
    
    
    if ([ObjectUtil isEmpty:self.datas]) {
        self.noDataTip.hidden = NO;
    }
    [self.mainGrid reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EnvelopeItemCell *envelopItemCell = (EnvelopeItemCell *)[tableView dequeueReusableCellWithIdentifier:ENVELOPE_ITEM_CELL];
    if (envelopItemCell == nil) {
        envelopItemCell = [EnvelopeItemCell getInstance];
        envelopItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Coupon *coupon = [self.datas objectAtIndex:indexPath.row];
    [envelopItemCell initWithData:coupon];
    return envelopItemCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([ObjectUtil isNotEmpty:self.datas]?[self.datas count]:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ENVELOPE_ITEM_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([ObjectUtil isNotEmpty:self.datas] && indexPath.row<self.datas.count) {
        Coupon *coupon = [self.datas objectAtIndex:indexPath.row];
        if (self.eventType == 2) {
            
            if (coupon.enableRule) {
                [AlertBox show:NSLocalizedString(@"抱歉，不能选裂变红包哦!", nil)];
                return;
            }
            
            if (coupon.status == STATUS_COUPON_CANCEL) {
                [AlertBox show:NSLocalizedString(@"抱歉，不能选过期红包哦！", nil)];
                return;
            }
            self.isClick = YES;
            self.coupon = coupon;
            [parent backLastView:PAD_KABAW viewTag:BASE_SETTING_VIEW];
            
            
        }else{
            [parent showView:ENVELOPE_DETAIL_VIEW];
            [parent.envelopeDetailView loadData:coupon._id];
            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromRight];
        }
    }
}

@end
