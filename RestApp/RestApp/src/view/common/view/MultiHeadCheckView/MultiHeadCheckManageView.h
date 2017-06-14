//
//  MultiHeadCheckView.h
//  RestApp
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiCheckManageView.h"

@interface MultiHeadCheckManageView : MultiCheckManageView

@property (nonatomic, strong) NSMutableArray *headList;    //商品.
@property (nonatomic, strong) NSMutableDictionary *detailMap;

- (void)loadData:(NSMutableArray*) headList detalMap:(NSMutableDictionary*)detailMap selectList:(NSMutableArray*) selectList;

- (void)reLoadData:(NSMutableArray*) headList detalMap:(NSMutableDictionary*)detailMap;

@end
