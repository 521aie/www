//
//  TDFSelectGoodsWithPlateViewController.h
//  RestApp
//
//  Created by 刘红琳 on 2017/5/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFCore/TDFCore.h>
#import "TDFShopSynchGroupModel.h"

@interface TDFSelectGoodsWithPlateViewController : TDFRootViewController

@property (copy,nonatomic) NSMutableArray *oldArr;
@property (copy,nonatomic) NSString *plateEntityId;
@property (assign,nonatomic) BOOL removeChain;

@property (nonatomic,copy) void(^rightActionCallBack)(NSArray<TDFShopSynchModuleModel *> *models);
@end
