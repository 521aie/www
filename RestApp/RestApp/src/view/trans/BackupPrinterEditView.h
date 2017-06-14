//
//  BackupPrinterEditView.h
//  RestApp
//
//  Created by SHAOJIANQING-MAC on 14-11-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "NumberInputClient.h"
#import "IEditItemListEvent.h"
#import "IEditMultiListEvent.h"
#import "TDFRootViewController.h"
@class TransService,FooterListView,MBProgressHUD;
@class NavigateTitle2,EditItemList,BackupPrinter;
@interface BackupPrinterEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,NumberInputClient,UIActionSheetDelegate,FooterListEvent>
{
    TransService *service;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet EditItemList *lsOriginIp;
@property (nonatomic, strong) IBOutlet EditItemList *lsBackupIp;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;
@property (nonatomic, strong) BackupPrinter* backupPrinter;
@property (nonatomic) NSInteger action;
@property (nonatomic) BOOL changed;
@property (nonatomic, copy)void(^callBack)(void);

- (void)loadData:(BackupPrinter *) tempVO action:(NSInteger)action;

- (IBAction)btnDelClick:(id)sender;

@end
