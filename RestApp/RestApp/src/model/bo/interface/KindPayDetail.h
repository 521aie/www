//
//  KindPayDetail.h
//  RestApp
//
//  Created by zxh on 14-4-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseKindPayDetail.h"
#import "INameValueItem.h"

@interface KindPayDetail : BaseKindPayDetail<INameValueItem>

@property (nonatomic,strong) NSMutableArray* options;

+(id) options_class;

@end
