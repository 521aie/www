//
//  TDFShopPowerEditViewController.h
//  RestApp
//
//  Created by zishu on 16/10/14.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFRootViewController.h"
#import "Plate.h"

@interface TDFShopPowerEditViewController : TDFRootViewController

@property (nonatomic,copy) void (^shopPowerCallBack)(BOOL orRefresh);
@property (nonatomic ,strong) Plate *plate;

@end
