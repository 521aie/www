//
//  TDFWXMarketingMenuCell.h
//  RestApp
//
//  Created by Octree on 9/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFExpanableLabel.h"

@interface TDFWXMarketingMenuCell : UITableViewCell

@property (strong, nonatomic, readonly) UIImageView *iconImageView;
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UILabel *detailLabel;
@property (strong, nonatomic, readonly) TDFExpanableLabel *badgeLabel;
@property (strong, nonatomic, readonly) UIImageView *indicatorImageView;
@property (assign, nonatomic) CGFloat viewalpha;
@property (assign, nonatomic) BOOL isShowindicatorImageView;
@property (nonatomic, strong) UILabel *versionLabel;
- (void)updateLayout;

@end
