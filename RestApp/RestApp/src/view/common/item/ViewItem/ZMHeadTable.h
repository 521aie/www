//
//  ZMTable.h
//  RestApp
//  此表格是用在节头没有删除，节内容有删除的列表.
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMTable.h"

@interface ZMHeadTable : ZMTable
@property (nonatomic, strong) NSMutableArray *headList;    //商品.
@property (nonatomic, strong) NSMutableDictionary *detailMap;

-(void) loadData:(NSMutableArray*)headList details:(NSMutableDictionary *)detailMap detailCount:(NSInteger)detailCount;

@end
