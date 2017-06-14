//
//  FeePlanEditViewViewController.h
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFRootViewController.h"
#import "INavigateEvent.h"
#import "ItemBase.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "IEditMultiListEvent.h"
#import "OptionPickerClient.h"
#import "MultiCheckHandle.h"
#import "TimePickerClient.h"
#import "DatePickerClient.h"
#import "NumberInputClient.h"

typedef void(^FeePlanEditViewViewCallBack) ();
@class SettingService,NavigateTitle2,ItemEndNote,EditItemList,EditItemText,EditItemRadio,ItemTitle,EditMultiList;
@class FeePlan,AreaFeePlan;
@interface FeePlanEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,IEditMultiListEvent,IEditItemRadioEvent,TimePickerClient,DatePickerClient,OptionPickerClient,NumberInputClient,UIActionSheetDelegate>{
    SettingService *service;
}

@property (nonatomic,copy)FeePlanEditViewViewCallBack callBack;
@property (nonatomic) BOOL changed;
@property (nonatomic, retain)  UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic, strong)  UIView *container;

@property (nonatomic, strong)  ItemTitle *baseTitle;
@property (nonatomic, strong)  EditItemText *txtName;
@property (nonatomic, strong)  EditMultiList *mlsArea;

@property (nonatomic, strong)  ItemTitle *titleFee;
@property (nonatomic, strong)  EditItemRadio *rdoIsServiceFee;
@property (nonatomic, strong)  EditItemList *lsServiceFeeMode;
@property (nonatomic, strong)  EditItemList *lsServiceFee;
@property (nonatomic, strong)  EditItemText *txtMinute;

@property (nonatomic, strong)  EditItemRadio *rdoIsMinFee;
@property (nonatomic, strong)  EditItemList *lsMinFeeMode;
@property (nonatomic, strong)  EditItemList *lsMinFee;

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

@property (nonatomic) FeePlan* feePlan;
@property (nonatomic) NSMutableArray* areas;
@property (nonatomic) NSMutableArray* areaFeePlans;
@property (nonatomic) int action;

@end
