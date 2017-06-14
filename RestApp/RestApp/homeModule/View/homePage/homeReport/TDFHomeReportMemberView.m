//
//  TDFHomeReportMemberView.m
//  Pods
//
//  Created by happyo on 2017/3/30.
//
//

#import "TDFHomeReportMemberView.h"
#import "TDFCollectionView.h"
#import "TDFHomeReportListCell.h"
#import "Masonry.h"
#import "YYModel.h"
#import "TDFCommonInfoListView.h"
#import "UIColor+Hex.h"
#import "NSString+TDF_Empty.h"

@implementation TDFHomeReportMemberModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"commonCells" : [TDFHomeReportListCellModel class]};
}

@end

@interface TDFHomeReportMemberView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *spliteView;

@property (nonatomic, strong) TDFCommonInfoListView *infoListView;

@property (nonatomic, strong) TDFMemberLevelView *memberLevelView;

@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UIButton *forwardButton;

@property (nonatomic, strong) UILabel *forwardLabel;

@end
@implementation TDFHomeReportMemberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //
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
        
        [self addSubview:self.infoListView];
        [self.infoListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.spliteView.mas_bottom).with.offset(10);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.height.equalTo(@0);
        }];
        
        [self addSubview:self.memberLevelView];
        [self.memberLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.infoListView.mas_bottom);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.height.equalTo(@100);
        }];
        
        [self addSubview:self.descriptionLabel];
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.memberLevelView.mas_bottom).with.offset(10);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.height.equalTo(@31);
        }];
        
        [self addSubview:self.forwardButton];
        [self.forwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self);
            make.top.equalTo(self.infoListView);
            make.bottom.equalTo(self.descriptionLabel).with.offset(33);
            make.leading.equalTo(self);
        }];
        
        [self.forwardButton addSubview:self.forwardLabel];
        [self.forwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.forwardButton).with.offset(-15);
            make.trailing.equalTo(self.forwardButton).with.offset(-25);
            make.height.equalTo(@(13));
            make.width.equalTo(@(150));
        }];
        
        UIImageView *igvArrowRight = [[UIImageView alloc] initWithFrame:CGRectZero];
        igvArrowRight.image = [UIImage imageNamed:@"business_info_arrow_right_blue"];
        [self.forwardButton addSubview:igvArrowRight];
        [igvArrowRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.forwardButton).with.offset(-15);
            make.trailing.equalTo(self.forwardButton).with.offset(-10);
            make.height.equalTo(@(13));
            make.width.equalTo(@(8));
        }];

    }
    
    return self;
}

- (void)configureViewWithModel:(TDFHomeReportMemberModel *)model
{
    if ([self.forwardString isNotEmpty]) {
        self.forwardLabel.text = self.forwardString;
        self.forwardButton.hidden = NO;
    } else {
        self.forwardButton.hidden = YES;
    }
    
    CGFloat titleHeight = 0;
    
    if ([model.title isNotEmpty]) {
        titleHeight = 44;
        self.titleLabel.text = model.title;
    }
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(titleHeight));
    }];
    
    [self.infoListView configureViewWithModelList:model.commonCells];
    [self.infoListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.infoListView.heightForView));
    }];
    
    
    
    CGFloat descHeight = 0;
    CGFloat offset = 0;
    
    if ([model.desc isNotEmpty]) {
        descHeight = 31;
        offset = 10;
        self.descriptionLabel.text = model.desc;
    }
    
    if (model.memberBarModel) {
        self.memberLevelView.hidden = NO;
        [self.memberLevelView configureViewWithModel:model.memberBarModel];
        [self.memberLevelView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([self.memberLevelView heightForView]));
        }];
    } else {
        self.memberLevelView.hidden = YES;
        [self.memberLevelView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        offset = 0;
    }
    
    [self.descriptionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memberLevelView.mas_bottom).with.offset(offset);
        make.height.equalTo(@(descHeight));
    }];
    
    [self layoutIfNeeded];
}

- (CGFloat)heightForView
{
    return self.titleLabel.frame.size.height + 10 + ([self.titleLabel.text isNotEmpty] ? 51 : 0) + self.infoListView.heightForView + (self.memberLevelView.hidden ? 0 : [self.memberLevelView heightForView]) + (self.forwardButton.hidden ? 0 : 33);
}

#pragma mark -- Actions --

- (void)forwardButtonClicked
{
    if (self.forwardWithUrlBlock) {
        self.forwardWithUrlBlock(self.forwardUrl);
    }
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

- (TDFCommonInfoListView *)infoListView
{
    if (!_infoListView) {
        _infoListView = [[TDFCommonInfoListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    }
    
    return _infoListView;
}

- (TDFMemberLevelView *)memberLevelView
{
    if (!_memberLevelView) {
        _memberLevelView = [[TDFMemberLevelView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    }
    
    return _memberLevelView;
}


- (UIButton *)forwardButton
{
    if (!_forwardButton) {
        _forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forwardButton addTarget:self action:@selector(forwardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _forwardButton;
}

- (UILabel *)forwardLabel
{
    if (!_forwardLabel) {
        _forwardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _forwardLabel.font = [UIFont systemFontOfSize:13];
        _forwardLabel.textColor = [UIColor colorWithHeX:0x0088CC];
        _forwardLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _forwardLabel;
}

- (UILabel *)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descriptionLabel.font = [UIFont systemFontOfSize:11];
        _descriptionLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    return _descriptionLabel;
}

@end
