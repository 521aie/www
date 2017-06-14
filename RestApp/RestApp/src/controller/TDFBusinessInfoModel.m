//
//  TDFBusinessInfoModel.m
//  RestApp
//
//  Created by happyo on 2016/11/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBusinessInfoModel.h"

@implementation TDFBusinessInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pays" : [TDFPayInfoModel class]};
}

@end
