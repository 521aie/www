//
//  TDFHealthCheckScanView.h
//  RestApp
//
//  Created by 黄河 on 2016/12/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFHealthCheckItemHeaderModel.h"

@interface TDFHealthCheckScanHeaderImageView : UIView

@property (nonatomic, strong)UIImageView *imageView;

@end

@interface TDFHealthCheckScanView : UIView

@property (nonatomic, strong) TDFHealthCheckScanHeaderImageView*headerImageView;



@property (nonatomic, assign)BOOL showScanAnimation;

@property (nonatomic, assign)BOOL isShowDetail;

@property (nonatomic, assign)BOOL isHeaderCheck;

@property (nonatomic, strong)UILabel *checkLabel;

@property (nonatomic, strong)TDFHealthCheckItemHeaderModel *headerModel;

- (void)startAnimation;

- (void)cancelAnimation;

@end

@interface TDFHealthCheckScanViewCell : UITableViewCell

@property (nonatomic, strong)TDFHealthCheckItemHeaderModel *headerModel;

@property (nonatomic, assign)BOOL isShowDetail;

@end
