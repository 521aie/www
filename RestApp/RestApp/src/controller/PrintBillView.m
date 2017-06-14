//
//  PrintBillView.m
//  RestApp
//
//  Created by 邵建青 on 15/11/11.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertBox.h"
#import "ObjectUtil.h"
#import "NameItemVO.h"
#import "HomeModule.h"
#import "PantryRender.h"
#import "XHAnimalUtil.h"
#import "PrintBillView.h"
#import "EventConstants.h"
#import "ServiceFactory.h"
#import "TDFOptionPickerController.h"
#import "ActionConstants.h"
#import "NSString+Estimate.h"
#import "ShopTemplateRender.h"


#import "MobileUtil.h"

@interface PrintBillView ()<EditItemListDelegate>

@end

@implementation PrintBillView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        printerService = [ServiceFactory Instance].printerService;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMainView];
    [self initNavigate];
    [self initWithData:self.dateStr];
}

- (void)editItemListDidFinishEditing:(EditItemList *)editItem {

    NSString *val = editItem.currentVal;
    if ([NSString isNotBlank:val]) {
        [self.ipAddrLst initData:val withVal:val];
        [printConfig setIpAddr:val];
        [PrintConfig putPrintConfig:printConfig];
    }
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:nil backImg:Head_ICON_BACK moreImg:nil];
    self.title = NSLocalizedString(@"打印账单统计", nil);
}

- (void)initMainView
{
    [self.ipAddrLst initLabel:NSLocalizedString(@"打印机IP地址", nil) withHit:nil isrequest:YES delegate:self];
    [self.widthLst initLabel:NSLocalizedString(@"打印纸宽度", nil) withHit:nil isrequest:YES delegate:self];
    [self.charNumLst initLabel:NSLocalizedString(@"每行打印字符数", nil) withHit:nil isrequest:YES delegate:self];
    
    self.ipAddrLst.tag = 1;
    self.widthLst.tag = 2;
    self.charNumLst.tag = 3;
    
    [self.ipAddrLst setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeIPAddress hasSymbol:NO];
    self.ipAddrLst.tdf_delegate = self;
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [self.navigationController popViewControllerAnimated:YES];
//        [homeModule showDetailView];
//        [XHAnimalUtil animal:homeModule type:kCATransitionPush direct:kCATransitionFromLeft];
    }
}

- (void)initWithData:(NSString *)date
{
    printDate = date;
    printConfig = [PrintConfig getPrintConfig];
    [self.ipAddrLst initData:printConfig.ipAddr withVal:printConfig.ipAddr];
    [self.widthLst initData:printConfig.widthName withVal:printConfig.width];
    [self.charNumLst initData:printConfig.charNumName withVal:printConfig.charNum];
}

- (IBAction)printTestClick:(id)sender
{
    if ([self isValid]) {
        NSString *wordCount = [self.widthLst getStrVal];
        [self showProgressHudWithText:NSLocalizedString(@"正在打印", nil)];
        [NSThread detachNewThreadSelector:@selector(loadTestData:) toTarget:self withObject:wordCount];
    }
}

- (IBAction)printBillBtnClick:(id)sender
{
    if ([self isValid]) {
        NSString *wordCount = [self.widthLst getStrVal];
        [self showProgressHudWithText:NSLocalizedString(@"正在打印", nil)];
        [NSThread detachNewThreadSelector:@selector(loadPrintData:) toTarget:self withObject:wordCount];
    }
}

- (BOOL)isValid
{
    if ([NSString isBlank:printDate]) {
        [AlertBox show:NSLocalizedString(@"打印日期不能为空哦!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.ipAddrLst getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"打印机IP地址不能为空!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.widthLst getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"打印纸宽度不能为空!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.charNumLst getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"每行打印字符数不能为空!", nil)];
        return NO;
    }
    return YES;
}

- (void)loadTestData:(NSString *)wordCount
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:wordCount forKey:@"charNum"];
    
    [MobileUtil postAPIWithPath:@"print/ios_test" param:param success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        NSString *host = [self.ipAddrLst getStrVal];
        [printerService printData:host port:9100 data:data delegate:self];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self performSelectorOnMainThread:@selector(finishPrint:) withObject:NSLocalizedString(@"网络不给力哦！", nil) waitUntilDone:NO];
    }];
}

