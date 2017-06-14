//
//  MultiCheckDetailCell.m
//  RestApp
//
//  Created by zxh on 14-7-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "OptionSelectBox.h"
#import "OptionSelectView.h"
#import "OptionSelectItemCell.h"

@implementation OptionSelectItemCell

- (void)initWithData:(id<INameItem>)data isSelected:(BOOL)isSelected delegate:(OptionSelectBox *)optionSelectBox
{
    self.type = 0;
    self.data = data;
    self.nameLbl.text = [data obtainItemName];
    self.optionSelectBox = optionSelectBox;
    [self setSelect:isSelected];
}

- (void)initWithData:(id<INameItem>)data isSelected:(BOOL)isSelected target:(OptionSelectView *)optionSelectBox
{
    self.data = data;
    self.type = 1;
    self.nameLbl.text = [data obtainItemName];
    self.optionSelectView = optionSelectBox;
    [self setSelect:isSelected];
}
- (IBAction)itemBtnClick:(id)sender
{  if(self.type){
    [self.optionSelectView selectItem:self];
     }else{
    [self.optionSelectBox selectItem:self];}
}

- (void)setSelect:(BOOL)isSelected
{
    if (isSelected) {
        self.selectImg.image = [UIImage imageNamed:@"ico_check.png"];
    } else {
        self.selectImg.image = [UIImage imageNamed:@"ico_uncheck.png"];
    }
}

@end
