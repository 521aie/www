//
//  BusinessPayDetailBox.h
//  RestApp
//
//  Created by zxh on 14-11-6.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KindPayDayVO,BusinessDayVO;
@interface BusinessPayDetailBox : UIView

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (nonatomic, strong) IBOutlet UIView *numContainer;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblTotalAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblSourceAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblDiscountAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblProfitAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblBillNum;
@property (nonatomic, strong) IBOutlet UILabel *lblPeopleAmout;
@property (nonatomic, strong) IBOutlet UILabel *lblAvgAmout;
@property (nonatomic, strong) IBOutlet UIImageView *imgType;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UIView* kindPayBox;

//控件初始化.
- (void)clearData:(NSString*)dayName;

//数据加载.
- (void)loadData:(NSString*)dayName summary:(BusinessDayVO*)summary pays:(NSMutableArray*)pays date:(NSString*)date;

@end
