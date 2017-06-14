//
//  TDFBusinessInfoModel.h
//  RestApp
//
//  Created by happyo on 2016/11/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFPayInfoModel.h"

@interface TDFBusinessInfoModel : NSObject

@property (nonatomic, assign) double actualAmount;

@property (nonatomic, assign) double actualAmountAvg;

@property (nonatomic, strong) NSString *date;

@property (nonatomic, assign) double discountAmount;

@property (nonatomic, assign) double mealsCount;

@property (nonatomic, assign) double orderCount;

@property (nonatomic, assign) double profitLossAmount;

@property (nonatomic, assign) double sourceAmount;

@property (nonatomic, assign) double memberChargeAmount;

@property (nonatomic, assign) double memberChargeTimes;

@property (nonatomic, strong) NSArray<TDFPayInfoModel *> *pays;

@end
