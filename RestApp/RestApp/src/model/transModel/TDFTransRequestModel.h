//
//  TDFTransRequestModel.h
//  RestApp
//
//  Created by 刘红琳 on 2017/5/26.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFNetworking/TDFNetworking.h>
#import "TDFRequestModel.h"

@interface TDFTransRequestModel : TDFRequestModel
+ (instancetype)modelWithActionPath:(NSString *)actionPath;

@end
