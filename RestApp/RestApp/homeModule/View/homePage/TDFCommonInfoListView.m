//
//  TDFCommonInfoListView.m
//  RestApp
//
//  Created by happyo on 2017/4/19.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFCommonInfoListView.h"
#import "TDFHomeReportListCell.h"

@implementation TDFCommonInfoListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    
    return self;
}

- (void)configureViewWithModelList:(NSArray<TDFHomeReportListCellModel *> *)modelList
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat viewWidth = self.bounds.size.width;
    
    CGFloat cellWidth = viewWidth / 3;
    
    CGFloat cellHeight = 50;
    
    NSInteger count = modelList.count;
    
    NSInteger lineNum = (count % 3 == 0) ? count /3 : count / 3 + 1;
    
    self.heightForView = lineNum * cellHeight;
    
//    if (self.heightForView != 0) {
//        self.heightForView += 10;
//    }
    
    for (int i = 0; i < modelList.count; i++) {
        TDFHomeReportListCellModel *cellModel = modelList[i];
        
        int line = i / 3;
        
        int column = i % 3;
        
        CGFloat x = 0;
        
        CGFloat y = 0;
        
        if (i % 3 == 0) {
            x = 0;
        } else {
            x = column * cellWidth + 1;
        }
        
        if (i / 3 == 0) {
            y = 0;
        } else {
            y = line * cellHeight + 1;
        }
        
        TDFHomeReportListCell *cell = [[TDFHomeReportListCell alloc] initWithFrame:CGRectMake(x, y, cellWidth, cellHeight)];
        
        cellModel.isShowSpliteLine = !(i % 3 == 2);
        
        if (i == modelList.count - 1) { // 如果是最后一个，则隐藏分割线
            cellModel.isShowSpliteLine = NO;
        }
        
        [cell configureViewWithModel:cellModel];
        
        
        [self addSubview:cell];
    }
}

@end
