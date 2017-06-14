//
//  TDFHomeReportView.h
//  Pods
//
//  Created by happyo on 2017/3/8.
//
//

#import <UIKit/UIKit.h>

@interface TDFHomeReportModel : NSObject

@property (nonatomic, copy) NSString *helpUrl;

@property (nonatomic, copy) NSString *forwardUrl;

@property (nonatomic, copy) NSString *forwardDescription;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *iconImage;

@property (nonatomic, copy) NSString *number;

@property (nonatomic, copy) NSString *numberUnit;

@property (nonatomic, copy) NSString *count;

@property (nonatomic, copy) NSString *countUnit;

@property (nonatomic, copy) NSString *extensionUrl;

@property (nonatomic, copy) NSString *reportStyle;

@property (nonatomic, assign) BOOL isFold;

@property (nonatomic, copy) NSArray<NSDictionary *> *reportModel;

@end

@interface TDFHomeReportView : UIView

@property (nonatomic, strong) void (^viewHeightChanged)(CGFloat newHeight);

@property (nonatomic, strong) void (^fetchExtensionData)(NSString *serviceName);

@property (nonatomic, strong) void (^forwardWithUrlBlock)(NSString *forwardUrl);

- (void)configureViewWithModel:(TDFHomeReportModel *)model;

- (CGFloat)heightForView;

@end
