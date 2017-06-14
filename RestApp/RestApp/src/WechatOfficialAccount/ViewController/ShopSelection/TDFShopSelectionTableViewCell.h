//
//  TDFShopSelectionTableViewCell.h
//  RestApp
//
//  Created by Octree on 13/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFShopSelectionItem.h"
#import "DHTTableViewCellProtocol.h"

@interface TDFShopSelectionTableViewCell : UITableViewCell <DHTTableViewCellDelegate>

@property (nonatomic) TDFShopSelectionState state;

@property (strong, nonatomic, readonly) UIImageView *selectionImageView;
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UILabel *subTitleLabel;
@property (strong, nonatomic, readonly) UIButton *statusButton;

@end
