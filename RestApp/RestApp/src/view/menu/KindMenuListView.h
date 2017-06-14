//
//  KindMenuListView.h
//  RestApp
//
//  Created by zxh on 14-5-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNameValueListView.h"
#import "ISampleListEvent.h"
#import "MenuModule.h"
#import "FooterListEvent.h"
#import "MenuService.h"
#import "NavigationToJump.h"
#import "NameValueCell.h"
#import "DataSingleton.h"
#import "ChainMenuFooterListView.h"

@class MenuModule;
@interface KindMenuListView : BaseNameValueListView<ISampleListEvent,FooterListEvent,NavigationToJump>
{
    MenuModule *parent;
    
    MenuService *service;
    
}
@property (nonatomic, strong) ChainMenuFooterListView *chainFooterView;
@property (nonatomic, strong) NSMutableArray *kindList;
@property (nonatomic, strong) NSMutableArray *treeNodes;
@property (nonatomic, assign) NSInteger backViewTag;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic,copy) void (^kindMenulistCallBack)(BOOL orRefresh);
@property (nonatomic, assign) NSInteger backIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp;
- (void) initIndexWithIndex:(NSInteger)index AndCallBack:(void (^)(BOOL ))kindMenulistCallBack;
- (void)initBackView:(NSInteger)backViewTag;
- (void)loadKindMenuData;

@end
