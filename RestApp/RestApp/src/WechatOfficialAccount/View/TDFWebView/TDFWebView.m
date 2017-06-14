//
//  TDFWebView.m
//  TDFWebViewBridge
//
//  Created by Octree on 15/2/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "TDFWebView.h"

@interface TDFWebView ()

@end

@implementation TDFWebView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userController;
    configuration.allowsInlineMediaPlayback = YES;
    configuration.processPool = [TDFProcessPoolMgr sharedIntance].sharedProcessPool;
    
    if (self = [super initWithFrame:frame configuration:configuration]) {
        
    }
    
    return self;
}

@end

@interface TDFProcessPoolMgr ()

@property (strong, nonatomic) NSMutableDictionary *processPoolDict;

@end

@implementation TDFProcessPoolMgr

+ (instancetype)sharedIntance {
    
    static TDFProcessPoolMgr *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TDFProcessPoolMgr alloc] initPrivacy];
    });
    return manager;
}

- (instancetype)initPrivacy {
    
    if (self = [super init]) {
        
        _sharedProcessPool = [[WKProcessPool alloc] init];
    }
    return self;
}

- (WKProcessPool *)processPoolWithIdentifier:(NSString *)identifier {
    
    NSAssert(identifier != nil, @"identifier can not be nil");
    WKProcessPool *processPool = self.processPoolDict[identifier];
    if (!processPool) {
        
        processPool = [[WKProcessPool alloc] init];
        self.processPoolDict[identifier] = processPool;
    }
    
    return processPool;
}

#pragma mark - Accessor


- (NSMutableDictionary *)processPoolDict {
    
    if (!_processPoolDict) {
        
        _processPoolDict = [NSMutableDictionary dictionary];
    }
    
    return _processPoolDict;
}


@end
