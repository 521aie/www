//
//  OrderDetailLblMaterialVoList.h
//  RestApp
//
//  Created by iOS香肠 on 16/4/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface OrderDetailLblMaterialVoList : Jastor

@property (nonatomic, assign)NSInteger  labelMaterialId;

@property (nonatomic ,strong)NSString *labelMaterialName;

@property (nonatomic ,strong)NSArray *mainMaterialList;
@end
