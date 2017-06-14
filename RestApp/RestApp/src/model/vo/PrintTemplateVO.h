//
//  PrintTemplateVO.h
//  RestApp
//
//  Created by zxh on 14-4-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "PrintPageDemo.h"
#import "INameItem.h"

@interface PrintTemplateVO : PrintPageDemo<INameItem>
/**
 * <code>模板来源</code>.
 */
@property short templateSource;

@end
