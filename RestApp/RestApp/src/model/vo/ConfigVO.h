//
//  ConfigVO.h
//  RestApp
//
//  Created by zxh on 14-4-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ConfigItem.h"

@interface ConfigVO : ConfigItem

@property (nonatomic,strong) NSString* val;
@property (nonatomic,strong) NSMutableArray* options;

+(id) options_class;
@end
