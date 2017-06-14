//
//  MenuSalesRankCell.m
//  RestApp
//
//  Created by xueyu on 16/1/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuSalesRankCell.h"

@implementation MenuSalesRankCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initDataWithMenuStatisticsVo:(MenuStatisticsVo *)vo number:(NSInteger)number{

    self.number.text = [NSString stringWithFormat:@"%ld",number];
    self.name.text = vo.name;
    self.count.text = [NSString stringWithFormat:NSLocalizedString(@"%ld份", nil),vo.count];
}
@end
