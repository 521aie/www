//
//  Target_LoanModule.h
//  RestApp
//
//  Created by zishu on 16/8/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_LoanModule : NSObject

//我要贷款主界面：zishu
- (UIViewController *)Action_nativeLoanListViewController:(NSDictionary *)params;

//我要贷款H5界面:zishu
- (UIViewController *)Action_nativeLoanWebViewController:(NSDictionary *)params;

//我要贷款协议界面:zishu
- (UIViewController *)Action_nativeLoanNoteViewController:(NSDictionary *)params;
@end
