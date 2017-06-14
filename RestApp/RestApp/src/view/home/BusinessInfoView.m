//
//  BusinessInfoView.m
//  RestApp
//
//  Created by 刘红琳 on 16/1/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "AlertBox.h"
#import "Platform.h"
#import "SystemUtil.h"
#import "ViewFactory.h"
#import "UIMenuAction.h"
#import "UIView+Sizes.h"
#import "DataSingleton.h"
#import "NavigateTitle.h"
#import "BusinessInfoView.h"
#import "NavigateTitle2.h"
#import "SecondMenuCell.h"
#import "ActionConstants.h"
#import "NSString+Estimate.h"
#import "GridHeightConstants.h"

@implementation BusinessInfoView
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<MenuSelectHandle>)parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        delegate = parent;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    
    menuItems = [delegate createList];
    //表格初始.
    [self initMainGrid];
    [self initNotifaction];
}

-(void) initHead
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"营业", nil) backImg:Head_ICON_BACK moreImg:nil];
}

-(void)initMainGrid
{
    //表格初始.
    [self.businessTab setBackgroundView:nil];
    self.businessTab.backgroundColor=[UIColor clearColor];
    self.businessTab.opaque=NO;
    self.businessTab.tableFooterView = [ViewFactory generateFooter:36];
    //如果想删除cell之间的分割线，设置
    self.businessTab.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initNotifaction
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(permissionChange:) name:Notification_Permission_Change object:nil];
}

-(void) permissionChange:(NSNotification*) notification
{
    [self.businessTab reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (menuItems.count > 0 && indexPath.row < menuItems.count) {
        SecondMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:SecondMenuCellIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SecondMenuCell" owner:self options:nil].lastObject;
        }
        UIMenuAction * menuAction = [menuItems objectAtIndex:indexPath.row];
        cell.lblName.text= menuAction.name;
        cell.lblDetail.text = menuAction.detail;
        [cell.lblName sizeToFit];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        cell.line.backgroundColor = [[UIColor alloc]initWithWhite:1 alpha:0.8];
        [cell.imgLock setHidden:!([[Platform Instance] isNetworkOk] && [[Platform Instance] lockAct:menuAction.code])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([NSString isNotBlank:menuAction.img]) {
            UIImage *img=[UIImage imageNamed:menuAction.img];
            cell.imgMenu.image=img;
        } else {
            cell.imgMenu.image=nil;
        }
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    } else {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:YES andLoadOverString:NSLocalizedString(@"没有数据", nil) andLoadingString:NSLocalizedString(@"正在加载..", nil) andIsLoading:NO];
    }
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (menuItems.count==0?1:menuItems.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MAIN_MENU_ITEM_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    if (row >= menuItems.count) {
        [self.businessTab reloadData];
    } else {
        UIMenuAction * menuAction = [menuItems objectAtIndex: row];
        BOOL isLockFlag=[[Platform Instance] lockAct:menuAction.code];
        if (isLockFlag) {
            [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),menuAction.name]];
            return;
        }
        [delegate onMenuSelectHandle:menuAction];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
