//
//  SeatItemCell.h
//  RestApp
//
//  Created by zxh on 14-10-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHListSelectHandle.h"

@class Seat;
@interface SeatItemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *iconView;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *lblType;

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblDetail;

@property (strong, nonatomic) Seat* item;
@property (strong, nonatomic) id<DHListSelectHandle> delegate;

- (void)loadItem:(Seat*)data delegate:(id<DHListSelectHandle>) handle;

@end
