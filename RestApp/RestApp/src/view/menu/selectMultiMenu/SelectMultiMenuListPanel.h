//
//  SelectMenuListPanel.h
//  RestApp
//
//  Created by zxh on 14-5-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "DHListPanel.h"
#import "Platform.h"
#import "RestConstants.h"
#import "ColorHelper.h"
@interface SelectMultiMenuListPanel : DHListPanel
{
    NSMutableArray *selectDataSet;
}

- (void)initSelectData:(NSArray *)selectData;

- (NSMutableArray *)getSelectDatas;

- (void)selectAll;

-(void)deSelectAll;

- (void)refreshDataView;

@end
