//
//  BillModifyCell.h
//  RestApp
//
//  Created by LSArlen on 2017/6/12.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillModifyCell : UITableViewCell

@property (nonatomic, strong) UIImageView *img_next;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblDetail;

+ (CGFloat)cell_height;

@end
