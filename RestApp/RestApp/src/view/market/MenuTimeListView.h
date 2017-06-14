//
//  MenuTimeListView.h
//  RestApp
//
//  Created by zxh on 14-6-27.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterListView.h"
#import "FooterListEvent.h"
#import "ISampleListEvent.h"
#import "ISampleListEvent.h"
#import "SelectMenuClient.h"
#import "TDFRootViewController.h"

@class NavigateTitle2,MBProgressHUD,MenuTime;
@interface MenuTimeListView : TDFRootViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,INavigateEvent,FooterListEvent,ISampleListEvent,SelectMenuClient>
{
    UIView *tableHeaderView;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet FooterListView *footView;
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格

@property (nonatomic, strong) NSMutableArray *datas;    //原始数据集
@property (nonatomic, strong) NSMutableArray* details;  //详细。
@property (nonatomic, strong) NSMutableDictionary* map;     //字典项.
@property (nonatomic, strong) NSMutableArray *backDatas; //备份数据集
@property (nonatomic, strong) NSMutableArray *headerItems;
@property (nonatomic, strong) MenuTime* currMenuTime;
@property (nonatomic, strong) NSMutableArray *headList;    //商品.
@property (nonatomic, strong) NSMutableArray* allNodeList;
@property (nonatomic, strong) NSMutableArray *detailList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) NSMutableArray *menuIds;

@property (nonatomic) NSInteger action;


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
