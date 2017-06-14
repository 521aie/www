//
//  TDFHomeGroupSectionView.h
//  Pods
//
//  Created by happyo on 2017/3/15.
//
//

#import <UIKit/UIKit.h>
@class TDFHomeGroupForwardChildCellModel;

@interface TDFHomeGroupSectionModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSArray<NSDictionary *> *cells;

@end

@interface TDFHomeGroupSectionView : UIView

@property (nonatomic, strong) void (^clickAction)(TDFHomeGroupForwardChildCellModel *model);

- (void)configureViewWithModel:(TDFHomeGroupSectionModel *)model;

- (CGFloat)heightForView;

@end
