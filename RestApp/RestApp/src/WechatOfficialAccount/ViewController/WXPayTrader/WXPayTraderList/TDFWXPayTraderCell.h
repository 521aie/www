//
//  TDFWXPayTraderCell.h
//  RestApp
//
//  Created by Octree on 16/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFWXPayTraderCell : UITableViewCell

@property (strong, nonatomic, readonly) UILabel *nameLabel;
@property (strong, nonatomic, readonly) UILabel *badgeLabel;
@property (strong, nonatomic, readonly) UIButton *detailButton;
@property (copy, nonatomic) void (^buttonBlock)();

@end
