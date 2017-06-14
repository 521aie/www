//
//  TDFPayInfoModel.m
//  RestApp
//
//  Created by happyo on 2016/11/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFPayInfoModel.h"

@implementation TDFPayInfoModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.kindPayId = @"";
        self.kindPayName = @"";
        self.imageUrl = @"";
        self.selected = NO;
        self.isAll = NO;
        self.kindPayIds = [NSArray array];
    }
    
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"kindPayId" : @[@"kindPayId",@"paymentType"],
             @"kindPayName" : @[@"kindPayName",@"paymentName"],
             @"money" : @[@"money"]
             };
}

@end
