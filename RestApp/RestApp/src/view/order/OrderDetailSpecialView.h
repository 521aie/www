//
//  OrderDetailSpecialView.h
//  RestApp
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface OrderDetailSpecialView : Jastor
@property (nonatomic ,assign)NSInteger isSelected;
@property (nonatomic ,strong)NSString *picUrl;
@property (nonatomic ,strong)NSString *specialTagString;
@property (nonatomic ,strong)NSString *specialTagId;
@property (nonatomic ,assign)NSInteger tagSource;
@end
