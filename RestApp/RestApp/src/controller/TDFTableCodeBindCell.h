//
//  TDFTableCodeBindCell.h
//  RestApp
//
//  Created by Octree on 6/9/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFTableCodeBindCell : UITableViewCell

@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UIButton *detailButton;
@property (strong, nonatomic, readonly) UIButton *scanButton;

@end
