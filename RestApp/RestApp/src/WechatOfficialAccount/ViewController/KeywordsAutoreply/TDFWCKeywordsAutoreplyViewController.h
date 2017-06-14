//
//  TDFWCKeywordsAutoreplyViewController.h
//  RestApp
//
//  Created by tripleCC on 2017/5/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFCore/TDFCore.h>

@class TDFOfficialAccountModel;
@interface TDFWCKeywordsAutoreplyViewController : TDFRootViewController
- (instancetype)initWithAuthorised:(BOOL)authorised wxAppId:(NSString *)wxAppId;
@end
