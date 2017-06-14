//
//  TDFMustSelectGoodsView.m
//  RestApp
//
//  Created by hulatang on 16/7/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFMustSelectGoodsView.h"
#import "TDFMustSelectGoodsCell.h"
#import "HeadNameItem.h"
#import "HelpDialog.h"
@interface TDFMustSelectGoodsView ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic ,strong)UIView *tableHeaderView;
@end


@implementation TDFMustSelectGoodsView

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        [self layoutTableHeaderView];
    }
    return _tableHeaderView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
        [self addSubview:_tableView];
    }
    return _tableView ;
}

#pragma mark --initView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self initTableView];
    }
    return self;
}

- (void)initTableView
{
    self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
}

- (void)layoutTableHeaderView
{
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    _tableHeaderView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"force_select_goods"]];
    [_tableHeaderView addSubview:imageView];
    UILabel *label = [[UILabel alloc] init];
    label.text = NSLocalizedString(@"主要是餐具、锅底、小料等用餐时必点的商品。在掌柜端可将商品和套餐设置成必选商品，顾客扫码点菜后，必点商品会自动加入购物车。", nil);
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    [_tableHeaderView addSubview:label];
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailButton setTitle:NSLocalizedString(@"查看详情 >>", nil) forState:UIControlStateNormal];
    [detailButton setTitleColor:RGBA(0, 136, 204, 1) forState:UIControlStateNormal];
    [detailButton addTarget:self action:@selector(showHelpDialog:) forControlEvents:UIControlEventTouchUpInside];
    detailButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_tableHeaderView addSubview:detailButton];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableHeaderView.mas_top).with.offset(5);
        make.centerX.equalTo(_tableHeaderView.mas_centerX);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(5);
        make.left.equalTo(_tableHeaderView).with.offset(10);
        make.bottom.equalTo(_tableHeaderView).with.offset(-20);
        make.right.equalTo(_tableHeaderView).with.offset(-10);
    }];
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(0);
        make.right.equalTo(_tableHeaderView).with.offset(-10);
        make.bottom.equalTo(_tableHeaderView).with.offset(-5);
    }];
    
}
#pragma mark --UITableViewDataSource,UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadNameItem *headNameItem = [[HeadNameItem alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [headNameItem initWithName:NSLocalizedString(@"必选商品", nil)];
    UIView *sectionHeaderBGView = [[UIView alloc] initWithFrame:headNameItem.bounds];
    [sectionHeaderBGView addSubview:headNameItem];
    return sectionHeaderBGView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.row < self.dataArray.count) {
        return [TDFMustSelectGoodsCell heightForCellWithData:self.dataArray[indexPath.row]];
    }

    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDFMustSelectGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TDFMustSelectGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        view.image = [UIImage imageNamed:@"ico_next"];
        cell.accessoryView = view;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row < self.dataArray.count) {
        [cell initDataWithData:self.dataArray[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArray.count) {
        if ([self.delegate respondsToSelector:@selector(seeDetailGoodInfoWithData:)]) {
            [self.delegate seeDetailGoodInfoWithData:self.dataArray[indexPath.row]];
        }
    }
}

- (void) showHelpDialog:(UIButton *) btn
{
    [HelpDialog show:@"forceMenuList"];
}

@end
