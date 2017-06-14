//
//  QuickStep.h
//  RestApp
//
//  Created by zxh on 14-6-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface QuickStep : NSObject<NSCopying>

/**
 * <code>步骤名称</code>.
 */
@property (nonatomic,retain) NSString *stepName;

/**
 * <code>类别</code>.
 */
@property short kind;

/**
 * <code>行为名称</code>.
 */
@property (nonatomic,retain) NSString *actName;

/**
 * <code>行为编码</code>.
 */
@property (nonatomic,retain) NSString *actCode;
/**
 * <code>详细内容</code>.
 */
@property (nonatomic,retain) NSString *actDetail;

/**
 * <code>是否必设置</code>.
 */
@property short isRequire;

/**
 * <code>状态是否设置</code>.
 */
@property short status;

/**
 * <code>类别下的步骤(小)</code>.
 */
@property NSInteger stepNum;

/**
 * <code>是否有权限</code>.
 */
@property BOOL isLock;

/**
 * <code>是否是中西餐模式</code>.
 */
@property BOOL isRest;

/**
 * <code>是否是快餐模式</code>.
 */
@property BOOL isFast;

/**
 * <code>是否是酒吧</code>.
 */
@property BOOL isBar;

@end
