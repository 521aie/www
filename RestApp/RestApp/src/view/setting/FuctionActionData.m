//
//  FuctionActionData.m
//  RestApp
//
//  Created by iOS香肠 on 15/12/25.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "FuctionActionData.h"

@implementation FuctionActionData
@synthesize id;

-(NSString *)description
{
    return  [NSString stringWithFormat:@"%@",self.name];
}

@end
