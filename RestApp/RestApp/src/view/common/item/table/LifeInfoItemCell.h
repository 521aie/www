//
//  CouponItemCell.h
//  RestApp
//
//  Created by 邵建青 on 15-1-13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notification.h"

#define LIFE_INFO_TOP_MARGIN 10
#define LIFE_INFO_BTM_MARGIN 20
#define LIFE_INFO_HEAD_HEIGHT 40

#define LIFEINFO_ITEM_CELL @"LIFEINFO_ITEM_CELL"

@class LifeInfoListView;
@interface LifeInfoItemCell : UITableViewCell
{
    LifeInfoListView *parent;
    
    Notification *notification;
    
    NSArray *subViews;
    
    CGFloat height;
    
    CGFloat minLabelHeight;
}
@property (weak, nonatomic) IBOutlet UILabel *lblOverdue;
@property (nonatomic,assign) BOOL isOverdue;
@property (nonatomic, strong) IBOutlet UIView *timeBg;
@property (nonatomic, strong) IBOutlet UILabel *timeLbl;
@property (nonatomic, strong) IBOutlet UILabel *titleLbl;
@property (nonatomic, strong) IBOutlet UILabel *kindCardLbl;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UIView *separateLine;
@property (nonatomic, strong) IBOutlet UIView *containerBg;
@property (nonatomic, strong) IBOutlet UILabel *contentLbl;
@property (nonatomic, strong) IBOutlet UIButton *itemBtn;
@property (nonatomic, strong) IBOutlet UIView *imageContainer;
@property (nonatomic, strong) IBOutlet UIImageView *infoImg;

+ (id)getInstance:(LifeInfoListView *)parent;

+ (CGFloat)calculateItemHeight:(Notification *)note;

- (void)initWithData:(Notification *)notification;

- (IBAction)deleteLifeInfo:(id)sender;

- (IBAction)itemBtnClick:(id)sender;

@end
