//
//  BusinessStatisticsVoList.m
//  RestApp
//
//  Created by iOS香肠 on 16/3/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BusinessStatisticsVoList.h"
#import "ObjectUtil.h"

@implementation BusinessStatisticsVoList


- (id)initWithDictionary:(NSDictionary *)dict {
    
    if (self = [super init]) {
        if ([ObjectUtil isNotEmpty:dict]) {
            
            self.orderDate =[ObjectUtil getStringValue:dict key:@"orderDate"];
            self.orderMonth =[ObjectUtil getStringValue:dict key:@"orderMonth"];
            self.payAmount =[ObjectUtil getDoubleValue:dict key :@"payAmount"];
            self.payKindName =[ObjectUtil getStringValue:dict key:@"payKindName"];
        }
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
-(void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues
{
    
}
@end
