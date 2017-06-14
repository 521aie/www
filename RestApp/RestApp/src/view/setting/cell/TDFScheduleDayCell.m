//
//  TDFScheduleDayCell.m
//  RestApp
//
//  Created by xueyu on 2016/11/7.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFScheduleDayCell.h"
@interface TDFScheduleDayCell()
@property (nonatomic, strong)  UIImageView *imgView;
@property (nonatomic, strong)  UILabel *titleTxt;
@end
@implementation TDFScheduleDayCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.titleTxt = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(2, 2, 2, 2));
            }];
            view.textAlignment = NSTextAlignmentCenter;
            view.layer.cornerRadius = 5;
            view.clipsToBounds = YES;
            view.layer.borderWidth = 1;
            view.layer.borderColor = [UIColor lightGrayColor].CGColor;
            view.font = [UIFont systemFontOfSize:12];
            view;
        });
        self.imgView = ({
            UIImageView *view = [UIImageView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(2, 2, 2, 2));
            }];
            view.image = [UIImage imageNamed:@"menu_sign_red"];
            view;
        });
    }
    return self;
}

-(void)initData:(id)title datas:(NSArray *)datas{
    self.titleTxt.text =  [title isKindOfClass:[NSString class]]?title:[title stringValue];
    self.titleTxt.textColor = [datas containsObject:title] ? [UIColor redColor]:[UIColor darkGrayColor];
    self.imgView.hidden = ![datas containsObject:title];
}

@end

