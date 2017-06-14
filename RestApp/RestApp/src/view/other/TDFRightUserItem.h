//
//  TDFRightUserItem.h
//  RestApp
//
//  Created by Cloud on 2017/4/21.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "DHTTableViewItem.h"

@interface TDFRightUserItem : DHTTableViewItem

@property (nonatomic ,copy) NSString *icoUrl;

@property (nonatomic ,copy) NSString *userName;

@property (nonatomic ,copy) NSString *userCompany;

@property (nonatomic, strong) void (^changeEnv)();

@end
