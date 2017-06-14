//
//  AboutView.m
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-25.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NotificationItemCell.h"
#import "SysNotificationView.h"
#import "NSString+Estimate.h"
#import "ActionConstants.h"
#import "SysNotification.h"
#import "ServiceFactory.h"
#import "NavigateTitle2.h"
#import "NoteHeaderItem.h"
#import "EventConstants.h"
#import "AppController.h"
#import "TDFKabawService.h"
#import "RemoteResult.h"
#import "XHAnimalUtil.h"
#import "RemoteEvent.h"
#import "SystemEvent.h"
#import "ItemFactory.h"
#import "SystemUtil.h"
#import "JsonHelper.h"
#import "ObjectUtil.h"
#import "DateUtils.h"
#import "AlertBox.h"

@implementation SysNotificationView

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        businessService = [ServiceFactory Instance].businessService;
        self.dataMaps = [[NSMutableDictionary alloc]init];
        self.datas = [[NSMutableArray alloc]init];
        [SystemEvent registe:REFRESH_SYS_NOTIFICAION target:self];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"系统通知";
    [self configLeftNavigationBar:@"ico_back.png" leftButtonName:@"返回"];
    
    [self initNotification];
    [self initDataView];
    
    [self.mainGrid registerNib:[UINib nibWithNibName:@"NotificationItemCell" bundle:nil] forCellReuseIdentifier:NOTIFICATION_INFO_ITEM];
}

#pragma 消息处理部分.
- (void)initNotification
{

}

- (void)initDataView
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//    [businessService listSysNotification:self callback:@selector(loadFinish:)];
     [[TDFKabawService new] listSysNotificationSucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
         [self.progressHud  hide:YES];
         [self remoteLoadData:data];
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         [self.progressHud  hide:YES];
         [AlertBox show:error.localizedDescription];
     }];

}


- (void)remoteLoadData:( id)data
{
    [self.datas removeAllObjects];
    [self.dataMaps removeAllObjects];
    NSDictionary* map= data [@"data"];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"TDFSystemNotifications"];
    NSArray *list = [map objectForKey:@"sysNotificationVos"];
    NSMutableArray *notificationList=[SysNotification convertToSysNotificationsByArr:list];
    for (SysNotification *notification in notificationList) {
        NSString *key = [DateUtils formatTimeWithTimestamp:notification.createTime type:TDFFormatTimeTypeChinese];
        if ([self.dataMaps objectForKey:key]==nil) {
            [self.datas addObject:key];
            [self.dataMaps setObject:[[NSMutableArray alloc]init] forKey:key];
        }
        NSMutableArray *array = [self.dataMaps objectForKey:key];
        [array addObject:notification];
    }
    [self.view bringSubviewToFront:self.mainGrid];
    [self.mainGrid reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"systemNoteRefresh" object:@""];
}

- (UITableViewCell *)tableView:(UITableView *)tableViewP cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listData = [self rowDataInSectionData:indexPath.section];
    SysNotification *notification = [listData objectAtIndex:indexPath.row];
    NotificationItemCell *notificationItemCell = [tableViewP dequeueReusableCellWithIdentifier:NOTIFICATION_INFO_ITEM forIndexPath:indexPath];
    notificationItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [notificationItemCell initWithData:notification];
    return notificationItemCell;
}

//rows数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self rowNumberInSectionData:section];
}

//每个section的header
- (UIView *)tableView:(UITableView *)tableViewP viewForHeaderInSection:(NSInteger)section
{
    NoteHeaderItem *noteHeaderItem = (NoteHeaderItem *)[tableViewP dequeueReusableHeaderFooterViewWithIdentifier:NOTE_HEADER_ITEM];
    if (noteHeaderItem == nil) {
        noteHeaderItem = [ItemFactory getNoteHeaderItem];
    }
    NSString *key = [self.datas objectAtIndex:section];
    [noteHeaderItem initWithName:key];
    return noteHeaderItem;
}

//section数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.datas count];
}

//每个row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SysNotification *notification = [[self rowDataInSectionData:indexPath.section] objectAtIndex:indexPath.row];
    return [NotificationItemCell calculateItemHeight:notification];
}

//header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return NOTIFICATION_HEAD_HEIGHT;
}

- (NSArray *)rowDataInSectionData:(NSInteger)section
{
    NSString *key = [self.datas objectAtIndex:section];
    if ([NSString isNotBlank:key]) {
        return [self.dataMaps objectForKey:key];
    }
    return nil;
}

- (NSInteger)rowNumberInSectionData:(NSInteger)section
{
    NSString *shopName = [self.datas objectAtIndex:section];
    if ([NSString isNotBlank:shopName]) {
        id object = [self.dataMaps objectForKey:shopName];
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray *notifications = (NSArray *)object;
            if ([ObjectUtil isNotNull:notifications]) {
                return notifications.count;
            }
        } else if ([object isKindOfClass:[NSString class]]) {
            return 1;
        }
    }
    return 0;
}

- (void)onEvent:(NSString *)eventType object:(id)object
{
    if ([REFRESH_SYS_NOTIFICAION isEqualToString:eventType]) {
        [self initDataView];
    }
}

- (void)onEvent:(NSString *)eventType
{
}

@end
