//
//  ShopCustomEvaluateCell.h
//  RestApp
//
//  Created by iOS香肠 on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopEvaluateCellData.h"

#define  ShopCustomEvaluateCellIndentifier @"ShopCustomEvaluateCellIndentifier"

@interface ShopCustomEvaluateCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *customerNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *createdAt;
@property (nonatomic, strong) IBOutlet UILabel *commentLabel;
@property (nonatomic, strong) IBOutlet UIImageView *icoImage;
@property (nonatomic, strong) IBOutlet UIView *background;

+ (CGFloat)totalHeight:(ShopEvaluateCellData *)commentData;

- (void)initWithData:(ShopEvaluateCellData *)data;

@end