- (void)loadPrintData:(NSString *)wordCount
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    param[@"entityId"] = [[Platform Instance] getkey:ENTITY_ID];
    param[@"shopName"] = [[Platform Instance] getkey:SHOP_NAME];
    NSString *userName = [[Platform Instance] getkey:USER_NAME];
    if ([NSString isBlank:userName]) {
        userName = [Platform Instance].memberExtend.userName;
    }
    param[@"printUser"] = userName;
    param[@"beginTime"] = printDate;
    param[@"charNum"] = wordCount;
    
    [MobileUtil postAPIWithPath:@"print/ios_billTotal" param:param success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        NSString *host = [self.ipAddrLst getStrVal];
        [printerService printData:host port:9100 data:data delegate:self];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self performSelectorOnMainThread:@selector(finishPrint:) withObject:NSLocalizedString(@"网络不给力哦！", nil) waitUntilDone:NO];
    }];
}

- (void)finishPrint:(NSString *)message
{
    [self.progressHud hide:YES];
    [AlertBox show:message];
}

- (void)onItemListClick:(EditItemList *)obj
{
    if (self.widthLst==obj) {
//        [OptionPickerBox initData:[ShopTemplateRender listWidth] itemId:[obj getStrVal]];
//        [OptionPickerBox show:NSLocalizedString(@"打印纸宽度", nil) client:self event:obj.tag];
        
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"打印纸宽度", nil)
                                                                                      options:[ShopTemplateRender listWidth]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[ShopTemplateRender listWidth][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    } else if (self.charNumLst==obj) {
        NSString *widthStr = [self.widthLst getStrVal];
        if ([NSString isNotBlank:widthStr]) {
            if([widthStr isEqualToString:@"42"]){
                widthStr = @"80";
            }else if ([widthStr isEqualToString:@"38"])
            {
                widthStr = @"76";
            }else  if ([widthStr isEqualToString:@"32"])
            {
                widthStr = @"58";
            }
//            [OptionPickerBox initData:[PantryRender listLineCounts:widthStr] itemId:[obj getStrVal]];
//            [OptionPickerBox show:NSLocalizedString(@"每行打印字符数", nil) client:self event:obj.tag];
            
            
            TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"每行打印字符数", nil)
                                                                                          options:[PantryRender listLineCounts:widthStr]
                                                                                    currentItemId:[obj getStrVal]];
            __weak __typeof(self) wself = self;
            pvc.competionBlock = ^void(NSInteger index) {
                
                [wself pickOption:[PantryRender listLineCounts:widthStr][index] event:obj.tag];
            };
            
            [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        } else {
            [AlertBox show:NSLocalizedString(@"请先选择打印纸宽度", nil)];
        }
    }
}

- (void)clientInput:(NSString *)val event:(NSInteger)eventType
{
    if ([NSString isNotBlank:val]) {
        [self.ipAddrLst initData:val withVal:val];
        [printConfig setIpAddr:val];
        [PrintConfig putPrintConfig:printConfig];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    NameItemVO *nameItem = (NameItemVO *)selectObj;
    if (eventType==self.widthLst.tag) {
        [self.widthLst initData:nameItem.itemName withVal:nameItem.itemId];
        [printConfig setWidth:nameItem.itemId];
        [printConfig setWidthName:nameItem.itemName];
        NSString *widthStr ;
        if([nameItem.itemId isEqualToString:@"42"]){
            widthStr = @"80";
        }else if ([nameItem.itemId isEqualToString:@"38"])
        {
            widthStr = @"76";
        }else  if ([nameItem.itemId isEqualToString:@"32"])
        {
            widthStr = @"58";
        }

        NameItemVO *item = [[PantryRender listLineCounts:widthStr] firstObject];
        [self.charNumLst initData:item.itemName withVal:item.itemId];
    } else if (eventType==self.charNumLst.tag) {
        [self.charNumLst initData:nameItem.itemName withVal:nameItem.itemId];
        [printConfig setCharNum:nameItem.itemId];
        [printConfig setCharNumName:nameItem.itemName];
    }
    [PrintConfig putPrintConfig:printConfig];
    return YES;
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
     [self.progressHud hide:YES];
    if (eventCode==NSStreamEventErrorOccurred) {
        NSError *error = [stream streamError];
        NSLog(NSLocalizedString(@"打印结果反馈:%@    %@", nil), [error localizedDescription], [error localizedFailureReason]);
        [AlertBox show:NSLocalizedString(@"打印出错，原因：打印机不通或IP设置有误！请检查设置、网络及打印机。", nil)];
        return;
    } else if (eventCode==NSStreamEventOpenCompleted) {
        [AlertBox show:NSLocalizedString(@"打印成功", nil)];
        return;
    }
}

@end
