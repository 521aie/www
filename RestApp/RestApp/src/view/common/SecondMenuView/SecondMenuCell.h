//
//  SecondMenuCell.h
//  RestApp
//
//  Created by zxh on 14-3-20.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 列表相关 **/
#define MAIN_MENU_ITEM_HEIGHT 92


@interface SecondMenuCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *bgView;
@property (nonatomic, strong) IBOutlet UIImageView *imgMenu;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblDetail;
@property (nonatomic, strong) IBOutlet UIImageView *imgLock;
@property (nonatomic, strong) IBOutlet UIImageView *img_next;
//@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIImageView *warningImageView;

@end
