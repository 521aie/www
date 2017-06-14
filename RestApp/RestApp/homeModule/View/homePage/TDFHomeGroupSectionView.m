//
//  TDFHomeGroupSectionView.m
//  Pods
//
//  Created by happyo on 2017/3/15.
//
//

#import "TDFHomeGroupSectionView.h"
#import "DHTTableViewManager.h"
#import "Masonry.h"
#import "TDFHomeGroupForwardItem.h"
#import "TDFHomeGroupTwoImageHeaderItem.h"
#import "YYModel.h"

@implementation TDFHomeGroupSectionModel


@end

@interface TDFHomeGroupSectionView ()

@property (nonatomic, strong) UIView *alphaView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) DHTTableViewManager *manager;

@end
@implementation TDFHomeGroupSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //
        [self addSubview:self.alphaView];
        [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).with.offset(10);
            make.trailing.equalTo(self).with.offset(-10);
            make.top.equalTo(self).with.offset(10);
            make.bottom.equalTo(self);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.alphaView);
            make.trailing.equalTo(self.alphaView);
            make.top.equalTo(self.alphaView).with.offset(15);
            make.height.equalTo(@15);
        }];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alphaView).with.offset(40);
            make.leading.equalTo(self.alphaView);
            make.trailing.equalTo(self.alphaView);
//            make.bottom.equalTo(self.alphaView);
            make.height.equalTo(@100);
        }];
        
        [self.manager registerCell:@"TDFHomeGroupForwardCell" withItem:@"TDFHomeGroupForwardItem"];
        [self.manager registerCell:@"TDFHomeGroupTwoImageHeaderCell" withItem:@"TDFHomeGroupTwoImageHeaderItem"];
    }
    
    return self;
}

- (void)configureViewWithModel:(TDFHomeGroupSectionModel *)model
{
    [self.manager removeAllSections];
    
    self.titleLabel.text = model.title;
    
    DHTTableViewSection *section = [DHTTableViewSection section];
    
    for (int i = 0; i < model.cells.count; i++) {
        NSDictionary *cellDict = model.cells[i];
        NSString *cellStyle = cellDict[@"cellStyle"];
        if ([cellStyle isEqualToString:@"cell_forward_style"]) {
            TDFHomeGroupForwardItem *forwardItem = [TDFHomeGroupForwardItem yy_modelWithDictionary:cellDict[@"cellModel"]];
            
            forwardItem.clickedBlock = ^(TDFHomeGroupForwardChildCellModel *model) {
                if (self.clickAction) {
                    self.clickAction(model);
                }
            };
            if (forwardItem) {
                [section addItem:forwardItem];
            }
        } else if ([cellStyle isEqualToString:@"cell_headerView_style"]) {
            TDFHomeGroupTwoImageHeaderItem *imageItem = [TDFHomeGroupTwoImageHeaderItem yy_modelWithDictionary:cellDict[@"cellModel"]];
            
            if (imageItem) {
                [section addItem:imageItem];
            }
        }
    }
    
    [self.manager addSection:section];
    [self.manager reloadData];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.tableView.contentSize.height));
    }];
    [self.tableView layoutIfNeeded];
}

- (CGFloat)heightForView
{
    return self.tableView.contentSize.height + 50;
}

#pragma mark -- Getters && Setters --

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UIView *)alphaView
{
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 100)];
        _alphaView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        _alphaView.layer.cornerRadius = 5;
    }
    
    return _alphaView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 100)];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    
    return _tableView;
}

- (DHTTableViewManager *)manager
{
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
    }
    
    return _manager;
}


@end
