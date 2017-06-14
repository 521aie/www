//
//  MenuTimePriceCell.h
//  RestApp
//
//  Created by zxh on 14-6-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrikeLabel.h"
#import "MenuTimePrice.h"
#import "ISampleListEvent.h"
#import "MenuTime.h"

@interface MenuTimePriceCell : UITableViewCell<UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet StrikeLabel *lblOrign;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblRatio;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscountRatio;

@property (strong, nonatomic) IBOutlet UIView *discountView;
@property (strong, nonatomic) IBOutlet UIView * perferentialView;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscount;

@property (strong, nonatomic) IBOutlet UIImageView *imgRatio;
@property (strong, nonatomic) IBOutlet UIImageView *imgDiscountRatio;
@property (strong, nonatomic) IBOutlet UIImageView *imgDel;

@property (nonatomic,strong) id<ISampleListEvent> delegate;
@property (strong, nonatomic) MenuTimePrice* obj;
@property (strong, nonatomic) MenuTime *menuTime;

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(MenuTimePrice*)objTemp meuTime:(MenuTime *)menuTime;
-(IBAction) btnDelClick:(id)sender;


@end
