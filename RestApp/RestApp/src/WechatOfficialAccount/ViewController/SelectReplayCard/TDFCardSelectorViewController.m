//
//  TDFCardSelectorViewController.m
//  RestApp
//
//  Created by tripleCC on 2017/5/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import <TDFCategories/TDFCategories.h>
#import <TDFAPIHUDPresenter/TDFAPIHUDPresenter.h>

#import "DHTTableViewManager+Register.h"
#import "TDFCardSelectorViewController.h"

@interface TDFCardSelectorViewController ()
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DHTTableViewManager *manager;
@property (strong, nonatomic) DHTTableViewSection *section;
@property (strong, nonatomic) TDFBaseAPI *api;
@property (strong, nonatomic) NSArray *cards;
@property (assign, nonatomic) NSInteger selectedIndex;
@end

@implementation TDFCardSelectorViewController

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.navigationItem.title = title;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self setupApiAction];
    [self nbc_setupNavigationBarType:TDFNavigationBarTypeNormal];
    [self.manager addSection:self.section];
    [self.api start];
}

- (void)viewControllerDidTriggerRightClick:(UIViewController *)viewController {
    NSArray *selectedIndexs = [self.section.items.tdf_selectedItems tdf_map:^id(id<TDFSelectableProtocol> value) {
        return @([self.section.items indexOfObject:value]);
    }];
    
    [self.delegate cardSelector:self didFinishSelectCard:[self.cards tdf_collectItemsWithIndexs:selectedIndexs].firstObject];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupApiAction {
    @weakify(self)
    self.api.apiSuccessHandler = ^(__kindof TDFBaseAPI *api, NSArray *response) {
        @strongify(self)
        
        NSAssert([response isKindOfClass:[NSArray class]], @"Response should be NSArray.");
        self.cards = response;
        
        [self.manager addItems:[response tdf_map:^id(id value) {
            return [self itemForCard:value];
        }] toSection:self.section];
        
        if ([self.delegate respondsToSelector:@selector(cardSelector:selectedIndexForCards:)]) {
            self.selectedIndex = [self.delegate cardSelector:self selectedIndexForCards:self.cards];
            
            if ([self validSelectedIndex:self.selectedIndex]) {
                [(id <TDFSelectableProtocol>)self.section.items[self.selectedIndex] setSelected:YES];
            }
        }
        
        [self.manager reloadData];
    };
}

- (void)setupSubviews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (DHTTableViewItem <TDFCardSelectorItemProtocol> *)itemForCard:(id)card {
    DHTTableViewItem <TDFCardSelectorItemProtocol> *item = [self.delegate cardSelector:self displayedItemForCard:card];
    @weakify(self)
    @weakify(item)
    item.selectedBlock = ^{
        @strongify(self)
        @strongify(item)
        
        [[self.section.items
            tdf_filter:^BOOL(id value) {
                return ![value isEqual:item];
            }]
            tdf_forEach:^(id <TDFCardSelectorItemProtocol> value) {
                value.selected = NO;
            }];
        
        item.selected = !item.selected;
        [self.manager reloadData];
        
        // 选中元素改变 || 取消原选中元素
        BOOL anyItemChanged = (item.selected && (self.selectedIndex != [self.section.items indexOfObject:item])) ||
        (!item.selected && [self validSelectedIndex:self.selectedIndex]);
        
        [self nbc_setupNavigationBarType: anyItemChanged ? TDFNavigationBarTypeConfirmed : TDFNavigationBarTypeNormal];
    };
    
    return item;
    
}

- (BOOL)validSelectedIndex:(NSInteger)selectedIndex {
    return selectedIndex >= 0 && selectedIndex < self.section.items.count;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (DHTTableViewManager *)manager {
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
    }
    
    return _manager;
}

- (DHTTableViewSection *)section {
    if (!_section) {
        _section = [DHTTableViewSection section];
    }
    
    return _section;
}

- (TDFBaseAPI *)api {
    if (!_api) {
        _api = [self.delegate apiForCardSelector:self];
        _api.presenter = [TDFAlertAPIHUDPresenter HUDWithView:self.view];
    }
    
    return _api;
}

@end
