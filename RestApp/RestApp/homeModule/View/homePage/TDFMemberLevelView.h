//
//  TDFMemberLevelView.h
//  Pods
//
//  Created by happyo on 2017/4/7.
//
//

#import <UIKit/UIKit.h>

@interface TDFMemberLevelCellModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *countUnit;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSString *percent;

@property (nonatomic, strong) UIColor *rectColor;

/**
 柱子的高度
 */
@property (nonatomic, assign) CGFloat height;

@end

@interface TDFMemberLevelCell : UIView

- (void)configureCellWithModel:(TDFMemberLevelCellModel *)model;

@end


@interface TDFMemberLevelModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSArray<TDFMemberLevelCellModel *> *barCells;

@end

@interface TDFMemberLevelView : UIView

- (void)configureViewWithModel:(TDFMemberLevelModel *)model;

- (CGFloat)heightForView;

@end
