//
//  TDFPermissionHelper.h
//  RestApp
//
//  Created by happyo on 2017/4/22.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFFunctionVo.h"
#import "TDFHomeGroupForwardItem.h"

@interface TDFPermissionHelper : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSArray<TDFHomeGroupForwardChildCellModel *> *functionModelList;

- (NSArray<NSString *> *)notLockedActionCodeList;

- (NSArray<TDFFunctionVo *> *)allModuleChargeList;

- (BOOL)isLockedWithActionCode:(NSString *)actionCode;

@end
