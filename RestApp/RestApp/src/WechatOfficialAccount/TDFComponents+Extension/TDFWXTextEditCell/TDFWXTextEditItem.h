//
//  TDFWXTextEditItem.h
//  RestApp
//
//  Created by Octree on 20/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBaseEditItem.h"

@interface TDFWXTextEditItem : TDFBaseEditItem <NSCopying>

@property (nonatomic, strong) void (^clickBlock)();

@end
