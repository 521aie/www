//
//  TDFHomeTwoInLineView.m
//  Pods
//
//  Created by happyo on 2017/3/11.
//
//

#import "TDFHomeTwoInLineView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "TDFCollectionView.h"

@implementation TDFHomeTwoInLineCellModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"isOpen" : @[@"isOpen",@"open"],
             @"isLock" : @[@"isLock",@"locked"],
             @"_id" : @"id"};
}

@end

@interface TDFHomeTwoInLineCellView ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UIView *alphaView;

@property (nonatomic, strong) UIImageView *lockImageView;

@end
@implementation TDFHomeTwoInLineCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        //
        [self addSubview:self.alphaView];
        [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.alphaView).with.offset(5);
            make.centerY.equalTo(self.alphaView);
            make.height.equalTo(@64);
            make.width.equalTo(@64);
        }];
        
        [self addSubview:self.rightView];
        [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImageView.mas_trailing).with.offset(5);
            make.centerY.equalTo(self.alphaView);
            make.trailing.equalTo(self.alphaView);
            make.height.equalTo(@34);
        }];

        [self.rightView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rightView);
            make.height.equalTo(@13);
            make.leading.equalTo(self.rightView);
            make.trailing.equalTo(self.rightView);
        }];

        [self.rightView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
            make.leading.equalTo(self.rightView);
            make.height.equalTo(@11);
            make.trailing.equalTo(self.rightView).with.offset(-5);
        }];
        
        [self addSubview:self.lockImageView];
        [self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).with.offset(-10);
            make.top.equalTo(self).with.offset(10);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
        }];
    }

    return self;
}

- (void)configureViewWithModel:(TDFHomeTwoInLineCellModel *)model
{
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.subTitle;

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"ico_homeviewplaceImage.png"]];
    
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

- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _rightView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _titleLabel.textColor = [UIColor whiteColor];
    }

    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.font = [UIFont systemFontOfSize:11];
        _detailLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        _detailLabel.adjustsFontSizeToFitWidth = YES;
    }

    return _detailLabel;
}

- (UIView *)alphaView
{
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:CGRectZero];
        _alphaView.layer.cornerRadius = 5;
        _alphaView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    }

    return _alphaView;
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

@interface TDFHomeTwoInLineView () <TDFCollectionViewDataSource, TDFCollectionViewDelegate>

@property (nonatomic, strong) TDFCollectionView *collectionView;

@property (nonatomic, copy) NSArray<TDFHomeTwoInLineCellModel *> *modelList;

@end
@implementation TDFHomeTwoInLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        //
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }

    return self;
}

- (void)configureViewWithModelList:(NSArray<TDFHomeTwoInLineCellModel *> *)modelList
{
    self.modelList = modelList;

    [self.collectionView reloadData];
}

- (CGFloat)heightForView
{
    return [self.collectionView heightForView];
}

#pragma mark -- TDFCollectionViewDataSource --

- (NSInteger)numberOfCellInCollectionView:(TDFCollectionView *)collectionView
{
    return self.modelList.count;
}

- (UIView *)cellForCollectionView:(TDFCollectionView *)collectionView atIndex:(NSInteger)index
{
    TDFHomeTwoInLineCellView *cellView = [[TDFHomeTwoInLineCellView alloc] initWithFrame:CGRectZero];
    [cellView configureViewWithModel:self.modelList[index]];

    return cellView;
}

- (CGSize)sizeForCellInCollectionView:(TDFCollectionView *)collectionView atIndex:(NSInteger)index
{
    CGFloat cellWidth = (self.frame.size.width - 30) / 2.0;

    return CGSizeMake(cellWidth, 98);
}

- (NSInteger)numberOfCellPerRowForCollectionView:(TDFCollectionView *)collctionView
{
    return 2;
}

- (CGFloat)leadingForCollectionView:(TDFCollectionView *)collectionView
{
    return 10;
}

- (CGFloat)intervalBetweenRowCellInCollectionView:(TDFCollectionView *)collectionView
{
    return 10;
}

- (CGFloat)intervalBetweenColumnCellInCollectionView:(TDFCollectionView *)collectionView
{
    return 10;
}

- (CGFloat)topForCollectionView:(TDFCollectionView *)collectionView
{
    return 10;
}

#pragma mark -- TDFCollectionViewDelegate --

- (void)collectionView:(TDFCollectionView *)collectionView didSelectedCellAtIndex:(NSInteger)index
{
    TDFHomeTwoInLineCellModel *cellModel = self.modelList[index];
    
    if (self.clickAction) {
        self.clickAction(cellModel);
    }
}

#pragma mark -- Getters && Setters --

- (TDFCollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[TDFCollectionView alloc] initWithFrame:CGRectZero];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }

    return _collectionView;
}

@end
