//
//  EmployeeItemCell.m
//  RestApp
//
//  Created by zxh on 14-9-29.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EmployeeItemCell.h"
#import "Employee.h"
#import "ImageUtils.h"
#import "NSString+Estimate.h"
#import "UIImageView+TDFRequest.h"
#import "UIView+Sizes.h"
#import "Role.h"

@interface EmployeeItemCell()
@property (nonatomic, strong) UIView *iconView;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIImageView *imgNoPath;
@property (nonatomic, strong) UILabel *lblRole;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblMobile;
@end

@implementation EmployeeItemCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
     if (self) {
         self.backgroundColor = [UIColor clearColor];
         
         UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 87)];
         bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
         [self.contentView addSubview:bgView];
    
         [self.contentView addSubview:self.iconView];
 
         [self.iconView addSubview:self.img];

         [self.iconView addSubview:self.imgNoPath];
         
         [self.iconView addSubview:self.lblRole];

         [self.contentView addSubview:self.lblName];
 
        [self.contentView addSubview:self.lblMobile];
         
         [self updateSize];
    }
     return self;
}

- (UIView *) iconView
{
    if (!_iconView) {
        _iconView = [[UIView alloc] init];
        _iconView.backgroundColor = [UIColor clearColor];
    }
    return _iconView;
}

- (UIImageView *) img
{
    if (!_img) {
        _img = [[UIImageView alloc] init];
        _img.backgroundColor = [UIColor clearColor];
    }
    return _img;
}

- (UIImageView *) imgNoPath
{
    if (!_imgNoPath) {
        _imgNoPath = [[UIImageView alloc] init];
        _imgNoPath.backgroundColor = [UIColor clearColor];
    }
    return _imgNoPath;
}

- (UILabel *) lblRole
{
    if (!_lblRole) {
        _lblRole = [[UILabel alloc] init];
        _lblRole.textColor = [UIColor colorWithRed:102/255 green:102/255 blue:102/255 alpha:1];
        _lblRole.textAlignment = NSTextAlignmentCenter;
        _lblRole.font = [UIFont systemFontOfSize:13];
    }
    return _lblRole;
}

- (UILabel *) lblName
{
    if (!_lblName) {
        _lblName = [[UILabel alloc] init];
        _lblName.textColor = [UIColor blackColor];
        _lblName.font = [UIFont boldSystemFontOfSize:16];
    }
    return _lblName;
}

- (UILabel *) lblMobile
{
    if (!_lblMobile) {
        _lblMobile = [[UILabel alloc] init];
        _lblMobile.textColor = [UIColor colorWithRed:102/255 green:102/255 blue:102/255 alpha:1];
        _lblMobile.font = [UIFont systemFontOfSize:13];
    }
    return _lblMobile;
}

-(void) loadItem:(Employee*)data role:(Role*)role delegate:(id<DHListSelectHandle>) handle
{
    self.delegate=handle;
    self.item=data;
    
    self.lblName.text= [data obtainItemName];
    if ([role._id isEqual:@"0"]) {
       self.lblMobile.text=@"";
    } else {
       self.lblMobile.text=[NSString stringWithFormat:NSLocalizedString(@"手机:%@", nil),[NSString isBlank:[data obtainItemValue]]?@"":[data obtainItemValue]];
        
    }
    self.lblRole.text=[role obtainItemName];
    [self.iconView.layer setMasksToBounds:YES];
    [self.iconView.layer setBorderWidth:1];
    UIColor* color=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    [self.iconView.layer setBorderColor:[color CGColor]];
    self.iconView.layer.cornerRadius = 5;
    self.img.size = CGSizeMake(72, 72);
    if ([NSString isNotBlank:self.item.path]) {
         NSString *imageUrl = [ImageUtils getImageUrl:self.item.server path:self.item.path];
        [self.lblRole setHidden:YES];
        [self.img tdf_imageRequstWithPath:imageUrl placeholderImage:[UIImage imageNamed:@"img_default.png"] urlModel:ImageUrlCapture];
        self.imgNoPath.hidden = YES;
        self.img.hidden = NO;
    } else {
        [self.lblRole setHidden:NO];
        NSString* imgPath=@"img_stuff_male.png";
        if ([self.item.roleId isEqualToString:@"0"]) {
            imgPath=@"img_stuff_admin.png";
        } else if (self.item.sex==0 || self.item.sex==1) {
            imgPath=@"img_stuff_male.png";
        } else {
            imgPath=@"img_stuff_female.png";
        }
        [self.imgNoPath tdf_imageRequstWithPath:nil placeholderImage:[UIImage imageNamed:imgPath] urlModel:ImageUrlCapture];
        self.imgNoPath.hidden = NO;
        self.img.hidden = YES;
    }
}

- (void) updateSize{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.size.mas_equalTo (CGSizeMake(72,72));
    }];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.iconView.mas_left).with.offset(0);
        make.top.equalTo(self.iconView.mas_top).with.offset(0);
        make.size.mas_equalTo (CGSizeMake(72,72));
    }];
    [self.imgNoPath mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.iconView.mas_left).with.offset(11);
         make.right.equalTo (self.iconView.mas_right).with.offset(-11);
        make.top.equalTo(self.iconView.mas_top).with.offset(0);
        make.size.mas_equalTo (CGSizeMake(50,50));
    }];
    [self.lblRole mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_left).with.offset(0);
        make.bottom.equalTo(self.iconView.mas_bottom).with.offset(0);
        make.size.mas_equalTo (CGSizeMake(72,21));
    }];
    UIImageView *nextImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_next.png"]];
    [self.contentView addSubview:nextImg];
    [nextImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.top.equalTo(self.contentView.mas_top).with.offset(34);
        make.size.mas_equalTo (CGSizeMake(20,20));
    }];
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).with.offset(4);
        make.top.equalTo(self.contentView.mas_top).with.offset(2);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-31);
        make.right.equalTo(nextImg.mas_left).with.offset(-10);
    }];
    [self.lblMobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).with.offset(4);
        make.top.equalTo(self.lblName.mas_bottom).with.offset(3);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-15);
        make.right.equalTo(nextImg.mas_left).with.offset(-10);
    }];
}

@end
