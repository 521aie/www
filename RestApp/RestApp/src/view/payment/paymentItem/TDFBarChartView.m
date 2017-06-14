//
//  TDFBarChartView.m
//  RestApp
//
//  Created by guopin on 16/6/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "NSString+Estimate.h"
#import "TDFBarChartVo.h"
#import "TDFBarChartView.h"
#import "TDFChartItemValue.h"
#import "TDFBarChartFlowLayout.h"
#import "TDFBarChartCollectionCell.h"
@interface TDFBarChartView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, assign) CGSize kItemSize;
@property (nonatomic, assign) CGFloat kitemSpace;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) TDFBarChartVo *selectVo;
@end
@implementation TDFBarChartView
- (instancetype)initWithFrame:(CGRect)frame itemSize:(CGSize)itemSize itemSpace:(CGFloat)itemSpace delegate:(id<TDFBarChartViewEvent>)deleagte
{
    self = [super initWithFrame:frame];
    if (self) {
        self.kItemSize = itemSize;
        self.kitemSpace = itemSpace;
        TDFBarChartFlowLayout *layout = [[TDFBarChartFlowLayout alloc]initWithItemSize:itemSize itemSpace:itemSpace];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height*5/6) collectionViewLayout:layout];
        [self initView:frame];
        
        self.dataDic = [[NSMutableDictionary alloc]init];
        self.delegate = deleagte;
    }
    return self;
}
#pragma mark 初始化UI
-(void)initView:(CGRect)frame{
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.allowsSelection = NO;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[TDFBarChartCollectionCell class] forCellWithReuseIdentifier:@"TDFBarCollectionCellID"];
    UILabel *mark = [[UILabel alloc]initWithFrame:CGRectMake(0,frame.size.height*4/5,frame.size.width, 12)];
    mark.font = [UIFont systemFontOfSize:14];
    mark.textColor = [UIColor redColor];
    mark.textAlignment = NSTextAlignmentCenter;
    mark.text = NSLocalizedString(@"▴", nil);
    [self addSubview:mark];
    self.tip = [[UILabel alloc]initWithFrame:CGRectMake(0,frame.size.height*4/5 + 12,frame.size.width, 15)];
    self.tip.font = [UIFont systemFontOfSize:12];
    self.tip.textAlignment = NSTextAlignmentCenter;
    self.tip.textColor = [UIColor whiteColor];
    [self addSubview:self.tip];
}


#pragma mark
-(void)loadData:(NSMutableDictionary *)dict{
    [self.dataDic removeAllObjects];
 
    self.dataDic = dict;

//    TDFBarChartVo *chartVo = [TDFBarChartVo new];
//    for (NSString *key in dict.allKeys) {
//        id<TDFChartItemValue>item = dict[key];
//        chartVo.value = [item itemValue];
//        chartVo.key = key;
//        chartVo.isSelected = NO;
//        [self.dataDic setObject:chartVo forKey:[item itemKey]];
//    }
//    
//    for (TDFBarChartVo *vo in self.dataDic.allValues ) {
//        
//        NSLog(@"%@---%.2f---%@",vo.key,vo.value,vo.isSelected?@"YES":@"NO");
//    }
}
-(void)initChartView:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    self.currentYear = year;
    self.currentMonth = month;
    self.currentDay = day;
    self.page =  self.dateFomatter == MonthToDay?(day -1):(month -1);
    
    if (self.dateFomatter ==MonthToDay || self.dateFomatter == MonthToDaySample) {
        self.page = day-1;
        self.week = [self getWeeKName:[self convertWeek]];
    }
      else{
        self.page = month -1;
    }
    
    NSString *key = [self keyFomatter:self.page + 1];
    TDFBarChartVo *barVo;
    if ([self.dataDic.allKeys containsObject:key]) {
        barVo = self.dataDic[key];
        barVo.isSelected = YES;
    }else{
        barVo = [TDFBarChartVo new];
        barVo.value = 0;
        barVo.isSelected = YES;
        barVo.key = key;
        [self.dataDic setObject:barVo forKey:key];
    }
    self.selectVo = barVo;
    self.collectionView.contentOffset = CGPointMake((self.kItemSize.width + self.kitemSpace) *self.page  - (self.collectionView.bounds.size.width/2 -self.kItemSize.width/2),0);
    [self.collectionView reloadData];
    [self.delegate barChartViewdidScroll:self chartVo:barVo];
}


