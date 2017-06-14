//
//  ReserveSeatListView.m
//  RestApp
//
//  Created by zxh on 14-5-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFMediator+KabawModule.h"
#import "ReserveSeatListView.h"
#import "KabawModule.h"
#import "ServiceFactory.h"
#import "KabawService.h"
#import "RemoteResult.h"
#import "XHAnimalUtil.h"
#import "DataSingleton.h"
#import "RemoteEvent.h"
#import "ReserveSeat.h"
#import "HelpDialog.h"
#import "UIView+Sizes.h"
#import "UIHelper.h"
#import "NameValueCell.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "TDFRootViewController+FooterButton.h"
@implementation ReserveSeatListView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNotification];
    [self initDelegate:self event:@"reserveseat" title:NSLocalizedString(@"可预订桌位", nil) foots:nil];
    [self.footView removeFromSuperview];
    self.title = NSLocalizedString(@"可预订桌位", nil);
    self.datas = self.params[@"data"];
    self.times = self.params[@"time"];
    [self loadSeatDatas:self.datas];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd];
}

#pragma 数据加载
-(void)loadDatas
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[ServiceFactory Instance].kabawService listReserveSeatTarget:self Callback:@selector(loadFinish:)];
}

-(void)loadSeatDatas:(NSMutableArray*)datas
{
//    self.datas=datas;
    [self.mainGrid reloadData];
}
- (void)loadtimes:(NSMutableArray *)timeArr;
{
    self.times=timeArr;
   
}
#pragma 实现协议 ISampleListEvent
-(void) closeListEvent:(NSString*)event
{
    
}

-(void) footerAddButtonAction:(UIButton *)sender
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_reserveSeatEditViewControllerWithData:nil times:self.times action:ACTION_CONSTANTS_ADD CallBack:^{
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) delEvent:(NSString*)event ids:(NSMutableArray *) ids
{
//    [service removeReserveSeats:ids event:REMOTE_RESERVESEAT_DEL];
    [[ServiceFactory Instance].kabawService removeReserveSeats:ids Target:self Callback:@selector(delFinish:)];
}

-(void) batchDelEvent:(NSString*)event ids:(NSMutableArray*)ids
{
//    [service removeReserveSeats:ids event:REMOTE_RESERVESEAT_DELALL];
    [[ServiceFactory Instance].kabawService removeReserveSeats:ids Target:self Callback:@selector(delBatchFinish:)];
}

-(void) sortEvent:(NSString*)event ids:(NSMutableArray*)ids
{
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"reserveset"];
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    ReserveSeat *editObj=(ReserveSeat *)obj;
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_reserveSeatEditViewControllerWithData:editObj times:self.times action:ACTION_CONSTANTS_EDIT CallBack:^{
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 消息处理部分.
-(void) initNotification
{
   
}

-(void) loadFinish:(RemoteResult*)result
{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        [self finishSort];
        return;
    }
    [self remoteLoadData:result.content];
}

-(void) delBatchFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        [self finishSort];
        return;
    }
    [self remoteLoadData:result.content];
    [self finishSort];
}

-(void) delFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
//        [self hideHud];
        [self.progressHud hide:YES];
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadData:result.content];
}

-(void) remoteLoadData:(NSString *) responseStr
{
    NSDictionary* map=[JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"reserveSeats"];
    self.datas=[JsonHelper transList:list objName:@"ReserveSeat"];
    [self reload:self.datas error:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_RESERVESEAT_REFRESH object:self.datas] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
        NameValueCell * cell = [tableView dequeueReusableCellWithIdentifier:NameValueCellIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell" owner:self options:nil].lastObject;
        }
        id<INameValueItem> item=(id<INameValueItem>)[self.datas objectAtIndex: indexPath.row];
        cell.lblName.text= [item obtainItemName];
        [cell.lblName setWidth:220];
        cell.lblVal.hidden=tableView.editing;
        cell.img.hidden=tableView.editing;
        cell.lblVal.text=[item obtainItemValue];
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    } else {
        self.mainGrid.editing=NO;
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:YES andLoadOverString:@"" andLoadingString:NSLocalizedString(@"正在加载..", nil) andIsLoading:NO];
    }
}

@end
