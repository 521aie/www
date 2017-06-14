//
//  TDFPaymentTypeVo.h
//  RestApp
//
//  Created by xueyu on 16/6/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,PaymentType){
    E_Payment = -1,
    Weixin = 1 , //微信
    Alipay = 2 , //支付宝
    Packet = 4 ,   //赞助
    QQ = 5 //QQ
};


@interface TDFPaymentTypeVo : NSObject
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *typeCode;// -1 电子支付; 1 微信 ，2 支付宝 , 4 赞助  5 QQ
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign)PaymentType payType;
- (id)initWithName:(NSString *)typeName detail:(NSString *)detailTemp img:(NSString*) imgTemp typeCode:(NSString*)typeCode  paymentType:(PaymentType)payType code:(NSInteger)code;

@end
