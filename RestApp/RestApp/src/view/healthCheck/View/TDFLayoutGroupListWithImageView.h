//
//  TDFLayoutGroupListWithImageView.h
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/12/13.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFLayoutGroupListWithImageView :UIView

@property (nonatomic, assign)BOOL isShowDetail;

@property (nonatomic, strong)UILabel *infoLabel;

@property (nonatomic, strong)UIImageView *infoImageView;

@property (nonatomic, strong)UILabel *detailLabel;

@property (nonatomic, strong)UIImageView *detailImageView;

+ (instancetype)listViewWithSpacing:(CGFloat)space;



//- (void)setInfoLabelText:(NSString *)text
//            andTextColor:(UIColor *)textColor
//        andInfoImageView:(NSString *)imageView;
//
//- (void)setInfoLabelText:(NSString *)text
//            andTextColor:(UIColor *)textColor
//        andInfoImageView:(NSString *)imageViewName
//      andDetailLabelText:(NSString *)detailText
//          andDetailLabel:(NSString *)detailImageViewName;

@end
