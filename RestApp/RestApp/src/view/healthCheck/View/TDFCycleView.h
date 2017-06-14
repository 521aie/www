//
//  TDFCycleView.h
//  ClassProperties
//
//  Created by xueyu on 2016/12/7.
//  Copyright © 2016年 ximi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFCycleView : UIView
-(void)loadDatas:(id)data;
- (void)drawProgress:(CGFloat )progress;
-(void)setLineWidth:(CGFloat)lineWidth;
@end
