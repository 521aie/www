//
//  SuitMenuItem.h
//  RestApp
//
//  Created by zxh on 14-8-25.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuitMenuSample.h"
#import "DHListSelectHandle.h"

@interface SuitMenuItem : UITableViewCell

@property (strong,nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblAccount;
@property (strong, nonatomic) IBOutlet UILabel *lblDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblImgName;

@property (strong, nonatomic) IBOutlet UILabel *lblSuit;
//@property (strong, nonatomic) IBOutlet UILabel *lblDishNum;

@property (strong, nonatomic) IBOutlet UIView *kabawView;
@property (strong, nonatomic) IBOutlet UIButton *btnKabaw;

@property (strong,nonatomic) SuitMenuSample* item;
@property (nonatomic,strong) id<DHListSelectHandle> delegate;

+ (id)getInstance;
-(void) loadItem:(SuitMenuSample*)data;
-(void) loadItem:(SuitMenuSample*)data delegate:(id<DHListSelectHandle>) handle;

-(IBAction)btnKabawClick:(id)sender;

@end
