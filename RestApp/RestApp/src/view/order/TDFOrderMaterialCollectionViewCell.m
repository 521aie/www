//
//  TDFOrderMaterialCollectionViewCell.m
//  RestApp
//
//  Created by QiYa on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOrderMaterialCollectionViewCell.h"

#import "TDFOrderMaterialVoModel.h"

#import "NSString+Estimate.h"

static NSString * const kTDFOrderMaterialCellUnselectImgName = @"material_unselected";
static NSString * const kTDFOrderMaterialCellSelectImgName = @"material_selected";

@interface TDFOrderMaterialCollectionViewCell ()
@property (nonatomic, strong)UILabel *materialNameLabel;
@property (nonatomic, strong)UIImageView *selectImgView;
@end

@implementation TDFOrderMaterialCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.materialNameLabel];
        [self.contentView addSubview:self.selectImgView];
        
        [self configureLayoutUI];
    }
    
    return self;
}

- (void)configureLayoutUI {
    
    [self.materialNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
}

- (void)configureCellWithModel:(TDFOrderDetailMaterialVoModel *)model {
    
    BOOL unvalidModel = [NSString isBlank:model.labelName];
    
    self.materialNameLabel.hidden = unvalidModel;
    self.selectImgView.hidden = unvalidModel;
   
    self.materialNameLabel.text = model.labelName;
    self.selectImgView.image = [UIImage imageNamed:model.isSelected ? kTDFOrderMaterialCellSelectImgName : kTDFOrderMaterialCellUnselectImgName];
    
}

#pragma mark - Setter & Getter 
- (UILabel *)materialNameLabel {
    
    if (!_materialNameLabel) {
        _materialNameLabel = ({
            UILabel *lbl = [[UILabel alloc] init];
            lbl.font = [UIFont systemFontOfSize:12.0];
            lbl.textColor = [UIColor colorWithRed:102 / 255.0
                                            green:102 / 255.0
                                             blue:102 / 255.0
                                            alpha:1.0];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = NSLocalizedString(@"熊猫", nil);
            lbl;
        });
    }
    
    return _materialNameLabel;
    
}

- (UIImageView *)selectImgView {
    
    if (!_selectImgView) {
        _selectImgView = [UIImageView new];
        _selectImgView.image = [UIImage imageNamed:kTDFOrderMaterialCellUnselectImgName];
    }
    
    return _selectImgView;
    
}

@end
