//
//  SecondMenuCell.h
//  RestApp
//
//  Created by zxh on 14-3-20.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMenuAction.h"

#define MAVIGATOR_CELL_HEIGHT 95

@interface NavigatorCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblDetail;
@property (strong, nonatomic) IBOutlet UIImageView *imgLock;
@property (strong, nonatomic) IBOutlet UIImageView *imgMenu;

+ (id)getInstance;

- (void)initWithData:(UIMenuAction *)menuAction;

@end
