//
//  TDFHealthCheckItemHeaderModel.h
//  RestApp
//
//  Created by xueyu on 2016/12/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHealthCheckTextModel.h"
@interface TDFHealthCheckItemHeaderModel : NSObject

/**
 * 体检项目名称
 */
@property(nonatomic, strong) NSString *itemName;

/**
 * 体检项目编号（取详情弹窗用）
 */
@property(nonatomic, strong) NSString *itemCode;

/**
 * 图标URL
 */
@property(nonatomic, strong) NSString *iconUrl;

/**
 * 描述内容
 */
@property(nonatomic, strong) TDFHealthCheckTextModel *subTitle;

/**
 * 状态文本
 */
@property(nonatomic, strong) NSString *status;

/**
 * 级别（0:一切正常/1:有待改进/2:急需优化）
 */
@property(nonatomic, assign) NSInteger  levelCode;

/**
 * 是否需要跳转至设置页面(0:否 / 1:是)
 */
@property(nonatomic, assign) NSInteger needSetting;
@end
