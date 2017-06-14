//
//  TDFHealthCheckResultModel.h
//  RestApp
//
//  Created by 黄河 on 2016/12/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHealthCheckItemHeaderModel.h"
#import "TDFHealthCheckLevelModel.h"
@interface TDFHealthCheckResultModel : NSObject

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
 * 体检项目Id
 */
@property (nonatomic, strong)NSString* resultId;

/**
 * 击败多少店家
 */
@property (nonatomic, strong) NSString *beatRatio;

/**
 * 体检项目
 */
@property (nonatomic, strong)NSArray<TDFHealthCheckItemHeaderModel*>* healthItems;

/**
 * 体检项目
 */
@property (nonatomic, strong)NSArray<TDFHealthCheckLevelModel*>* levels;

@end
