//
//  TDFTagPaperTempleteView.m
//  RestApp
//
//  Created by BK_G on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTagPaperTempleteView.h"

#define kFontSizeWithpx(px) px / 96 * 72
#define DCSystemFontWithpx(px) [UIFont systemFontOfSize:kFontSizeWithpx(px)]
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface TDFTagPaperTempleteView ()

@property (nonatomic, assign) CGRect rect;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) CGRect contentRect;

@property (nonatomic, strong) UILabel *leftToplabel;

@property (nonatomic, strong) UILabel *leftCenterlabel;

@property (nonatomic, strong) UILabel *leftBottomlabel;

@property (nonatomic, strong) UIView *realContenView;

@property (nonatomic, strong) UILabel *goodNameLabel;

@property (nonatomic, strong) UILabel *goodNameDescLabel;

@property (nonatomic, strong) UIView *goodNameDescLineView;

@property (nonatomic, strong) UILabel *goodPropLabel;

@property (nonatomic, strong) UILabel *goodPropDesclabel;

@property (nonatomic, strong) UIView *goodPropDescLineView;

@property (nonatomic, strong) UIImageView *goodPropDescDottedLineView;

@property (nonatomic, strong) UIView *paperDetailView;

@property (nonatomic, strong) UIImageView *paperDetailDottedLineView;

@property (nonatomic, strong) UILabel *detailLeftLabel;

@property (nonatomic, strong) UILabel *detailRightLabel;

@property (nonatomic, strong) UILabel *paperTailLabel;

@property (nonatomic, strong) UILabel *paperTailDescLabel;

@property (nonatomic, strong) UIView *paperTailDescLineView;

@property (nonatomic, strong) NSMutableDictionary *propDic;

@end

@implementation TDFTagPaperTempleteView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.rect = frame;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self configlayout];
    }
    
    return self;
}

#pragma mark - Layout

- (void)configlayout {
    
    [self addSubview:self.contentView];
    
    [self addSubview:self.leftToplabel];
    
    [self addSubview:self.leftCenterlabel];
    
    [self addSubview:self.leftBottomlabel];
    
    [self addSubview:self.realContenView];
    
    [self addSubview:self.goodNameLabel];
    
    [self addSubview:self.goodNameDescLabel];
    
    [self addSubview:self.goodNameDescLineView];
    
    [self addSubview:self.goodPropLabel];
    
    [self addSubview:self.goodPropDesclabel];
    
    [self addSubview:self.goodPropDescLineView];
    
    [self addSubview:self.goodPropDescDottedLineView];
    
    [self addSubview:self.paperDetailView];
    
    [self addSubview:self.paperDetailDottedLineView];
    
    [self addSubview:self.detailLeftLabel];
    
    [self addSubview:self.detailRightLabel];
    
    [self addSubview:self.paperTailLabel];
    
    [self addSubview:self.paperTailDescLabel];
    
    [self addSubview:self.paperTailDescLineView];
    
    [self configConstraints];
}

