//
//  TDFHomeReportMemberView.h
//  Pods
//
//  Created by happyo on 2017/3/30.
//
//

#import <UIKit/UIKit.h>
#import "TDFMemberLevelView.h"
#import "TDFHomeReportListCell.h"

@interface TDFHomeReportMemberModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSArray<TDFHomeReportListCellModel *> *commonCells;

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) TDFMemberLevelModel *memberBarModel;

@end

@interface TDFHomeReportMemberView : UIView

@property (nonatomic, strong) NSString *forwardUrl;

@property (nonatomic, strong) NSString *forwardString;

@property (nonatomic, strong) void (^forwardWithUrlBlock)(NSString *forwardUrl);

- (void)configureViewWithModel:(TDFHomeReportMemberModel *)model;

- (CGFloat)heightForView;

@end
