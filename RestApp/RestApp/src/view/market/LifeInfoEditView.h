//
//  LifeInfoEditView.h
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ItemTitle.h"
#import "EditItemInfo.h"
#import "EditItemView.h"
#import "EditItemList.h"
#import <UIKit/UIKit.h>
#import "EditItemText.h"
#import "EditItemList.h"
#import "Notification.h"
#import "EditItemRadio.h"
#import "SystemService.h"
#import "MBProgressHUD.h"
#import "EditItemImage.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "INavigateEvent.h"
#import "CalendarClient.h"
#import "MemoInputClient.h"
#import "LifeInfoService.h"
#import "ISampleListEvent.h"
#import "DatePickerClient.h"
#import "MessageBoxClient.h"
#import "NumberInputClient.h"
#import "IEditItemMemoEvent.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "OptionPickerClient.h"
typedef void (^Callback)();
@class MarketModule;
@interface LifeInfoEditView : TDFRootViewController<INavigateEvent,FooterListEvent,IEditItemListEvent,ISampleListEvent,IEditItemRadioEvent,MessageBoxClient,IEditItemImageEvent,OptionPickerClient,UINavigationControllerDelegate, UIImagePickerControllerDelegate,IEditItemMemoEvent,MemoInputClient>
{
    MarketModule *parent;
    
    SystemService *systemService;
    
    LifeInfoService *service;
    
    MBProgressHUD *hud;
    
    Notification *notificationData;
    
    NSString *imgFilePathTemp;
    
    UIImage *notificationImage;
    
    UIImagePickerController *imagePickerController;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet EditItemInfo *infoTitle;
@property (nonatomic, strong) IBOutlet EditItemText *txtTitle;
@property (nonatomic, strong) IBOutlet EditItemList *lsKindCard;
@property (nonatomic, strong) IBOutlet EditItemMemo *txtContent;
@property (nonatomic, strong) IBOutlet EditItemImage *imgUpload;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic) NSInteger action;
@property (nonatomic, copy) Callback callback;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MarketModule *)parentTemp;


@end
