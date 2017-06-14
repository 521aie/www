//
//  AboutView.h
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-25.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "PopupBoxViewController.h"

@class NavigateTitle2;
@interface AboutView : PopupBoxViewController<INavigateEvent>

@property (nonatomic, strong) IBOutlet UILabel *lblVer;   //版本.


@end
