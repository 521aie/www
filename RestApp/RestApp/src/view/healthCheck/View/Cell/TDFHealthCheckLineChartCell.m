//
//  TDFHealthCheckLineChartCell.m
//  RestApp
//
//  Created by happyo on 2017/5/31.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckLineChartCell.h"
#import "TDFHealthCheckItemBodyModel.h"
#import "TDFChartView.h"
#import "UIColor+Hex.h"
#import "TDFHealthTitleView.h"

@interface TDFHealthCheckLineChartCell ()

@property (nonatomic, strong) TDFHealthTitleView *titleView;

@property (nonatomic, strong) UIView *containerView;

@end
@implementation TDFHealthCheckLineChartCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configViews];
    }
    return self;
}


-(void)configViews
{
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

-(void)cellLoadData:(TDFHealthCheckItemBodyModel *)data
{
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
        TDFChartView *chartView = [[TDFChartView alloc] init];
        
        chartView.axisColor = [UIColor colorWithHeX:0x999999];
        chartView.xLabelColor = [UIColor colorWithHeX:0x666666];
        chartView.yLabelColor = [UIColor colorWithHeX:0x666666];
        
        CGFloat width = 0.95 * SCREEN_WIDTH - 35 - 25;
        chartView.frame = CGRectMake(35, i * 110, width, 80);
        chartView.backgroundColor = [UIColor clearColor];
        
        [self configureChartView:chartView dict:datas[i]];
        
        [self.containerView addSubview:chartView];
    }

}

- (void)configureChartView:(TDFChartView *)chartView dict:(NSDictionary *)dict
{
    NSArray *xline = dict[@"xline"];
    NSMutableArray *xAxisValues = [NSMutableArray array];
    
    for (NSDictionary *xPoint in xline) {
        NSNumber *hideFlag = xPoint[@"hideFlag"];
        
        if ([hideFlag boolValue]) {
            [xAxisValues addObject:@""];
        } else {
            [xAxisValues addObject:xPoint[@"displayLbl"]];
        }
    }
    
    chartView.xAxisValues = xAxisValues;
    
    
    
    NSNumber *yMax = dict[@"ylineMaxValue"];
    
    chartView.yMax = [yMax floatValue];
    
    
    
    NSArray *yline = dict[@"yline"];
    NSMutableArray *yAxisValues = [NSMutableArray array];
    
    for (NSDictionary *yPoint in yline) {
        [yAxisValues addObject:yPoint[@"displayLbl"]];
    }
    
    chartView.yAxisValues = yAxisValues;
    
    
    
    NSArray *lines = dict[@"lines"];
    NSMutableArray *lineList = [NSMutableArray array];
    for (NSDictionary *lineDict in lines) {
        TDFLine *line = [[TDFLine alloc] init];
        
        line.color = [UIColor colorWithHexString:lineDict[@"color"]];
        line.title = lineDict[@"subscript"];
        
        NSArray *points = lineDict[@"points"];
        NSMutableArray *pointList = [NSMutableArray array];
        
        for (NSDictionary *pointDict in points) {
            NSNumber *yNum = pointDict[@"value"];
            TDFPoint *point = [TDFPoint pointWithX:0 y:[yNum floatValue]];
            
            [pointList addObject:point];
        }
        
        line.points = pointList;
        
        [lineList addObject:line];
    }
    
    chartView.lines = lineList;
}

/**
 cell height
 */
+(CGFloat)heightForCellAtIndexPath:(UITableView *)tableView model:(id)data
{
    TDFHealthCheckItemBodyModel *model = data;
    TDFHealthTitleView *titleView = [[TDFHealthTitleView alloc] init];
    [titleView initTitle:model.title detail:model.desc];
    return model.details.count * 130 + titleView.frame.size.height + 20 + 10;
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
