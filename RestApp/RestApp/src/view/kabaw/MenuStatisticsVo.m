//
//  MenuStatisticsVo.m
//  RestApp
//
//  Created by xueyu on 16/1/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ObjectUtil.h"
#import "MenuStatisticsVo.h"

@implementation MenuStatisticsVo
-(id)initWithDictionary:(NSDictionary *)dict{
  
    if (self == [super init]) {
        if ([ObjectUtil isNotEmpty:dict]) {
            self.name = [ObjectUtil getStringValue:dict key:@"name"];
            self.createTime  = [ObjectUtil getLonglongValue:dict key:@"createTime"];
            self.num_id	 = [ObjectUtil getStringValue:dict key:@"id"];
            self.entityId = [ObjectUtil getStringValue:dict key:@"entityId"];
            self.count = [ObjectUtil getIntegerValue:dict key:@"count"] ;
            self.isSelf = [ObjectUtil getShortValue:dict key:@"isSelf"];
            self.code= [ObjectUtil getStringValue:dict key:@"code"];
            self.menuId =  [ObjectUtil getStringValue:dict key:@"menuId"];
            self.isAutomatic = [ObjectUtil getShortValue:dict key:@"isAutomatic"];
        }
    }
    return self;
}
@end
