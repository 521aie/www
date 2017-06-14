//
//  BusinessDetailPanel.h
//  RestApp
//
//  Created by zxh on 14-8-13.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "CMButton.h"
#import <UIKit/UIKit.h>

@class BusinessSummaryVO, HomeView ,ChainBusinessStatisticsDay;
@interface BusinessDetailPanel: UIViewController<CMButtonClient>
{
    HomeView *homeView;
}
@property (nonatomic, strong) IBOutlet UIView *background;
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

@property (nonatomic, strong) CMButton *detailBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil homeView:(HomeView *)homeViewTemp;

//控件初始化.
- (void)clearData:(NSString*)dayName;

//数据加载.
- (void)loadData:(NSString*)dayName summary:(BusinessSummaryVO*)summary date:(NSString*)date;

- (void)loadChainData:(NSString*)dayName summary:(ChainBusinessStatisticsDay*)summary date:(NSString*)date;

@end