- (void)configConstraints {
    

    __weak typeof(self) ws = self;
    
    [self.realContenView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.contentView.mas_left).offset(70);
        make.right.equalTo(ws.contentView.mas_right).offset(-40);
        make.top.equalTo(ws.contentView.mas_top).offset(33);
        make.bottom.equalTo(ws.paperTailDescLineView.mas_bottom).offset(5);
    }];
    
    [self.goodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(ws.realContenView.mas_left).offset(15);
        make.right.equalTo(ws.realContenView.mas_right).offset(-15);
        make.top.equalTo(ws.realContenView.mas_top).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    [self.goodNameDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(ws.goodNameLabel.mas_left);
        make.right.equalTo(ws.contentView.mas_right).offset(-15);
        make.top.equalTo(ws.goodNameLabel.mas_top);
        make.height.mas_equalTo(20);
    }];
    
    [self.goodNameDescLineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(ws.goodNameDescLabel.mas_left);
        make.right.equalTo(ws.goodNameDescLabel.mas_right);
        make.bottom.equalTo(ws.goodNameDescLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.goodPropLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(ws.goodNameLabel.mas_left);
        make.right.equalTo(ws.goodNameLabel.mas_right);
        make.top.equalTo(ws.goodNameLabel.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    [self.goodPropDesclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.goodPropLabel.mas_left);
        make.right.equalTo(ws.contentView.mas_right).offset(-15);
        make.bottom.equalTo(ws.goodPropLabel.mas_bottom);
        make.height.equalTo(ws.goodPropLabel);
    }];
    
    [self.goodPropDescLineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(ws.goodPropDesclabel.mas_left);
        make.right.equalTo(ws.goodPropDesclabel.mas_right);
        make.bottom.equalTo(ws.goodPropDesclabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.goodPropDescDottedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(ws.realContenView.mas_left);
        make.right.equalTo(ws.realContenView.mas_right);
        make.top.equalTo(ws.goodPropDescLineView.mas_bottom).offset(3);
        make.height.mas_equalTo(2);
    }];
    
    [self.paperDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(ws.goodNameLabel.mas_left);
        make.right.equalTo(ws.goodNameLabel.mas_right);
        make.top.equalTo(ws.goodPropDescDottedLineView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.paperDetailDottedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(ws.realContenView.mas_left);
        make.right.equalTo(ws.realContenView.mas_right);
        make.top.equalTo(ws.paperDetailView.mas_bottom);
        make.height.mas_equalTo(2);
    }];
    
    [self.paperTailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.goodNameLabel.mas_left);
        make.right.equalTo(ws.goodNameLabel.mas_right);
        make.top.equalTo(ws.paperDetailDottedLineView.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    
    [self.paperTailDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.paperTailLabel.mas_left);
        make.right.equalTo(ws.contentView.mas_right).offset(-15);
        make.bottom.equalTo(ws.paperTailLabel.mas_bottom);
//        make.height.mas_equalTo(20);
    }];
    
    [self.paperTailDescLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.paperTailDescLabel.mas_left);
        make.right.equalTo(ws.contentView.mas_right).offset(-15);
        make.bottom.equalTo(ws.paperTailDescLabel.mas_bottom).offset(2);
        make.height.mas_equalTo(1);
    }];
    
    [self.detailLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(ws.paperDetailView.mas_left);
        make.top.equalTo(ws.paperDetailView.mas_top).offset(5);
    }];
    
    [self.detailRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.paperDetailView.mas_centerX);
        make.top.equalTo(ws.paperDetailView.mas_top).offset(5);
    }];
    
    [self.leftToplabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(ws.contentView.mas_left);
        make.right.equalTo(ws.realContenView.mas_left);
        make.top.equalTo(ws.goodNameLabel.mas_top);
        make.height.equalTo(ws.paperDetailView.mas_height);
    }];
    
    [self.leftCenterlabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(ws.leftToplabel.mas_left);
        make.right.equalTo(ws.leftToplabel.mas_right);
        make.top.equalTo(ws.paperDetailView.mas_top);
        make.bottom.equalTo(ws.paperDetailView.mas_bottom);
    }];
    
    [self.leftBottomlabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(ws.leftToplabel.mas_left);
        make.right.equalTo(ws.leftToplabel.mas_right);
        make.top.equalTo(ws.paperTailLabel.mas_top);
        make.bottom.equalTo(ws.paperTailLabel.mas_bottom);
    }];
}

#pragma mark - Getter&Setter

- (UIView *)contentView {

    if (!_contentView) {
     
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, _rect.size.width-20, _rect.size.height)];
        
        _contentRect = _contentView.frame;
        
        _contentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    }
    return _contentView;
}

- (UILabel *)leftToplabel {

    if (!_leftToplabel) {
        
        _leftToplabel = [[UILabel alloc]init];
        
        _leftToplabel.textAlignment = NSTextAlignmentCenter;
        
        _leftToplabel.text = NSLocalizedString(@"标签纸头部", nil);
        
        _leftToplabel.font = DCSystemFontWithpx(11.0);
        
        _leftToplabel.textColor = [UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1];
    }
    
    return _leftToplabel;
}

- (UILabel *)leftCenterlabel {
    
    if (!_leftCenterlabel) {
        
        _leftCenterlabel = [[UILabel alloc]init];
        
        _leftCenterlabel.textAlignment = NSTextAlignmentCenter;
        
        _leftCenterlabel.text = NSLocalizedString(@"标签纸明细", nil);
        
        _leftCenterlabel.font = DCSystemFontWithpx(11.0);
        
        _leftCenterlabel.textColor = [UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1];
    }
    
    return _leftCenterlabel;
}

