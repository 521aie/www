//
//  TDFMustSelectGoodsListView.m
//  RestApp
//
//  Created by hulatang on 16/8/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFMustSelectGoodsListView.h"
#import "UIImageView+TDFRequest.h"
#import "TDFRightSelectView.h"
#import "TDFForceKindMenuVo.h"
#import "UIImageView+WebCache.h"
#import "TDFForceMenuVo.h"
#import "HeadNameItem.h"
#import "AlertBox.h"
#define HEADERVIEW_HEIGHT 44
#define ROW_HEIGHT 84
@interface TDFMustSelectGoodsListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@end

@implementation TDFMustSelectGoodsListView

#pragma mark -- init
- (void)setScrollIndex:(NSInteger)scrollIndex
{
    _scrollIndex = scrollIndex;
    [self scrollToSection:scrollIndex];
}

- (TDFMustSelectGoodsListView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self layoutTableView];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (void)layoutTableView
{
    self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ROW_HEIGHT;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark --UITableViewDelegate,UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < self.dataArray.count) {
        TDFForceKindMenuVo *menuVo = self.dataArray[section];
        HeadNameItem *headNameItem = [[HeadNameItem alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        UIView *sectionHeaderBGView = [[UIView alloc] initWithFrame:headNameItem.bounds];
        [sectionHeaderBGView addSubview:headNameItem];
        [headNameItem initWithName:menuVo.kindMenuName panelRect:CGRectMake(0, 0,200, 24)];
        return sectionHeaderBGView;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERVIEW_HEIGHT;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < self.dataArray.count) {
        TDFForceKindMenuVo *menuVo = self.dataArray[section];
        return menuVo.forceMenuVoList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.layer.cornerRadius = 5;
        cell.imageView.clipsToBounds = YES;
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.tag = 10;
        titleLable.textColor = RGBA(153, 153, 153, 1);
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont systemFontOfSize:10];
        titleLable.numberOfLines = 0;
        titleLable.text = NSLocalizedString(@"暂无图片", nil);
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
        [cell.contentView addSubview:lineView];
        [cell.contentView addSubview:titleLable];
        [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(10);
            make.top.equalTo(cell.contentView.mas_top).offset(10);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
            make.width.equalTo(cell.imageView.mas_height);
        }];
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.imageView.mas_left).offset(2);
            make.right.equalTo(cell.imageView.mas_right).offset(-2);
            make.centerY.equalTo(cell.imageView.mas_centerY);
        }];
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.imageView.mas_right).offset(15);
            make.bottom.equalTo(cell.contentView.mas_centerY).offset(-4);
        }];
        [cell.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.imageView.mas_right).offset(15);
            make.top.equalTo(cell.contentView.mas_centerY).offset(4);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(0);
            make.height.equalTo(@1);
            make.left.equalTo(cell.contentView.mas_left).offset(0);
            make.width.equalTo(@(SCREEN_WIDTH));
        }];
    }
    
    if (indexPath.section < self.dataArray.count) {
        TDFForceKindMenuVo *kindMenuVo = self.dataArray[indexPath.section];
        if (indexPath.row < kindMenuVo.forceMenuVoList.count) {
            TDFForceMenuVo *menuVo = kindMenuVo.forceMenuVoList[indexPath.row];
            cell.textLabel.text = menuVo.menuName;
            cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"¥%.2lf/%@", nil),menuVo.price,menuVo.account];
            UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:10];
            if (menuVo.path.length > 0) {
                [cell.imageView tdf_imageRequstWithPath:menuVo.path placeholderImage:[UIImage imageNamed:@"img_default.png"] urlModel:ImageUrlOrigin];
                titleLabel.hidden = YES;
            }else
            {
                [cell.imageView sd_cancelCurrentAnimationImagesLoad];
                [cell.imageView setImage:[UIImage imageNamed:@"img_default.png"]];
                titleLabel.hidden = NO;
            }
            [self layoutRightViewWithCell:cell andForceMenuVo:menuVo];
        }
    }
    return cell;
}

- (void)layoutRightViewWithCell:(UITableViewCell *)cell andForceMenuVo:(TDFForceMenuVo *)menuVo
{
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 15, 20, 20)];
    NSString *image;
    if (!menuVo.isSelf || !menuVo.isReserve || menuVo.isMealOnly) {
        image = @"icon_tanhao";
    }else
    {
        image = @"ico_next";
    }
    nextImageView.image = [UIImage imageNamed:image];
    [accessoryView addSubview:nextImageView];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_force_menu"]];
    [accessoryView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(accessoryView.mas_centerY);
        make.right.equalTo(nextImageView.mas_left).offset(-10);
    }];
    
    
    if (menuVo.isForceMenu == 1) {
        imageView.hidden = NO;
    }else
    {
        imageView.hidden = YES;
    }
    cell.accessoryView = accessoryView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.dataArray.count) {
        TDFForceKindMenuVo *kindMenuVo = self.dataArray[indexPath.section];
        if (indexPath.row < kindMenuVo.forceMenuVoList.count) {
            TDFForceMenuVo *menuVo = kindMenuVo.forceMenuVoList[indexPath.row];
            if (menuVo.isSelf == 0) {
                [AlertBox show:NSLocalizedString(@"此商品已下架，无法添加成为必选商品。", nil)];
                return;
            }
            if (menuVo.isReserve == 0) {
                [AlertBox show:NSLocalizedString(@"此商品在顾客端不可点，不能添加为必选商品。", nil)];
                return;
            }
            if (menuVo.isMealOnly) {
                [AlertBox show:NSLocalizedString(@"此商品已被设置了“仅在套餐中显示”不能添加为必选商品。", nil)];
                return;
            }
            if ([self.delegate respondsToSelector:@selector(selectGoodWithData:andIsForceMenu:)]) {
                [self.delegate selectGoodWithData:menuVo andIsForceMenu:menuVo.isForceMenu];
            }
        }
        
    }
}

#pragma mark -- scrollToSection
- (void)scrollToSection:(NSInteger)section
{
    if (section < self.dataArray.count) {
        float offset = 0;
        for (int i = 0; i < section; i ++) {
            offset += HEADERVIEW_HEIGHT;
            TDFForceKindMenuVo *menuVo = self.dataArray[i];
            for (int j = 0; j < menuVo.forceMenuVoList.count; j ++) {
                offset += ROW_HEIGHT;
            }
        }
        [self.tableView setContentOffset:CGPointMake(0, offset) animated:YES];
    }
}

@end
