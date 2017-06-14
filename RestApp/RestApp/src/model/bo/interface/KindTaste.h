//
//  KindTaste.h
//  RestApp
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseKindTaste.h"
#import "INameItem.h"
#import "INameValueItem.h"

@interface KindTaste : BaseKindTaste<INameItem, INameValueItem>

-(id)initWithVal:(NSString*)name andId:(NSString*)itemId;

@end
