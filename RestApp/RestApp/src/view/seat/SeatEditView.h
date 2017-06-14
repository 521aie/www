//
//  SeatEditView.h
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "FooterListEvent.h"
#import "TDFRootViewController.h"
#import "Seat.h"
typedef void(^SeatEditViewCallBack) ();
@class  SeatItemQr;
@class NavigateTitle2, EditItemList, EditItemText, FooterListView;
@interface SeatEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,OptionPickerClient,FooterListEvent,UIActionSheetDelegate>
@property (nonatomic,copy)SeatEditViewCallBack callBack;
@property (nonatomic, strong) IBOutlet FooterListView *footView;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

@property (nonatomic, strong) IBOutlet EditItemList *lsArea;
@property (nonatomic, strong) IBOutlet EditItemText *txtName;
@property (nonatomic, strong) IBOutlet EditItemText *txtCode;
@property (nonatomic, strong) IBOutlet EditItemList *lsKind;
@property (nonatomic, strong) IBOutlet SeatItemQr *imgQr;
@property (nonatomic, strong) IBOutlet EditItemText *txtAdviseNum;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;

@property (nonatomic, strong) NSMutableArray *areaList;
@property (nonatomic, strong) Seat *seat;

@property (nonatomic, assign) BOOL changed;
@property (nonatomic, assign) NSInteger action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
