//
//  TDFSmartOrderModel.h
//  RestApp
//
//  Created by BK_G on 2017/1/12.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFSmartOrderGroupModel.h"

@interface TDFSmartOrderModel : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSMutableArray<TDFSmartOrderGroupModel *> *functionGroupList;


@end
