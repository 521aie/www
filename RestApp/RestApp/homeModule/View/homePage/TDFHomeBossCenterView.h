//
//  TDFHomeBossCenterView.h
//  RestApp
//
//  Created by happyo on 2017/6/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFHomeBossCenterModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *actionCode;

@property (nonatomic, strong) NSString *caseImage;

@property (nonatomic, strong) NSString *iconImage;

@property (nonatomic, strong) NSString *clickUrl;

@property (nonatomic, assign) BOOL hasUnReadCase;

@property (nonatomic, strong) NSArray<NSString *> *marketingCaseList;

@end

@interface TDFHomeBossCenterView : UIView

@property (nonatomic, strong) void (^clickBlock)(NSString *url);

- (void)configureViewWithModel:(TDFHomeBossCenterModel *)model;

+ (CGFloat)heightForView;

@end
