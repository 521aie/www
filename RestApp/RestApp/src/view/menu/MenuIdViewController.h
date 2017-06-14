//
//  MenuIdViewController.h
//  RestApp
//
//  Created by zishu on 16/8/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "NavigateTitle2.h"
#import "TDFRootViewController.h"
#import "CopyFounctionLabel.h"

@interface MenuIdViewController : TDFRootViewController<CopyFounctionLabelEvent>

@property (nonatomic ,strong) NSString *menuName;
@property (nonatomic ,strong) NSString *menuId;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) CopyFounctionLabel *idLbel;
@property (nonatomic ,strong) UIView *line;
@property (nonatomic ,strong) UILabel *tipLabel;
@end
