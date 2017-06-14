//
//  TDFRouter.h
//  RestApp
//
//  Created by happyo on 2017/4/19.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFRouter : NSObject

+ (instancetype)sharedInstance;

- (id)routerWithUrlString:(NSString *)urlString;

@end
