//
//  TDFBarChartView.m
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/12/2.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import "TDFHealthCheckBarChartView.h"
#import "UIColor+Hex.h"
#import "ObjectUtil.h"
#import "Masonry.h"
///约定barview的宽度是间距的一半
@interface TDFHealthCheckBarChartView ()
{
    int _maxCount;
    CGFloat _barWidth;
    CGFloat _maxHeight;
    CGFloat _itemWidth;
    CGFloat _space;
}

@property (nonatomic, strong) UILabel *title;
@end

@implementation TDFHealthCheckBarChartView

-(instancetype)init{
    if (self = [super init]) {
        _itemWidth = 12;
        _maxCount = 8;
        _maxHeight = 30;
        [self configViews];
    }
    return self;
}

-(void)configViews{
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.and.left.equalTo(self);
    }];
}
-(void)loadDatas:(NSDictionary *)dict{
    self.title.text = dict[@"title"];
    _dataArray = dict[@"charts"];
    if ([ObjectUtil isEmpty:dict] || [ObjectUtil isEmpty:_dataArray] ) {
        return;
    }
    [self updateViews];
}
-(void)updateViews{
    [self layoutIfNeeded];
    CGFloat space =  (self.bounds.size.width-_maxCount*_itemWidth)/(_maxCount-1);
    CGFloat start = (self.bounds.size.width-_dataArray.count*_itemWidth-space*(_dataArray.count-1))*0.5;
    NSArray *res = [_dataArray valueForKeyPath:@"value"];
    CGFloat maxValue = [[res valueForKeyPath:@"@max.floatValue"] floatValue];
    if(maxValue ==0){
        maxValue = 1;
    }
    UIView *line = ({
        UIView *view = [UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@1);
            make.bottom.equalTo(self.mas_bottom).offset(-36);
            make.left.equalTo(self.mas_left).offset(start);
        }];
        view.backgroundColor = [UIColor colorWithHexString:@"#685A60" alpha:0.5];
        view;
    });
    UIView *lastView = nil;
    for (NSInteger i = 0; i < _dataArray.count; i++) {
        NSDictionary *dict = _dataArray[i];
        UIView *bar = ({
            UIView *view = [UIView new];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(_itemWidth,_maxHeight*[dict[@"value"] doubleValue]/maxValue));
                make.bottom.equalTo(line.mas_top);
                if (lastView) {
                    make.left.equalTo(lastView.mas_right).offset(space);
                }else{
                    make.left.equalTo(self.mas_left).offset(start);
                }
            }];
            view.backgroundColor = [UIColor colorWithHexString:dict[@"color"]];
            view;
        });
        lastView = bar;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
        UILabel *xLabel = ({
            UILabel *view = [UILabel new];
            view.textColor = [UIColor colorWithHexString:@"#666666"];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line.mas_bottom).offset(5);
                make.centerX.equalTo(bar.mas_centerX);
                make.width.mas_equalTo(@28);
            }];
            view.font = [UIFont systemFontOfSize:9];
            view.textAlignment = NSTextAlignmentCenter;
            view.numberOfLines = 0;
            view.text = dict[@"subscript"];
            view;
        });
        UILabel *yLabel = ({
            UILabel *view = [UILabel new];
            view.textColor = [UIColor colorWithHexString:@"#666666"];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(bar.mas_top).offset(-5);
                make.centerX.equalTo(bar.mas_centerX);
                make.width.mas_equalTo(@30);
            }];
            view.font = [UIFont systemFontOfSize:9];
            view.textAlignment = NSTextAlignmentCenter;
            view.numberOfLines = 0;
            view.text = [NSString stringWithFormat:@"%@%@",dict[@"value"],dict[@"unit"]?dict[@"unit"]:@""];
            view;
        });
        #pragma clang diagnostic pop

    }
    [line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right);
    }];
}
-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark
-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.numberOfLines = 0;
        _title.font = [UIFont systemFontOfSize:11];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _title;
}
@end
