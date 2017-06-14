//
//  TDFOrderRdDetailViewController.h
//  RestApp
//
//  Created by iOS香肠 on 16/9/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//


#import "TDFBaseViewController.h"
#import "TDFRootViewController.h"
#import "NavigationToJump.h"
@class  SmartOrderModel;
typedef NS_ENUM(NSInteger, TDFOrderRecomendType)
{
    TDFOrderMainCategoriesType = 0 , //主料大类提醒与推荐
    TDFOrderSpecificMainType , //具体主料提醒与推荐
};

@interface TDFOrderRdDetailViewController : TDFRootViewController 
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) id <NavigationToJump>delegate;
- (id)initWithparent:(SmartOrderModel*)parentm;
- (void)getHttpData:(NSString *)plantId WithTitle:(NSString *)title;

@end
