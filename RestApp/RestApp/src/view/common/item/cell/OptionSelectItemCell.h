//
//  MultiCheckDetailCell.h
//  RestApp
//
//  Created by zxh on 14-7-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"

#define OPTION_SELECT_ITEM_CELL_HEIGHT 88
#define OPTION_SELECT_ITEM_CELL44_HEIGHT 44

@class OptionSelectBox,OptionSelectView;
@interface OptionSelectItemCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *selectImg;
@property (nonatomic, strong) IBOutlet UILabel *nameLbl;
@property (nonatomic, strong) OptionSelectBox *optionSelectBox;

@property (nonatomic, strong) id<INameItem> data;
@property(nonatomic, strong) OptionSelectView *optionSelectView;
@property (nonatomic,assign) NSInteger type;
- (void)initWithData:(id<INameItem>)data isSelected:(BOOL)isSelected target:(OptionSelectView *)optionSelectBox;
- (void)initWithData:(id<INameItem>)data isSelected:(BOOL)isSelected delegate:(OptionSelectBox *)optionSelectBox ;

- (IBAction)itemBtnClick:(id)sender;

- (void)setSelect:(BOOL)isSelected;

@end

