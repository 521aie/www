//
//  SelectMenuListView.h
//  RestApp
//
//  Created by zxh on 14-5-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterMultiView.h"
#import "ISampleListEvent.h"
#import "SelectMenuClient.h"
#import "DHListSelectHandle.h"
#import "TDFRootViewController.h"

@class MenuService,MBProgressHUD,NavigateTitle2,SelectMultiMenuListPanel;
@interface SelectMultiMenuListView : TDFRootViewController<INavigateEvent,ISampleListEvent,DHListSelectHandle>
{
    MenuService *service;
    
    MBProgressHUD *hud;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet SelectMultiMenuListPanel *dhListPanel;

@property (nonatomic, strong) NSMutableArray *headList;
@property (nonatomic, strong) NSMutableArray *detailList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) NSMutableDictionary *menuMap;

@property (nonatomic, strong) NSMutableArray *kindMenuList;
@property (nonatomic, strong) NSMutableArray *allNodeList;

@property (nonatomic, strong) NSString* titleStr;
@property (nonatomic, strong) id<SelectMenuClient> delegate;

-(void) loadMenus:(NSMutableArray*)oldArrs delegate:(id<SelectMenuClient>) delegate;

@end
