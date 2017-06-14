//
//  KindMenuDetailVo.h
//  RestApp
//
//  Created by zishu on 16/9/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdditionKindMenuVo.h"
#import "KindAndTasteVo.h"
@interface KindMenuDetailVo : NSObject
@property(nonatomic, strong) NSMutableArray *additionKindMenuVoList;

@property(nonatomic, strong) NSMutableArray *kindAndTasteVoList;

@end
