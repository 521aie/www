//
//  UnitEditView.h
//  RestApp
//
//  Created by zxh on 14-5-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"
#import "INavigateEvent.h"
#import "TDFRootViewController.h"

@class MenuModule,NavigateTitle,NavigateTitle2,EditItemText,MBProgressHUD,FooterListView;
@class NameItemVO;
@interface SuitUnitEditView : TDFRootViewController<INavigateEvent,FooterListEvent>{
    MenuModule *parent;
    MBProgressHUD *hud;
}

@property (nonatomic, weak) IBOutlet FooterListView *footView;
@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;

@property (nonatomic, weak) IBOutlet UIView *container;

@property (nonatomic, weak) IBOutlet EditItemText *txtName;

@property (nonatomic) BOOL changed;
@property (nonatomic) NameItemVO* unit;
@property (nonatomic) int action;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)_parent;
-(void) loadData:(NameItemVO*) objTemp action:(int)action;

@end
