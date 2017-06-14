//
//  TDFSmartOrderGroupModel.h
//  RestApp
//
//  Created by BK_G on 2017/1/12.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFSmartOrderFieldModel.h"

@interface TDFSmartOrderGroupModel : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) NSMutableArray<TDFSmartOrderFieldModel *> *funcFieldValues;

@property (nonatomic, copy) NSString *functionCode;

@property (nonatomic, assign) BOOL isDisplay;

@property (nonatomic, assign) BOOL isMaxLimited;

@property (nonatomic, assign) NSInteger maxNum;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger ordinal;

@property (nonatomic, copy) NSString *remark;

@end
