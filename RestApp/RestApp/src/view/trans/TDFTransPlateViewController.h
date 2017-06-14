//
//  TDFTransPlateViewController.h
//  RestApp
//
//  Created by 刘红琳 on 2017/5/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFCore/TDFCore.h>
typedef NS_ENUM(NSInteger,TDFTransType) {
    TDFTransMenu = 1,//传菜方案
    TDFITransNoListMenu = 2,//不出单商品
    TDFSuitKindMenuPrint = 3,//套餐中商品分类打印
};

@interface TDFTransPlateViewController : TDFRootViewController
@property (nonatomic, assign)TDFTransType transType;
@property (nonatomic ,strong) NSString *actionCode;

@end
