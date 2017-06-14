//
//  TDFOAPermissionView.m
//  RestApp
//
//  Created by Octree on 9/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOAPermissionView.h"
#import "TDFLabelFactory.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

@interface TDFOAPermissionItemView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;

@end

@interface TDFOAPermissionView ()

@property (strong, nonatomic) TDFOfficialAccountModel *officialAccount;
@property (strong, nonatomic) NSArray *titles;
@property (copy, nonatomic) NSArray *itemViews;

@end

@implementation TDFOAPermissionView

- (instancetype)initWithOfficialAccount:(TDFOfficialAccountModel *)officialAccount {

    if (self = [super initWithFrame:CGRectMake(0, 0, 300, 300)]) {
    
        self.officialAccount = officialAccount;
        [self configViews];
    }
    
    return self;
}



- (void)configViews {

    UIView *targetView = self;
    BOOL isFirst = YES;
    for (TDFOfficialAccountPermissionModel *permission in self.officialAccount.wxPermissions) {
        
        TDFOAPermissionItemView *view = [self generateItemViews];
        view.label.text = permission.name;
        view.imageView.image = [UIImage imageNamed: permission.status == 1 ? @"wxoa_permission_allow" : @"wxoa_permission_deny"];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(24);
            if (isFirst) {
                make.top.equalTo(targetView.mas_top).with.offset(15);
            } else {
                make.top.equalTo(targetView.mas_bottom);
            }
        }];
        targetView = view;
        isFirst = NO;
    }
}


- (TDFOAPermissionItemView *)generateItemViews {

    TDFOAPermissionItemView *itemView = [[TDFOAPermissionItemView alloc] init];
    return itemView;
}

@end


@implementation TDFOAPermissionItemView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self configViews];
    }
    return self;
}

- (void)configViews {

    UIView *pointView = [[UIView alloc] init];
    pointView.backgroundColor = [UIColor blackColor];
    pointView.layer.masksToBounds = YES;
    pointView.layer.cornerRadius = 2;
    
    [self addSubview:pointView];
    @weakify(self);
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).with.offset(20);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(4);
    }];
    
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(pointView.mas_right).with.offset(5);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.right.equalTo(self).with.offset(-20);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(14);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)label {

    if (!_label) {
        
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor colorWithHeX:0x666666];
        _label.font = [UIFont systemFontOfSize:12];
    }
    return _label;
}

- (UIImageView *)imageView {

    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeRight;
    }
    return _imageView;
}



@end
