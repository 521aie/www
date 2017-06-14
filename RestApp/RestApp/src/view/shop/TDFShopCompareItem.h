//
//  TDFShopCompareItem.h
//  RestApp
//
//  Created by Cloud on 2017/3/30.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "DHTTableViewItem.h"

@interface TDFShopPays :NSObject

@property (nonatomic ,copy) NSString *kindPayId;//支付类型id

@property (nonatomic ,copy) NSString *kindPayName;//支付类型名称

@property (nonatomic ,assign) double money;//支付金额

@end

@interface TDFShopCompareItem : DHTTableViewItem

@property (nonatomic ,assign) double maxActualAmount;//最大营业额

//@property (nonatomic ,assign) double turnOver;//营业额

@property (nonatomic ,assign) double sourceAmount;//应收

@property (nonatomic ,assign) double actualAmount;//实收

@property (nonatomic ,assign) double actualAmountAvg;//实收人均

@property (nonatomic ,assign) double discountAmount;//折扣

@property (nonatomic ,assign) NSInteger mealsCount;//总客人数

@property (nonatomic ,assign) NSInteger orderCount;//账单数

@property (nonatomic ,assign) double profitLossAmount;//损益

@property (nonatomic ,copy) NSString *shopName;//门店名称

@property (nonatomic ,strong) NSMutableArray<TDFShopPays *> *pays;//支付方式统计




@property (nonatomic ,assign) float proportion;//计算比例

@property (nonatomic ,copy) NSMutableAttributedString *turnOverToStr;//营业额str

+ (NSMutableAttributedString *)stringFromDouble:(double )doubValue;

+ (NSString *)normalStringFromDouble:(double )doubValue;

+ (NSMutableAttributedString *)stringFromInt:(NSInteger )intValue withUnit:(NSString *)unitStr;

@end

