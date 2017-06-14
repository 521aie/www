//
//  NavigateMenuFristCell.h
//  RestApp
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickStep.h"
@interface NavigateMenuFristCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *sectionview;

@property (weak, nonatomic) IBOutlet UIView *indexview;
@property (weak, nonatomic) IBOutlet UIImageView *imgLock;
@property (weak, nonatomic) IBOutlet UIImageView *imgVer;
@property (weak, nonatomic) IBOutlet UILabel *LblActName;

@property (weak, nonatomic) IBOutlet UILabel *sectionlbl;
- (void)loadData:(QuickStep *)step;
- (void)loadImageData:(NSString  *)imgstr;
- (void)loadtablbl:(NSString *)lbl;
@end
