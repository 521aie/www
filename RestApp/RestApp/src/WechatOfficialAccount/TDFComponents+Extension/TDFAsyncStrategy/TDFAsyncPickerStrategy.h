//
//  TDFAsyncPickerStrategy.h
//  RestApp
//
//  Created by Octree on 16/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFPickerActionStrategy.h"
#import "INameItem.h"
#import "TDFAsync.h"

@interface TDFAsyncPickerStrategy : TDFPickerActionStrategy

/**
 *  TDFAsync<NSArray <id<INameItem>> *>
 *  封装的类型必须实现 INameItem 协议
 */
@property (nonatomic, strong) TDFAsync *async;
@property (nonatomic, strong) NSString *currentSelectedItemId;

@property (nonatomic, strong) NSString *pickerName;

@property (nonatomic, strong) BOOL (^shouldShowPickerBlock)();

@end
