//
//  ImageBox.h
//  CardApp
//
//  Created by 邵建青 on 13-12-19.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppController.h"
#import "DACircularProgressView.h"

@interface BigImageBox : UIViewController
{
    DACircularProgressView *progressView;
    
    CGFloat screenHeight;
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

+ (void)initImageBox:(UIViewController *)appController;

+ (void)show:(NSString *)server path:(NSString *)path;

+ (void)hide;

- (IBAction)hideBtnClick:(id)sender;

@end
