//
//  OrderListView.h
//  RestApp
//
//  Created by iOS香肠 on 16/3/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartOrderModel.h"
#import "NavigateTitle2.h"
#import "INavigateEvent.h"
#import "FooterListView.h"
#import "TDFRootViewController.h"


@interface OrderListView : TDFRootViewController<INavigateEvent,UITableViewDataSource,UITableViewDelegate,FooterListEvent>

{
    SmartOrderModel *model;
}

@property (weak, nonatomic) IBOutlet UIView *titleDiv;

@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (nonatomic ,strong) NSMutableArray *arry;
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (strong, nonatomic) IBOutlet UILabel *detailLbl;
@property (strong, nonatomic) IBOutlet FooterListView *footview;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SmartOrderModel *)controller;
- (IBAction)OnClickConfire:(id)sender;
- (void)reloadData;

@end
