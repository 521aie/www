//
//  ExtraAction.h
//  RestApp
//
//  Created by zxh on 14-4-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseExtraAction.h"

@interface ExtraAction : BaseExtraAction

@property (nonatomic,strong) NSMutableArray* extraActionOptions;

+(id) extraActionOptions_class;

@end
