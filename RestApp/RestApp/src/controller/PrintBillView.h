//
//  PrintBillView.h
//  RestApp
//
//  Created by 邵建青 on 15/11/11.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PrintConfig.h"
#import <UIKit/UIKit.h>
#import "EditItemList.h"
#import "RemoteResult.h"
#import "MBProgressHUD.h"
#import "PrinterService.h"
#import "NavigateTitle2.h"
#import "NumberInputClient.h"
#import "OptionPickerClient.h"
#import "TDFRootViewController.h"

@interface PrintBillView : TDFRootViewController<NSStreamDelegate, INavigateEvent, IEditItemListEvent, NumberInputClient, OptionPickerClient>
{
    PrintConfig *printConfig;
    
    PrinterService *printerService;
    
    NSString *printDate;
}
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet EditItemList *ipAddrLst;
@property (nonatomic, strong) IBOutlet EditItemList *widthLst;
@property (nonatomic, strong) IBOutlet EditItemList *charNumLst;
@property (nonatomic, strong) NSString *dateStr;

//- (void)initWithData:(NSString *)date;

- (IBAction)printTestClick:(id)sender;

- (IBAction)printBillBtnClick:(id)sender;

@end
