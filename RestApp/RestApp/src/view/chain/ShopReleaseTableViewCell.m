//
//  ShopReleaseTableViewCell.m
//  RestApp
//
//  Created by iOS香肠 on 2016/10/19.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "ShopReleaseTableViewCell.h"
#import "Masonry.h"
#import "TDFPlatePublishVo.h"
#import "DateUtils.h"
@implementation ShopReleaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

-  (void)initMainView
{
    self.backgroundColor  =  [UIColor clearColor];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 1, 0));
    }];
    self.bgView.backgroundColor  = [UIColor whiteColor];
    self.bgView.alpha =0.7;
      [self.lblName  mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.mas_left).with.offset(16);
          make.top.equalTo(self.mas_top).with.offset(4);
          make.size.mas_equalTo(CGSizeMake(141, 80));
      }];
    self.lblName.textColor  = [UIColor blackColor] ;
    self.lblName.textAlignment   = NSTextAlignmentLeft;
    self.lblName.font  = [UIFont  systemFontOfSize:15];
    self.lblName.text  = @"";
    
    [self.imgPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo (self.mas_right).with.offset (-2);
        make.top.equalTo (self.mas_top).with.offset(31);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
   self.imgPic.image  =  [UIImage imageNamed:@"ico_next.png"];
    
    [self.lblVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo (self.imgPic.mas_left).with.offset(-3);
        make.top.equalTo (self.imgPic.mas_top).with.offset(-3);
        make.size.mas_equalTo (CGSizeMake(50, 14));
    }];
    self.lblVal.textColor  =  [UIColor whiteColor];
    self.lblVal.font  =  [UIFont  systemFontOfSize:11];
    self.lblVal.text = @"";
    self.lblVal.textAlignment = NSTextAlignmentCenter;
    self.lblVal.layer.masksToBounds = YES;
    self.lblVal.layer.cornerRadius = 3;
    self.lblVal.backgroundColor = [UIColor redColor];
    
    [self.lblDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo (self.imgPic.mas_left).with.offset(-3);
        make.top.equalTo(self.lblVal.mas_bottom).with.offset(1);
        make.size.mas_equalTo(CGSizeMake(100, 14));
    }];
    self.lblDate.textColor = [UIColor grayColor];
    self.lblDate.textAlignment = NSTextAlignmentRight;
    self.lblDate.text = @"";
    self.lblDate.font = [UIFont systemFontOfSize:12];
    
}

- (void)initFillWithData:(id)data
{
    TDFPlatePublishVo *vo = (TDFPlatePublishVo *)data;
    self.lblName .text  = [NSString stringWithFormat:@"%@",vo.plateName];
    self.lblVal .text  =  [TDFPlatePublishVo  getPublishStatusString:vo.publishStatus];
    self.lblVal.backgroundColor = [TDFPlatePublishVo getPublishStatusColor:vo.publishStatus];
    self.lblVal.hidden  = [TDFPlatePublishVo isHideWithPublishStatus:vo.publishStatus];
    self.lblDate.text  = [NSString stringWithFormat:@"%@",[DateUtils formatTimeWithTimestamp:vo.publishDate*1000 type:TDFFormatTimeTypeChinese]];
    self.lblDate.hidden  = [TDFPlatePublishVo isHideWithPublishStatus:vo.publishStatus];
}



- (UILabel *)lblVal
{
    if (!_lblVal) {
        _lblVal  = [[UILabel  alloc]  init];
        [self addSubview:_lblVal];
    }
    return _lblVal;
}

- (UILabel *)lblName
{
    if (!_lblName) {
        _lblName  = [[UILabel  alloc] init];
        [self addSubview:_lblName];
    }
    return _lblName;
}

- (UILabel *)lblDate
{
    if (!_lblDate) {
        _lblDate   = [[UILabel  alloc]  init];
        [self addSubview:_lblDate];
    }
    return _lblDate ;
}

- (UIImageView *)imgPic
{
    if (!_imgPic) {
        _imgPic  =  [[UIImageView  alloc] init];
        [self addSubview:_imgPic];
        
    }
    return _imgPic;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView  =  [[UIView  alloc] init];
        [self addSubview:_bgView];
    }
    return _bgView;
}

@end
