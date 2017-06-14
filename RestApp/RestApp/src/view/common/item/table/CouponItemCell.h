//
//  CouponItemCell.h
//  RestApp
//
//  Created by 邵建青 on 15-1-13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Coupon.h"
#import <UIKit/UIKit.h>

#define COUPON_ITEM_CELL @"COUPON_ITEM_CELL"

#define COUPON_ITEM_HEIGHT 140

@interface CouponItemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *statusImg;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *statusLbl;
@property (strong, nonatomic) IBOutlet UILabel *periodLbl;
@property (strong, nonatomic) IBOutlet UILabel *memoLbl;
@property (strong, nonatomic) IBOutlet UILabel *publishLbl;

+ (id)getInstance;

- (void)initWithData:(Coupon *)coupon;

@end
