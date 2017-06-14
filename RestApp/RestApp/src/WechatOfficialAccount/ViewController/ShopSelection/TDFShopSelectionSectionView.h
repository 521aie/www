//
//  TDFShopSelectionSectionView.h
//  RestApp
//
//  Created by Octree on 13/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BranchShopVo.h"

@interface TDFShopSelectionSectionView : UIView

@property (strong, nonatomic, readonly) UIButton *selectionButton;
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic) void(^selectionBlock)();
//@property (strong, nonatomic) BranchShopVo *branch;

@end
