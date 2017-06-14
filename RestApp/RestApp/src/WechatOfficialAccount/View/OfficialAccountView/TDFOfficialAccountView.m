//
//  TDFOfficialAccountView.m
//  TDFFakeOfficialAccount
//
//  Created by Octree on 6/2/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "TDFOfficialAccountView.h"
#import <Masonry/Masonry.h>
#import "TDFNormalMenuCell.h"
#import "TDFMenuAdditionCell.h"
#import "TDFOfficialAccountLayout.h"
#import "UIColor+Hex.h"

@interface TDFOfficialAccountView ()<UICollectionViewDataSource, TDFOfficialAccountLayoutDelegate>

@property (strong, nonatomic) UIImageView *navImageView;
@property (strong, nonatomic) UIButton *menu0;
@property (strong, nonatomic) UIButton *menu1;
@property (strong, nonatomic) UIButton *menu2;
@property (strong, nonatomic) UIImageView *keyboardImageView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) TDFOfficialAccountLayout *layout;
@property (nonatomic) NSUInteger numOfSections;

@property (strong, nonatomic) TDFNormalMenuCell *normalMenuCell;
@property (strong, nonatomic) TDFMenuAdditionCell *additionCell;

@end

@implementation TDFOfficialAccountView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self configViews];
    }
    
    return self;
}


#pragma mark - Public Method

- (void)reloadData {

    [self updateMenuButtons];
    [self.collectionView reloadData];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadData];
}

#pragma mark - Private Method

#pragma mark Config Views

- (void)configViews {

    CGSize size = self.navImageView.image.size;
    self.backgroundColor = [UIColor colorWithHeX:0xECECEC];
    [self addSubview:self.navImageView];
    __weak __typeof(self) wself = self;
    [self.navImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(wself) sself = wself;
        make.leading.equalTo(sself.mas_leading);
        make.trailing.equalTo(sself.mas_trailing);
        make.top.equalTo(sself.mas_top);
        make.height.equalTo(sself.navImageView.mas_width).multipliedBy(size.height / size.width);
    }];
    
    [self addSubview:self.keyboardImageView];
    [self.keyboardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(wself) sself = wself;
        make.leading.equalTo(sself.mas_leading);
        make.bottom.equalTo(sself.mas_bottom);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(50);
    }];
    
    UIView *containerView = [[UIView alloc] init];
    [self addSubview:containerView];
    containerView.backgroundColor = [UIColor whiteColor];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(wself) sself = wself;
        make.left.mas_equalTo(sself.keyboardImageView.mas_right);
        make.bottom.equalTo(sself.mas_bottom);
        make.height.mas_equalTo(50);
        make.right.equalTo(sself.mas_right);
    }];
    
    [containerView addSubview:self.menu0];
    [self.menu0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView.mas_left).with.offset(-1);
        make.top.equalTo(containerView.mas_top);
        make.bottom.equalTo(containerView.mas_bottom);
        make.width.equalTo(containerView.mas_width).multipliedBy(1.0/3);
    }];
    
    [containerView addSubview:self.menu1];
    [self.menu1 mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(wself) sself = wself;
        make.left.equalTo(sself.menu0.mas_right).with.offset(-1);
        make.top.equalTo(containerView.mas_top);
        make.bottom.equalTo(containerView.mas_bottom);
        make.width.equalTo(containerView.mas_width).multipliedBy(1.0/3);
    }];
    
    [containerView addSubview:self.menu2];
    [self.menu2 mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(wself) sself = wself;
        make.left.equalTo(sself.menu1.mas_right).with.offset(-1);
        make.top.equalTo(containerView.mas_top);
        make.bottom.equalTo(containerView.mas_bottom);
        make.right.equalTo(sself.mas_right);
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(wself) sself = wself;
        make.top.equalTo(sself.navImageView.mas_bottom).with.offset(5);
        make.bottom.equalTo(containerView.mas_top);
        make.left.equalTo(containerView.mas_left);
        make.right.equalTo(containerView.mas_right);
    }];
}


#pragma mark UpdateViews

