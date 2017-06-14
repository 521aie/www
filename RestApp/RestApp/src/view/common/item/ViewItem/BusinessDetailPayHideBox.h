//
//  BusinessDetailPayHideBox.h
//  RestApp
//
//  Created by zxh on 14-11-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessDayVO.h"
#import "KindPayDayStatMainVO.h"

@interface BusinessDetailPayHideBox : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblTotalAmout;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageView;
@property (nonatomic, strong) IBOutlet UIImageView *imgType;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UIView* totalView;
@property (nonatomic, strong) IBOutlet UILabel *lblSourceAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblDiscountAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblProfitAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblBillNum;
@property (nonatomic, strong) IBOutlet UILabel *lblPeopleAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblAvgAmout;

@property (nonatomic, strong)  KindPayDayStatMainVO* payMain;
@property (nonatomic, strong) NSMutableArray* subViews;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) BOOL pageControlUsed;

//控件初始化.
- (void)clearData:(NSString *)dayName;
//数据加载.
- (void)loadData:(NSString *)dayName summary:(BusinessDayVO *)summary dayPay:(KindPayDayStatMainVO *)payTemps date:(NSString *)date;

- (IBAction)pageChange:(id)sender;

@end
