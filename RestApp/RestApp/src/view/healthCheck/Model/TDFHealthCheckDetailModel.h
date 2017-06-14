//
//  TDFHealthChechDetailModel.h
//  RestApp
//
//  Created by guopin on 2016/12/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHealthCheckItemHeaderModel.h"
@interface TDFHealthCheckDetailModel : NSObject
/**
 * 头部
 */
@property (nonatomic, strong) TDFHealthCheckItemHeaderModel *header;

/**
 * 详情主体部分
 */
@property (nonatomic, strong) NSArray *components;


@end
