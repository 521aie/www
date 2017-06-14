//
//  TDFHealthCheckDetailHeader.m
//  ClassProperties
//
//  Created by xueyu on 2016/12/7.
//  Copyright © 2016年 ximi. All rights reserved.
//
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "NSString+TDFRegix.h"
#import "NSString+Estimate.h"
#import "UIImageView+WebCache.h"
#import "TDFHealthCheckConfigViewModel.h"
#import "TDFHealthCheckDetailHeader.h"
@interface TDFHealthCheckDetailHeader()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *detail;
@property (nonatomic, strong) UIImageView *statusImg;
@property (nonatomic, strong) UILabel *statusTxt;
@property (nonatomic, strong) UIView *iconback;
@end
@implementation TDFHealthCheckDetailHeader
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configSubViews];
    }
    return self;
}

-(void)configSubViews{
    self.iconback= ({
        UIView *view = [UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(36,36));
            make.left.equalTo(self.mas_left).offset(15);
        }];
        view.backgroundColor = [UIColor redColor];
        view.layer.cornerRadius = 18;
        view.clipsToBounds = YES;
        view;
    });

   self.icon = ({
        UIImageView *view = [UIImageView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.iconback);
            make.size.mas_equalTo(CGSizeMake(21,21));
        }];
        view.image = [UIImage imageNamed:@"rate"];
        view;
    });
    
    self.statusTxt = ({
        UILabel *view = [UILabel new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.icon.mas_centerY);
            make.size.mas_offset(CGSizeMake(40, 13));
        }];
        view.font = [UIFont systemFontOfSize:13];
        view;
    });
    
    self.statusImg = ({
        UIImageView *view = [UIImageView new];
        [self  addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.icon.mas_centerY);
            make.right.equalTo(self.statusTxt.mas_left).offset(-8);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        view;
    });

    
   self.title= ({
        UILabel *view = [UILabel new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).offset(15);
            make.bottom.equalTo(self.icon.mas_centerY).offset(-2);
            make.size.mas_offset(CGSizeMake(180, 15));
            
        }];
       view.textAlignment = NSTextAlignmentLeft;
       view.numberOfLines = 0;
       view.font = [UIFont systemFontOfSize:15];
       view;
    });
    

    
     self.detail = ({
        UILabel *view = [UILabel new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.statusImg.mas_left).offset(-20);
            make.top.equalTo(self.icon.mas_centerY).offset(2);
            make.left.equalTo(self.title.mas_left);
        }];
         view.textAlignment = NSTextAlignmentLeft;
         view.font = [UIFont systemFontOfSize:11];
         view.numberOfLines = 0 ;
        view;
    });
    
 
    

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    


    
    UIView *line= ({
        UIView *view = [UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.left.equalTo(self).offset(10);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
        view;
    });
    
#pragma clang diagnostic pop
    
    
}
-(void)loadData:(TDFHealthCheckItemHeaderModel *)model {
    
    self.iconback.backgroundColor = [TDFHealthCheckConfigViewModel statusColor:model.levelCode];
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:nil];
  
    self.statusImg.image = [TDFHealthCheckConfigViewModel statusImage:model.levelCode];
    
    self.title.text = model.itemName;
    
    self.statusTxt.textColor = [TDFHealthCheckConfigViewModel statusColor:model.levelCode];
    
    self.statusTxt.text = model.status;
    
    if ( model.subTitle && [NSString isNotBlank:model.subTitle.originalStr]) {
         self.detail.attributedText = [NSString string:model.subTitle.originalStr with:model.subTitle.replaceStrs colors:model.subTitle.colors regixString:@"\\{0?\\}"];
    }else{
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.icon.mas_centerY).offset(7.5);
        }];
    }
   
}

@end
