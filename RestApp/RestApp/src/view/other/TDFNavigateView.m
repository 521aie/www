//
//  TDFNavigateView.m
//  RestApp
//
//  Created by 黄河 on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "TDFFunctionKindVo.h"
#import "TDFNavigateView.h"
#import "TDFFunctionVo.h"
#import "Masonry.h"
#import "TDFLeftHandSectionHeaderView.h"

#define sectionHeaderHeight 20;

@implementation TDFNavigateSectionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"forwardCells" : [TDFHomeGroupForwardChildCellModel class]
             };
}

@end

@interface TDFNavigateView ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    BOOL _searchStatus;
    
    UISearchBar *_searchBar;
}
@property (nonatomic, strong)UIView         *headerView;

@property (nonatomic, strong)NSMutableArray *headerViewArray;

@end

@implementation TDFNavigateView

- (void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark --init


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UITableView new];
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [UIView new];
    }
    return _headerView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [UIView new];
        for (int i = 0; i < 1; i ++) {
            UIControl *controll = [[UIControl alloc] initWithFrame:CGRectMake(i * self.bounds.size.width/2.0, 0, self.bounds.size.width/2.0, 49)];
            controll.tag = 20 + i;
            [controll addTarget:self action:@selector(footerClick:) forControlEvents:UIControlEventTouchUpInside];
            UIView *contentView = [UIView new];
            contentView.userInteractionEnabled = NO;
            [controll addSubview:contentView];
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@18);
                make.centerX.equalTo(controll.mas_centerX);
                make.centerY.equalTo(controll.mas_centerY);
            }];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:i==0?@"left_functions_icon":@"left_help_video_icon"]];
            [contentView addSubview:imageView];
            UILabel *label = [UILabel new];
            label.font = [UIFont boldSystemFontOfSize:12];
            label.textColor = [UIColor whiteColor];
            label.text = i ==0 ? NSLocalizedString(@"功能大全", nil):NSLocalizedString(@"帮助视频", nil);
            [contentView addSubview:label];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(contentView.mas_centerY);
                make.left.equalTo(contentView.mas_left);
                make.width.equalTo(@22);
                make.height.equalTo(@22);
            }];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(contentView.mas_centerY);
                make.left.equalTo(imageView.mas_right).offset(4);
                make.right.equalTo(contentView.mas_right);
            }];
            [_footerView addSubview:controll];
        }
        
        UIView *line = [UIView new];
        line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        [_footerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footerView.mas_left);
            make.right.equalTo(_footerView.mas_right);
            make.top.equalTo(_footerView.mas_top);
            make.height.equalTo(@1);
        }];

    }
    return _footerView;
}

- (UILabel *) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
//        _titleLabel.text = [[Platform Instance] isChainOrBranch]?@"收银设置":NSLocalizedString(@"店家设置", nil);
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

- (NSMutableArray *)headerViewArray
{
    if (!_headerViewArray) {
        _headerViewArray = [NSMutableArray array];
    }
    return _headerViewArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headerView.frame = CGRectMake(0, 0, frame.size.width, 100);
        [self addSubview:self.headerView];
        
        self.footerView.frame = CGRectMake(0, frame.size.height - 49, frame.size.width, 49);
//        [self initFooterView];
        [self addSubview:self.footerView];
        self.footerView.hidden = [[Platform Instance] isChainOrBranch];
        [self initHeaderView];
        self.tableView.frame = CGRectMake(0, self.headerView.frame.size.height, frame.size.width, frame.size.height - 149);
        [self addSubview:self.tableView];
        [self initWithTableView];
        [self initNotification];
    }
    return self;
}


///保存功能大全和点回主页以及其他回到这里时要回归元状态
- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelClick) name:@"notification_back_navigateView" object:nil];
}

- (void)cancelClick {
    [self searchBarCancelButtonClicked:_searchBar];
}

- (void)initHeaderView {
    [self.headerView addSubview:self.titleLabel];
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.placeholder = NSLocalizedString(@"输入关键字搜索", nil);
    _searchBar.delegate = self;
    UITextField *textField = [[[_searchBar.subviews firstObject] subviews] objectAtIndex:1];
    textField.font = [UIFont systemFontOfSize:12];
    textField.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    textField.textColor = [UIColor whiteColor];
    textField.clearsOnBeginEditing = YES;
    UILabel *placeLabel = [textField valueForKey:@"placeholderLabel"];
    placeLabel.textColor = [UIColor whiteColor];
    placeLabel.font = [UIFont systemFontOfSize:12];
    _searchBar.backgroundImage = [UIImage new];
    [self.headerView addSubview:_searchBar];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height - 1, self.headerView.frame.size.width, 1)];
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    [self.headerView addSubview:line];
    [self layoutHeaderViewWithSubView:self.titleLabel
                         andSearchBar:_searchBar];
}

