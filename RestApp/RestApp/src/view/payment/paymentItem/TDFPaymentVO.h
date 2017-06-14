//
//  TDFPaymentVO.h
//  RestApp
//
//  Created by 栀子花 on 2017/1/3.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFPaymentVO : NSObject

@property (nonatomic, strong) NSString *entityId;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, assign) NSInteger accountType;
@property (nonatomic, assign) NSInteger holderCardNo;
@property (nonatomic, assign) NSInteger orgNo;
@property (nonatomic, assign) NSInteger holderPhone;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankProvNo;
@property (nonatomic, strong) NSString *bankCityNo;
@property (nonatomic, strong) NSString *bankSubNo;
@property (nonatomic, strong) NSString *bankCardNumber;
@property (nonatomic, strong) NSString *bankAccount;
@property (nonatomic, strong) NSString *locusProvince;
@property (nonatomic, strong) NSString *locusCity;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *ownerPhone;
@property (nonatomic, strong) NSString *detailAddress;



@end
