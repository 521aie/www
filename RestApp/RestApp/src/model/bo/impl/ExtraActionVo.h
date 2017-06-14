//
//  ExtraActionVo.h
//  RestApp
//
//  Created by zishu on 16/7/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ExtraAction.h"

@interface ExtraActionVo : Jastor
@property (nonatomic, strong) NSString *id;
/**
 * 保存的值
 */
@property(nonatomic, strong) NSString *value;
/**
 * <code>编码</code>.
 */
@property (nonatomic,retain) NSString *code;
@end
