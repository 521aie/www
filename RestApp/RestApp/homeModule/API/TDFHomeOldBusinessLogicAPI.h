//
//  TDFHomeOldBusinessLogicAPI.h
//  RestApp
//
//  Created by happyo on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFAPIKit/TDFAPIKit.h>

@interface TDFHomeOldBusinessLogicAPI : TDFBaseAPI

@property (nonatomic, strong) NSString *appCode;

@property (nonatomic, strong) NSString *jsessionId;

/**
 平台（1：安卓 2：IOS）
 */
@property (nonatomic, strong) NSString *platformType;

/**
 类型 1.选择工作店铺(绑定) 2.连锁切店
 */
@property (nonatomic, strong) NSString *type;

@end
