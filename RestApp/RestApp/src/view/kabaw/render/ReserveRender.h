//
//  ReserveRender.h
//  RestApp
//
//  Created by zxh on 14-5-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReserveRender : NSObject

+(NSMutableArray*) listMode;

+ (NSMutableArray  *)listArea;
+(NSString*) obtainReserveFeeUnit:(short)mode;
@end
