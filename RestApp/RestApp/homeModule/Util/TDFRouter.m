//
//  TDFRouter.m
//  RestApp
//
//  Created by happyo on 2017/4/19.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRouter.h"
#import "TDFBusinessFlowViewController.h"
#import "TDFMediator.h"
#import "TDFMediator+ReportWeb.h"

// 掌柜跳转scheme
static NSString *kTDFBossAppScheme = @"tdf-manager";

@implementation TDFRouter

+ (instancetype)sharedInstance
{
    static TDFRouter *router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[TDFRouter alloc] init];
    });
    return router;
}

- (id)routerWithUrlString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    if ([url.scheme isEqualToString:kTDFBossAppScheme]) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        NSString *urlQuery = [url query];
        
        for (NSString *param in [urlQuery componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if ([elts count] < 2) continue;
            params[elts.firstObject] = elts.lastObject;
        }
        
        if (url.pathComponents.count >= 3) {// 路径包含target和action
            NSString *target = url.pathComponents[1];
            NSString *actionName = url.pathComponents[2];
            
            id result = [[TDFMediator sharedInstance] performTarget:target
                                                             action:actionName
                                                             params:params];
            
            return result;
        }
    } else if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        return [[TDFMediator sharedInstance] TDFMediator_reportWebViewControllerWithURL:urlString];
    } else {
        return @(NO);
    }
    
    return @(NO);
}



@end
