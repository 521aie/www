//
//  MenuAreaPrinterEditView.h
//  RestApp
//
//  Created by xueyu on 16/2/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMTable.h"
#import "ItemTitle.h"
#import "AsyncSocket.h"
#import "EditItemList.h"
#import "MBProgressHUD.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "MultiCheckHandle.h"
#import "ISampleListEvent.h"
#import "NumberInputClient.h"
#import "TDFRootViewController.h"

@class TransService,AreaPantry;
@interface MenuAreaPrinterEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,ISampleListEvent,NumberInputClient,MultiCheckHandle,AsyncSocketDelegate>

{

    TransService *transService;
    MBProgressHUD *hud;
    AsyncSocket *clientSocket;
}
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) ItemTitle *settingTitle;
@property (strong, nonatomic) UIView *delBtnView;
@property (strong, nonatomic) EditItemList *lsIP;
@property (strong, nonatomic) EditItemList *lsWidth;
@property (strong, nonatomic) EditItemList *lsCharCount;
@property (strong, nonatomic) ItemTitle *titleArea;
@property (strong, nonatomic) ZMTable *areaGrid;

@property (strong, nonatomic) UITextView *lblTip;
@property (nonatomic, assign) NSInteger action;
@property (nonatomic,assign) BOOL isContinue;
@property (nonatomic, strong) NSString* continueEvent;

@property (nonatomic, strong) NSMutableArray* pantryPlanAreas;
@property (nonatomic, strong) NSMutableArray *areas;
@property (nonatomic, strong) AreaPantry *areaPantry;
@property (nonatomic, copy)void(^callBack)(void);

- (void)loadData:(AreaPantry*) tempVO action:(int)action isContinue:(BOOL)isContinue;
@end




