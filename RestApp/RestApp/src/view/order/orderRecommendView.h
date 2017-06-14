//
//  orderRecommendViewViewController.h
//  RestApp
//
//  Created by iOS香肠 on 16/4/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "EditItemRadio.h"
#import "INavigateEvent.h"
#import "FooterListView.h"
#import "OrderService.h"
#import "EditItemList.h"
#import "MBProgressHUD.h"
#import "FuctionViewCell.h"
#import "TDFRootViewController.h"
#import "NavigationToJump.h"

typedef NS_ENUM(NSInteger,TDFSaveType) {
           TDFSaveWithPush , //保存并跳转页面
           TDFOnlySave , //仅做保存
};

@class SmartOrderModel;
@interface orderRecommendView : TDFRootViewController<INavigateEvent,IEditItemRadioEvent,FooterListEvent,UITableViewDataSource,UITableViewDelegate,FuctionViewCellDelegate,NavigationToJump>
{
    SmartOrderModel *model;
    
    OrderService *service ;
 
     UIView * tableHeaderView;

}

@property (strong, nonatomic) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UITableView *tabView;
@property (strong, nonatomic)  EditItemRadio *recommendView;
@property (strong, nonatomic) IBOutlet FooterListView *footview;
@property (strong, nonatomic) IBOutlet UILabel *detailLbl;
@property (nonatomic, assign) BOOL isChange;

@property (nonatomic ,strong) NSString *isturnon;
@property (nonatomic, assign) NSInteger istype;
@property (nonatomic, assign)  NSInteger isPush;
@property (nonatomic, strong) NSMutableArray *dataArry;

- (void)preData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SmartOrderModel *)controller;
@end
