//
//  QueuKindListView.h
//  RestApp
//
//  Created by YouQ-MAC on 15/1/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KabawService.h"
#import "SpecialTagVO.h"
#import "MBProgressHUD.h"
#import "FooterListView.h"
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "SpecialTagModule.h"
#import "ISampleListEvent.h"
#import "NavigationToJump.h"
#import "TDFRootViewController.h"

@class KabawModule;
@class NavigateTitle2;
@interface SpecialTagListView : TDFRootViewController<INavigateEvent,UITableViewDataSource,UITableViewDelegate,ISampleListEvent,FooterListEvent,NavigationToJump>
{
    SpecialTagModule *parent;
    
    KabawService *service;
    
    NSString *moduleName;
}

@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;         //列表组件
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, assign) NSInteger action;
@property (nonatomic, strong) NSString *hdtitle;
@property (nonatomic, strong) SpecialTagVO *specialTag;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic) int backView;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, assign) id <NavigationToJump> delegate;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SpecialTagModule *)parentTemp moduleName:(NSString *)moduleNameTemp;

-(void) initWithData:(NSArray *)dataList backView:(int)backView;

-(void) initWithData:(NSArray *)dataList;

-(void)initWithIdStr:(NSString *)str action:(NSInteger)action  title:(NSString *)title;

@end
