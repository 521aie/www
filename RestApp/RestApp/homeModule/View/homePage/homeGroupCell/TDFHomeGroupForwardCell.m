//
//  TDFHomeGroupForwardCell.m
//  Pods
//
//  Created by happyo on 2017/3/24.
//
//

#import "TDFHomeGroupForwardCell.h"
#import "TDFHomeGroupForwardItem.h"
#import "TDFCollectionView.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "UIImageView+WebCache.h"

NSInteger kNumberOfChildPerLine = 4;

CGFloat kLeading = 10;

CGFloat kTop = 10;

CGFloat kColumnInterval = 10;

CGFloat kCellWidth = 64;

CGFloat kCellHeight = 64 + 26;

@interface TDFHomeGroupForwardChildView ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *lockImageView;

@end
@implementation TDFHomeGroupForwardChildView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.width.equalTo(@64);
            make.height.equalTo(@64);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView.mas_bottom);
            make.centerX.equalTo(self.iconImageView);
            make.width.equalTo(self.iconImageView);
        }];
        
        [self addSubview:self.lockImageView];
        [self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self);
            make.top.equalTo(self);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
        }];
    }
    
    return self;
}

- (void)configureViewWithModel:(TDFHomeGroupForwardChildCellModel *)model
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"ico_homeviewplaceImage.png"]];
    
    self.titleLabel.text = model.title;
    
    self.lockImageView.image = model.isLock ? [UIImage imageNamed:@"ico_pw_w.png"] : (model.isOpen == 0 ? [UIImage imageNamed:@"ico_pw_red"] : nil);
}

#pragma mark -- Getters && Setters --

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor colorWithHeX:0xFFFFFF];
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UIImageView *)lockImageView
{
    if (!_lockImageView) {
        _lockImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _lockImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _lockImageView;
}

@end

@interface TDFHomeGroupForwardCell () <TDFCollectionViewDataSource, TDFCollectionViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *spliteView;

@property (nonatomic, strong) TDFCollectionView *collectionView;

@property (nonatomic, strong) TDFHomeGroupForwardItem *model;

@end
@implementation TDFHomeGroupForwardCell

- (void)cellDidLoad
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.leading.equalTo(self).with.offset(10);
        make.height.equalTo(@13);
        make.trailing.equalTo(self).with.offset(-10);
    }];
    
    [self addSubview:self.spliteView];
    [self.spliteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(33);
        make.height.equalTo(@1);
        make.leading.equalTo(self).with.offset(10);
        make.trailing.equalTo(self).with.offset(-10);
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self.spliteView.mas_bottom);
    }];
}

- (void)configCellWithItem:(TDFHomeGroupForwardItem *)item
{
    self.model = item;
    
    self.titleLabel.text = item.title;
    
    CGFloat spliteTop = 0;
    if (item.title) {
        spliteTop = 33;
    }
    
    [self.spliteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(spliteTop));
    }];
    
    [self.collectionView reloadData];
}

+ (CGFloat)heightForCellWithItem:(TDFHomeGroupForwardItem *)item
{
    CGFloat height = 1;
    
    CGFloat collectionViewHeight = kTop;
    
    NSInteger count = item.forwardCells.count;
    
    NSInteger lineCount = count % kNumberOfChildPerLine == 0 ? (count / kNumberOfChildPerLine) : (count / kNumberOfChildPerLine + 1);
    
    for (int i = 0; i < lineCount; i++) {
        collectionViewHeight += kCellHeight;
        
        if (i > 0) {
            collectionViewHeight += kColumnInterval;
        }
    }
    
    if (item.title) {
        height += 33;
    }
    
    return height + collectionViewHeight + 30;
}

#pragma mark -- TDFCollectionViewDataSource --

- (NSInteger)numberOfCellInCollectionView:(TDFCollectionView *)collectionView
{
    return self.model.forwardCells.count;
}

- (UIView *)cellForCollectionView:(TDFCollectionView *)collectionView atIndex:(NSInteger)index
{
    TDFHomeGroupForwardChildView *childView = [[TDFHomeGroupForwardChildView alloc] initWithFrame:CGRectZero];
    
    [childView configureViewWithModel:self.model.forwardCells[index]];
    
    return childView;
}

- (NSInteger)numberOfCellPerRowForCollectionView:(TDFCollectionView *)collctionView
{
    return kNumberOfChildPerLine;
}

- (CGSize)sizeForCellInCollectionView:(TDFCollectionView *)collectionView atIndex:(NSInteger)index
{
    return CGSizeMake(kCellWidth, kCellHeight);
}

- (CGFloat)leadingForCollectionView:(TDFCollectionView *)collectionView
{
    return kLeading;
}

- (CGFloat)topForCollectionView:(TDFCollectionView *)collectionView
{
    return kTop;
}

- (CGFloat)intervalBetweenRowCellInCollectionView:(TDFCollectionView *)collectionView
{
    CGFloat rowInterval = (SCREEN_WIDTH - 20 - kLeading * 2 - kCellWidth * kNumberOfChildPerLine) / (kNumberOfChildPerLine - 1);
    
    return rowInterval;
}

- (CGFloat)intervalBetweenColumnCellInCollectionView:(TDFCollectionView *)collectionView
{
    return kColumnInterval;
}

#pragma mark -- TDFCollectionViewDelegate --

- (void)collectionView:(TDFCollectionView *)collectionView didSelectedCellAtIndex:(NSInteger)index
{
    TDFHomeGroupForwardChildCellModel *cellModel = self.model.forwardCells[index];
    
    if (self.model.clickedBlock) {
        self.model.clickedBlock(cellModel);
    }
}

#pragma mark -- Getters && Setters --

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _titleLabel.textColor = [UIColor colorWithHeX:0xFFFFFF];
    }
    
    return _titleLabel;
}

- (UIView *)spliteView
{
    if (!_spliteView) {
        _spliteView = [[UIView alloc] initWithFrame:CGRectZero];
        _spliteView.backgroundColor = [[UIColor colorWithHeX:0xFFFFFF] colorWithAlphaComponent:0.3];
    }
    
    return _spliteView;
}

- (TDFCollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[TDFCollectionView alloc] initWithFrame:self.bounds];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    
    return _collectionView;
}

@end
