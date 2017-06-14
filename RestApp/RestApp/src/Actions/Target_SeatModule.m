//
//  Target_SeatModule.m
//  RestApp
//
//  Created by zishu on 16/9/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_SeatModule.h"
#import "SeatListView.h"
#import "SeatEditView.h"
#import "AreaListView.h"
#import "AreaEditView.h"
#import "SystemUtil.h"

@implementation Target_SeatModule

///桌位列表 .
-(UIViewController *)Action_nativeSeatListView:(NSDictionary *)params
{
    SeatListView *seatListView=[[SeatListView alloc] initWithNibName:@"SeatListView" bundle:nil];
    
    return seatListView;
}

///桌位编辑
- (UIViewController *)Action_nativeSeatEditView:(NSDictionary *)params{
    SeatEditView *seatEditView = [[SeatEditView alloc]initWithNibName:@"SeatEditView" bundle:nil];
    seatEditView.callBack = params[@"callBack"];
    seatEditView.seat = params[@"data"];
    seatEditView.action = [params[@"status"] intValue];
    seatEditView.areaList = params[@"headList"];
    return seatEditView;
}

///区域列表 .
-(UIViewController *)Action_nativeAreaListView:(NSDictionary *)params
{
    AreaListView *areaListView=[[AreaListView alloc] initWithNibName:@"SampleListView" bundle:nil];
    
    areaListView.callBack = params[@"callBack"];
    return areaListView;
}

///区域编辑
- (UIViewController *)Action_nativeAreaEditView:(NSDictionary *)params{
    AreaEditView *areaEditView = [[AreaEditView alloc]initWithNibName:@"AreaEditView" bundle:nil];
    areaEditView.callBack = params[@"callBack"];
    areaEditView.area = params[@"data"];
    areaEditView.action = [params[@"status"] intValue];

    return areaEditView;
}

@end
