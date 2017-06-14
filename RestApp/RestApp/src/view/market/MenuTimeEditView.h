//
//  MenuTimeEditView.h
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "ItemBase.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "IEditMultiListEvent.h"
#import "MultiCheckHandle.h"
#import "TimePickerClient.h"
#import "DatePickerClient.h"
#import "FooterListEvent.h"
#import "OptionPickerClient.h"
#import "NumberInputClient.h"
#import "TDFRootViewController.h"

typedef void(^MenuTimeEditViewCallBack) ();

@class MenuTimeService,NavigateTitle2,ItemEndNote,EditItemList,EditItemText,EditItemRadio,ItemTitle,EditMultiList,EditItemView;
@class MenuTime,FooterListView,EditItemInfo;
@interface MenuTimeEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,IEditMultiListEvent,MultiCheckHandle,IEditItemRadioEvent,TimePickerClient,DatePickerClient,UIActionSheetDelegate,FooterListEvent,OptionPickerClient,NumberInputClient>
{
    MenuTimeService *service;
}
@property (nonatomic,copy)MenuTimeEditViewCallBack callBack;
@property (nonatomic, strong)  FooterListView *footView;
@property (nonatomic, strong)  UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic, strong)  UIView *container;
@property (nonatomic, strong)  ItemTitle *baseTitle;
@property (nonatomic, strong)  EditItemText *txtName;
@property (nonatomic, strong)  EditItemList *lsPerferential;//优惠方式
@property (nonatomic, strong)  EditItemView *lblPerferentialName; // 优惠方式编辑模式下
@property (nonatomic, strong)  EditItemList *lsDiscount; //折扣率
@property (nonatomic, strong)  EditItemRadio *rdoIsRatio; //是否打折
@property (nonatomic, strong)  ItemTitle *titleValid;
@property (nonatomic, strong)  EditItemRadio *rdoIsDate;
@property (nonatomic, strong)  EditItemList *lsStartDate;
@property (nonatomic, strong)  EditItemList *lsEndDate;
@property (nonatomic, strong)  EditItemRadio *rdoIsTime;
@property (nonatomic, strong)  EditItemList *lsStartTime;
@property (nonatomic, strong)  EditItemList *lsEndTime;
@property (nonatomic, strong)  EditItemRadio *rdoIsWeek;
@property (nonatomic, strong)  EditMultiList *mlsWeek;
@property (nonatomic, strong)  UIButton *btnDel;
@property (nonatomic, strong) MenuTime* menuTime;
@property (nonatomic, assign) NSInteger action;
@property (nonatomic, assign) BOOL changed;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (IBAction)btnDelClick:(id)sender;

@end
