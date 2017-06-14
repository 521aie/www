//
//  FeedBackView.h
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-25.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import "UIHelper.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "RemoteResult.h"
#import "SystemService.h"
#import "SystemService.h"
#import "MBProgressHUD.h"
#import "INavigateEvent.h"
#import "INavigateEvent.h"
#import "EditItemTextView.h"
#import "PopupBoxViewController.h"

@class NavigateTitle2;
@interface FeedBackView : PopupBoxViewController<INavigateEvent>
{
    SystemService *systemService;
}

@property (nonatomic, strong) IBOutlet UIView *emailBackground;
@property (nonatomic, strong) IBOutlet EditItemTextView *emailTxt;
@property (nonatomic, strong) IBOutlet EditItemTextView *suggestionTxt;

@end
