//
//  TDFCheckInspectorCell.m
//  ClassProperties
//
//  Created by guopin on 2016/12/15.
//  Copyright © 2016年 ximi. All rights reserved.
//

#import "TDFHealthCheckInspectorCell.h"
#import "TDFHealthTitleView.h"
#import "TDFHealthCheckItemBodyModel.h"
#import <Masonry/Masonry.h>
@interface TDFHealthCheckInspectorCell()
@property (nonatomic, strong) TDFHealthTitleView *titleView;
@end
@implementation TDFHealthCheckInspectorCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configViews];
    }
    return self;
}

-(void)configViews{
    self.titleView = ({
        TDFHealthTitleView *view = [TDFHealthTitleView new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(10);
        }];
        view;
    });
}
#pragma mark

-(void)cellLoadData:(TDFHealthCheckItemBodyModel *)data{
    
    [self.titleView initTitle:data.title detail:data.desc];
    [self.titleView layoutIfNeeded];
}
+(CGFloat)heightForCellAtIndexPath:(UITableView *)tableView model:(id)data {
    static UITableViewCell *cell = nil;
    NSString *cellIdentifier = [NSString stringWithUTF8String:object_getClassName([TDFHealthCheckInspectorCell class])];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[TDFHealthCheckInspectorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }) ;
    [(TDFHealthCheckInspectorCell *)cell cellLoadData:(TDFHealthCheckItemBodyModel*)data];
    return [(TDFHealthCheckInspectorCell *)cell calculateHeightForCell];
}
- (CGFloat)calculateHeightForCell {
    [self layoutIfNeeded];
    CGFloat height = self.titleView.frame.origin.y + self.titleView.frame.size.height;
    return height > 22 ? (height+10):(22+10);
}


@end
