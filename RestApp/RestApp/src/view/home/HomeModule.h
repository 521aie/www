//
//  HomeModule.h
//  RestApp
//
//  Created by Shaojianqing on 15/9/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MainModule.h"
#import <UIKit/UIKit.h>
#import "UIMenuAction.h"

@class HomeView, EntryView;
@interface HomeModule : UIViewController
{
    MainModule *mainModule;
}
@property (nonatomic, strong) UINavigationController *rootController;
@property (nonatomic, strong) HomeView *homeView;
@property (nonatomic, strong) EntryView *entryView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent;

+ (HomeModule *)sharedInstance;

- (void)initHomeDataView;

- (void)initEntryDataView;

- (void)showChainDetailView;

- (void)showHomeView;

- (void)showEntryView;

- (void)showOrderDetail;

- (void)showOrderList;


- (void)showBranchBusinessDayDetail;

- (void)selectModule:(UIMenuAction *)menu;

- (void)forwardToModule:(NSString *)code;


@end

