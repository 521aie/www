//
//  AboutView.m
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-25.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "SystemUtil.h"
#import "AboutView.h"

@implementation AboutView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关于";
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:@"关闭"];
    self.lblVer.text=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
