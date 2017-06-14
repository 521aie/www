//
//  CancelBindView.h
//  RestApp
//
//  Created by zxh on 14-4-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "INavigateEvent.h"
#import "FooterListEvent.h"

@class SettingModule,SettingService,MBProgressHUD,FooterListView;
@class NavigateTitle2;
@interface CancelBindView : UIViewController<INavigateEvent,UIActionSheetDelegate,FooterListEvent>{
    SettingModule *parent;
    SettingService *service;
    MBProgressHUD *hud;
}

@property (nonatomic, weak) IBOutlet FooterListView *footView;
@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;
@property (nonatomic,weak) IBOutlet UITextView* lblWarn;

@property (nonatomic, weak) IBOutlet UIButton *btnCancel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SettingModule *)_parent;

- (IBAction)btnClearClick:(id)sender;
-(void)loadDatas;
@end
