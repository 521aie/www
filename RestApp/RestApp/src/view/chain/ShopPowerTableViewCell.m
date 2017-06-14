//
//  ShopPowerTableViewCell.m
//  RestApp
//
//  Created by zishu on 16/10/14.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "ShopPowerTableViewCell.h"

@implementation ShopPowerTableViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
      [self initMainView];
    }
    return self;
}

- (void) initMainView
{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 96);
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 96)];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.contentView addSubview:bgView];

    self.edititemView = [[EditItemView alloc] init];
    self.edititemView.lblDetail.text = @"";
    self.edititemView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 48);
    [self.contentView addSubview:self.edititemView];
    
    self.edititemRadio = [[EditItemRadio alloc] init];
    self.edititemRadio.frame = CGRectMake(0, 48,  self.contentView.frame.size.width, 48);
    [self.contentView addSubview:self.edititemRadio];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
