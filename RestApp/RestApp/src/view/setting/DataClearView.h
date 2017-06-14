//
//  DataClearView.h
//  RestApp
//
//  Created by zxh on 14-4-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "FooterListEvent.h"
#import "TDFOptionPickerController.h"
#import "TDFRootViewController.h"

@class TDFIntroductionHeaderView;

@class SettingService,MBProgressHUD,MenuService;

@class EditItemList,EditItemView,EditItemText,EditItemRadio,NavigateTitle2,FooterListView,EditItemSignList;
@interface DataClearView : TDFRootViewController<INavigateEvent,IEditItemListEvent,UIActionSheetDelegate,FooterListEvent>
{
    
    SettingService *service;
    
    int _count;
    
    NSString *str;
}
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) EditItemList *kindSelectTime;
@property (nonatomic, strong) EditItemList *kindSelectDate;
@property (nonatomic, strong) EditItemList *lsStartDate;
@property (nonatomic, strong) EditItemList *lsEndDate;
@property (nonatomic, strong) UIButton *btnClear;
@property (strong, nonatomic) UILabel *warningTip;
@property (nonatomic, strong) TDFIntroductionHeaderView *headerView;
@property (nonatomic, strong) UIView *btnClearView;

@property (nonatomic, assign) BOOL isAlert;


-(void) loadData;

- (IBAction)btnClear:(id)sender;

@end
