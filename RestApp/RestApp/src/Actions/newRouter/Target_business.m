//
//  Target_business.m
//  RestApp
//
//  Created by happyo on 2017/4/22.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_business.h"
#import "TDFBusinessFlowViewController.h"
#import "TDFSubShopCompareController.h"
#import "ChainBusinessDetailView.h"

@implementation Target_business

- (UIViewController *)Action_dayReportFlow:(NSDictionary *)params
{
    TDFBusinessFlowViewController *vc = [[TDFBusinessFlowViewController alloc] init];
    
    vc.dateString = params[@"date"];
    
    return vc;
}

- (UIViewController *)Action_shopTurnoverComparison:(NSDictionary *)params
{
    TDFSubShopCompareController *vc = [[TDFSubShopCompareController alloc] init];
    
    vc.typeStr = params[@"type"];
    vc.dateStr = params[@"date"];
    
    return vc;
}

- (UIViewController *)Action_summary:(NSString *)params
{
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    
    comps.day = -1;
    
    NSDate *newDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay fromDate:newDate];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    ChainBusinessDetailView *chainBusinessDetailView = [[ChainBusinessDetailView alloc]initWithNibName:@"ChainBusinessDetailView" bundle:nil];
    chainBusinessDetailView.currYear = year;
    chainBusinessDetailView.currMonth = month;
    chainBusinessDetailView.currDay = day;
    chainBusinessDetailView.needHideOldNavigationBar = NO;
    
    return chainBusinessDetailView;
}

@end
