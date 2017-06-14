//
//  TDFWebView.h
//  RestApp
//
//  Created by Octree on 20/4/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <WebKit/WebKit.h>

/**
 *  WebView
 */
@interface TDFWebView : WKWebView

- (instancetype)initWithFrame:(CGRect)frame;

@end


@interface TDFProcessPoolMgr : NSObject

@property (strong, nonatomic, readonly) WKProcessPool *sharedProcessPool;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)sharedIntance;
- (WKProcessPool *)processPoolWithIdentifier:(NSString *)identifier;

@end
