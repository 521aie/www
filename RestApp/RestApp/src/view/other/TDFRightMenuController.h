//
//  TDFRightMenuController.h
//  RestApp
//
//  Created by doubanjiang on 2017/4/20.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"

@interface TDFRightMenuController : TDFRootViewController


/// old funcs

- (void)refreshSysStatus:(NSUInteger)sysNoteCount;
+ (TDFRightMenuController *)sharedInstance;
- (void)resetShopInfo;
- (void)resetDataView;

@end
