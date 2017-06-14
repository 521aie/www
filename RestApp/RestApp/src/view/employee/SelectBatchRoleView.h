//
//  SelectBatchRoleView.h
//  RestApp
//
//  Created by zxh on 14-10-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MultiCheckView.h"
#import "HeadCheckHandle.h"

@interface SelectBatchRoleView : MultiCheckView<HeadCheckHandle>

@property (nonatomic, strong) NSMutableArray *nodeList;    //节点.
@property (nonatomic, strong) NSMutableArray *selectIdSet;

- (void)loadData:(NSMutableArray*)nodeList;

@end
