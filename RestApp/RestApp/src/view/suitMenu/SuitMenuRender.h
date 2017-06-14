//
//  SuitMenuRender.h
//  RestApp
//
//  Created by zxh on 14-8-27.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuitMenuRender : NSObject

///允许点的数量.
@property (nonatomic, strong)NSMutableArray *countArray;


//点单方式.
+(NSMutableArray*) listDetailKind;


@end
