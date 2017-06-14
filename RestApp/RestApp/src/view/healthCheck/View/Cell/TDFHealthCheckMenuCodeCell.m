//
//  TDFMenuCodeCell.m
//  ClassProperties
//
//  Created by guopin on 2016/12/9.
//  Copyright © 2016年 ximi. All rights reserved.
//
#import "UIColor+Hex.h"
#import "TDFSwitchTool.h"
#import "TDFFunctionVo.h"
#import <Masonry/Masonry.h>
#import "TDFHealthCheckMenuCodeCell.h"
#import "UIImageView+WebCache.h"
#import "TDFHealthCheckItemBodyModel.h"
@interface TDFHealthCheckMenuCodeCell()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *rightImg;
@end
@implementation TDFHealthCheckMenuCodeCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

-(void)configViews{
     self.imgView = ({
        UIImageView *view = [UIImageView new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(4);
            make.top.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-4);
            make.height.equalTo(view.mas_width).multipliedBy(1);
        }];
         view.contentMode = UIViewContentModeScaleAspectFit;
        view;
    });
    self.title = ({
        UILabel *view = [UILabel new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(5);
            make.left.and.right.equalTo(self.contentView);
        }];
        view.numberOfLines = 0;
        view.font = [UIFont systemFontOfSize:11];
        view.textAlignment = NSTextAlignmentCenter;
        view.textColor = [UIColor colorWithHexString:@"#0076FF"];
        view;
    });
     self.rightImg = ({
        UIImageView *view = [UIImageView new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(44.5);
            make.right.equalTo(self.contentView.mas_right).offset(-8);
            make.size.mas_equalTo(CGSizeMake(10.5,13.5));
        }];
        view;
    });
}
-(void)cellLoadData:(TDFHealthCheckBtnModel *)data{
    TDFFunctionVo *funcVo;
    for (TDFFunctionVo *vo in [Platform Instance].allModuleChargeList) {
        if ([vo.actionCode isEqualToString:data.actionCode]) {
            funcVo = vo;
        }
    }
//    TDFFunctionVo *funcVo = [TDFSwitchTool switchTool].codeWithFunctionVoDic[data.actionCode];
    if (funcVo.isLock && funcVo) {
        self.rightImg.image = [UIImage imageNamed:@"ico_check_lock_gray"];
    }else if(!funcVo.isOpen && funcVo){
        self.rightImg.image = [UIImage imageNamed:@"ico_check_lock_red"];
    }else{
        self.rightImg.image = [UIImage imageNamed:@""];
    }
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:data.iconUrl] placeholderImage:[UIImage imageNamed:@"ico_functionplaceImage"]];
    self.title.text = data.actionName;
  
}
@end
