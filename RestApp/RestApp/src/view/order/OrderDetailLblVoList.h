//
//  labelVoList.h
//  RestApp
//
//  Created by iOS香肠 on 16/4/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface OrderDetailLblVoList : Jastor

@property (nonatomic ,assign)NSInteger isSelected;

@property (nonatomic ,assign)NSInteger labelId;

@property (nonatomic ,strong)NSString *labelName;

@property (nonatomic ,strong)NSString *picUrl;
@end