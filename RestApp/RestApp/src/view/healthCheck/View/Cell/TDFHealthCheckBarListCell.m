//
//  TDFHealthCheckBarListCell.m
//  RestApp
//
//  Created by happyo on 2017/5/23.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckBarListCell.h"
#import "TDFHealthCheckItemBodyModel.h"
#import "TDFHealthTitleView.h"
#import "TDFHealthCheckBarChartView.h"

@interface TDFHealthCheckBarListCell ()

@property (nonatomic, strong) TDFHealthTitleView *titleView;

@property (nonatomic, strong) UIView *containerView;

@end
@implementation TDFHealthCheckBarListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configViews];
    }
    return self;
}


-(void)configViews{
    [self addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).with.offset(10);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

-(void)cellLoadData:(TDFHealthCheckItemBodyModel *)data{
    [self.titleView initTitle:data.title detail:data.desc];
    if ([ObjectUtil isEmpty:data.details]) {
        return;
    }
   
    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *datas = [[NSMutableArray alloc]init];
    for (NSString *str in data.details) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:NULL];
        [datas addObject:dict];
    }

    for (int i = 0 ; i < datas.count; i++) {
        TDFHealthCheckBarChartView *chartView = [[TDFHealthCheckBarChartView alloc] init];
        CGFloat width = 0.95 * SCREEN_WIDTH - 15 * 2;
        chartView.frame = CGRectMake(15, i * 110, width, 110);
        chartView.backgroundColor = [UIColor clearColor];
        
        [chartView loadDatas:datas[i]];
        
        [self.containerView addSubview:chartView];
    }
}

/**
 cell height
 */
+(CGFloat)heightForCellAtIndexPath:(UITableView *)tableView model:(id)data{
    TDFHealthCheckItemBodyModel *model = data;
    TDFHealthTitleView *titleView = [[TDFHealthTitleView alloc] init];
    [titleView initTitle:model.title detail:model.desc];
    return model.details.count * 110 + titleView.frame.size.height + 20 + 10;
}

#pragma mark -- Getters && Setters --

- (TDFHealthTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[TDFHealthTitleView alloc] init];
    }
    
    return _titleView;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _containerView;
}

@end