- (UILabel *)leftBottomlabel {
    
    if (!_leftBottomlabel) {
        
        _leftBottomlabel = [[UILabel alloc]init];
        
        _leftBottomlabel.textAlignment = NSTextAlignmentCenter;
        
        _leftBottomlabel.text = NSLocalizedString(@"标签纸尾部", nil);
        
        _leftBottomlabel.font = DCSystemFontWithpx(11.0);
        
        _leftBottomlabel.textColor = [UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1];
    }
    
    return _leftBottomlabel;
}

- (UIView *)realContenView {

    if (!_realContenView) {
        
        _realContenView = [[UIView alloc]init];
        
        _realContenView.backgroundColor = [UIColor whiteColor];
    }
    return _realContenView;
}

- (UILabel *)goodNameLabel {

    if (!_goodNameLabel) {
        
        _goodNameLabel = [[UILabel alloc]init];
        
        _goodNameLabel.text = NSLocalizedString(@"红茶玛奇朵", nil);
        
        _goodNameLabel.font = [UIFont boldSystemFontOfSize:kFontSizeWithpx(18.0)];
        
        _goodNameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        
    }
    return _goodNameLabel;
}

- (UILabel *)goodNameDescLabel {

    if (!_goodNameDescLabel) {
        
        _goodNameDescLabel = [[UILabel alloc]init];
        
        _goodNameDescLabel.text = NSLocalizedString(@"品名", nil);
        
        _goodNameDescLabel.font = DCSystemFontWithpx(11.0);
        
        _goodNameDescLabel.textColor = [UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1];
        
        _goodNameDescLabel.textAlignment = NSTextAlignmentRight;
    }
    return _goodNameDescLabel;
}

- (UIView *)goodNameDescLineView {

    if (!_goodNameDescLineView) {
        
        _goodNameDescLineView = [[UIView alloc]init];
        
        _goodNameDescLineView.backgroundColor = [UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1];
    }
    return _goodNameDescLineView;
}

- (UILabel *)goodPropLabel {

    if (!_goodPropLabel) {
        
        _goodPropLabel = [[UILabel alloc]init];
        
        _goodPropLabel.numberOfLines = 2;
        
        _goodPropLabel.text = NSLocalizedString(@"加珍珠，加珍珠，加珍珠，加珍珠，加珍珠，加珍珠", nil);
        
        _goodPropLabel.font = DCSystemFontWithpx(11.0);
        
        _goodPropLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];

    }
    return _goodPropLabel;
}

- (UILabel *)goodPropDesclabel {

    if (!_goodPropDesclabel) {
        
        _goodPropDesclabel = [[UILabel alloc]init];
        
        _goodPropDesclabel.numberOfLines = 2;
        
        _goodPropDesclabel.text = NSLocalizedString(@"\n规格，加料，做法，备注", nil);
        
        _goodPropDesclabel.font = DCSystemFontWithpx(11.0);
        
        _goodPropDesclabel.textColor = [UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1];
        
        _goodPropDesclabel.textAlignment = NSTextAlignmentRight;
    }
    return _goodPropDesclabel;
}

- (UIView *)goodPropDescLineView {

    if (!_goodPropDescLineView) {
        
        _goodPropDescLineView = [[UIView alloc]init];
        
        _goodPropDescLineView.backgroundColor = [UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1];
    }
    return _goodPropDescLineView;
}

- (UIImageView *)goodPropDescDottedLineView {

    if (!_goodPropDescDottedLineView) {
        
        _goodPropDescDottedLineView = [[UIImageView alloc]init];
        
        _goodPropDescDottedLineView.image = [UIImage imageNamed:@"dottedLine"];
    }
    return _goodPropDescDottedLineView;
}

- (UIView *)paperDetailView {

    if (!_paperDetailView) {
        
        _paperDetailView = [[UIView alloc]init];
        
    }
    return _paperDetailView;
}

- (UIImageView *)paperDetailDottedLineView {

    if (!_paperDetailDottedLineView) {
        
        _paperDetailDottedLineView = [[UIImageView alloc]init];
        
        _paperDetailDottedLineView.image = [UIImage imageNamed:@"dottedLine"];
    }
    return _paperDetailDottedLineView;
}

