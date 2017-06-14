//
//  TDFHealthCheckTextModel.h
//  RestApp
//
//  Created by 黄河 on 2016/12/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFHealthCheckTextModel : NSObject
/**
 * 原始文本 占位符：{0}
 */
@property (nonatomic, strong)NSString *originalStr;

/**
 * 替换文本
 */
@property (nonatomic, strong)NSArray<NSString*> *replaceStrs;

/**
 * 色号
 */
@property (nonatomic, strong)NSArray<NSString *> *colors;
@end
