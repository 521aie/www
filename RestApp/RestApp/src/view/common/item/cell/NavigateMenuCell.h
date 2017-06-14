//
//  NavigateMenuCell.h
//  RestApp
//
//  Created by zxh on 14-5-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickStep.h"

#define NAVIGATE_MENU_CELL_HEIGHT 34

@interface NavigateMenuCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgCheck;
@property (strong, nonatomic) IBOutlet UIImageView *imgNoCheck;
@property (strong, nonatomic) IBOutlet UILabel *lblStepName;
@property (strong, nonatomic) IBOutlet UILabel *lblActName;
@property (strong, nonatomic) IBOutlet UILabel *lblActDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblNum;  //数字
@property (strong, nonatomic) IBOutlet UIImageView *imgLock;
@property (strong, nonatomic) IBOutlet UIButton *btnRequire;
@property (strong, nonatomic) IBOutlet UIImageView *imgVer;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) QuickStep* quickStep;
@property (weak, nonatomic) IBOutlet UIView *line;

- (void)loadData:(QuickStep *)step;
- (void)loadImageData:(NSString  *)imgstr;

@end

