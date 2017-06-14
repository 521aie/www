//
//  TDFShopTurnCollCell.h
//  RestApp
//
//  Created by Cloud on 2017/3/31.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFShopTurnItem : NSObject

@property (nonatomic ,copy) NSString *titleStr;

@property (nonatomic ,copy) NSMutableAttributedString *detail;

- (instancetype)initWithTitle:(NSString *)title andDetail:(NSMutableAttributedString *)detail;

@end

@interface TDFShopTurnCollCell : UICollectionViewCell

- (void)configWithItem:(TDFShopTurnItem *)item andIndex:(NSInteger )index;

@end
