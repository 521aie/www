//
//  QuickStep.m
//  RestApp
//
//  Created by zxh on 14-6-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "QuickStep.h"

@implementation QuickStep


- (id)copyWithZone:(NSZone *)zone
{
    QuickStep *obj = [[[self class] allocWithZone:zone] init];
    obj.stepName = [self.stepName copy];
    obj.actName = [self.actName copy];
    obj.actCode = [self.actCode copy];
    obj.actDetail = [self.actDetail copy];
    obj.isRequire = self.isRequire;
    obj.status = self.status;
    obj.stepNum = self.stepNum;
    obj.isLock=self.isLock;
    obj.isFast=self.isFast;
    obj.kind=self.kind;
    obj.isBar=self.isBar;
    obj.isRest=self.isRest;
    return obj;
}

@end
