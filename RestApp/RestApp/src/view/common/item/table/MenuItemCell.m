//
//  MenuItemCell.m
//  RestApp
//
//  Created by zxh on 14-5-6.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Menu.h"
#import "UIImageView+TDFRequest.h"
#import "UIView+Sizes.h"
#import "SampleMenuVO.h"
#import "MenuItemCell.h"
#import "NSString+Estimate.h"
#import "SDWebImageDownloader.h"

#import "ColorHelper.h"
@implementation MenuItemCell

+ (id)getInstance
{
    MenuItemCell *item = [[[NSBundle mainBundle]loadNibNamed:@"MenuItemCell" owner:self options:nil]lastObject];
    [item initMainView];
    return item;
}

- (void) initMainView
{
    [self.contentView addSubview:self.lblName];
    [self.contentView addSubview:self.lblIschain];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.kabawView.mas_right).with.offset(18);
        make.top.equalTo (self.contentView.mas_top).with.offset(10);
        make.height.mas_equalTo(23);
    }];
    [self.lblIschain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.lblName.mas_right).with.offset(3);
          make.centerY.equalTo(self.lblName.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(31, 15));
    }];
}

- (UILabel *) lblName
{
    if (!_lblName) {
        _lblName = [[UILabel alloc] init];
        _lblName.textColor = [UIColor blackColor];
        _lblName.font = [UIFont boldSystemFontOfSize:16];
        _lblName.numberOfLines = 2;
        _lblName.textAlignment = NSTextAlignmentLeft;
    }
    return _lblName;
}

- (UIImageView *) lblIschain
{
    if (!_lblIschain) {
        _lblIschain = [[UIImageView alloc] init];
        _lblIschain.image = [UIImage imageNamed:@"ico_chain"];
    }
    return _lblIschain;
}

- (void)loadItem:(SampleMenuVO*)data
{
    [self loadItem:data delegate:nil];
}

- (void)loadItem:(SampleMenuVO*)data delegate:(id<DHListSelectHandle>) handle
{
    int acridLevel = [data obtainItemAcridLevel];
    int recommendLevel = [data obtainItemRecommendLevel];
    NSString *specialTagString = [data obtainItemSpecial];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(18*(acridLevel +recommendLevel), 2, 54, 18)];
    lab.text = specialTagString;
    if ([specialTagString isEqualToString:NSLocalizedString(@"不设定", nil)]|| [NSString isBlank:specialTagString]) {
        lab.hidden = YES;
    } else {
        lab.hidden = NO;
    }
    lab.font = [UIFont systemFontOfSize:12];
    lab.textColor = [UIColor colorWithRed:222/255.0 green:52/255.0 blue:0 alpha:1];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    [self.imgView addSubview:lab];
    CALayer *layer = [lab layer];
    layer.cornerRadius = 4;
    layer.borderColor = [UIColor colorWithRed:222/255.0 green:52/255.0 blue:0 alpha:1].CGColor;
    layer.borderWidth = 1;
    layer.masksToBounds = YES;
    for (int i = 0; i < acridLevel +recommendLevel; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i *18, 2, 18, 18)];
        [self.imgView addSubview:imgView];
        if (i < acridLevel) {
            imgView.image = [UIImage imageNamed:@"ico_chilli"];
        } else {
            imgView.image = [UIImage imageNamed:@"ico_approve"];
        }
    }
    
    self.item = data;
    self.delegate = handle;
    self.lblName.text = [data obtainItemName];
    self.lblDetail.text = [data obtainItemValue];
    self.lblAccount.text = [NSString stringWithFormat:@"/%@",[self.item showUnit]];
    [self.lblDetail sizeToFit];
    [self.lblAccount setLeft:(self.lblDetail.left+self.lblDetail.width+2)];
    [self.lblAccount sizeToFit];
    [self.lblAccount setNeedsDisplay];
    self.kabawView.layer.cornerRadius = 5;
    if ([NSString isNotBlank:[data obtainImgpath]]) {
        self.img.contentMode = UIViewContentModeScaleAspectFill;
//        NSString *imageUrl = [ImageUtils getSmallImageUrl:self.item.server path:self.item.path];
        [self.img.layer setMasksToBounds:YES];
        [self.img.layer setCornerRadius:ITEM_RADIUS];
        [self showImg:YES];
        [self.img tdf_imageRequstWithPath:self.item.path placeholderImage:[UIImage imageNamed:@"img_default.png"] urlModel:ImageUrlCapture];
    } else {
        [self.img setImage:[UIImage imageNamed:@"img_default.png"]];
        [self showImg:NO];
    }
}

- (void)showImg:(BOOL)visibal
{
    [self.img setHidden:!visibal];
    [self.kabawView setHidden:visibal];
}

- (IBAction)btnKabawClick:(id)sender
{
    if (self.delegate!=nil) {
        [self.delegate selectKind:self.item];
        
    }
}

@end
