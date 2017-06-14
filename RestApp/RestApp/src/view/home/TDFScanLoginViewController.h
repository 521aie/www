//
//  TDFScanLoginViewController.h
//  RestApp
//
//  Created by doubanjiang on 16/8/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"

@interface TDFScanLoginViewController : TDFRootViewController

//登录类型
@property (nonatomic, copy) NSString *type;

//二维码
@property (nonatomic, copy) NSString *code;

@end
