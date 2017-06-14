//
//  TDFShopCompareItem.m
//  RestApp
//
//  Created by Cloud on 2017/3/30.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopCompareItem.h"
@class TDFShopPays;
@implementation TDFShopCompareItem

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"pays" : [TDFShopPays class]};
}

+ (NSMutableAttributedString *)stringFromDouble:(double )doubValue {

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    
    formatter.numberStyle =NSNumberFormatterDecimalStyle;
    
    formatter.minimumFractionDigits = 2;
    
    formatter.maximumFractionDigits = 2;
    
    formatter.minimumIntegerDigits = 1;
    
    double x = doubValue;
    
    if (x>=100000000) {
        
        x = doubValue/100000000;
        
        formatter.positiveSuffix = @"亿";
        
    }else if (x>=1000000) {
        
        x = doubValue/10000;
        formatter.positiveSuffix = @"万";
    }else {
        
        formatter.positiveSuffix = @"元";
    }
    
    NSMutableAttributedString *newText = [[NSMutableAttributedString alloc]initWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:x]]];
    
    if (doubValue<0) {
        
        [newText appendAttributedString:[[NSAttributedString alloc] initWithString:@"元"]];
    }
    
    [newText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(newText.length-1, 1)];
    
    return newText;
}

+ (NSString *)normalStringFromDouble:(double )doubValue {

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    
    formatter.numberStyle =NSNumberFormatterDecimalStyle;
    
    formatter.minimumFractionDigits = 2;
    
    formatter.maximumFractionDigits = 2;
    
    formatter.minimumIntegerDigits = 1;
    
    double x = doubValue;
    
    if (x>=100000000) {
        
        x = doubValue/100000000;
        
        formatter.positiveSuffix = @"亿";
        
    }else if (x>=1000000) {
        
        x = doubValue/10000;
        formatter.positiveSuffix = @"万";
    }else {
        
        formatter.positiveSuffix = @"元";
    }
    
    NSString *newText = [formatter stringFromNumber:[NSNumber numberWithDouble:x]];
    
    return newText;
}

+ (NSMutableAttributedString *)stringFromInt:(NSInteger )intValue withUnit:(NSString *)unitStr{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    
    formatter.numberStyle =NSNumberFormatterDecimalStyle;
    
//    formatter.minimumFractionDigits = 2;
    
    formatter.maximumFractionDigits = 0;
    
    formatter.minimumIntegerDigits = 1;
    
    NSInteger x = intValue;
    
    if (x>=100000000) {
        
        x = intValue/100000000;
        
        formatter.positiveSuffix = [NSString stringWithFormat:@"亿%@",unitStr];
        
    }else if (x>=1000000) {
        
        x = intValue/10000;
//        formatter.positiveSuffix = @"万人";
        formatter.positiveSuffix = [NSString stringWithFormat:@"万%@",unitStr];
    }else {
        
//        formatter.positiveSuffix = @"人";
        formatter.positiveSuffix = [NSString stringWithFormat:@"%@",unitStr];
    }
    
    NSMutableAttributedString *newText = [[NSMutableAttributedString alloc]initWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:x]]];
    
    if (intValue<0) {
        
        [newText appendAttributedString:[[NSAttributedString alloc] initWithString:@"人"]];
    }
    
    [newText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(newText.length-1, 1)];
    
    return newText;
}

- (NSMutableAttributedString *)turnOverToStr {
    
    if (!_turnOverToStr) {
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        
        formatter.numberStyle =NSNumberFormatterDecimalStyle;
        
        formatter.minimumFractionDigits = 2;
        
        formatter.maximumFractionDigits = 2;
        
        formatter.minimumIntegerDigits = 1;
        
        double x = _actualAmount;
        
        if (x>=100000000) {
            
            x = _actualAmount/100000000;
            
            formatter.positiveSuffix = @"亿";
            
        }else if (x>=1000000) {
            
            x = _actualAmount/10000;
            formatter.positiveSuffix = @"万";
        }else {
            
            formatter.positiveSuffix = @"元";
        }
        
        NSMutableAttributedString *newText = [[NSMutableAttributedString alloc]initWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:x]]];
        
        [newText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(newText.length-1, 1)];
        
        _turnOverToStr = newText;
    }
    return _turnOverToStr;
}

- (float)proportion {

    if (!self.maxActualAmount) {
        
        return 0;
    }
    
    return self.actualAmount/self.maxActualAmount;
}

@end

@implementation TDFShopPays



@end
