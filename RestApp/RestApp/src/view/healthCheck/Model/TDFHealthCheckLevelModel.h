//
//  TDFHealthCheckLevelModel.h
//  RestApp
//
//  Created by 黄河 on 2016/12/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHealthCheckItemHeaderModel.h"
@interface TDFHealthCheckLevelModel : NSObject

/**
 * 级别编号（0:一切正常/1:有待改进/2:急需优化）
 */
@property (nonatomic, assign)int levelCode;

/**
 * 级别名称
 */
@property (nonatomic, strong)NSString *levelName;

@property (nonatomic, strong) NSString *extraStr;

/**
 * 体检结果为该级别下的体检项目
 */
@property (nonatomic, strong)NSArray<TDFHealthCheckItemHeaderModel*>*healthItems;

@end
