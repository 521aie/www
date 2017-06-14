//
//  TDFShopImgStaticCell.m
//  RestApp
//
//  Created by Cloud on 2017/4/23.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopImgStaticCell.h"
#import "TDFShopImgStaticItem.h"
#import "ColorHelper.h"

@interface TDFShopImgStaticCell ()
    
@property (nonatomic, strong) UILabel *sampLeTitle;
    
@property (nonatomic, strong) UILabel *tips1;
    
@property (nonatomic, strong) UIImageView *sampleImage1;
    
@property (nonatomic, strong) UILabel *tip2;
    
@property (nonatomic, strong) UIImageView *sampleImage2;
    
@property (nonatomic, strong) UIButton *saveBtn;
    
@property (nonatomic, strong) UILabel *btnTips;

@property (nonatomic, copy) void (^commitBlock)();
    
@end

@implementation TDFShopImgStaticCell
    
- (void)cellDidLoad {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    [self configLayout];
}
    
- (void)configCellWithItem:(TDFShopImgStaticItem *)item {
 
    self.commitBlock = item.commitBlock;
        
    self.saveBtn.hidden = item.isWaiting;
    self.btnTips.hidden = item.isWaiting;
    
}

- (void)configLayout {
    
    [self.contentView addSubview:self.sampLeTitle];
    [self.contentView addSubview:self.tips1];
    [self.contentView addSubview:self.sampleImage1];
    [self.contentView addSubview:self.tip2];
    [self.contentView addSubview:self.sampleImage2];
    [self.contentView addSubview:self.saveBtn];
    [self.contentView addSubview:self.btnTips];
    
    [self.sampLeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.offset(20);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    
    [self.tips1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.sampLeTitle.mas_bottom).offset(10);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    
    [self.sampleImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.tips1.mas_bottom).offset(10);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.mas_equalTo(140);
    }];
    
    [self.tip2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.sampleImage1.mas_bottom).offset(10);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    
    [self.sampleImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tip2.mas_bottom).offset(10);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.mas_equalTo(220);
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.sampleImage2.mas_bottom).offset(10);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [self.btnTips mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.saveBtn.mas_bottom).offset(10);
        make.left.offset(10);
        make.right.offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-44);
    }];
    
}
    
- (UILabel *)sampLeTitle {
    
    if (!_sampLeTitle) {
        
        _sampLeTitle = [UILabel new];
        _sampLeTitle.textAlignment = NSTextAlignmentCenter;
        _sampLeTitle.font = [UIFont systemFontOfSize:16];
        _sampLeTitle.text = NSLocalizedString(@"店家LOGO示例", nil);
    }
    return _sampLeTitle;
}
    
- (UILabel *)tips1 {
    
    if (!_tips1) {
        
        _tips1 = [UILabel new];
        _tips1.textColor = [UIColor darkGrayColor];
        _tips1.font = [UIFont systemFontOfSize:11];
        _tips1.numberOfLines = 0;
        _tips1.text = NSLocalizedString(@"注：您的店标（LOGO）会显示在二维火“附近的店”中，顾客可以在“火小二”应用及微信扫码时看见。", nil);
        _tips1.preferredMaxLayoutWidth = SCREEN_WIDTH-20;
        [_tips1 sizeToFit];
    }
    return _tips1;
}
    
- (UIImageView *)sampleImage1 {
    
    if (!_sampleImage1) {
        
        _sampleImage1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_shopLogo_sample1.png"]];
        _sampleImage1.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _sampleImage1;
}
    
- (UILabel *)tip2 {
    
    if (!_tip2) {
        
        _tip2 = [UILabel new];
        _tip2.textColor = [UIColor darkGrayColor];
        _tip2.font = [UIFont systemFontOfSize:11];
        _tip2.text = NSLocalizedString(@"注：您的店标（LOGO）会显示在二维火“吃饭直播”等活动中，顾客可以在好友分享后看到。", nil);
        _tip2.numberOfLines = 0;
        [_tip2 sizeToFit];
    }
    return _tip2;
}
    
- (UIImageView *)sampleImage2 {
    
    if (!_sampleImage2) {
        
        _sampleImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_shopLogo_sample2.png"]];
        _sampleImage2.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _sampleImage2;
}
    
- (UIButton *)saveBtn {

    if (!_saveBtn) {
        
        _saveBtn = [UIButton new];
        [_saveBtn setBackgroundColor:[ColorHelper getRedColor]];
        [_saveBtn setTitle:@"保存并提交审核" forState:UIControlStateNormal];
        _saveBtn.layer.cornerRadius = 5;
        _saveBtn.layer.masksToBounds = YES;
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_saveBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
    
- (UILabel *)btnTips {

    if (!_btnTips) {
        
        _btnTips = [UILabel new];
        _btnTips.numberOfLines = 0;
        _btnTips.textAlignment = NSTextAlignmentCenter;
        _btnTips.text = @"以上必填内容需全部填写后才能提交审核，24小时内处理；若资料有修改，需重新提交审核（一周仅限1次）";
        _btnTips.textColor = [UIColor darkGrayColor];
        _btnTips.font = [UIFont systemFontOfSize:11];
        _btnTips.preferredMaxLayoutWidth = SCREEN_WIDTH-60;
        [_btnTips sizeToFit];
    }
    return _btnTips;
}
    
- (void)commit {

    if (self.commitBlock) {
        self.commitBlock();
    }
}
    
+ (CGFloat)heightForCellWithItem:(DHTTableViewItem *)item {
    
        TDFShopImgStaticCell *ii = [[self alloc]init];
    [ii configLayout];
//
//    
        return [ii systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
//    return 500;
}
    @end
