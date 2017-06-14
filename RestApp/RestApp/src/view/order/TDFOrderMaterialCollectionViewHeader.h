//
//  TDFOrderMaterialCollectionViewHeader.h
//  RestApp
//
//  Created by QiYa on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFOrderMaterialCollectionViewHeader : UICollectionReusableView
@property (nonatomic, strong)UILabel *titleLabel;
+ (CGFloat)headerHeight;
@end
