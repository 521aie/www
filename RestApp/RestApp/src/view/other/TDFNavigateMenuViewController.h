//
//  TDFNavigateMenuViewController.h
//  RestApp
//
//  Created by 黄河 on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFRootViewController.h"
@interface TDFNavigateMenuViewController : UIViewController

// 因为系统的viewWillAppear不会调，所以只能手动调用
- (void)viewWillAppearByHand;

@end
