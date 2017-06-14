//
//  DateModel.m
//  时间
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 xiaocao. All rights reserved.
//

#import "DateModel.h"

@implementation DateModel

+ (NSDate*) dateByModifiyingDate:(NSDate*)date withModifier:(NSString*)modifier
{
    BOOL substract = NO;
    __block int numOfKind = 0;
    DateModelType type;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierRepublicOfChina];
    
    // What should we do (add vs. sub)?
    if([modifier hasPrefix:@"-"]) substract = YES;
    
    // How much?
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{1,}" options:0 error:&error];
    
    if (error == NULL) {
        [regex enumerateMatchesInString:modifier options:0 range:NSMakeRange(0, [modifier length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSString *match = [modifier substringWithRange:[result range]];
            if(substract) numOfKind -= [match intValue];
            else numOfKind += [match intValue];
        }];
    }
    
    // What kind? (days, months, years)
    if ([modifier rangeOfString:@"day"].location != NSNotFound)
    {
        type = DateModelTypeDays;
    }
    else if([modifier rangeOfString:@"week"].location != NSNotFound)
    {
        type = DateModelTypeWeeks;
    }
    else if([modifier rangeOfString:@"month"].location != NSNotFound)
    {
        type = DateModelTypeMonths;
    }
    else if([modifier rangeOfString:@"year"].location != NSNotFound)
    {
        type = DateModelTypeYears;
    }
    else
    {
        // We default to adding 0 days
        type = DateModelTypeDays;
    }
    
    switch (type) {
        case DateModelTypeDays:
            [components setDay:numOfKind];
            break;
        case DateModelTypeWeeks:
            [components setWeekOfYear:numOfKind];
            break;
        case DateModelTypeMonths:
            [components setMonth:numOfKind];
            break;
        case DateModelTypeYears:
            [components setYear:numOfKind];
            break;
        default:
            [components setDay:0];
            break;
    }
    
    return [gregorian dateByAddingComponents:components toDate:date options:0];
}

+ (NSDate*) dateByModifiyingDate:(NSDate*)date withModifiers:(NSArray*)modifiers
{
    NSDate *resultDate = date;
    
    if(modifiers != nil && modifiers.count > 0)
    {
        for (NSString *modifier in modifiers) {
            resultDate = [DateModel dateByModifiyingDate:resultDate withModifier:modifier];
        }
    }
    
    return resultDate;
}
@end
