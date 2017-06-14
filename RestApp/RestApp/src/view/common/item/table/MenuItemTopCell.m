//
//  MenuItemTopCell.m
//  RestApp
//
//  Created by 果汁 on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#import "Menu.h"
#import "UIImageView+TDFRequest.h"
#import "UIView+Sizes.h"
#import "SampleMenuVO.h"
#import "MenuItemTopCell.h"
#import "ImageUtils.h"
#import "Platform.h"
#import "NSString+Estimate.h"
#import "SDWebImageDownloader.h"
#import "ColorHelper.h"

@implementation MenuItemTopCell

+ (id)getInstance
{
    MenuItemTopCell *item = [[MenuItemTopCell alloc] init];
    return item;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 230);
        self.backgroundColor = [UIColor clearColor];
        [self initMainView];
    }
    return self;
}

- (void) initMainView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 219)];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.contentView addSubview:bgView];
    [self.contentView addSubview:self.img];
    
    UIImageView *largeMenuImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 79, SCREEN_WIDTH - 20, 130)];
    largeMenuImg.image = [UIImage imageNamed:@"bg_large_menu.png"];
    [self.contentView addSubview:largeMenuImg];
    [self.contentView addSubview:self.lblName];
    [self.contentView addSubview:self.lblIsChain];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.lblDetail];
    [self.contentView addSubview:self.btnMember];
    [self.contentView addSubview:self.lblOriginPrice];
    [self.contentView addSubview:self.lblRedLine];
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.contentView.mas_left).with.offset(26);
        make.top.equalTo (self.contentView.mas_top).with.offset(130);
        make.height.mas_equalTo( 18);
    }];
    
    [self.lblIsChain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.lblName.mas_right).with.offset(3);
        make.centerY.equalTo(self.lblName.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(31, 15));
    }];
}

- (UILabel *) lblOriginPrice
{
    if (!_lblOriginPrice) {
        _lblOriginPrice = [[UILabel alloc] initWithFrame:CGRectMake(146, 175, SCREEN_WIDTH- 6146, 15)];
        _lblOriginPrice.textColor = [UIColor redColor];
        _lblOriginPrice.textAlignment = NSTextAlignmentLeft;
        _lblOriginPrice.font = [UIFont systemFontOfSize:15];
    }
    return _lblOriginPrice;
}

- (UILabel *) lblRedLine
{
    if (!_lblRedLine) {
        _lblRedLine = [[UILabel alloc] initWithFrame:CGRectMake(33, 184, 45, 1)];
        _lblRedLine.backgroundColor = [UIColor redColor];
        _lblRedLine.textAlignment = NSTextAlignmentLeft;
    }
    return _lblRedLine;
}

- (UIButton *) btnMember
{
    if (!_btnMember) {
        _btnMember = [[UIButton alloc] initWithFrame:CGRectMake(120, 176, 50, 15)];
        [_btnMember setTitle:NSLocalizedString(@"会员价", nil) forState:UIControlStateNormal];
        [_btnMember setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        _btnMember.titleLabel.font = [UIFont systemFontOfSize:12];
        [_btnMember setBackgroundImage:[UIImage imageNamed:@"ico_box_bdr_g.png"] forState:UIControlStateNormal];
    }
    return _btnMember;
}

- (UIImageView *) img
{
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 200)];
    }
    return _img;
}

- (UILabel *) lblName
{
    if (!_lblName) {
        _lblName = [[UILabel alloc] init];
        _lblName.textColor = [UIColor whiteColor];
        _lblName.textAlignment = NSTextAlignmentLeft;
        _lblName.font = [UIFont systemFontOfSize:16];
    }
    return _lblName;
}

- (UIImageView *) lblIsChain
{
    if (!_lblIsChain) {
        _lblIsChain = [[UIImageView alloc] init];
        _lblIsChain.image = [UIImage imageNamed:@"ico_chain"];
    }
    return _lblIsChain;
}

- (UIView *) imgView
{
    if (!_imgView) {
        _imgView = [[UIView alloc] initWithFrame:CGRectMake(26, 150, 180, 18)];
        _imgView.backgroundColor = [UIColor clearColor];
    }
    return _imgView;
}

- (UILabel *) lblDetail
{
    if (!_lblDetail) {
        _lblDetail = [[UILabel alloc] initWithFrame:CGRectMake(26, 176, 120, 15)];
        _lblDetail.textColor = [UIColor redColor];
        _lblDetail.textAlignment = NSTextAlignmentLeft;
        _lblDetail.font = [UIFont systemFontOfSize:15];
    }
    return _lblDetail;
}

-(void) loadItem:(SampleMenuVO*)data
{
    [self loadItem:data delegate:nil];
}
-(void) loadItem:(SampleMenuVO*)data delegate:(id<DHListSelectHandle>) handle
{
    int acridLevel = [data obtainItemAcridLevel];
    int recommendLevel = [data obtainItemRecommendLevel];
    NSString *specialTagString = [data obtainItemSpecial];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(18*(acridLevel +recommendLevel), 2, 54, 18)];
    lab.text = specialTagString;
    if ([specialTagString isEqualToString:NSLocalizedString(@"不设定", nil)] || [NSString isBlank:specialTagString]) {
        lab.hidden = YES;
    }else
    {
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

    for (int i = 0; i < acridLevel +recommendLevel; i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i *18, 2, 18, 18)];
        [self.imgView addSubview:imgView];
        if (i < acridLevel)
        {
            imgView.image = [UIImage imageNamed:@"ico_chilli"];
        }
        else
        {
            imgView.image = [UIImage imageNamed:@"ico_approve"];
        }
    }
    
    self.delegate=handle;
    self.item=data;
    self.lblName.text= [data obtainItemName];
      self.img.contentMode = UIViewContentModeScaleAspectFill;
       NSString *imageUrl = [ImageUtils getImageUrl:self.item.server path:self.item.path];
    NSLog(@"//////////////////%@ \n%@\n%@ \n %@",imageUrl,[Platform Instance].fileServerPath,[Platform Instance].imageServerPath,[Platform Instance].serverPath);
    
        [self.img.layer setMasksToBounds:YES];
        [self.img.layer setCornerRadius:ITEM_RADIUS];
         self.img.contentMode = UIViewContentModeScaleAspectFill;
    [self.img tdf_imageRequstWithPath:self.item.path placeholderImage:[UIImage imageNamed:@"img_default.png"] urlModel:ImageUrlCapture];
   }

@end