- (void)initFooterView {

//    for (int i = 0; i < 2; i ++) {
//        UIControl *controll = [[UIControl alloc] initWithFrame:CGRectMake(i * self.footerView.bounds.size.width/2.0, 0, self.footerView.bounds.size.width/2.0, self.footerView.bounds.size.height)];
//        controll.tag = 20 + i;
//        [controll addTarget:self action:@selector(footerClick:) forControlEvents:UIControlEventTouchUpInside];
//        UIView *contentView = [UIView new];
//        contentView.userInteractionEnabled = NO;
//        [controll addSubview:contentView];
//        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@18);
//            make.centerX.equalTo(controll.mas_centerX);
//            make.centerY.equalTo(controll.mas_centerY);
//        }];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:i==0?@"ico_nav_fa.png":@"ico_video.png"]];
//        [contentView addSubview:imageView];
//        UILabel *label = [UILabel new];
//        label.font = [UIFont systemFontOfSize:12];
//        label.textColor = [UIColor whiteColor];
//        label.text = i ==0 ? NSLocalizedString(@"功能大全", nil):NSLocalizedString(@"帮助视频", nil);
//        [contentView addSubview:label];
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(contentView.mas_centerY);
//            make.left.equalTo(contentView.mas_left);
//            make.width.equalTo(i==0 ?@15:@25);
//            make.height.equalTo(i==0 ?@15:@25);
//        }];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(contentView.mas_centerY);
//            make.left.equalTo(imageView.mas_right).offset(4);
//            make.right.equalTo(contentView.mas_right);
//        }];
//        [self.footerView addSubview:controll];
//    }
//    
//    UIView *line = [UIView new];
//    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
//    [self.footerView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.footerView.mas_left);
//        make.right.equalTo(self.footerView.mas_right);
//        make.top.equalTo(self.footerView.mas_top);
//        make.height.equalTo(@1);
//    }];
}

- (void)initWithTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 30;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark --layout

- (void)layoutHeaderViewWithSubView:(UILabel *)titleLabel
                       andSearchBar:(UISearchBar *)searchBar
{
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView.mas_centerX);
//        make.top.equalTo(self.headerView.mas_top).offset(20);
        make.centerY.equalTo(self.headerView.mas_centerY).offset(-8);
    }];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.headerView.mas_width);
        make.centerX.equalTo(self.headerView.mas_centerX);
        make.bottom.equalTo(self.headerView.mas_bottom);
        make.height.equalTo(@50);
    }];
}

