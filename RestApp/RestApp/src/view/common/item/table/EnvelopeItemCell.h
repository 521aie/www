//
//  CouponItemCell.h
//  RestApp
//
//  Created by 邵建青 on 15-1-13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Coupon.h"
#import <UIKit/UIKit.h>

#define ENVELOPE_ITEM_CELL @"ENVELOPE_ITEM_CELL"

#define ENVELOPE_ITEM_HEIGHT 120

@interface EnvelopeItemCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *shopLbl;
@property (nonatomic, strong) IBOutlet UILabel *statusLbl;
@property (nonatomic, strong) IBOutlet UILabel *nameLbl;
@property (nonatomic, strong) IBOutlet UILabel *unitLbl;
@property (nonatomic, strong) IBOutlet UILabel *periodLbl;
@property (nonatomic, strong) IBOutlet UILabel *publishLbl;
@property (nonatomic, strong) IBOutlet UIImageView *statusImg;

+ (id)getInstance;

- (void)initWithData:(Coupon *)coupon;

@end
