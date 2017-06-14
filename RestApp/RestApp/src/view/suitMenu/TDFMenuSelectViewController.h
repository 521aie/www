//
//  TDFMenuSelectViewController.h
//  RestApp
//
//  Created by xueyu on 16/9/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"
typedef void (^ Callback)(id obj);
@interface TDFMenuSelectViewController : TDFRootViewController
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy) Callback callback;
@end
