//
//  TDFWXKeywordsRuleSettingViewController.h
//  RestApp
//
//  Created by tripleCC on 2017/5/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFCore/TDFCore.h>

@class TDFWXKeywordsRuleModel;
@interface TDFWXKeywordsRuleSettingViewController : TDFRootViewController

- (instancetype)initWithModifiedHandler:(dispatch_block_t)modifiedHandler wxAppId:(NSString *)wxAppId;
- (instancetype)initWithRule:(TDFWXKeywordsRuleModel *)rule modifiedHandler:(dispatch_block_t)modifiedHandler wxAppId:(NSString *)wxAppId;

@end
