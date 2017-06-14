//
//  SeatItem.h
//  RestApp
//
//  Created by zxh on 14-4-13.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Seat.h"

@interface SeatItem : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblDetail;
@property (nonatomic, strong) IBOutlet UIImageView *imgType;
@property (nonatomic, strong) Seat* seat;

@end
