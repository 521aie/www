//
//  TDFHealthCheckBarCell.h
//  ClassProperties
//
//  Created by xueyu on 2016/12/19.
//  Copyright © 2016年 ximi. All rights reserved.
//

#import <UIKit/UIKit.h>
//（0:无 / 1:结果-环图 / 2:结果-饼图 / 3:结果-柱状图 / 4:结果-图片 / 5:优化方案-按钮及视频
typedef NS_ENUM(NSUInteger, TDFHealthCheckCellStyle){
    TDFCellStyleNone = 0,
    TDFCellStyleCycle,
    TDFCellStylePie,
    TDFCellStyleBar,
    TDFCellStyleImage,
    TDFCellStyleScheme
};
@interface TDFHealthCheckCycleCell : UITableViewCell
+(CGFloat)heightForCellAtIndexPath:(UITableView *)tableView model:(id)data;
@end
