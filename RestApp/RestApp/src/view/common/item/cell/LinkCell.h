//
//  LinkCell.h
//  RestApp
//
//  Created by zxh on 14-7-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblVal;
@property (strong, nonatomic) IBOutlet UILabel *lblTip;
@property (strong, nonatomic) IBOutlet UIImageView *img;

@end
