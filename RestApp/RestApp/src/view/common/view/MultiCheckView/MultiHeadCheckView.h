//
//  MultiHeadCheckView.h
//  RestApp
//
//  Created by zxh on 14-10-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MultiCheckView.h"

@interface MultiHeadCheckView : MultiCheckView

@property (nonatomic, strong) NSMutableArray *headList;    //商品.
@property (nonatomic, strong) NSMutableDictionary *detailMap;

- (void)loadData:(NSMutableArray*) headList detalMap:(NSMutableDictionary*)detailMap selectList:(NSMutableArray*) selectList;

- (void)reLoadData:(NSMutableArray*) headList detalMap:(NSMutableDictionary*)detailMap;

@end
