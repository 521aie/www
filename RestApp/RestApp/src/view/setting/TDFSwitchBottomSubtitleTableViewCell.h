//
//  TDFSwitchBottomSubtitleTableViewCell.h
//  RestApp
//
//  Created by chaiweiwei on 2017/3/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopVO.h"

@interface TDFSwitchBottomSubtitleTableViewCell : UITableViewCell

@property (nonatomic,strong) ShopVO *model;

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UILabel *detailLable;

@property (nonatomic,strong) UILabel *tagLable;

@property (nonatomic, strong) UIButton *btnSwitch;

@property (nonatomic,strong) UILabel *lblTip;

@property (nonatomic,copy) void (^filterBlock)(BOOL isOn);

@end