- (UILabel *)detailLeftLabel {

    if (!_detailLeftLabel) {
        
        _detailLeftLabel = [[UILabel alloc]init];
        
        _detailLeftLabel.text = NSLocalizedString(@"价格：73元\n收款人：ADMIN", nil);
        
        _detailLeftLabel.numberOfLines = 0;
        
        _detailLeftLabel.font = DCSystemFontWithpx(13.0);
        
        _detailLeftLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        
    }
    return _detailLeftLabel;
}

- (UILabel *)detailRightLabel {

    if (!_detailRightLabel) {
        
        _detailRightLabel = [[UILabel alloc]init];
        
        _detailRightLabel.text = NSLocalizedString(@"单号：18\n2016/12/22", nil);
        
        _detailRightLabel.numberOfLines = 0;
        
        _detailRightLabel.font = DCSystemFontWithpx(13.0);
        
        _detailRightLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        
    }
    return _detailRightLabel;
}

- (UILabel *)paperTailLabel {

    if (!_paperTailLabel) {
        
        _paperTailLabel = [[UILabel alloc]init];
        
        _paperTailLabel.text = NSLocalizedString(@"欢迎常来本店！", nil);
        
        _paperTailLabel.numberOfLines = 0;
        
        _paperTailLabel.font = DCSystemFontWithpx(11.0);
        
        _paperTailLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    }
    return _paperTailLabel;
}

- (UILabel *)paperTailDescLabel {

    if (!_paperTailDescLabel) {
        
        _paperTailDescLabel = [[UILabel alloc]init];
        
        _paperTailDescLabel.text = NSLocalizedString(@"尾注", nil);
        
        _paperTailDescLabel.font = DCSystemFontWithpx(11.0);
        
        _paperTailDescLabel.textColor = [UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1];
        
        _paperTailDescLabel.textAlignment = NSTextAlignmentRight;
    }
    return _paperTailDescLabel;
}

- (UIView *)paperTailDescLineView {

    if (!_paperTailDescLineView) {
        
        _paperTailDescLineView = [[UIView alloc]init];
        
        _paperTailDescLineView.backgroundColor = [UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1];
    }
    return _paperTailDescLineView;
}

- (NSMutableDictionary *)propDic {

    if (!_propDic) {
        
        _propDic = [NSMutableDictionary new];
        
        _propDic[NSLocalizedString(@"品名", nil)] = NSLocalizedString(@"红茶玛奇朵", nil);
        _propDic[NSLocalizedString(@"规格", nil)] = NSLocalizedString(@"大杯", nil);
        _propDic[NSLocalizedString(@"加料", nil)] = NSLocalizedString(@"加珍珠，加椰果", nil);
        _propDic[NSLocalizedString(@"做法", nil)] = NSLocalizedString(@"炭烧", nil);
        _propDic[NSLocalizedString(@"备注", nil)] = NSLocalizedString(@"加冰，不加糖，热", nil);
        _propDic[NSLocalizedString(@"重量", nil)] = NSLocalizedString(@"重量：5.50kg", nil);
        _propDic[NSLocalizedString(@"价格", nil)] = NSLocalizedString(@"价格：73元", nil);
        _propDic[NSLocalizedString(@"促销价", nil)] = NSLocalizedString(@"促销价：70元", nil);
        _propDic[NSLocalizedString(@"单号", nil)] = NSLocalizedString(@"单号：18", nil);
        _propDic[NSLocalizedString(@"流水号", nil)] = NSLocalizedString(@"流水号：1/3", nil);
        _propDic[NSLocalizedString(@"桌号", nil)] = NSLocalizedString(@"桌号：58", nil);
        _propDic[NSLocalizedString(@"收款人", nil)] = NSLocalizedString(@"收款人：ADMIN", nil);
        _propDic[NSLocalizedString(@"打印时间", nil)] = @"2016/12/22";
        _propDic[NSLocalizedString(@"店名", nil)] = NSLocalizedString(@"二维火测试店", nil);
        _propDic[NSLocalizedString(@"商家电话", nil)] = NSLocalizedString(@"0571—86778789", nil);
        _propDic[NSLocalizedString(@"尾注", nil)] = NSLocalizedString(@"欢迎常来本店！", nil);
        _propDic[NSLocalizedString(@"顾客电话", nil)] = NSLocalizedString(@"顾客电话：13577088552", nil);
        _propDic[NSLocalizedString(@"送货地址", nil)] = NSLocalizedString(@"送货地址：杭州市拱墅区教工路552号", nil);
        
    }
    return _propDic;
}
#pragma mark - loadData

