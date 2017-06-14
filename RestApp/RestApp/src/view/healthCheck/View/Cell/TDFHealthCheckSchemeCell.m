//
//  TDFHeadCheckSchemeCell.m
//  ClassProperties
//
//  Created by guopin on 2016/12/14.
//  Copyright © 2016年 ximi. All rights reserved.
//
#import "TDFHealthCheckItemBodyModel.h"
#import "TDFHealthCheckMenuCodeCell.h"
#import "TDFHealthCheckSchemeCell.h"
#import "TDFHealthCheckVideoCell.h"
#import "TDFHealthTitleView.h"
#import "YYModel/YYModel.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "ObjectUtil.h"
@interface TDFHealthCheckSchemeCell()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) TDFHealthTitleView *titleView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSArray *videos;
@property (nonatomic, strong) NSArray *menus;

@end
@implementation TDFHealthCheckSchemeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self configViews];
    }
    return self;
}

-(void)configViews{
    self.titleView = ({
        TDFHealthTitleView *view = [TDFHealthTitleView new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(10);
        }];
        view;
    });
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = ({
        UICollectionView *view = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleView.mas_bottom).offset(5);
            make.right.equalTo(self.contentView).offset(-15);
            make.left.equalTo(self.contentView).offset(15);
            make.height.mas_offset(@0);
        }];
        view.scrollEnabled = NO;
        view.backgroundColor = [UIColor clearColor];
        [view registerClass:[TDFHealthCheckMenuCodeCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"TDFHealthCheckMenuCodeCellIdentifier"]];
        [view registerClass:[TDFHealthCheckVideoCell class] forCellWithReuseIdentifier:@"TDFHealthCheckVideoCellIdentifier"];
        view.delegate = self;
        view.dataSource = self;
        view;
    });

}

#pragma mark collectionView delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.datas.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *data = self.datas[section];
    return data.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (indexPath.section) {
         cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"TDFHealthCheckVideoCellIdentifier"] forIndexPath:indexPath];
    }else{
     cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"TDFHealthCheckMenuCodeCellIdentifier"] forIndexPath:indexPath];
    }
    if ([cell respondsToSelector:@selector(cellLoadData:)]) {
        [cell performSelector:@selector(cellLoadData:) withObject:self.datas[indexPath.section][indexPath.row]];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(didSelectCellWithData:)]){
        [self.delegate didSelectCellWithData:self.datas[indexPath.section][indexPath.row]];
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat interval = (SCREEN_WIDTH - 30 - 20 - 60 * 4) / 3;
    
    return interval - 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.section?CGSizeMake(0.95 * [UIScreen mainScreen].bounds.size.width, 28):CGSizeMake(60, 60+30);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        NSArray *data = self.datas[section];
        CGFloat collectionWidth = SCREEN_WIDTH - 50;
        CGFloat interval = (collectionWidth - 60 * 4) / 3;

        if (data.count == 1) {
            CGFloat leading = (collectionWidth - 60) / 2;
            return UIEdgeInsetsMake(0, leading, 0, leading);
        }
        
        if (data.count == 2) {
            CGFloat leading = (collectionWidth - 60 * 2 - interval) / 2;
            return UIEdgeInsetsMake(0, leading, 0, leading);
        }
        
        if (data.count == 3) {
            CGFloat leading = (collectionWidth- 60 * 3 - interval * 2) / 2;
            return UIEdgeInsetsMake(0, leading, 0, leading);
        }
        
        if (data.count > 3) {
            CGFloat leading = (collectionWidth- 60 * 4 - interval * 3) / 2;
            return UIEdgeInsetsMake(0, leading, 0, leading);
        }
    }
    
    return UIEdgeInsetsMake(0,0,10,0);
}
#pragma mark public
-(void)cellLoadData:(TDFHealthCheckItemBodyModel *)data{
    [self.titleView initTitle:data.title detail:data.desc];
    if ([ObjectUtil isEmpty:data.details]) {
        return;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[[data.details lastObject] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:NULL];
    self.menus = [NSArray yy_modelArrayWithClass:[TDFHealthCheckBtnModel class] json:  dict[@"buttons"]];
    self.videos = [NSArray yy_modelArrayWithClass:[TDFHealthCheckVideoModel class] json:  dict[@"videos"]] ;
    self.datas  = @[self.menus,self.videos];
    CGFloat width = 60;
    NSInteger index = self.menus.count%4 ? (self.menus.count/4 + 1):self.menus.count/4;
    CGFloat height = (index *(width+30)+(index-1)*10)+self.videos.count*28 ;
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(height);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });    
}
+(CGFloat)heightForCellAtIndexPath:(UITableView *)tableView model:(id)data {
    static UITableViewCell *cell = nil;
    NSString *cellIdentifier = [NSString stringWithUTF8String:object_getClassName([TDFHealthCheckSchemeCell class])];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[TDFHealthCheckSchemeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }) ;
    [(TDFHealthCheckSchemeCell *)cell cellLoadData:data];
    return [(TDFHealthCheckSchemeCell *)cell calculateHeightForCell];
}

#pragma mark private
- (CGFloat)calculateHeightForCell {
    [self layoutIfNeeded];
    CGFloat height = self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 10;
    return height;
}

#pragma mark getter

-(NSArray *)datas{
    if (!_datas) {
        _datas = [[NSArray alloc]init];
    }
    return _datas;
}

-(NSArray *)menus{
  
    if (!_menus) {
        _menus = [[NSArray alloc]init];
    }
    return _menus;
}

-(NSArray *)videos{
    if (!_videos) {
        _videos = [[NSArray alloc]init];
    }
    return _videos;
}
@end
