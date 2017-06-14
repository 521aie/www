//
//  TDFHomeTwoInLineView.h
//  Pods
//
//  Created by happyo on 2017/3/11.
//
//

#import <UIKit/UIKit.h>

@interface TDFHomeTwoInLineCellModel : NSObject

@property (nonatomic, strong) NSString *_id;

@property (nonatomic, strong) NSString *iconUrl;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *subTitle;

@property (nonatomic, strong) NSString *actionCode;

@property (nonatomic, assign) BOOL isHide;

@property (nonatomic, assign) BOOL isLock;

@property (nonatomic, assign) BOOL isOpen;

@end

@interface TDFHomeTwoInLineCellView : UIView

- (void)configureViewWithModel:(TDFHomeTwoInLineCellModel *)model;

@end

@interface TDFHomeTwoInLineView : UIView

@property (nonatomic, strong) void (^clickAction)(TDFHomeTwoInLineCellModel *model);

- (void)configureViewWithModelList:(NSArray<TDFHomeTwoInLineCellModel *> *)modelList;

- (CGFloat)heightForView;

@end
