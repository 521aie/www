//
//  CancelQueuView.h
//  RestApp
//
//  Created by YouQ-MAC on 15/1/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "TDFRootViewController.h"
@class SettingService,MBProgressHUD,FooterListView;
@class NavigateTitle2;
@interface CancelQueuView : TDFRootViewController<INavigateEvent,UIActionSheetDelegate,FooterListEvent>
{
    SettingService *service;
}

@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;
@property (nonatomic,weak) IBOutlet UITextView* lblWarn;

@property (nonatomic, weak) IBOutlet UIButton *btnCancel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (IBAction)btnClearClick:(id)sender;
-(void)loadDatas;
@end
