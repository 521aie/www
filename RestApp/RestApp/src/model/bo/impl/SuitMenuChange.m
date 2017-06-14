//
//  SuitMenuChange.m
//  RestApp
//
//  Created by zxh on 14-8-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SuitMenuChange.h"
#import "FormatUtil.h"
#import "NSString+Estimate.h"
@implementation SuitMenuChange

-(NSString*) obtainItemId{
    return self._id;
}

-(NSString*) obtainItemName{
    if([NSString isBlank:self.specDetailName]){
        return self.menuName;
    }else{
        return [NSString stringWithFormat:@"%@(%@)",self.menuName,self.specDetailName];
    }
}

-(NSString*) obtainOrignName{
    return self.menuName;
}

-(NSString*) obtainItemValue{
    if (self.isRequired==1){
        return [NSString stringWithFormat:NSLocalizedString(@"%@份", nil),[FormatUtil formatDouble4:self.num]];
    }else{
        return self.price==0?@"":[NSString stringWithFormat:NSLocalizedString(@"加价:%@元", nil),[FormatUtil formatDouble4:self.price]];
    }
}

- (TDFSuitMenuChangeSuitMenuChangeExtra *)suitMenuChangeExtra
{
    if (!_suitMenuChangeExtra) {
        _suitMenuChangeExtra = [[TDFSuitMenuChangeSuitMenuChangeExtra alloc] init];
    }
    return _suitMenuChangeExtra;
}

@end

@implementation TDFSuitMenuChangeSuitMenuChangeExtra

@end