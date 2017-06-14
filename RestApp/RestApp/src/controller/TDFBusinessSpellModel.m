//
//  TDFBusinessSpellModel.m
//  RestApp
//
//  Created by happyo on 2016/11/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBusinessSpellModel.h"

@implementation TDFBusinessSpellModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.isAll = NO;
        self.bTime = @"";
        self.eTime = @"";
        self.name = @"";
    }
    
    return self;
}

- (NSString *)obtainItemId
{
    if (self.isAll) {
        return kBusinessSpellAllDay;
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        
        NSDate *bTime = [dateFormatter dateFromString:self.bTime];
        NSDate *eTime = [dateFormatter dateFromString:self.eTime];
        
        dateFormatter.dateFormat = @"HHmm";
        
        return [NSString stringWithFormat:@"%@-%@", [dateFormatter stringFromDate:bTime], [dateFormatter stringFromDate:eTime]];
    }
}

- (NSString *)obtainItemName
{
    if (self.isAll) {
        return kBusinessSpellAllDay;
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        
        NSDate *bTime = [dateFormatter dateFromString:self.bTime];
        NSDate *eTime = [dateFormatter dateFromString:self.eTime];
        
        dateFormatter.dateFormat = @"HH:mm";
        
        return [NSString stringWithFormat:@"%@(%@-%@)", self.name, [dateFormatter stringFromDate:bTime], [dateFormatter stringFromDate:eTime]];
    }
}

- (NSString *)obtainOrignName
{
    return nil;
}

@end
