//
//  TDFPantryRequestModel.h
//  RestApp
//
//  Created by 刘红琳 on 2017/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFNetworking/TDFNetworking.h>
#import "TDFRequestModel.h"

@interface TDFPantryRequestModel : TDFRequestModel

+ (instancetype)modelWithActionPath:(NSString *)actionPath;

@end
