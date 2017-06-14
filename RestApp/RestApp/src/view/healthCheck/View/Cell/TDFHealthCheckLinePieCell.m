//
//  TDFHealthCheckLinePieCell.m
//  RestApp
//
//  Created by happyo on 2017/6/8.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckLinePieCell.h"
#import "TDFHealthTitleView.h"
#import "TDFHealthCheckItemBodyModel.h"
#import "TDFChartFanDiagram.h"
#import "UIColor+Hex.h"

@interface TDFHealthCheckLinePieCell ()

@property (nonatomic, strong) TDFHealthTitleView *titleView;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, assign) CGFloat height;

@end
@implementation TDFHealthCheckLinePieCell

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
  
    CGFloat y = 0;
    CGFloat width = 0.95 * SCREEN_WIDTH - 30;

    for (int i = 0 ; i < datas.count; i++) {
        UIView *item = [self healthCheckPieView:datas[i]];
        item.backgroundColor = [UIColor clearColor];
        
        CGFloat eachHeight = self.height > 85 ? self.height : 85;
        item.frame = CGRectMake(0, y, width, eachHeight);
        
        y += eachHeight + 10;
        
        [self.containerView addSubview:item];
    }

}

-(UIView *)healthCheckPieView:(id)dict
{
    UIView *pageView = [[UIView alloc]initWithFrame:CGRectZero];
    NSArray *charts = dict[@"charts"];
    if ([ObjectUtil isEmpty:dict] || [ObjectUtil isEmpty:charts]) {
        return pageView;
    }
    NSInteger count = [charts count];

    UIView *listView = [self annotationlistView:charts];
    [pageView addSubview:listView];
    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pageView.mas_left).offset(19);
        make.top.equalTo(pageView.mas_top).offset(8);
        make.height.mas_equalTo(@(count*9+(count-1)*6));
        make.width.mas_equalTo(@80);
    }];
   
    self.height = count*9+(count-1)*6;
    NSArray *valus = [charts valueForKeyPath:@"value"];
    NSArray *colors = [charts valueForKeyPath:@"color"];

    TDFChartFanDiagram *pieView = [TDFChartFanDiagram new];
    [pageView addSubview:pieView];
    [pieView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pageView.mas_top).offset(4);
        make.size.mas_equalTo(CGSizeMake(54, 54));
        make.centerX.equalTo(pageView.mas_centerX);
    }];
    pieView.colorArray = colors;
    pieView.dataArray = valus;

    UILabel *titleView = [UILabel new];
    titleView.textColor = [UIColor colorWithHexString:@"#666666"];
    [pageView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pieView.mas_bottom).offset(5);
        make.centerX.equalTo(pieView.mas_centerX);
        make.width.mas_offset(@112);
    }];
    titleView.text = dict[@"subscript"];
    titleView.font = [UIFont systemFontOfSize:9];
    titleView.textAlignment = NSTextAlignmentCenter;

    return pageView;
}

-(NSArray*)data:(NSArray *)datas maxItems:(NSInteger)maxNum{
    NSMutableArray *data = [NSMutableArray array];
    for (NSInteger i = 0; i < [datas count]; i++) {
        NSMutableArray *items = [NSMutableArray array];
        NSInteger count = 0;
        while (count != maxNum && i < [datas count]) {
            count++;
            [items addObject:datas[i]];
            i++;
        }
        [data addObject:items];
        i--;
    }
    return data;
}

-(UIView *)annotationlistView:(NSArray *)datas{
    UIView *listView = [[UIView alloc]initWithFrame:CGRectZero];
    UIView *lastView = nil;
    for (NSInteger i = 0; i < datas.count; i++) {
        UIView *item = [self annotationItem:datas[i]];
        [listView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(listView);
            make.size.mas_equalTo(CGSizeMake(6, 9));
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(6);
            }else{
                make.top.equalTo(listView.mas_top);
            }
        }];
        lastView = item;
    }
    return listView;
}


-(UIView *)annotationItem:(id)dict
{
    UIView *item = [[UIView alloc]initWithFrame:CGRectZero];
    UIView *icon = [[UIView alloc]init];
    [item addSubview:icon];
    icon.backgroundColor =  [UIColor colorWithHexString:dict[@"color"]];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6,8));
        make.left.and.top.equalTo(item);
    }];
    UILabel *title = [[UILabel alloc]init];
    title.text = dict[@"subscript"];
    title.textColor = [UIColor colorWithHexString:@"#666666"];
    title.font = [UIFont systemFontOfSize:9];
    [item addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(item);
        make.left.equalTo(icon.mas_right).offset(4);
        make.width.mas_equalTo(@80);
    }];
    return item;
}

/**
 cell height
 */
+(CGFloat)heightForCellAtIndexPath:(UITableView *)tableView model:(id)data{
    TDFHealthCheckItemBodyModel *model = data;
    TDFHealthTitleView *titleView = [[TDFHealthTitleView alloc] init];
    [titleView initTitle:model.title detail:model.desc];
    
    NSMutableArray *datas = [[NSMutableArray alloc]init];
    for (NSString *str in model.details) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:NULL];
        [datas addObject:dict];
    }
    
    CGFloat piesHeight = 0;
    
    for (int i = 0 ; i < datas.count; i++) {
        NSDictionary *dict = datas[i];
        
        NSArray *charts = dict[@"charts"];
        
        CGFloat height = charts.count * 9 + (charts.count - 1) * 6;
        
        CGFloat eachHeight = height > 85 ? height : 85;
        
        piesHeight += eachHeight + 10;
    }
    
    
    return piesHeight + titleView.frame.size.height + 20 + 10;
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
