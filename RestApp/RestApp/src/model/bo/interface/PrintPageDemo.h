//
//  PrintPageDemo.h
//  RestApp
//
//  Created by zxh on 14-4-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BasePrintPageDemo.h"

@interface PrintPageDemo : BasePrintPageDemo
/**
 * <code>数据来源</code>.
 */
@property short type;

/**
 * <code>打印页模板ID</code>.
 */
@property (nonatomic,retain) NSString *pageDemoId;

/** 预览图路径 */
@property (nonatomic,retain) NSString *filePath;

@end
