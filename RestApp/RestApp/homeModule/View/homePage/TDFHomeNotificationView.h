//
//  TDFHomeNotificationView.h
//  Pods
//
//  Created by happyo on 2017/3/9.
//
//

#import <UIKit/UIKit.h>

@interface TDFHomeNotificationModel : NSObject

@property (nonatomic, copy) NSString *iconImage;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *forwardDescription;

@property (nonatomic, copy) NSString *forwardUrl;

@end

@interface TDFHomeNotificationView : UIView

- (void)configureViewWithModel:(TDFHomeNotificationModel *)model;

@end