- (void)loadDataWithArray:(NSArray *)arr andIsTailCenter:(BOOL )isTailCenter{
    
    if (arr.count<3) {
        
        return;
    }
    
    [self makeGoodPropStringWithArr:arr[0]];
    
    [self makeDetailWithArr:arr[1]];
    
//    [self makeTailWithArr:arr[2]];
    [self makeTailWithArr:arr[2] andIsTailCenter:isTailCenter];
    
    [self updateAllMyConst];
}

- (void )makeGoodPropStringWithArr:(NSArray *)arr {
    
    if (arr.count<=1) {
    
        self.goodPropDescLineView.hidden = YES;
        
    }else {
    
        self.goodPropDescLineView.hidden = NO;
    }
    
    NSMutableString *str = [NSMutableString new];
    
    NSMutableString *desStr = [NSMutableString new];
    
    for (int i = 1; i<arr.count; i++) {
        
        if (i==arr.count-1) {
            
            [str appendString:[arr[i] allObjects][0]];
            
            [desStr appendString:[arr[i] allKeys][0]];
        }else {
        
            [str appendString:[arr[i] allObjects][0]];
            [str appendString:NSLocalizedString(@"，", nil)];
            
            [desStr appendString:[arr[i] allKeys][0]];
            [desStr appendString:NSLocalizedString(@"，", nil)];
        }
    }
    
    
    self.goodPropDesclabel.text = [NSString stringWithFormat:@"\n%@",desStr];
    
    self.goodPropLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.goodPropLabel.text = [NSString stringWithFormat:@"%@\n",str];
}

- (void)makeDetailWithArr:(NSArray *)arr {

    WS(weakSelf);
    
    NSMutableString *strLeft = [NSMutableString new];
    
    NSMutableString *strRight = [NSMutableString new];
    
    for (int i = 0; i<arr.count; i++) {
        
        if (i%2==0) {
            
            [strLeft appendString:[arr[i] allObjects][0]];
            if ((i==arr.count-1)||(i==arr.count-2)) {
                
            }else {
                [strLeft appendString:@"\n"];
            }
        }else {
            [strRight appendString:[arr[i] allObjects][0]];
            if ((i==arr.count-1)||(i==arr.count-2)) {
                
            }else {
                [strRight appendString:@"\n"];
            }
        }
    }
    
    self.detailLeftLabel.text = strLeft;
    self.detailRightLabel.text = strRight;
    
    [self.detailLeftLabel sizeToFit];
    [self.detailRightLabel sizeToFit];
    
    
    CGFloat height = [self.detailLeftLabel sizeThatFits:CGSizeZero].height;
    
    if (height) {
        
        [self.paperDetailView mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.height.mas_equalTo(height+10);
        }];
    }
}

- (void)makeTailWithArr:(NSArray *)arr andIsTailCenter:(BOOL )isTailCenter {
    
    if (arr.count == 0) {
    
        self.paperTailDescLineView.hidden = YES;
        
    }else {
    
        self.paperTailDescLineView.hidden = NO;
    }

    NSMutableString *str = [[NSMutableString alloc]init];
    
    NSMutableString *desStr = [[NSMutableString alloc]init];
    
    for (int i = 0; i<arr.count; i++) {
        
        if (i==arr.count-1) {
            
            [str appendString:[arr[i] allObjects][0]];
            
            [desStr appendString:[arr[i] allKeys][0]];
        }else {
        
            [str appendString:[arr[i] allObjects][0]];
            [str appendString:@"\n"];
            
            [desStr appendString:[arr[i] allKeys][0]];
            [desStr appendString:@","];
        }
    }
    self.paperTailLabel.text = str;
    
    self.paperTailDescLabel.text = [NSString stringWithFormat:@"%@",desStr];
    
    if (isTailCenter) {
        
        self.paperTailLabel.textAlignment = NSTextAlignmentCenter;
        
    }else {
    
        self.paperTailLabel.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)updateAllMyConst {
    

    [self updateConstraints];
    
}

@end
























