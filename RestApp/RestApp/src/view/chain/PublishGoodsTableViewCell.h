//
//  TDFPublishGoodsTableViewCell.h
//  RestApp
//
//  Created by iOS香肠 on 2016/10/20.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationToJump.h"
#import "ChainPublishHistoryVo.h"
#define publishGoodsTableViewCellDefine @"publishGoodsTableViewCellDefine"
@interface PublishGoodsTableViewCell : UITableViewCell
@property (nonatomic ,strong) UIImageView *publishStatus;
@property (nonatomic ,strong) UILabel *publishLbl;
@property (nonatomic ,strong) UILabel *publishTimeLbl;
@property (nonatomic ,strong) UILabel *brandLbl;
@property (nonatomic ,strong) UILabel *summaryLbl;
@property (nonatomic ,strong) UIButton *nextClickButton;
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) ChainPublishHistoryVo *vo;
@property (nonatomic ,strong) id <NavigationToJump> delegate;
- (void)initDelegate:(id <NavigationToJump>)delegate;
- (void) initMainViewWithData:(id)data;

@end
