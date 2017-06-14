//
//  TDFMapViewController.h
//  RestApp
//
//  Created by iOS香肠 on 2017/3/23.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"
#import "TDFTakeOutSettings.h"
typedef  void(^fileBlock)(id  data);
@interface TDFMapViewController : TDFRootViewController
- (void)configIteam:(TDFTakeOutSettings *)vo;
@property (nonatomic  ,strong) fileBlock  fileBlock;
@end
