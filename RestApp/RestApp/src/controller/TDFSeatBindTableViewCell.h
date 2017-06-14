//
//  TDFSeatBindTableViewCell.h
//  RestApp
//
//  Created by Octree on 8/12/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


/// height 102
@interface TDFSeatBindTableViewCell : UITableViewCell

@property (strong, nonatomic, readonly) UIImageView *iconImageView;
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UILabel *detailLabel;
@property (strong, nonatomic, readonly) UIButton *removeButton;
@property (strong, nonatomic, readonly) UIView *iconContainerView;
@property (strong, nonatomic, readonly) UILabel *typeLabel;
@property (strong, nonatomic) void (^removeBlock)();

@end
