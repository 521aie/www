//
//  SecondMenuView.m
//  RestApp
//
//  Created by zxh on 14-3-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertBox.h"
#import "Platform.h"
#import "SystemUtil.h"
#import "ViewFactory.h"
#import "UIMenuAction.h"
#import "UIView+Sizes.h"
#import "DataSingleton.h"
#import "NavigateTitle.h"
#import "SecondMenuView.h"
#import "NavigateTitle2.h"
#import "SecondMenuCell.h"
#import "ActionConstants.h"
#import "NSString+Estimate.h"
#import "GridHeightConstants.h"
#import "ShopReviewCenter.h"

@implementation SecondMenuView
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<MenuSelectHandle>)parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        delegate = parent;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initHead];
    
    self.menuItems = [delegate createList];
    //表格初始.
    [self initMainGrid];
    [self initNotifaction];
}

#pragma mark TitleBox deal
-(void) initHead
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"顾客端设置", nil) backImg:Head_ICON_BACK moreImg:nil];
}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        if (isnavigatemenupush) {
            isnavigatemenupush =NO;
            [delegate backNavigateMenuView];
        }
        else {
            [delegate backMenu];
        }
    }
}

-(void)initMainGrid
{
    //表格初始.
    [self.tableSeMenus setBackgroundView:nil];
    self.tableSeMenus.backgroundColor=[UIColor clearColor];
    self.tableSeMenus.opaque=NO;
    self.tableSeMenus.tableFooterView = [ViewFactory generateFooter:36];
    //如果想删除cell之间的分割线，设置
    self.tableSeMenus.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initNotifaction
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(permissionChange:) name:Notification_Permission_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reviewStatusChanged)
                                                 name:kShopReviewStateChangedNotification
                                               object:nil];
}

- (void)reviewStatusChanged {

//    [self.tableSeMenus reloadData];
}


-(void) permissionChange:(NSNotification*) notification
{
    [self.tableSeMenus reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.menuItems.count > 0 && indexPath.row < self.menuItems.count) {
        SecondMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:SecondMenuCellIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SecondMenuCell" owner:self options:nil].lastObject;
        }
        UIMenuAction * menuAction = [self.menuItems objectAtIndex:indexPath.row];
        cell.lblName.text= menuAction.name;
        cell.lblDetail.text = menuAction.detail;
        [cell.lblName sizeToFit];
        [cell.imgLock setHidden:!([[Platform Instance] isNetworkOk] && [[Platform Instance] lockAct:menuAction.code])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([NSString isNotBlank:menuAction.img]) {
            UIImage *img=[UIImage imageNamed:menuAction.img];
            cell.imgMenu.image=img;
        } else {
            cell.imgMenu.image=nil;
        }
        
        cell.backgroundColor=[UIColor clearColor];

        cell.warningImageView.hidden = ![menuAction.name isEqualToString:NSLocalizedString(@"店家资料", nil)] || ![ShopReviewCenter sharedInstance].shouldShowWarningBadge;
        return cell;
    } else {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:YES andLoadOverString:NSLocalizedString(@"没有数据", nil) andLoadingString:NSLocalizedString(@"正在加载..", nil) andIsLoading:NO];
    }
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.menuItems.count==0?1:self.menuItems.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MAIN_MENU_ITEM_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    if (row >= self.menuItems.count) {
        [self.tableSeMenus reloadData];
    } else {
        UIMenuAction * menuAction = [self.menuItems objectAtIndex: row];
        BOOL isLockFlag=[[Platform Instance] lockAct:menuAction.code];
        if (isLockFlag) {
            [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),menuAction.name]];
            return;
        }
        [delegate onMenuSelectHandle:menuAction];
    }
    
}
- (void) loadData
{
    self.menuItems = [delegate createList];
    [self.tableSeMenus reloadData];
}

@end
