//
//  TDFSmartOrderFieldModel.h
//  RestApp
//
//  Created by BK_G on 2017/1/12.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFSmartOrderFieldModel : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *defaultValue;

@property (nonatomic, copy) NSString *functionGroupCode;

@property (nonatomic, assign) BOOL isDisplay;

@property (nonatomic, strong) NSString *example;

@property (nonatomic, assign) BOOL isEditable;

@property (nonatomic, assign) BOOL isLinkageField;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSMutableArray *optionalValue;

@property (nonatomic, assign) NSInteger ordinal;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *valueType;

@end
