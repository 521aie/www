//
//  NSString+TDFRegix.m
//  ClassProperties
//
//  Created by xueyu on 2016/12/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "NSString+Estimate.h"
#import "NSString+TDFRegix.h"
#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"
@implementation NSString (TDFRegix)
+(NSArray *)dataString:(NSString *)dataString regixString:(NSString *)regix{
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regix  options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:dataString options:0 range:NSMakeRange(0, dataString.length)];
    NSMutableArray *array = [NSMutableArray array];
    for (NSTextCheckingResult * match in matches) {
        NSRange range = [match range];
        [array addObject:NSStringFromRange(range)];
    }
    return array;
}

+(NSMutableAttributedString *)string:(NSString *)string with:(NSArray *)strings colors:(NSArray *)colors regixString:(NSString *)regix{
    if ([NSString isBlank:string]) {
        return  nil;
    }
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:string attributes:@{}];
    NSInteger i = 0;
    while ([content.string  rangeOfString:regix options:NSRegularExpressionSearch].location != NSNotFound)
    {
        NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:colors[i]]};
        NSMutableAttributedString *stringM = [[NSMutableAttributedString alloc]initWithAttributedString:content];
        NSArray *matches = [NSString dataString:content.string regixString:regix];
        NSRange range = NSRangeFromString(matches[0]);
         [stringM replaceCharactersInRange:[content.string rangeOfString:regix options:NSRegularExpressionSearch] withString:[NSString stringWithFormat:@"%@",strings[i]]];
        NSRange newRange ;
        newRange.location = range.location;
        newRange.length = [(NSString *)strings[i] length];
          ;
        content = [[NSMutableAttributedString alloc]initWithAttributedString:stringM];
        [content  addAttributes:dict range:newRange];
        i++;
    };
    return content;
}
@end
