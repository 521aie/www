//
//  TDFSuitMenuPrinterModel.m
//  RestApp
//
//  Created by 黄河 on 16/9/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSuitMenuPrinterModel.h"

@implementation TDFSuitMenuPrinterModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"menuID":@"id"};
}

- (NSString *)obtainItemId
{
    return self.menuID;
}

- (NSString *)obtainItemName
{
    return self.name;
}

- (NSString *)obtainOrignName
{
    return self.name;
}

-(BOOL)isEqual:(id)object
{
    if (object !=nil && [object respondsToSelector:@selector(obtainItemId)]) {
        if ([[object obtainItemId] isEqualToString:self.menuID]) {
            return YES;
        }
    }
    return NO;
}

- (id)copyWithZone:(NSZone *)zone
{
    TDFSuitMenuPrinterModel *model = [[[self class] allocWithZone:zone] init];
    if (model) {
        model.menuID = [self.menuID copy];
        model.name = [self.name copy];
        model.needOneMealOneCut = self.needOneMealOneCut;
    }
    return model;
}
@end
