//
//  TagLibraryRNModel.h
//  RestApp
//
//  Created by 忘忧 on 16/9/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"

typedef void (^ChangeBlock)(BOOL isChange);

@interface TagLibraryRNModel : TDFRootViewController

@property (nonatomic, copy) ChangeBlock callBack;

@end
