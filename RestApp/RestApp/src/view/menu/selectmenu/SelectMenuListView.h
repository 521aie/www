//
//  SelectMenuListView.h
//  RestApp
//
//  Created by zxh on 14-5-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "ISampleListEvent.h"
#import "DHListSelectHandle.h"
#import "SelectMenuClient.h"
#import "TDFRootViewController.h"

@class MenuService,NavigateTitle2,SelectMenuListPanel;
@interface SelectMenuListView : TDFRootViewController<INavigateEvent,ISampleListEvent,DHListSelectHandle>{
    MenuService *service;
}

@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet SelectMenuListPanel *dhListPanel;

@property (nonatomic,retain) NSMutableArray *headList;
@property (nonatomic,retain) NSMutableArray *detailList;
@property (nonatomic,retain) NSMutableDictionary *detailMap;
@property (nonatomic,retain) NSMutableDictionary *menuMap;

@property (nonatomic,retain) NSMutableArray *kindMenuList;
@property (nonatomic,retain) NSMutableArray *allNodeList;

@property (nonatomic,strong) NSString* titleStr;
@property (nonatomic,strong) id<SelectMenuClient> delegate;
@property (nonatomic,strong) NSDictionary *sourceDic;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void)loadData:(NSMutableArray*)headList nodes:(NSMutableArray*)nodes datas:(NSMutableArray*)datas dic:(NSMutableDictionary*)dic delegate:(id<SelectMenuClient>) delegate;

@end
