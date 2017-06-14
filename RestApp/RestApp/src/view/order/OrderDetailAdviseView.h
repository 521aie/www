//
//  OrderDetailAdviseView.h
//  RestApp
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface OrderDetailAdviseView : Jastor
@property (nonatomic ,assign)NSInteger isSelected;
@property (nonatomic ,strong)NSString *picUrl;
@property (nonatomic ,assign)NSInteger recommendLevel;
@property (nonatomic ,strong)NSString *recommendLevelString;
@end
