//
//  AboutView.h
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-25.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "IEventListener.h"
#import "INavigateEvent.h"
#import "BusinessService.h"
#import "PopupBoxViewController.h"

@class AppController,NavigateTitle2;
@interface SysNotificationView : PopupBoxViewController<UITableViewDataSource, INavigateEvent, IEventListener>
{
    BusinessService *businessService;
}
@property (nonatomic, strong) IBOutlet UITableView* mainGrid;
@property (nonatomic,strong)  NSMutableArray *datas;
@property (nonatomic,strong)  NSMutableDictionary *dataMaps;

- (void)initDataView;
@end
