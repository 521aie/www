//
//  TDFShopTurnOverController.m
//  RestApp
//
//  Created by Cloud on 2017/3/31.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopTurnOverController.h"
#import "TDFShopTurnCollCell.h"

@interface TDFShopTurnOverController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) UIView *titleView;

@property (nonatomic ,strong) UIButton *backBtn;

@property (nonatomic ,strong) UIView *lineView;

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UICollectionView *collectionV;

@property (nonatomic ,strong) UICollectionViewFlowLayout *layout;

@property (nonatomic ,strong) UIView *collectionBgView;

@property (nonatomic ,strong) NSMutableArray<TDFShopTurnItem *> *dataArr;

@property (nonatomic ,strong) UIView *tabTitleView;

@property (nonatomic ,strong) UIView *tabTitleBGView;

@property (nonatomic ,strong) UILabel *tabTitleLabel;

@property (nonatomic ,strong) UILabel *tabDetailLabel;

@property (nonatomic ,strong) UIView *tabTitleLine;

@end

@implementation TDFShopTurnOverController

static NSString *reuseId = @"tdfCollectionReuse";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"门店营业额";
    
    [self configLayout];
    
    [self configItem];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)configItem {

    _dataArr = [NSMutableArray new];
    
    TDFShopTurnItem *item = [[TDFShopTurnItem alloc]initWithTitle:@"应收" andDetail:[TDFShopCompareItem stringFromDouble:self.item.sourceAmount]];
    
    TDFShopTurnItem *item1 = [[TDFShopTurnItem alloc]initWithTitle:@"折扣" andDetail:[TDFShopCompareItem stringFromDouble:self.item.discountAmount]];
    
    TDFShopTurnItem *item2 = [[TDFShopTurnItem alloc]initWithTitle:@"损益" andDetail:[TDFShopCompareItem stringFromDouble:self.item.profitLossAmount]];
    
    TDFShopTurnItem *item3 = [[TDFShopTurnItem alloc]initWithTitle:@"账单数" andDetail:[TDFShopCompareItem stringFromInt:self.item.orderCount withUnit:@"单"]];
    
    TDFShopTurnItem *item4 = [[TDFShopTurnItem alloc]initWithTitle:@"总客人" andDetail:[TDFShopCompareItem stringFromInt:self.item.mealsCount withUnit:@"人"]];//self.item.mealsCount
    
    TDFShopTurnItem *item5 = [[TDFShopTurnItem alloc]initWithTitle:@"人均" andDetail:[TDFShopCompareItem stringFromDouble:self.item.actualAmountAvg]];
    
    [_dataArr addObject:item];
    [_dataArr addObject:item1];
    [_dataArr addObject:item2];
    [_dataArr addObject:item3];
    [_dataArr addObject:item4];
    [_dataArr addObject:item5];
    
    for (TDFShopPays *pay in self.item.pays) {
        
        TDFShopTurnItem *itemn = [[TDFShopTurnItem alloc]initWithTitle:pay.kindPayName andDetail:[TDFShopCompareItem stringFromDouble:pay.money]];
        [_dataArr addObject:itemn];
    }
    
    __weak typeof(self) ws = self;
    
    [self.collectionBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        
//        make.top.left.right.equalTo(ws.collectionV);
//        
//        if (self.dataArr.count == 0) {
//            
//            make.height.equalTo(@0);
//            
//        }else {
//            
//            int row = 0;
//            
//            if (self.dataArr.count%3>0) {
//                
//                row +=1;
//            }
//            row += self.dataArr.count/3;
//            
//            make.height.equalTo(ws.collectionV.mas_width).multipliedBy(0.2*row);
//            
//        }
        
        make.left.right.equalTo(ws.collectionV);
        make.top.equalTo(self.tabTitleView.mas_top);
        
        if (self.dataArr.count == 0) {
            
            make.height.equalTo(@60);
            
        }else {
            
            int row = 0;
            
            if (self.dataArr.count%3>0) {
                
                row +=1;
            }
            row += self.dataArr.count/3;
            
            make.height.equalTo(ws.collectionV.mas_width).multipliedBy(0.2*row).offset(60);
            
        }
    }];
    
    [self.view layoutIfNeeded];
    
    [self.collectionV reloadData];
    
    [self configTabTitle];
}

- (void)configTabTitle {

    self.tabTitleLabel.text = self.item.shopName;
    
    NSString *str = (self.dateType == TDFShopTurnOverDateTypeMonth)?@"当月收益：":@"当日收益：";
    
    NSString *totalStr = [str stringByAppendingString:[TDFShopCompareItem normalStringFromDouble:self.item.actualAmount]];
    
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    
    [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(attriStr.length-1, 1)];
    
    [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, str.length)];
    
    self.tabDetailLabel.attributedText = attriStr;
}

- (void)configLayout {

    [self.view addSubview:self.titleView];
    [self.titleView addSubview:self.backBtn];
    [self.titleView addSubview:self.titleLabel];
    [self.titleView addSubview:self.lineView];
    
    [self.view addSubview:self.tabTitleView];
//    [self.tabTitleView addSubview:self.tabTitleBGView];
    [self.tabTitleView addSubview:self.tabTitleLabel];
    [self.tabTitleView addSubview:self.tabDetailLabel];
    [self.tabTitleView addSubview:self.tabTitleLine];
    
    [self.view addSubview:self.collectionBgView];
    [self.view addSubview:self.collectionV];
    
    __weak typeof(self) ws = self;
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(20);
        make.left.offset(0);
        make.right.offset(0);
        make.height.mas_equalTo(44);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.offset(0);
        make.top.offset(0);
        make.left.offset(0);
        make.width.mas_equalTo(40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(ws.titleView.mas_centerX);
        make.bottom.offset(0);
        make.top.offset(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(10);
        make.right.offset(-10);
        make.height.mas_equalTo(0.5);
        make.bottom.offset(0);
    }];
    
    
    [self.tabTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(ws.titleView.mas_bottom).offset(20);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.equalTo(@60);
    }];
    
