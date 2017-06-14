//
//  TDFBusinessSummaryManager.h
//  RestApp
//
//  Created by happyo on 2016/11/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TDFRootViewController;
@class TDFBusinessSummaryManager;

@protocol TDFBusinessSummaryManagerDelegate <NSObject>

@optional
- (void)managerForwardDidClicked:(TDFBusinessSummaryManager *)manager withDayString:(NSString *)dayString;

- (void)manager:(TDFBusinessSummaryManager *)manager viewHeightChanged:(CGFloat)newHeight;

@end

@interface TDFBusinessSummaryManager : NSObject

@property (nonatomic, weak) TDFRootViewController *viewController;

@property (nonatomic, strong, readonly) UIView *view;

@property (nonatomic, weak) id<TDFBusinessSummaryManagerDelegate> delegate;

- (void)fetchBusinessData;

- (CGFloat)heightForView;

@end
