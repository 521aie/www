//
//  orderSaveData.h
//  RestApp
//
//  Created by apple on 16/5/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"
@interface orderSaveData : Jastor

@property (nonatomic ,strong)NSString *labelId;
@property (nonatomic ,strong)NSString *maxNumber;
@property (nonatomic ,strong)NSString *maxSwitch;
@property (nonatomic ,strong)NSString  *minNumber;
@property (nonatomic ,strong)NSString *minSwitch;


@end
