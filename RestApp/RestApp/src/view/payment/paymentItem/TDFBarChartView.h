//
//  TDFBarChartView.h
//  RestApp
//
//  Created by guopin on 16/6/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  NS_ENUM (NSInteger,DateFormatter){
  
     MonthToDay = 0, //YYYY-MM-dd
     YearToMonth = 1, //YYYY—MM
     MonthToDaySample =2 //YYYYMMdd
};

@class TDFBarChartView,TDFBarChartVo;
@protocol TDFBarChartViewEvent <NSObject>
-(void)barChartViewdidScroll:(TDFBarChartView *)barChartView chartVo:(TDFBarChartVo*)chartVo;
@end
@interface TDFBarChartView : UIView
@property (nonatomic, strong) UILabel *tip;
@property (nonatomic, assign) id<TDFBarChartViewEvent> delegate;
@property (nonatomic, assign) DateFormatter dateFomatter;
@property (nonatomic, assign) NSInteger currentMonth;
@property (nonatomic, assign) NSInteger currentYear;
@property (nonatomic, assign) NSInteger currentDay;
@property (nonatomic, copy) NSString *week;
- (instancetype)initWithFrame:(CGRect)frame itemSize:(CGSize)itemSize itemSpace:(CGFloat)itemSpace  delegate:(id<TDFBarChartViewEvent>)deleagte;
-(void)loadData:(NSDictionary *)dict;
-(void)initChartView:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
@end
 