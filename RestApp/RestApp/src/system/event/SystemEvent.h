//
//  SystemEvent.h
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-25.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEventListener.h"

@interface SystemEvent : NSObject

+ (void)dispatch:(NSString *)eventType;

+ (void)dispatch:(NSString *)eventType object:(id)object;

+ (void)registe:(NSString *)eventType target:(id<IEventListener>)target;

@end
