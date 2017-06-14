//
//  TDFLayoutGroupListView.h
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/12/13.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFLayoutGroupListView : UIView

+ (instancetype)listViewWithSpacing:(CGFloat)space;

@property (nonatomic, assign)BOOL isShowDetail;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *detailLabel;

@end
