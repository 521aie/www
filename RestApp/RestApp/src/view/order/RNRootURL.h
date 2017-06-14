//
//  RNRootURL.h
//  RestApp
//
//  Created by QiYa on 2016/9/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RNRootURL : NSObject
+ (instancetype)shareInstance;

@property(nonatomic, copy, readonly)NSURL *indexUrl;
@property(nonatomic, copy, readonly)NSURL *majorMaterialUrl;
@end
