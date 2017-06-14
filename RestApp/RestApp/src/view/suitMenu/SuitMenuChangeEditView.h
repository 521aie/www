//
//  SuitMenuChangeEditView.h
//  RestApp
//
//  Created by zxh on 14-8-27.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "NumberInputClient.h"
#import "TDFRootViewController.h"

@class MenuModule,MBProgressHUD;
@class NavigateTitle2,EditItemView,EditItemList,ItemEndNote;
@class SuitMenuDetail,SampleMenuVO;
@interface SuitMenuChangeEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,OptionPickerClient,NumberInputClient>
{
    MenuModule *parent;
    MBProgressHUD *hud;
}

@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *container;


@property (nonatomic, retain) IBOutlet EditItemView *lblKind;
@property (nonatomic, retain) IBOutlet EditItemView *lblName;
@property (nonatomic, retain) IBOutlet EditItemList *lsSpec;
@property (nonatomic, retain) IBOutlet EditItemList *lsPrice;
@property (nonatomic, retain) IBOutlet EditItemList *lsNum;
@property (nonatomic, strong) EditItemList *forceNum;
@property (nonatomic, retain) IBOutlet ItemEndNote *txtNote;

@property (nonatomic, retain) SuitMenuDetail* suitDetail;
@property (nonatomic, retain) SampleMenuVO* menu;
@property (nonatomic, retain) NSMutableArray* specs;

@property (nonatomic) BOOL changed;
@property (nonatomic) int action;
@property (nonatomic ,strong) NSDictionary *sourceDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)_parent;
- (void)loadData:(SuitMenuDetail*)detail menu:(SampleMenuVO*)menu;

@end
