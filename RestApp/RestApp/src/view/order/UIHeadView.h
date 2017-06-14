//
//  UIHeadView.h
//  RestApp
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHeadTitle.h"

#define UIHEADVIEWHEIGHT  220

@interface UIHeadView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (nonatomic ,assign) id<TitleClickButton>delegate;
- (void) initdelegate:(id<TitleClickButton>)delgate;
- (IBAction) btnClick:(UIButton *)sender;

@end
