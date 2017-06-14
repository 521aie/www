//
//  ServiceFactory.m
//  RestApp
//
//  Created by zxh on 14-4-13.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ServiceFactory.h"

@implementation ServiceFactory

static ServiceFactory * instance = nil;

+(ServiceFactory *) Instance
{
    @synchronized(self) {
        if (nil == instance) {
            [self new];
            [instance initService];
        }
    }
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

- (void)initService
{
    self.settingService = [[SettingService alloc] init];
    self.menuService = [[MenuService alloc] init];
    self.systemService = [[SystemService alloc] init];
    self.employeeService = [[EmployeeService alloc] init];
    self.kabawService = [[KabawService alloc] init];
    self.transService = [[TransService alloc] init];
    self.memberService = [[MemberService alloc] init];
    self.businessService = [[BusinessService alloc] init];
    self.envelopeService = [[EnvelopeService alloc] init];
    self.lifeInfoService = [[LifeInfoService alloc] init];
    self.smsService = [[SmsService alloc] init];
    self.printerService = [[PrinterService alloc]init];
    self.userService = [[UserService alloc]init];
    self.chainService = [[ChainService alloc] init];
    self.billModifyService = [[BillModifyService alloc] init];
    self.orderService =[[OrderService alloc] init];
}

@end