- (void)updateMenuButtons {

    NSArray *menus = @[self.menu0, self.menu1, self.menu2];
    NSUInteger count = self.numOfSections;
    NSAssert(count <= 3, NSLocalizedString(@"最多有三个 Menu", nil));
    for (NSUInteger i = 0; i < 3; i++) {
        UIButton *button = menus[i];
        if (i >= count) {
            //  没有内容
            [button setImage:[UIImage imageNamed:@"wxoa_menu_add"] forState:UIControlStateNormal];
            [button setTitle:@"" forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            button.selected = NO;
            NSString *title = [self.dataSource officialAccountView:self menuTitleForSection:i];
            [button setTitle:title forState:UIControlStateNormal];
            BOOL isURL = [self.dataSource officialAccountView:self menuTypeForSection:i] == TDFMenuTypeURL;
            [button setImage:isURL ? nil : [UIImage imageNamed:@"wxoa_menu"] forState:(UIControlState)TDFMenuTypeNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, isURL ? 0 : 5);
        }
    }
}

- (NSUInteger)numOfSections {

    return [self.dataSource numOfSectionInOfficialAccountView:self];
}

- (NSUInteger)itemsInSection:(NSUInteger)section {

    return [self.dataSource officialAccountView:self numOfItemsInSection:section];
}


- (BOOL)shouldShowAddMenuInSection:(NSUInteger)section {

    return [self.dataSource officialAccountView:self shouldShowAddItemInSection:section];
}



#pragma mark Action

- (void)menuButtonTapped:(UIButton *)button {

    if ([self.delegate respondsToSelector:@selector(officialAccountView:didSelectMenuInSection:)]) {
        
        [self.delegate officialAccountView:self didSelectMenuInSection:button.tag];
    }
}



#pragma mark UICollectionViewDataSource & TDFOfficialAccountLayoutDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    BOOL flag = [self shouldShowAddMenuInSection:indexPath.section];
    if (flag && indexPath.item == 0) {
        
        if ([self.delegate respondsToSelector:@selector(officialAccountView:didSelectAddItemInSection:)]) {
            [self.delegate officialAccountView:self didSelectAddItemInSection:indexPath.section];
        }
        return;
    }
    
    NSIndexPath *menuIndexPath = [NSIndexPath indexPathForItem:indexPath.item - flag inSection:indexPath.section];
    if ([self.delegate respondsToSelector:@selector(officialAccountView:didSelectItemAtIndexPath:)]) {
        
        [self.delegate officialAccountView:self didSelectItemAtIndexPath:menuIndexPath];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [self.dataSource numOfSectionInOfficialAccountView:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSUInteger count = [self.dataSource officialAccountView:self numOfItemsInSection:section];
    return [self shouldShowAddMenuInSection:section] ? count + 1 : count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger count = [self.dataSource officialAccountView:self numOfItemsInSection:indexPath.section];
    BOOL flag = [self shouldShowAddMenuInSection:indexPath.section];
    TDFOfficialAccountMenuPresenter *presenter = [[TDFOfficialAccountMenuPresenter alloc] init];
    TDFOfficialAccountMenuCell *cell;
    if (flag && indexPath.item == 0) {
        //   展示添加按钮
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TDFMenuAdditionCell" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TDFNormalMenuCell" forIndexPath:indexPath];
        NSIndexPath *menuIndexPath = [NSIndexPath indexPathForItem:indexPath.item - flag inSection:indexPath.section];
        presenter.title = [self.dataSource officialAccountView:self titleForItemAtIndexPath:menuIndexPath];
    }
    
    presenter.showArrow = (count - !flag) == indexPath.item;
    [cell updateWithPresenter:presenter];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger count = [self.dataSource officialAccountView:self numOfItemsInSection:indexPath.section];
    BOOL flag = [self shouldShowAddMenuInSection:indexPath.section];
    TDFOfficialAccountMenuPresenter *presenter = [[TDFOfficialAccountMenuPresenter alloc] init];
    TDFOfficialAccountMenuCell *cell;
    if (flag && indexPath.item == 0) {
        //   展示添加按钮
        cell = self.additionCell;
    } else {
        cell = self.normalMenuCell;
        NSIndexPath *menuIndexPath = [NSIndexPath indexPathForItem:indexPath.item - flag inSection:indexPath.section];
        presenter.title = [self.dataSource officialAccountView:self titleForItemAtIndexPath:menuIndexPath];
    }
    presenter.showArrow = (count - !flag) == indexPath.item;
    return [cell sizeThatFits:CGSizeMake(self.layout.itemWidth, 0) withPresenter:presenter].height;
}

#pragma mark - Accessor

- (UIImageView *)navImageView {
    
    if (!_navImageView) {
        
        _navImageView = [[UIImageView alloc] init];
        _navImageView.image = [UIImage imageNamed:@"wxoa_oa_navigation"];
    }
    return _navImageView;
}

- (UIButton *)menu0 {
    
    if (!_menu0) {
        
        _menu0 = [self generateMenu];
        _menu0.tag = 0;
    }
    return _menu0;
}

- (UIButton *)menu1 {
    
    if (!_menu1) {
        
        _menu1 = [self generateMenu];
        _menu1.tag = 1;
    }
    return _menu1;
}

- (UIButton *)menu2 {
    
    if (!_menu2) {
        
        _menu2 = [self generateMenu];
        _menu2.tag = 2;
    }
    return _menu2;
}

- (UIImageView *)keyboardImageView {
    
    if (!_keyboardImageView) {
        
        _keyboardImageView = [[UIImageView alloc] init];
        _keyboardImageView.image = [UIImage imageNamed:@"wxoa_menu_keyboard"];
        _keyboardImageView.backgroundColor = [UIColor whiteColor];
        _keyboardImageView.contentMode = UIViewContentModeCenter;
        [self renderBorder:_keyboardImageView];
    }
    return _keyboardImageView;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                             collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithHeX:0xECECEC];
        [_collectionView registerClass:[TDFNormalMenuCell class] forCellWithReuseIdentifier:@"TDFNormalMenuCell"];
        [_collectionView registerClass:[TDFMenuAdditionCell class] forCellWithReuseIdentifier:@"TDFMenuAdditionCell"];
        _collectionView.clipsToBounds = NO;
        _collectionView.allowsSelection = YES;
    }
    return _collectionView;
}
- (TDFOfficialAccountLayout *)layout {
    
    if (!_layout) {
        
        _layout = [[TDFOfficialAccountLayout alloc] init];
        _layout.sectionPadding = 5;
    }
    return _layout;
}

- (TDFMenuAdditionCell *)additionCell {

    if (!_additionCell) {
        _additionCell = [[TDFMenuAdditionCell alloc] init];
    }
    
    return _additionCell;
}


- (TDFNormalMenuCell *)normalMenuCell {

    if (!_normalMenuCell) {
        
        _normalMenuCell = [[TDFNormalMenuCell alloc] init];
    }
    
    return _normalMenuCell;
}

#pragma mark Helper

- (UIButton *)generateMenu {

    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor colorWithHeX:0x4A4A4A] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(menuButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self renderBorder:button];
    button.backgroundColor = [UIColor whiteColor];
    return button;
}

- (void)renderBorder:(UIView *)view {

    view.layer.borderColor = [UIColor colorWithHeX:0xD1D1D1].CGColor;
    view.layer.borderWidth = 1;
}



@end
