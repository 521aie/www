//
//  SelectMenuClient.h
//  RestApp
//
//  Created by 邵建青 on 14-12-12.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SampleMenuVO.h"
#import <Foundation/Foundation.h>

@protocol SelectMenuClient <NSObject>

-(void) closeView;

- (void)finishSelectList:(NSArray *)list;

@optional
- (void)finishSelectMenu:(SampleMenuVO *)menu;

// 仓库管理用（供应商项目添加）
- (void)selectDatasFinish:(NSMutableArray *)list;

@end
