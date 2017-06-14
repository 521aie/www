//
//  PrinterParasEditView.h
//  RestApp
//
//  Created by zxh on 14-4-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ConfigVO.h"
#import "ShopDetail.h"
#import "TDFRootViewController.h"
#import "INavigateEvent.h"
#import "MemoInputClient.h"
#import "NumberInputClient.h"
#import "IEditItemListEvent.h"
#import "IEditItemMemoEvent.h"
#import "OptionPickerClient.h"
#import "IEditItemImageEvent.h"
#import "IEditItemRadioEvent.h"
#import <MobileCoreServices/MobileCoreServices.h>

@class SettingService,MBProgressHUD,SystemService;
@class NavigateTitle2,EditItemRadio,EditItemList,EditItemMemo,EditItemText,EditItemImage,ItemTitle;
@interface PrinterParasEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,IEditItemMemoEvent,OptionPickerClient,MemoInputClient,UIActionSheetDelegate,IEditItemRadioEvent,UINavigationControllerDelegate, UIImagePickerControllerDelegate,NumberInputClient,IEditItemImageEvent>
{
    UIImage *shopImage;
    
    SettingService *service;
    
    SystemService *systemService;
    
    UIImagePickerController *imagePickerController;
}

@property (nonatomic, strong)  UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic, strong)  UIView *container;

@property (nonatomic, strong)  ItemTitle *baseTitle;
@property (nonatomic, strong)  EditItemList *lsPrinterSort;
@property (nonatomic, strong)  EditItemRadio *rdoIsPrintBell;
@property (nonatomic, strong)  EditItemMemo *txtShopMemo;
@property (nonatomic, strong)  EditItemImage *imgLogo;

@property (nonatomic, strong)  EditItemList *taxRateView;
@property (nonatomic, strong)  EditItemList *currencyUnitView;

@property (nonatomic, strong)  EditItemList *numsOfVip;
@property (nonatomic, strong)  ItemTitle *titleOtherSet;
@property (nonatomic, strong)  EditItemRadio *rdoIsPrintConsume;
@property (nonatomic, strong)  EditItemList *lsConsumePrintIp;
@property (nonatomic, strong)  EditItemList *lsConsumeWordCount;

@property (nonatomic, strong)  EditItemRadio *rdoIsPrintDraw;
@property (nonatomic, strong)  EditItemList *lsDrawPrintIp;
@property (nonatomic, strong)  EditItemList *lsDrawWordCount;

@property (nonatomic, strong)  EditItemRadio *rdoAccountBill;
@property (nonatomic, strong)  EditItemRadio *rdoFinanceCashDrawer;
@property (nonatomic, strong)  EditItemRadio *rdoAccountCashDrawer;

@property (nonatomic, strong)  EditItemRadio *rdoIsPrintGift;
@property (nonatomic, strong)  EditItemRadio *rdoIsPrintOrder;
@property (nonatomic, strong)  EditItemRadio *rdoIsPrintQRCode;
@property (nonatomic, strong)  EditItemRadio *rdoIsPrintBack;
//@property (nonatomic, strong) IBOutlet EditItemText *txtAddPrefix;

@property (nonatomic, strong) ConfigVO* printerSortConfig;
@property (nonatomic, strong) ConfigVO *numsOfVipConfig;
@property (nonatomic, strong) ConfigVO* isPrintbeepConfig;

@property (nonatomic, strong) ConfigVO* isPrintConsumeConfig;
@property (nonatomic, strong) ConfigVO* consumePrinterCharNumConfig;
@property (nonatomic, strong) ConfigVO* consumePrinterIpConfig;

@property (nonatomic, strong) ConfigVO* isPrintDrawConfig;
@property (nonatomic, strong) ConfigVO* drawPrinterIpConfig;
@property (nonatomic, strong) ConfigVO* drawPrinterCharNumConfig;

@property (nonatomic, strong) ConfigVO* isAccountBillConfig;
@property (nonatomic, strong) ConfigVO* financeCashDrawerConfig;
@property (nonatomic, strong) ConfigVO* isAccountCashDrawerConfig;
@property (nonatomic, strong) ConfigVO* isPrintOrderConfig;
@property (nonatomic, strong) ConfigVO* isPrintQRCodeConfig;
@property (nonatomic, strong) ConfigVO* isPrintBackConfig;
@property (nonatomic, strong) ConfigVO* isPrintGiftConfig;

@property (nonatomic, strong) ConfigVO* isAddPrefixConfig;
@property (nonatomic, strong) ShopDetail* shopDetail;
@property (nonatomic, strong) NSString* imgFilePathTemp;
@property (nonatomic) BOOL changed;


//使用会员卡支付时消费凭证的打印份数 数组
@property (nonatomic, strong) NSMutableArray *vipCountChoiceArr;


- (void)initMainView;

- (void)loadData;

@end
