//
//  BaseShopTemplate.m
//  RestApp
//
//  Created by zxh on 14-4-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseShopTemplate.h"

@implementation BaseShopTemplate

-(void)dealloc{
    self.templateType=nil;
    self.name=nil;
    self.printTemplateId=nil;
    self.attachmentId=nil;
    self.providerAttachmentId=nil;
}

@end
