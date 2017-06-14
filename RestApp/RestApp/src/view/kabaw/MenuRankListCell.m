//
//  MenuRankListCell.m
//  RestApp
//
//  Created by guopin on 16/1/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuRankListCell.h"

@implementation MenuRankListCell

- (void)awakeFromNib {
    [self.selectBtn  setBackgroundImage:[UIImage imageNamed:@"ico_uncheck.png"] forState:UIControlStateNormal];
    [self.selectBtn  setBackgroundImage:[UIImage imageNamed:@"ico_check.png"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)initDataWithMenuStatisticsVo:(MenuStatisticsVo *)vo{
 
    self.menuName.attributedText = [self attributeString:vo.name SecondString: vo.isSelf?@"":[NSString stringWithFormat:NSLocalizedString(@"(已下架)", nil)]];
    self.selectBtn.selected = vo.isAutomatic;
    self.counts.text = [NSString stringWithFormat:NSLocalizedString(@"%ld份", nil),vo.count];

}
-(NSMutableAttributedString *)attributeString:(NSString *)firstString SecondString:(NSString *)secondString {
    NSDictionary *attrDict1 = @{ NSForegroundColorAttributeName: [UIColor blackColor] };
    NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString:firstString attributes: attrDict1];
    
    NSDictionary *attrDict2 = @{NSForegroundColorAttributeName: [UIColor redColor] };
    NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString: secondString attributes: attrDict2];
     NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithAttributedString: attrStr1];
    [attributedStr appendAttributedString: attrStr2];
    return attributedStr;
}

@end
