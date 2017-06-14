//
//  TDFMemberLevelView.m
//  Pods
//
//  Created by happyo on 2017/4/7.
//
//

#import "TDFMemberLevelView.h"
#import "SwipeView.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "NSString+TDF_Empty.h"

@implementation TDFMemberLevelCellModel

@end

@interface TDFMemberLevelCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *levelLabel;

@property (nonatomic, strong) UIView *rectView;

@property (nonatomic, strong) UIView *spliteView;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UILabel *percentLabel;

@end
@implementation TDFMemberLevelCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.height.equalTo(@8);
        }];
        
        [self addSubview:self.levelLabel];
        [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.titleLabel.mas_top);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.height.equalTo(@11);
        }];
        
        [self addSubview:self.spliteView];
        [self.spliteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.bottom.equalTo(self.levelLabel.mas_top);
            make.height.equalTo(@1);
        }];
        
        [self addSubview:self.rectView];
        [self.rectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.equalTo(@9);
            make.height.equalTo(@0);
            make.bottom.equalTo(self.spliteView.mas_top);
        }];
        
        [self addSubview:self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.bottom.equalTo(self.rectView.mas_top);
            make.height.equalTo(@7);
        }];
        
        [self addSubview:self.percentLabel];
        [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.bottom.equalTo(self.countLabel.mas_top);
            make.height.equalTo(@9);
        }];
    }
    
    return self;
}

- (void)configureCellWithModel:(TDFMemberLevelCellModel *)model
{
    self.titleLabel.text = model.title;
    self.levelLabel.text = model.countUnit;
    
    [self.rectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(model.height));
    }];
    [self.rectView layoutIfNeeded];
    
    self.rectView.backgroundColor = model.rectColor;

    self.countLabel.text = model.count == 0 ? @"0" : [NSString stringWithFormat:@"%i人", (int)model.count];
    self.percentLabel.text = model.percent;
}

#pragma mark -- Getters && Setters --

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:8];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UILabel *)levelLabel
{
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _levelLabel.font = [UIFont systemFontOfSize:11];
        _levelLabel.textColor = [UIColor whiteColor];
        _levelLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _levelLabel;
}


- (UIView *)rectView
{
    if (!_rectView) {
        _rectView = [[UIView alloc] initWithFrame:CGRectZero];
        _rectView.backgroundColor = [UIColor whiteColor];
    }
    
    return _rectView;
}

- (UIView *)spliteView
{
    if (!_spliteView) {
        _spliteView = [[UIView alloc] initWithFrame:CGRectZero];
        _spliteView.backgroundColor = [UIColor colorWithHeX:0x979797];
    }
    
    return _spliteView;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countLabel.font = [UIFont systemFontOfSize:7];
        _countLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _countLabel;
}

- (UILabel *)percentLabel
{
    if (!_percentLabel) {
        _percentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _percentLabel.font = [UIFont systemFontOfSize:9];
        _percentLabel.textColor = [UIColor whiteColor];
        _percentLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _percentLabel;
}

@end

@implementation TDFMemberLevelModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"barCells" : [TDFMemberLevelCellModel class]};
}

@end

@interface TDFMemberLevelView () <SwipeViewDataSource, SwipeViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *spliteView;

@property (nonatomic, strong) SwipeView *swipeView;

@property (nonatomic, strong) NSArray<TDFMemberLevelCellModel *> *barCells;

@end
@implementation TDFMemberLevelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self).with.offset(10);
            make.height.equalTo(@44);
            make.trailing.equalTo(self);
        }];
        
        [self addSubview:self.spliteView];
        [self.spliteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).with.offset(10);
            make.trailing.equalTo(self).with.offset(-10);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.height.equalTo(@1);
        }];
        
        [self addSubview:self.swipeView];
        [self.swipeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).with.offset(10);
            make.trailing.equalTo(self).with.offset(-10);
            make.height.equalTo(@100);
            make.top.equalTo(self.spliteView.mas_bottom).with.offset(10);
        }];
    }
    
    return self;
}

- (void)configureViewWithModel:(TDFMemberLevelModel *)model
{
    CGFloat titleHeight = 0;
    
    if ([model.title isNotEmpty]) {
        titleHeight = 44;
        self.titleLabel.text = model.title;
    }
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(titleHeight));
    }];
    
    self.barCells = model.barCells;
    
    NSInteger maxCount = [self getMaxCountWithBarCells:self.barCells];
    NSInteger maxHeight = 56;
    
    for (TDFMemberLevelCellModel *cellModel in self.barCells) {
        CGFloat heightPercent = maxCount == 0 ? 0 : cellModel.count / (CGFloat)maxCount;
//        if (percent > 0) {
//            cellModel.percent = [NSString stringWithFormat:@"%0.2f%%", percent];
//        }
        cellModel.height = maxHeight * heightPercent;
        
        if (cellModel.count == maxCount) {
            cellModel.rectColor = [[UIColor colorWithHeX:0xFF0000] colorWithAlphaComponent:0.7];
        } else {
            cellModel.rectColor = [[UIColor colorWithHeX:0xFFFFFF] colorWithAlphaComponent:0.5];
        }
    }
    
    [self.swipeView reloadData];
    [self layoutIfNeeded];
}

- (CGFloat)heightForView
{
    return ([self.titleLabel.text isNotEmpty] ? 155 : 110);
}

- (NSInteger)getMaxCountWithBarCells:(NSArray<TDFMemberLevelCellModel *> *)barCells
{
    NSInteger maxCount = 0;
    
    for (TDFMemberLevelCellModel *cellModel in self.barCells) {
        if (cellModel.count > maxCount) {
            maxCount = cellModel.count;
        }
    }
    
    return maxCount;
}

#pragma mark -- SwipeViewDataSource --

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.barCells.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    TDFMemberLevelCell *cell = [[TDFMemberLevelCell alloc] initWithFrame:CGRectZero];
    
    [cell configureCellWithModel:self.barCells[index]];
    
    return cell;
}

#pragma mark -- SwipeViewDelegate --

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return CGSizeMake((SCREEN_WIDTH - 40) / 8, 100);
}

#pragma mark -- Getters && Setters --

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    
    return _titleLabel;
}

- (UIView *)spliteView
{
    if (!_spliteView) {
        _spliteView = [[UIView alloc] initWithFrame:CGRectZero];
        _spliteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    }
    
    return _spliteView;
}

- (SwipeView *)swipeView
{
    if (!_swipeView) {
        _swipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0, 0, 220, 100)];
        _swipeView.dataSource = self;
        _swipeView.delegate = self;
    }
    
    return _swipeView;
}

- (NSArray<TDFMemberLevelCellModel *> *)barCells
{
    if (!_barCells) {
        _barCells = [NSArray<TDFMemberLevelCellModel *> array];
    }
    
    return _barCells;
}

@end
