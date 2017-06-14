//
//  FuctionActionData.h
//  RestApp
//
//  Created by iOS香肠 on 15/12/25.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface FuctionActionData : Jastor
@property (nonatomic ,strong)NSString *code;
@property (nonatomic ,strong)NSString *id;
@property (nonatomic ,assign)int isHide;
@property (nonatomic ,assign)int isUserHide;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,assign)int status;
@end
