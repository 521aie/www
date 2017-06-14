//
//  TDFPriceFormatViewController.h
//  RestApp
//
//  Created by zishu on 16/10/10.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFBaseListViewController.h"
#import "MenuPricePlanVo.h"
#import "NameValueCell.h"
#import "TDFChainMenuService.h"
#import "AlertBox.h"
#import "TDFMediator+ChainMenuModule.h"

@interface TDFPriceFormatViewController : TDFBaseListViewController<ISampleListEvent>
@property (nonatomic,copy) void (^priceFormatCallBack)(BOOL orRefresh);
@end
