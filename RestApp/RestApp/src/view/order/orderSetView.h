//
//  orderSetView.h
//  RestApp
//
//  Created by iOS香肠 on 16/3/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartOrderModel.h"
#import "NavigateTitle2.h"
#import "INavigateEvent.h"
#import "OrderService.h"
#import "FooterListView.h"
#import "FooterListEvent.h"
#import "MBProgressHUD.h"
//#import "UIHeadView.h"
#import "NavigationToJump.h"
#import "TDFRootViewController.h"


@interface orderSetView : TDFRootViewController<INavigateEvent,UITableViewDataSource,UITableViewDelegate,FooterListEvent,NavigationToJump>
{
    SmartOrderModel *model;
    OrderService  *service;
    MBProgressHUD *hud;
}
@property (nonatomic, strong) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UITableView *tabView;
@property (nonatomic, strong) NSMutableArray *dataArry;
@property (strong, nonatomic) IBOutlet FooterListView *footview;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SmartOrderModel *)controller;






-(void)preData;

@end
