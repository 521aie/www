//
//  SettingSecondView.h
//  RestApp
//
//  Created by zxh on 14-7-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "ISampleListEvent.h"
#import "SelectMenuHandle.h"
#import "MenuSelectHandle.h"

#define DH_IMAGE_CELL_ITEM_HEIGHT 88
#define DH_HEAD_HEIGHT 40

#define BASE_SETTING @"BASE_SETTING"
#define CASH_SETTING @"CASH_SETTING"
#define EXTRA_SETTING @"EXTRA_SETTING"

@class NavigateTitle2, SettingModule, MBProgressHUD;
@interface SettingSecondView : UIViewController<INavigateEvent, ISampleListEvent, SelectMenuHandle, UITableViewDataSource, UITableViewDelegate>
{
    SettingModule *parent;
    
    MBProgressHUD *hud;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2*titleBox;
@property (nonatomic, strong) id<MenuSelectHandle> delegate;      //标题容器
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;
@property (nonatomic, strong) NSMutableArray *headList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SettingModule *)parentTemp;

- (void)refreshDataView;

@end


