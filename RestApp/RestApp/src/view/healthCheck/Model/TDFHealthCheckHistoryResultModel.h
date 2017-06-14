//
//  TDFHealthCheckHistoryResultModel.h
//  RestApp
//
//  Created by 黄河 on 2016/12/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHealthCheckLevelModel.h"
@interface TDFHealthCheckHistoryResultModel : NSObject
/**
 * 是否成功(0:否 / 1:是)
 */
@property (nonatomic, assign)int isSuccess;

/**
 * 得分
 */
@property (nonatomic, assign)int score;

/**
 * 消息
 */
@property (nonatomic, strong)NSString *message;

/**
 * 项目总数
 */
@property (nonatomic, assign)int totalCnt;

/**
 * 问题数量
 */
@property (nonatomic, assign)int warnCnt;

/**
 * 体检项目
 */
@property (nonatomic, strong)NSArray<TDFHealthCheckLevelModel*>* levels;
@end
