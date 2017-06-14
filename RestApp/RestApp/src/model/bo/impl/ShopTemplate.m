//
//  ShopTemplate.m
//  RestApp
//
//  Created by zxh on 14-4-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopTemplate.h"
#import "NSString+Estimate.h"

@implementation ShopTemplate

-(NSString*) obtainItemId{
    return self._id;
}

-(NSString*) obtainItemName{
    return self.kindPrintTemplateName;
}

-(NSString*) obtainOrignName{
    return self.kindPrintTemplateName;
}

-(NSString*) obtainItemValue{
    return [NSString isBlank:self.name]?NSLocalizedString(@"默认", nil):self.name;
}

-(void)dealloc{
    self.kindPrintTemplateId=nil;
    self.kindPrintTemplateName=nil;
    self.filePath=nil;
}

@end
