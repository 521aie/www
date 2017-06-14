//
//  TDFWaveWithSideView.h
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/11/28.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFWaveWithSideView : UIView

@property (nonatomic, assign)CGFloat score;

@property (nonatomic, assign) NSInteger waterHeight;

@property (nonatomic, strong)NSString *attentionText;

@property (nonatomic, assign)BOOL isShowAttentionText;

@property (nonatomic, strong) NSArray<NSDictionary *> *colorRules;
///没体检或者重新体检
@property (nonatomic, assign)BOOL isNoScore;

@property (nonatomic, copy)void(^touchClick)();

- (instancetype)initWithFrame:(CGRect)frame withRadius:(CGFloat)radius;

- (void)updateHeight:(NSInteger)waterHeight;

- (void)updateColorWithType:(NSInteger)colorType;

@end
