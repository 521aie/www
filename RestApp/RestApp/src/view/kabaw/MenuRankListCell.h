//
//  MenuRankListCell.h
//  RestApp
//
//  Created by guopin on 16/1/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuStatisticsVo.h"
@interface MenuRankListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *menuName;
@property (weak, nonatomic) IBOutlet UILabel *counts;
-(void)initDataWithMenuStatisticsVo:(MenuStatisticsVo *)vo;
@end
