//
//  KindAndTasteVo.h
//  RestApp
//
//  Created by zishu on 16/9/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taste.h"
#import "SortItemValue.h"
@interface KindAndTasteVo : NSObject<INameValueItem,SortItemValue>
/**
 * 口味分类ID
 */
@property(nonatomic ,strong) NSString *kindTasteId;

/**
 * 口味分类名
 */
@property(nonatomic ,strong) NSString *kindTasteName;

/**
 * 口味列表
 */
@property(nonatomic ,strong) NSMutableArray *tasteList;

@property (nonatomic, assign) int sortCode;

@end
