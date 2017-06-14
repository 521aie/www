//
//  TDFPaymentTypeVo.m
//  RestApp
//
//  Created by xueyu on 16/6/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFPaymentTypeVo.h"


@implementation TDFPaymentTypeVo
- (id)initWithName:(NSString *)typeName detail:(NSString *)detailTemp img:(NSString*) imgTemp typeCode:(NSString*)typeCode paymentType:(PaymentType)payType code:(NSInteger)code{
    
    if(self = [super init]){
        self.typeName = typeName;
        self.detail = detailTemp;
        self.image = imgTemp;
        self.typeCode = typeCode;
        self.payType = payType;
        self.code = code;
    }
    return self;
}
@end