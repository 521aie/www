//
//  OrderDetailAcridView.h
//  RestApp
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface OrderDetailAcridView : Jastor

@property (nonatomic ,assign)NSInteger acridLevel;
@property (nonatomic ,strong)NSString *acridLevelString;
@property (nonatomic ,assign)NSInteger isSelected;
@property (nonatomic ,strong)NSString *picUrl;
@end