#pragma mark collectionView代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return   self.dateFomatter == YearToMonth?12:[self getDaysOfMonth:[self convertDate]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TDFBarChartCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TDFBarCollectionCellID" forIndexPath:indexPath];
    NSString *key = [self keyFomatter:indexPath.row + 1];

    TDFBarChartVo *barVo;
    if ([self.dataDic.allKeys containsObject:key]) {
        barVo = self.dataDic[key];
    }else{
        barVo = [TDFBarChartVo new];
        barVo.value = 0;
        barVo.isSelected = NO;
        barVo.key = key;
        [self.dataDic setObject:barVo forKey:key];
    }
    barVo.maxValue = [self getMax]==0 ?1:[self getMax];
    [cell initDataView:barVo];
    return cell;
}

#pragma mark 滑动事件

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateData];
//    NSLog(@"-------%ld", self.page);

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        [self updateData];
//        NSLog(@"+++++++%ld", self.page);

    }
}

-(void)updateData{

    self.page = (self.collectionView.contentOffset.x + (self.collectionView.bounds.size.width/2 -self.kItemSize.width/2))/(self.kItemSize.width + self.kitemSpace);
    if (self.page < 0) {
        return;
    }
    if (self.dateFomatter == MonthToDay || self.dateFomatter == MonthToDaySample) {
        self.currentDay = self.page + 1;
        self.week = [self getWeeKName:[self convertWeek]];
    }else{
        self.currentMonth = self.page + 1;
    }
    NSString *indexKey = [self keyFomatter:self.page + 1];
    self.selectVo.isSelected = NO;
    TDFBarChartVo *barVo = self.dataDic[indexKey];
    if(!barVo){
        barVo = [TDFBarChartVo new];
        barVo.value = 0;
        barVo.key = indexKey;
        [self.dataDic setObject:barVo forKey:indexKey];
        
    }
    barVo.isSelected = YES;
    self.selectVo = barVo;
    if ([self.delegate respondsToSelector:@selector(barChartViewdidScroll:chartVo:)]) {
        [self.delegate barChartViewdidScroll:self chartVo:barVo];
    }
    [self.collectionView reloadData];

}

#pragma mark 数据处理
- (NSString*) getWeeKName:(NSInteger)week
{
    if (week==1) {
        return NSLocalizedString(@"星期日", nil);
    } else if (week==2) {
        return NSLocalizedString(@"星期一", nil);
    } else if (week==3) {
        return NSLocalizedString(@"星期二", nil);
    } else if (week==4) {
        return NSLocalizedString(@"星期三", nil);
    } else if (week==5) {
        return NSLocalizedString(@"星期四", nil);
    } else if (week==6) {
        return NSLocalizedString(@"星期五", nil);
    } else {
        return NSLocalizedString(@"星期六", nil);
    }
}

- (NSInteger)convertWeek
{
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:[self convertDate]];
    return [comps weekday];
}

- (NSDate*)convertDate
{
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setMonth:self.currentMonth];
    [comps setDay:self.currentDay];
    [comps setYear:self.currentYear];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar dateFromComponents:comps];
}

- (NSInteger)getDaysOfMonth:(NSDate*)date
{
    NSCalendar* calender=[NSCalendar currentCalendar];
    NSRange range=[calender rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

- (double) getMax
{
    return [[self.dataDic.allValues valueForKeyPath:@"@max.value"] doubleValue];
}
-(NSString*)keyFomatter:(NSInteger)index{
   
    NSString *key;
    switch (self.dateFomatter) {
        case MonthToDay:
            key = [NSString stringWithFormat:@"%ld-%02ld-%02ld",self.currentYear,self.currentMonth,index];
            break;
        case YearToMonth:
        key = [NSString stringWithFormat:@"%ld-%02ld",self.currentYear,index];
            break;
       case MonthToDaySample:
            key = [NSString stringWithFormat:@"%ld%02ld%02ld",self.currentYear,self.currentMonth,index];
            break;
    }
    return key;
}
@end
