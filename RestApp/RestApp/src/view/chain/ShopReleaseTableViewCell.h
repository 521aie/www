//
//  ShopReleaseTableViewCell.h
//  RestApp
//
//  Created by iOS香肠 on 2016/10/19.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ShopReleaseTableViewCellDefine  @"ShopReleaseTableViewCellDefine"

@interface ShopReleaseTableViewCell : UITableViewCell

@property (nonatomic ,strong) UILabel *lblName;//名称
@property (nonatomic ,strong) UILabel *lblVal;//状态
@property (nonatomic ,strong) UILabel *lblDate;//时间
@property (nonatomic ,strong) UIImageView  *imgPic; //图片
@property (nonatomic ,strong) UIView *bgView;//背景
-  (void)initMainView;
-  (void)initFillWithData:(id) data;
@end
