//
//  TimePickerBox.m
//  RestApp
//
//  Created by zxh on 14-4-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ImageBox.h"
#import "SystemUtil.h"
#import "AppController.h"

static ImageBox *imageBox;

@implementation ImageBox

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.hidden = YES;
}

+ (void)initImageBox:(UIViewController *)appController
{
    imageBox = (ImageBox *)[appController.view viewWithTag:TAG_IMAGEBOX];
    if(!imageBox) {
        imageBox = [[ImageBox alloc]initWithNibName:@"ImageBox"bundle:nil];
        imageBox.view.tag = TAG_IMAGEBOX;
        [appController.view addSubview:imageBox.view];
    }
}

+ (void)show:(UIImage *)image
{
    imageBox.imageView.image = image;
    [imageBox showMoveIn];
}

+ (void)hide
{
    [imageBox hideMoveOut];
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self hideMoveOut];
}


@end
