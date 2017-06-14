//
//  ShopSalesRankView.h
//  RestApp
//
//  Created by xueyu on 16/1/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertBox.h"
#import "EditItemList.h"
#import "MBProgressHUD.h"
#import "NavigateTitle2.h"
#import "OptionPickerClient.h"
#import "TDFRootViewController.h"
@class KabawModule,KabawService,MBProgressHUD;
@interface ShopSalesRankView : TDFRootViewController<INavigateEvent,IEditItemListEvent,OptionPickerClient,UITableViewDataSource,UITableViewDelegate>
{
    KabawModule *parent;
    KabawService *service;
     BOOL isRefreshed;
    
}
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet EditItemList *lsRankType;
@property (weak, nonatomic) IBOutlet EditItemList *lsMenuCount;
@property (weak, nonatomic) IBOutlet UILabel *note;
@property (weak, nonatomic) IBOutlet UIView *noteView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *titleDetail;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *noDataTip;
@property (weak, nonatomic) IBOutlet UILabel *tipContent;
@property (nonatomic,assign) int status;

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *menus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)parentTemp;
-(void)loadDatas;

@end
