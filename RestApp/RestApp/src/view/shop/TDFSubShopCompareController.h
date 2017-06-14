//
//  TDFSubShopCompareController.h
//  RestApp
//
//  Created by Cloud on 2017/3/29.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"
//#import "TDFShopFilterViewController.h"

@interface TDFSubShopCompareController : TDFRootViewController



//20160401
@property (nonatomic ,copy) NSString *dateStr;

//day month
@property (nonatomic ,copy) NSString *typeStr;





//日或者月，0日 1月
@property (nonatomic ,assign) NSInteger type;

@property (nonatomic ,strong) NSDate *date;

//2016年04月01日
@property (nonatomic ,copy) NSString *dateTitleStr;

@end
