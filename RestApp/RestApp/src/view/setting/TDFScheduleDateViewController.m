//
//  TDFScheduleDateViewController.m
//  RestApp
//
//  Created by xueyu on 2016/11/7.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//
#import <Masonry/Masonry.h>
#import "ObjectUtil.h"
#import "TDFScheduleDayCell.h"
#import "TDFScheduleDateViewController.h"
#import "TDFRootViewController+FooterButton.h"
static NSString *cellId = @"DayCellIdentifier";
@interface TDFScheduleDateViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation TDFScheduleDateViewController

#pragma mark life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
}



-(void)configViews{
    
    self.title = NSLocalizedString(@"选择特定日期", nil);
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(35, 35);
    layout.sectionInset = UIEdgeInsetsMake(10,10, 10, 10);
    layout.minimumInteritemSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    UIView *view = ({
        UIView *view = [UIView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        view;
    });

    
    
    self.collectionView = ({
        UICollectionView *view =  [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [view registerClass:[TDFScheduleDayCell class] forCellWithReuseIdentifier:cellId];
        view.backgroundColor = [UIColor clearColor];
        view.dataSource = self;
        view.delegate = self;
        view;
    });
    
#pragma clang diagnostic pop
    
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAllCheck|TDFFooterButtonTypeNotAllCheck];
    
 }



#pragma mark UICollectionviewDelegate/datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TDFScheduleDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [cell initData:self.datas[indexPath.row] datas:self.selectDatas];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    id item = self.datas[indexPath.row];
    if ([self.selectDatas containsObject:item]) {
        [self.selectDatas removeObject:item];
    }else{
        [self.selectDatas addObject:item];
    }
    [collectionView reloadData];
}

#pragma mark nav button 

- (void)rightNavigationButtonAction:(id)sender
{
    [super rightNavigationButtonAction:sender];
    [self save];
}

-(void)save{
    
  
    !self.completionBlock ?:self.completionBlock(self.selectDatas);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark footer button
-(void)footerAllCheckButtonAction:(UIButton *)sender{
    [self.selectDatas removeAllObjects];
    [self.selectDatas addObjectsFromArray:self.datas];
    [self.collectionView reloadData];
}
- (void)footerNotAllCheckButtonAction:(UIButton *)sender{
    [self.selectDatas removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark getter
-(NSMutableArray *)datas{
    if (!_datas) {
        _datas = ({
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:31];
            for (int i = 0; i < 31; i++) {
                [array addObject:@(i+1).stringValue];
            }
            array;
        });
    }
    return _datas;
}

-(NSMutableArray *)selectDatas{
    if (!_selectDatas) {
        _selectDatas = [NSMutableArray new];
    }
    return _selectDatas;
}

@end
