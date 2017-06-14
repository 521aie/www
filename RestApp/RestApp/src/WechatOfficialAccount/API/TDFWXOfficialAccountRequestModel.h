//
//  TDFWXOfficialAccountRequestModel.h
//  RestApp
//
//  Created by tripleCC on 2017/5/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFNetworking/TDFRequestModel.h>

@interface TDFWXOfficialAccountRequestModel : TDFRequestModel
+ (instancetype)modelWithActionPath:(NSString *)actionPath;
@end
