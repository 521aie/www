//
//  ShopEvaluateHeader.h
//  RestApp
//
//  Created by iOS香肠 on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarRatingView.h"
#import "ShopEvaluateViewData.h"

#define TOPVIEW_BTN_HEIGHT 100
#define SHOPOPERATE_BTN_HEIGHT 40

@class  ShopEvaluateView;
@interface ShopEvaluateHeader : UIView
{
    ShopEvaluateView *evaluateView;
    
    CGFloat collapseHeight;
    
    CGFloat expandedHeight;
    
    BOOL isExpanded;
}
@property (nonatomic, strong) IBOutlet UILabel *ShopnameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *Icoimage;
@property (nonatomic, strong) IBOutlet UIImageView *picImage;
@property (nonatomic, strong) IBOutlet UILabel *goooPredicLabel;
@property (nonatomic, strong) IBOutlet UIImageView *tasteimage;
@property (nonatomic, strong) IBOutlet UIImageView *speedimage;
@property (nonatomic, strong) IBOutlet UILabel *environmentLabel;
@property (nonatomic, strong) IBOutlet UIImageView *environmentimage;
@property (nonatomic, strong) IBOutlet UILabel *tasteLabel;
@property (nonatomic, strong) IBOutlet UILabel *speedLabel;
@property (nonatomic, strong) IBOutlet UIView *Topview;
@property (nonatomic, strong) IBOutlet UIView *listContainer;
@property (nonatomic, strong) UIView *operContainer;
@property (nonatomic, strong) StarRatingView *tasteSign;
@property (nonatomic, strong) StarRatingView *speedSign;
@property (nonatomic, strong) StarRatingView *environmentSign;
@property (nonatomic, strong) NSMutableArray *shopEvaluateDataList;

+ (ShopEvaluateHeader *)createShopEvaluateHeader:(ShopEvaluateView *)evaluateView;

- (void)initWithData:(ShopEvaluateViewData *)shopEvaluateViewData;

- (IBAction)operateBtnClick:(id)sender;

- (void)collapseHeader;

- (void)expandeHeader;

@end
