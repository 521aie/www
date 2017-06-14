//
//  TDFMenuPromptView.h
//  RestApp
//
//  Created by Octree on 20/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TDFMenuPromptView : UIView

@property (strong, nonatomic, readonly) UILabel *promptLabel;
@property (strong, nonatomic, readonly) UIButton *closeButton;

+ (instancetype)promptViewWithTitle:(NSString *)title closeBlock:(void(^)())block;

@end
