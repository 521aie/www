//
//  MySelectMultiMenuListPanel.h
//  RestApp
//
//  Created by 刘红琳 on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DHListPanel.h"
#import "SampleMenuVO.h"
@interface MySelectMultiMenuListPanel : DHListPanel

@property (nonatomic, strong) NSMutableArray *selectDataSet;
@property (nonatomic, strong) NSMutableArray *detailList;
@property (nonatomic, strong) NSString *ratio;

- (void)initDelegate:(id<DHListSelectHandle>)delegate headChange:(NSString *)headChangeEvent detailChange:(NSString *)detailChangeEvent;

- (void)initDataWithDetailMap:(NSMutableDictionary *)detailMap withRatio:(NSString *)ratio;

- (void)refreshDataView;

@end