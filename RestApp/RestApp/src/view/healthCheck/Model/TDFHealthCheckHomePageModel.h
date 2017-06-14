//
//  TDFHealthCheckHomePageModel.h
//  RestApp
//
//  Created by 黄河 on 2016/12/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFHealthCheckHomePageModel : NSObject

/**
 * 体检是否上锁(0:否/1:是)
 */
@property (nonatomic, assign)int isLocked;

/**
 * 是否是首次体检（0:否 / 1:是）
 */
@property (nonatomic, assign)int isFirstTime;

/**
 * 体检结果ID
 */
@property (nonatomic, strong)NSString* resultId;

/**
 * 得分
 */
@property (nonatomic, assign)int score;

/**
 * 总分
 */
@property (nonatomic, assign) int totalScore;

/**
 * 水波的高度
 */
@property (nonatomic, assign) int waterLineHeight;

/**
 * 首页体检球颜色
 */
@property (nonatomic, assign) int ballColor;

/**
 * 体检页 体检球颜色变化规则
 */
@property (nonatomic, strong) NSArray<NSDictionary *> *colorRules;

/**
 * 消息
 */
@property (nonatomic, strong)NSString* message;


/**
 * 掌柜是否需要升级（0/否 ,1/是）
 */
@property (nonatomic, assign)int needUpdate;

/**
 * 版本升级提示消息
 */
@property (nonatomic, strong)NSString *updateMessage;

/**
 *
 */
@property (nonatomic, strong)NSString *updateUrl;

@end
