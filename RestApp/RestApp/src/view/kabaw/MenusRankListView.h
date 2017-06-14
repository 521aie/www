//
//  MenusRankListView.h
//  RestApp
//
//  Created by xueyu on 16/1/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "FooterMultiView.h"
#import "TDFRootViewController.h"
typedef void(^CallBackBlock) (id data);
@class KabawModule,KabawService,MBProgressHUD;
@interface MenusRankListView : TDFRootViewController<INavigateEvent,FooterMultiEvent,UITableViewDataSource,UITableViewDelegate>
{
//    KabawModule *parent;
    KabawService *service;
//    MBProgressHUD *hud;
    BOOL isRefreshed;
    
}
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *menus;
@property (nonatomic, strong)NSMutableArray *menuIds;

@property (nonatomic, copy)CallBackBlock callBack;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)parentTemp;

-(void)initData;
@end
