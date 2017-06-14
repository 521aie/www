//
//  TakeOutSetView.h
//  RestApp
//
//  Created by zxh on 14-5-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "IEditMultiListEvent.h"
#import "IEditItemRadioEvent.h"
#import "NumberInputClient.h"
#import "OptionPickerClient.h"
#import "QRCodeGenerator.h"

#define WEIXIN_FRIEND 1
#define WEIXIN_MOMENT 2

@class NavigateTitle2,EditItemList,EditItemText,EditItemRadio,EditMultiList;
@class KabawModule,KabawService,MBProgressHUD;
@class TDFTakeOutSettings,TDFRootViewController,TDFTakeoutSettingsVo;
typedef void(^TakeOutSetEditViewCallBack)(int kind);
@interface TakeOutSetEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,NumberInputClient,IEditMultiListEvent,IEditItemRadioEvent,OptionPickerClient,NumberInputClient>{
    KabawService *service;
    NSUInteger currentBtnIndex;
}


@property (nonatomic,strong) UINavigationController *rootController;

@property (nonatomic, retain)  UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic, strong)  UIView *container;
@property (nonatomic,copy)TakeOutSetEditViewCallBack callBack;
@property (nonatomic, strong)  EditItemRadio *rdoIsSale;
@property (nonatomic, strong)  EditItemList *lsOutFeeMode;
@property (nonatomic, strong)  EditItemList *lsFee;
@property (nonatomic, strong)  EditItemList *txtArea;
@property (nonatomic, strong)  EditItemText *txtNewArea;
@property (nonatomic, strong)  EditItemRadio *whetherSupportCustomerAuto;
@property (nonatomic, strong)  EditItemList *outStartAmount;
@property (nonatomic, strong)  EditItemText *txtMinute;
@property (nonatomic, strong)  EditItemText *advanceAutoOrder;
@property (nonatomic, strong)  EditItemRadio *whetherAppointment;
@property (nonatomic, strong)  EditMultiList *mlsSender;
@property (nonatomic, strong)  EditMultiList *mlsTime;
@property (nonatomic, strong)  UITextView *lblHelp;
@property (nonatomic, strong)  UIImageView *setQRCodeImageView;
@property (nonatomic, strong)  UIView *summaryInfoView;
@property (nonatomic, strong)  UIView *sendInfoView;
@property (nonatomic) BOOL changed;
@property (nonatomic) TDFTakeOutSettings* takeOutSet;
@property(nonatomic) TDFTakeoutSettingsVo *settingVo;
@property (nonatomic) NSMutableArray* times;
@property (nonatomic) NSMutableArray* senders;
@property (nonatomic) int action;
@property (nonatomic  ,strong) UIControl  *contol;

@property (nonatomic, strong) UIImage *qrImg;

-(void) loadDatas;

@end
