//
//  ServiceFactory.h
//  RestApp
//
//  Created by zxh on 14-4-13.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SmsService.h"
#import "UserService.h"

#import "MenuService.h"
#import "TransService.h"
#import "KabawService.h"
#import "MemberService.h"
#import "SystemService.h"
#import "SettingService.h"
#import "LifeInfoService.h"
#import "EnvelopeService.h"
#import "EmployeeService.h"
#import "BusinessService.h"
#import "PrinterService.h"
#import "OrderService.h"
#import "ChainService.h"

#import "BillModifyService.h"

@interface ServiceFactory : NSObject

@property (nonatomic, strong) SmsService *smsService;
@property (nonatomic, strong) MenuService *menuService;
@property (nonatomic, strong) KabawService *kabawService;
@property (nonatomic, strong) TransService *transService;
@property (nonatomic, strong) MemberService *memberService;
@property (nonatomic, strong) SystemService *systemService;
@property (nonatomic, strong) SettingService *settingService;
@property (nonatomic, strong) EmployeeService *employeeService;
@property (nonatomic, strong) BusinessService *businessService;
@property (nonatomic, strong) EnvelopeService *envelopeService;
@property (nonatomic, strong) LifeInfoService *lifeInfoService;
@property (nonatomic, strong) PrinterService *printerService;
@property (nonatomic, strong) UserService *userService;
@property (nonatomic, strong) ChainService *chainService;

@property (nonatomic, strong) BillModifyService *billModifyService;

@property (nonatomic, strong) OrderService *orderService;
+ (ServiceFactory *)Instance;

- (void)initService;

@end
