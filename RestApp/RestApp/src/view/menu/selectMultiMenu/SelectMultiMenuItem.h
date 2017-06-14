//
//  SelectMenuItem.h
//  RestApp
//
//  Created by zxh on 14-5-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SampleMenuVO,chainEmployeeData;
@interface SelectMultiMenuItem : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIImageView *imgCheck;
@property (strong, nonatomic) IBOutlet UIImageView *imgUnCheck;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *lblVal;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIImageView *isChainLbl;

@property (strong,nonatomic) SampleMenuVO* item;

-(void) loadItem:(SampleMenuVO*)data;

-(void) loadChainItem:(chainEmployeeData*)data;

- (void)IsHide:(BOOL)hide;
@end
