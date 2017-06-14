//
//  BellEditView.h
//  RestApp
//
//  Created by zxh on 14-5-12.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ItemBase.h"
#import "ConfigVO.h"
#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterListEvent.h"

@class KabawModule,SettingService,NavigateTitle2,EditItemRadio,FooterListView;
@class ConfigVO,MBProgressHUD;
@interface BellEditView : UIViewController<INavigateEvent,FooterListEvent>
{
    KabawModule *parent;
    
    SettingService *service;
    
    MBProgressHUD *hud;
}

@property (nonatomic) BOOL changed;
@property (nonatomic, weak) IBOutlet FooterListView *footView;
@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UIView *container;

@property (nonatomic, weak) IBOutlet EditItemRadio *rdoAddReview;
@property (nonatomic, weak) IBOutlet EditItemRadio *rdoUrgencyReview;

@property (nonatomic,strong) ConfigVO* isAddReviewConfig;
@property (nonatomic,strong) ConfigVO* isUrgencyReviewConfig;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)_parent;

-(void) initMainView;

-(void) loadData;

@end