//    [self.tabTitleBGView mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.edges.equalTo(ws.tabTitleView);
//    }];
    
    [self.tabTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.offset(0);
        make.left.offset(5);
        make.right.offset(-5);
        make.height.equalTo(ws.tabTitleView.mas_height).multipliedBy(0.5);
    }];
    
    [self.tabDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(ws.tabTitleLabel.mas_bottom);
        make.left.offset(5);
        make.right.offset(-5);
        make.bottom.offset(0);
    }];
    
    [self.tabTitleLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.tabDetailLabel.mas_left);
        make.right.equalTo(self.tabDetailLabel.mas_right);
        make.bottom.equalTo(self.tabDetailLabel.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.offset(10);
        make.right.offset(-10);
        make.top.equalTo(ws.tabTitleView.mas_bottom);
    }];
    
    [self.collectionBgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
//        make.top.left.right.equalTo(ws.collectionV);
//        
//        if (self.dataArr.count == 0) {
//            
//            make.height.equalTo(@0);
//            
//        }else {
//        
//            int row = 0;
//            
//            if (self.dataArr.count%3>0) {
//                
//                row +=1;
//            }
//            row += self.dataArr.count/3;
//            
//            make.height.equalTo(ws.collectionV.mas_width).multipliedBy(0.2*row);
//            
//        }

        make.left.right.equalTo(ws.collectionV);
        make.top.equalTo(self.tabTitleView.mas_top);
        
        if (self.dataArr.count == 0) {
            
            make.height.equalTo(@60);
            
        }else {
            
            int row = 0;
            
            if (self.dataArr.count%3>0) {
                
                row +=1;
            }
            row += self.dataArr.count/3;
            
            make.height.equalTo(ws.collectionV.mas_width).multipliedBy(0.2*row).offset(60);
            
        }

    }];
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TDFShopTurnCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    
    [cell configWithItem:self.dataArr[indexPath.row] andIndex:indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(collectionView.frame.size.width/3, collectionView.frame.size.width/5);
}

#pragma mark - Getter

- (UIView *)titleView {

    if (!_titleView) {
        
        _titleView = [UIView new];
    }
    return _titleView;
}

- (UIButton *)backBtn {
    
    if (!_backBtn) {
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_backBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        
        UIImage *backIcon = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_back"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
        [_backBtn setImage:backIcon forState:UIControlStateNormal];
        
        [_backBtn addTarget:self action:@selector(leftNavigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIView *)lineView {

    if (!_lineView) {
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [UILabel new];
        
        _titleLabel.text = @"门店营业额";
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.textColor = [UIColor whiteColor];
        
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UICollectionView *)collectionV {

    if (!_collectionV) {
        
        _collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        
        _collectionV.backgroundColor = [UIColor clearColor];
        
        [_collectionV registerClass:[TDFShopTurnCollCell class] forCellWithReuseIdentifier:reuseId];
        
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
    }
    return _collectionV;
}

- (UICollectionViewFlowLayout *)layout {

    if (!_layout) {
        
        _layout = [[UICollectionViewFlowLayout alloc]init];
        
        [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
    }
    return _layout;
}

- (UIView *)collectionBgView {

    if (!_collectionBgView) {
        
        _collectionBgView = [UIView new];
        
        _collectionBgView.backgroundColor = [UIColor whiteColor];
        
        _collectionBgView.alpha = 0.1;
        
        _collectionBgView.layer.cornerRadius = 5;
        
        _collectionBgView.layer.masksToBounds = YES;
    }
    return _collectionBgView;
}

- (NSMutableArray<TDFShopTurnItem *> *)dataArr {

    if (!_dataArr) {
        
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

- (UIView *)tabTitleView {

    if (!_tabTitleView) {
        
        _tabTitleView = [UIView new];
    }
    return _tabTitleView;
}

- (UIView *)tabTitleBGView {

    if (!_tabTitleBGView ) {
        
        _tabTitleBGView = [UIView new];
        _tabTitleBGView.backgroundColor = [UIColor whiteColor];
        _tabTitleBGView.alpha = 0.1;
        _tabTitleBGView.layer.cornerRadius = 5;
        _tabTitleBGView.layer.masksToBounds = YES;
    }
    return _tabTitleBGView;
}

- (UILabel *)tabTitleLabel {

    if (!_tabTitleLabel) {
        
        _tabTitleLabel = [UILabel new];
        _tabTitleLabel.text = @"店名";
        _tabTitleLabel.textColor = [UIColor whiteColor];
        _tabTitleLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return _tabTitleLabel;
}

- (UIView *)tabTitleLine {

    if (!_tabTitleLine) {
        
        _tabTitleLine = [UIView new];
        _tabTitleLine.backgroundColor = [UIColor grayColor];
    }
    return _tabTitleLine;
}

- (UILabel *)tabDetailLabel {

    if (!_tabDetailLabel) {
        
        _tabDetailLabel = [UILabel new];
        _tabDetailLabel.text = @"营业额";
        _tabDetailLabel.textColor = [UIColor whiteColor];
        _tabDetailLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return _tabDetailLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
