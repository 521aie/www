//
//  TDFBaseView.m
//  RestApp
//
//  Created by hulatang on 16/8/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "FooterListView.h"
#import "TDFBaseView.h"


@interface TDFBaseHeaderView : UIView
@property (nonatomic, copy)void(^frameUpdate)();
@end

@implementation TDFBaseHeaderView
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.frameUpdate) {
        self.frameUpdate();
    }
}
@end

@interface TDFBaseView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)TDFBaseHeaderView *tableHeaderView;
@property (nonatomic ,strong)FooterListView *footerListView;
@end

@implementation TDFBaseView

#pragma mark -- init
- (instancetype)initWithFrame:(CGRect)frame
              withHeaderImage:(UIImage *)headerImage
                  andHelpText:(NSString *)helpText
{
    return [self initWithFrame:frame
               withHeaderImage:headerImage
                   andHelpText:helpText
                    showDetail:YES];
}

- (instancetype)initWithFrame:(CGRect)frame
              withHeaderImage:(UIImage *)headerImage
                  andHelpText:(NSString *)helpText
                   showDetail:(BOOL)isShowDetail {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutTableHeaderViewWithHeaderImage:headerImage
                                       andHelpText:helpText
                                      isShowDetail:isShowDetail];
        [self layoutTableView];
    }
    return self;
}

- (void)initFooterListViewWithArray:(NSArray *) array
                       withDelegate:(id<FooterListEvent>)delegate
                        andShowHelp:(BOOL)isShow{
    [self.footerListView setBackgroundColor:[UIColor clearColor]];
    [self.footerListView initDelegate:delegate btnArrs:array];
    [self.footerListView showHelp:isShow];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
}


- (FooterListView *)footerListView
{
    if (!_footerListView) {
        _footerListView = [[FooterListView alloc] init];
        [_footerListView awakeFromNib];
        _footerListView.frame = CGRectMake(0, self.bounds.size.height - _footerListView.view.bounds.size.height, self.bounds.size.width, _footerListView.view.bounds.size.height);
        [self addSubview:_footerListView];
    }
    return _footerListView;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [TDFBaseHeaderView new];
    }
    return _tableHeaderView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    }
    return _tableView;
}

#pragma mark --layoutView
- (void)layoutTableHeaderViewWithHeaderImage:(UIImage *)image
                                 andHelpText:(NSString *)helpText
                                isShowDetail:(BOOL)isShowDetail
{
    if (helpText.length == 0) {
        return;
    }
    @weakify(self);
    self.tableHeaderView.frameUpdate = ^{
        @strongify(self);
        self.tableView.tableHeaderView = self.tableHeaderView;
    };
    self.tableHeaderView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:image];
    [self.tableHeaderView addSubview:headerImageView];
    [self.tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@200);
    }];
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.numberOfLines = 0;
    [self.tableHeaderView addSubview:infoLabel];
    infoLabel.text = helpText;
    infoLabel.textColor = [UIColor grayColor];
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [_tableHeaderView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tableHeaderView.mas_left);
        make.right.equalTo(_tableHeaderView.mas_right);
        make.bottom.equalTo(_tableHeaderView.mas_bottom);
        make.height.equalTo(@1);
    }];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableHeaderView.mas_top).with.offset(10);
        make.centerX.equalTo(_tableHeaderView.mas_centerX);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImageView.mas_bottom).with.offset(7);
        make.left.equalTo(_tableHeaderView).with.offset(10);
        make.bottom.equalTo(_tableHeaderView).with.offset(-35);
        make.right.equalTo(_tableHeaderView).with.offset(-10);
        if (!isShowDetail) {
            make.bottom.equalTo(_tableHeaderView).with.offset(-5);
        }
    }];
    if (isShowDetail) {
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailButton setTitle:NSLocalizedString(@"查看详情 >>", nil) forState:UIControlStateNormal];
        [detailButton setTitleColor:RGBA(0, 136, 204, 1) forState:UIControlStateNormal];
        [detailButton addTarget:self action:@selector(showHelpDialog:) forControlEvents:UIControlEventTouchUpInside];
        detailButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_tableHeaderView addSubview:detailButton];
        [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(infoLabel.mas_bottom).offset(5);
            make.right.equalTo(_tableHeaderView).with.offset(-10);
            make.bottom.equalTo(_tableHeaderView).with.offset(-5);
        }];
    }
    [self.tableHeaderView setNeedsLayout];
    [self.tableHeaderView layoutIfNeeded];
}

- (void)layoutTableView
{
    [self addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
}

#pragma mark --UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.numberOfRowWithSection) {
        return self.numberOfRowWithSection(section);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.sectionHeaderview) {
        return self.sectionHeaderview(tableView,section);
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.heightForSectionView) {
        return self.heightForSectionView(tableView,section);
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.numberOfSection) {
        return self.numberOfSection(tableView);
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellWithTableViewAndIndexPath) {
        return self.cellWithTableViewAndIndexPath(tableView,indexPath);
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        [self initWithCell:cell];
        [self layouWithCell:cell];
        
    }
    if (self.loadDataInCell) {
        self.loadDataInCell(cell,indexPath);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.heightForRowInTableViewWithIndexPath) {
        return self.heightForRowInTableViewWithIndexPath(tableView,indexPath);
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectRow) {
        self.didSelectRow(tableView,indexPath);
    }
}

#pragma mark --reloadData
- (void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark --buttonclick
- (void)showHelpDialog:(UIButton *)button
{
    if (self.showHelpDialog) {
        self.showHelpDialog();
    }
}

#pragma mark --initWithCell
- (void)initWithCell:(UITableViewCell *)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.imageView.layer.borderWidth = 1;
    cell.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.imageView.layer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1].CGColor;
    cell.imageView.layer.cornerRadius = 30;
    [cell.imageView clipsToBounds];
    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
}
#pragma mark --layoutCell
- (void)layouWithCell:(UITableViewCell *)cell {
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left);
        make.right.equalTo(cell.mas_right);
        make.bottom.equalTo(cell.mas_bottom);
        make.height.equalTo(@1);
    }];
    [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(10);
        make.top.equalTo(cell.contentView.mas_top).offset(10);
        make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
        make.width.equalTo(cell.imageView.mas_height);
    }];
    
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.imageView.mas_right).offset(15);
        make.bottom.equalTo(cell.contentView.mas_centerY).offset(-4);
    }];
    [cell.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.imageView.mas_right).offset(15);
        make.top.equalTo(cell.contentView.mas_centerY).offset(4);
        make.right.equalTo(cell.contentView.mas_right).offset(-20);
    }];
}

@end
