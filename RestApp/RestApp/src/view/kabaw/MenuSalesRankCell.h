//
//  MenuSalesRankCell.h
//  RestApp
//
//  Created by xueyu on 16/1/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuStatisticsVo.h"
@interface MenuSalesRankCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *count;
-(void)initDataWithMenuStatisticsVo:(MenuStatisticsVo *)vo number:(NSInteger)number;
@end
