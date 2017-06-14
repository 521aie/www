//
//  TDFHealthCheckItemBodyModel.h
//  RestApp
//
//  Created by xueyu on 2016/12/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFHealthCheckItemBodyModel : NSObject
/**
 * 标题
 */
@property(nonatomic, copy) NSString *title;

/**
 * 描述内容
 */
@property(nonatomic, copy) NSString *desc;

/**
 * 详情类型（0:无 / 1:结果-环图 / 2:结果-饼图 / 3:结果-柱状图 / 4:结果-图片 / 5:优化方案-按钮及视频）
 */
@property(nonatomic, assign) NSInteger type;

/**
 * 对应type的详情数据Json串的列表
 */
@property(nonatomic, strong) NSArray *details;

@end


//优化方案

@interface TDFHealthCheckBtnModel : NSObject

/**
 * 编号
 */
@property(nonatomic, copy) NSString *actionCode;

/**
 * 名称
 */
@property(nonatomic, copy) NSString *actionName;

/**
 * 图片URL
 */
@property(nonatomic, copy) NSString *iconUrl;

/**
 * 是否上锁(0：否 / 1:是)
 */
@property(nonatomic, assign) NSInteger isLocked;

@end

@interface TDFHealthCheckVideoModel : NSObject

/**
 * 图标URL
 */
@property(nonatomic, copy) NSString *iconUrl;

/**
 * 视频URL
 */
@property(nonatomic, copy) NSString *videoUrl;

/**
 * 视频名称
 */
@property(nonatomic, copy) NSString *videoName;

/**
 * 视频 1 ,网页 2
 */
@property(nonatomic, assign) NSInteger  type;

@end


