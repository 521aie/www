//
//  MenuItemCell.h
//  RestApp
//
//  Created by zxh on 14-5-6.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleMenuVO.h"
#import "DHListSelectHandle.h"

@interface MenuItemCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic)  UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblAccount;
@property (strong, nonatomic) IBOutlet UIButton *btnMember;
@property (strong, nonatomic) IBOutlet UILabel *lblDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblImgName;
@property (weak, nonatomic) IBOutlet UIView *imgView;


@property (strong, nonatomic) IBOutlet UIView *kabawView;
@property (strong, nonatomic) IBOutlet UIButton *btnKabaw;
@property (weak, nonatomic) IBOutlet UILabel *lblOriginPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblRedLine;
@property (strong, nonatomic) UIImageView *lblIschain;

@property (strong,nonatomic) SampleMenuVO* item;
@property (nonatomic,strong) id<DHListSelectHandle> delegate;

+ (id)getInstance;

- (void)loadItem:(SampleMenuVO *)data;

- (void)loadItem:(SampleMenuVO *)data delegate:(id<DHListSelectHandle>) handle;

-(IBAction)btnKabawClick:(id)sender;

@end
