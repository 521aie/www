//
//  TDFMustSelectGoodsCell.m
//  RestApp
//
//  Created by hulatang on 16/7/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFMustSelectGoodsCell.h"
#import "Masonry.h"
@implementation TDFMustSelectGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithView];
    }
    return self;
}

- (void)initWithView
{
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.nameLabel];
    
    self.detailInfoLable = [[UILabel alloc] init];
    self.detailInfoLable.font = [UIFont systemFontOfSize:12];
    self.detailInfoLable.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.detailInfoLable];
    
    self.selectCountLabel = [[UILabel alloc] init];
    self.selectCountLabel.font = [UIFont systemFontOfSize:13];
    self.selectCountLabel.textColor = RGBA(0, 136, 204, 1);
    [self.contentView addSubview:self.selectCountLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.left.equalTo(self.contentView).with.offset(10);
        make.bottom.equalTo(self.detailInfoLable.mas_top).with.offset(-10);
//        make.height.mas_equalTo(self.detailInfoLable);
    }];
    [self.detailInfoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.contentView).with.offset(10);
//        make.bottom.equalTo(self.contentView).with.offset(-10);
//        make.height.mas_equalTo(self.nameLabel);
    }];
    [self.selectCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).with.offset(0);
        make.width.lessThanOrEqualTo(@(self.contentView.bounds.size.width/2.0));
        make.left.greaterThanOrEqualTo(self.nameLabel.mas_right).with.offset(10);
        make.left.greaterThanOrEqualTo(self.detailInfoLable.mas_right).with.offset(10);
        
    }];
}

- (void)initDataWithData:(id)data
{
    if ([data isKindOfClass:[TDFForceMenuVo class]]) {
        TDFForceMenuVo *menuVo = (TDFForceMenuVo *)data;
        self.nameLabel.text = menuVo.menuName;
        
        self.selectCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"必选数量：%@", nil),menuVo.forceConfigVo.forceType == 0?[NSString stringWithFormat:@"%d",menuVo.forceConfigVo.forceNum]:NSLocalizedString(@"与用餐人数相同", nil)];
        
        if (menuVo.forceConfigVo.make.makeName.length>0||menuVo.forceConfigVo.spec.specName.length>0) {
            [self.detailInfoLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).with.offset(-10);
            }];
            NSString *str;
            if (menuVo.forceConfigVo.make.makeName.length>0) {
                str = menuVo.forceConfigVo.make.makeName;
                if (menuVo.forceConfigVo.spec.specName.length>0) {
                    str = [NSString stringWithFormat:@"%@;%@",str,menuVo.forceConfigVo.spec.specName];
                }
            }else
            {
                str = menuVo.forceConfigVo.spec.specName;
            }
            
            self.detailInfoLable.text = str;
        }else
        {
            self.detailInfoLable.text = nil;
            [self.detailInfoLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).with.offset(0);
            }];
        }

    }
}

+ (CGFloat)heightForCellWithData:(id)data
{
    if ([data isKindOfClass:[TDFForceMenuVo class]]) {
        TDFForceMenuVo *menuVo = (TDFForceMenuVo *)data;
        if (menuVo.forceConfigVo.make.makeName.length>0||menuVo.forceConfigVo.spec.specName.length>0) {
            return 60;
        }
        return 44;
    }
    return 0;
}


@end
