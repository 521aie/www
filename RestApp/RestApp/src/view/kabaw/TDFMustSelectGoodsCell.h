//
//  TDFMustSelectGoodsCell.h
//  RestApp
//
//  Created by hulatang on 16/7/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFForceMenuVo.h"
@interface TDFMustSelectGoodsCell : UITableViewCell

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UILabel *detailInfoLable;

@property (nonatomic, strong)UILabel *selectCountLabel;

- (void)initDataWithData:(id)data;

+ (CGFloat)heightForCellWithData:(id)data;
@end