#pragma mark -- UITableVIewDataSource,UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    [self initTableViewSectionViewWith:section];
//    if (section < self.headerViewArray.count) {
//        UIView *sectionView = self.headerViewArray[section];
//        UILabel *label = [sectionView viewWithTag:10];
//        if (section < _searchStatus? self.searchDataArray.count:self.dataArray.count) {
//            TDFNavigateSectionModel *sectionModel = _searchStatus? self.searchDataArray[section]:self.dataArray[section];
//            label.text = sectionModel.title;
//            
//            if (sectionModel.index == 2) {
//                UIButton *button = [sectionView viewWithTag:110];
//                [button setTitle:sectionModel.clickTitle forState:UIControlStateNormal];
//            }
//        }
//        return sectionView;
//    }
//    return nil;
    
    TDFLeftHandSectionHeaderView *headerView = [[TDFLeftHandSectionHeaderView alloc] initWithFrame:CGRectZero];
    
    if (section < _searchStatus? self.searchDataArray.count:self.dataArray.count) {
        TDFNavigateSectionModel *sectionModel = _searchStatus? self.searchDataArray[section]:self.dataArray[section];
        
        [headerView configureViewWithTitle:sectionModel.title more:sectionModel.clickTitle clickUrl:sectionModel.clickUrl];
        
        @weakify(self);
        headerView.clickedBlock = ^(NSString *clickUrl) {
            @strongify(self);
            if (self.delegate) {
                [self.delegate goNextWithUrlString:clickUrl];
            }
        };
    }

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void)initTableViewSectionViewWith:(NSInteger)section
{
    if (section < self.headerViewArray.count) {
        return ;
    }
    UIView *sectionView = [UIView new];
    UILabel *headerLabel = [UILabel new];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.tag = 10;
    headerLabel.font = [UIFont boldSystemFontOfSize:14];
    UIView *line = [UIView new];
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    [sectionView addSubview:headerLabel];
    [sectionView addSubview:line];
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView.mas_left).offset(20);
        make.bottom.equalTo(sectionView.mas_bottom).offset(-10);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView.mas_left).offset(20);
        make.right.equalTo(sectionView.mas_right).offset(-20);
        make.bottom.equalTo(sectionView.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    moreButton.tag = 110;
    
    [sectionView addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sectionView.mas_right).offset(-10);
        make.bottom.equalTo(sectionView.mas_bottom).with.offset(-10);
        make.height.equalTo(@11);
    }];
    
    [self.headerViewArray addObject:sectionView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _searchStatus? self.searchDataArray.count:self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < _searchStatus? self.searchDataArray.count:self.dataArray.count) {
        TDFNavigateSectionModel *sectionModel = _searchStatus? self.searchDataArray[section]:self.dataArray[section];
        return sectionModel.forwardCells.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedBackgroundView = [UIView new];
        cell.selectedBackgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:10];
        label.tag = 110;
        label.hidden = YES;
        label.textColor = [UIColor whiteColor];
        
        [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.textLabel.mas_left).offset(-8);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.equalTo(@18);
            make.height.equalTo(@18);
        }];
        
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(20);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.equalTo(@30);
            make.height.equalTo(@14);
        }];
        
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(55);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
    }
    if (indexPath.section < _searchStatus? self.searchDataArray.count:self.dataArray.count) {
        TDFNavigateSectionModel *sectionModel = _searchStatus? self.searchDataArray[indexPath.section]:self.dataArray[indexPath.section];
        if (indexPath.row < sectionModel.forwardCells.count) {
            TDFHomeGroupForwardChildCellModel *childModel = sectionModel.forwardCells[indexPath.row];
            cell.textLabel.text = childModel.title;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:childModel.iconUrl] placeholderImage:[UIImage imageNamed:@"ico_leftsliderplaceImage.png"] options:SDWebImageRefreshCached];
            
            UILabel *leftLabel = (UILabel *)[cell viewWithTag:110];
            
            if (sectionModel.index == 1) {
                leftLabel.text = @"[指南]";
                leftLabel.hidden = NO;
                cell.imageView.hidden = YES;
            } else if (sectionModel.index == 2) {
                leftLabel.text = @"[问题]";
                leftLabel.hidden = NO;
                cell.imageView.hidden = YES;
            } else {
                leftLabel.hidden = YES;
                cell.imageView.hidden = NO;
            }
            
            if (childModel.isLock) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_pw_fw.png"]];
                imageView.bounds = CGRectMake(0, 0, 12, 12);
                cell.accessoryView = imageView;
            }else
            {
                cell.accessoryView = nil;
            }
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
    [_searchBar endEditing:YES];
    if (indexPath.section < _searchStatus? self.searchDataArray.count:self.dataArray.count) {
        TDFNavigateSectionModel *sectionModel = _searchStatus? self.searchDataArray[indexPath.section]:self.dataArray[indexPath.section];
        if (indexPath.row < sectionModel.forwardCells.count) {
            TDFHomeGroupForwardChildCellModel *childModel = sectionModel.forwardCells[indexPath.row];
            if (self.delegate) {
                if (sectionModel.index == 0) {
                    [self.delegate switchToViewControllerWithCode:childModel.actionCode isLock:childModel.isLock actionName:childModel.title];
                } else if (sectionModel.index == 1 || sectionModel.index == 2) {
                    [self.delegate goNextWithUrlString:childModel.clickUrl];
                }

            }
        }
    }

}

- (void)moreButtonClicked:(UIButton *)button
{
    
}

#pragma mark --UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 50 && scrollView.contentOffset.y > 0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    }
    
    else if (scrollView.contentOffset.y >= 50) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
        
    }
}


#pragma mark --UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";
    [self setEnableInSearchBar:searchBar];
    _searchStatus = NO;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self setEnableInSearchBar:searchBar];
    _searchStatus = YES;
    
    if ([self.delegate respondsToSelector:@selector(navigateView:didSearchWithKeyword:)]) {
        [self.delegate navigateView:self didSearchWithKeyword:searchBar.text];
    }
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    UIButton*cancelBtn = [searchBar valueForKey:@"cancelButton"];//首先取出cancelBtn
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    cancelBtn.enabled=YES;//把enabled设置为yes
    return YES;
}

- (void)setEnableInSearchBar:(UISearchBar *)searchBar;
{
    [searchBar endEditing:YES];
    UIButton*cancelBtn = [searchBar valueForKey:@"cancelButton"];//首先取出cancelBtn
    cancelBtn.enabled=YES;//把enabled设置为yes
}


#pragma mark --帮助视频和功能大全点击事件
- (void)footerClick:(UIControl *)control
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(footerButtonClickWithIndex:)]) {
        [self.delegate footerButtonClickWithIndex:(int)control.tag];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

