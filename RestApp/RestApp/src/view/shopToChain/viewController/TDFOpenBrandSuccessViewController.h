//
//  TDFOpenBrandSuccessViewController.h
//  RestApp
//
//  Created by 刘红琳 on 2017/3/2.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"
#import "TDFShopUpgradeBrandModel.h"

#define FROMINVITESHOPTOJOINCHAIN   @"FROMINVITESHOPTOJOINCHAIN"
@interface TDFOpenBrandSuccessViewController : TDFRootViewController
@property(nonatomic, strong) NSString *event;
@property(nonatomic, strong) TDFShopUpgradeBrandModel*model;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *shopName;
@end
