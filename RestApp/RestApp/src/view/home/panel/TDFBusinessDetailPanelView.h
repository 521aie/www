//
//  TDFBusinessDetailPanelView.h
//  RestApp
//
//  Created by 黄河 on 16/9/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFDataHeaderView : UIView
@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UIImageView *imageView;
@end

@interface TDFDataTitleInfoView : UIView
@property (nonatomic, strong)UIButton *dateButton;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *detailLabel;
@end

@interface TDFDataInfoDetailView : UIView
@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *dataLabel;

@property (nonatomic, strong) UILabel *lblDescription;

@end

@interface TDFDataInfoView : UIView

@property (nonatomic, strong)NSArray *dataTitleArray;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong) NSArray *descriptionArray;
@property (nonatomic, assign) CGFloat cellWidthd;

- (CGFloat)heightForView;

@end
@protocol TDFBusinessDetailPanelViewDelegate <NSObject>

@optional
- (void)touchUpClick;
@end

@interface TDFBusinessDetailPanelView : UIControl

@property (nonatomic, strong)TDFDataHeaderView *headerView;

@property (nonatomic, strong)TDFDataTitleInfoView *titleInfoView;

@property (nonatomic, strong)TDFDataInfoView *infoView;
@property (nonatomic, weak)id<TDFBusinessDetailPanelViewDelegate> delegate;

@property (nonatomic, strong)NSArray *dataTitleArray;
@property (nonatomic, strong)NSArray *dataArray;


- (void)initDataWithDateYesterDay:(NSString *)yesterDay
                    andYesterDate:(NSString *)yesterDate
                    andTotalAmout:(NSString *)totalAmout
                         withData:(id)data;
@end
