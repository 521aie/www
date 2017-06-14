//
//  TDFCustomStrategy+Generator.m
//  RestApp
//
//  Created by tripleCC on 2017/5/12.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFCustomStrategy+Generator.h"

@implementation TDFCustomStrategy (Generator)
+ (instancetype)wx_strategyWithBlock:(dispatch_block_t)block {
    TDFCustomStrategy *s = [[TDFCustomStrategy alloc] init];
    s.btnClickedBlock = block;
    return s;
}
@end
