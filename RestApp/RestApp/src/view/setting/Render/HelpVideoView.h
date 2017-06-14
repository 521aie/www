//
//  HelpVideoView.h
//  RestApp
//
//  Created by 果汁 on 15/7/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "TDFRootViewController.h"
@class SettingModule,SettingService,MBProgressHUD,NavigateTitle2;

@interface HelpVideoView : TDFRootViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,INavigateEvent>
{
    SettingModule *parent;
    SettingService *service;
    MBProgressHUD *hud;
}
@property (nonatomic) BOOL changed;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,strong) NSMutableArray *arrSection;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic,strong) NSArray *videoArr;
@property (nonatomic,unsafe_unretained) BOOL isPlay;
@property (nonatomic,copy) NSString *str;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SettingModule *)_parent;



@end
