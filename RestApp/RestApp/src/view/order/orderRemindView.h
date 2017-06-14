//
//  orderRemindView.h
//  RestApp
//
//  Created by iOS香肠 on 16/4/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "NavigateTitle2.h"
#import "orderRemindCell.h"
#import "OrderService.h"
#import "NavigationToJump.h"
#import "TDFRootViewController.h"

#import "TDFRootViewController.h"

@class SmartOrderModel ;
@interface orderRemindView : TDFRootViewController <INavigateEvent,SizetofitKeyboard,UITableViewDataSource,UITableViewDelegate>

{
    SmartOrderModel *model;
    OrderService  *service;
    CGRect keyBoardBounds;
    CGFloat _initialTVHeight;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UITableView *tabview;
@property (nonatomic, strong) NSMutableArray *dataArry;
@property (nonatomic ,strong) NSMutableArray *foodArry;
@property (nonatomic ,strong) NSMutableArray *majorArry;
@property (nonatomic ,strong) NSMutableArray *minorArry;
@property (nonatomic, strong) NSMutableArray *headArry;
@property (nonatomic ,strong) NSMutableDictionary *oldarry;
@property (nonatomic, strong) NSDictionary *dic ;
@property (nonatomic, assign) id <NavigationToJump>delegate;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SmartOrderModel *)controller;
-(void)preData;
@end
