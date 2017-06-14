//
//  RNRootURL.m
//  RestApp
//
//  Created by QiYa on 2016/9/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "RNRootURL.h"

#import "RCTBundleURLProvider.h"
#import "RCTLinkingManager.h"
#import "CodePush.h"
@interface RNRootURL ()

@end

@implementation RNRootURL
@synthesize indexUrl = _indexUrl;
@synthesize majorMaterialUrl = _majorMaterialUrl;
+ (instancetype)shareInstance
{
    static RNRootURL *root;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        root = [[RNRootURL alloc] init];
    });
    return root;
}

- (NSURL *)indexUrl {
    if (!_indexUrl) {
        
#ifdef DEBUG
//        _indexUrl = [CodePush bundleURL];
        _indexUrl = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
#else
//        _indexUrl = [CodePush bundleURL];暂停使用热更新
        _indexUrl = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
#endif
    }
    
    return _indexUrl;
}

- (NSURL *)majorMaterialUrl {
    if (!_majorMaterialUrl) {
#ifdef DEBUG
        _majorMaterialUrl = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"rjs/components/SelectMajorMaterial" fallbackResource:nil];
#else
//        _majorMaterialUrl = [CodePush bundleURL];
        _majorMaterialUrl = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"rjs/components/SelectMajorMaterial" fallbackResource:nil];
#endif
    }
    
    return _majorMaterialUrl;
}

@end
