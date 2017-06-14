//
//  ImageBox.m
//  CardApp
//
//  Created by 邵建青 on 13-12-19.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import "BigImageBox.h"
#import "SystemUtil.h"
#import "ImageUtils.h"
#import "AppController.h"
#import "SDWebImageManager.h"
#import "DACircularProgressView.h"

static BigImageBox *imageBox;

@implementation BigImageBox

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        screenHeight = [UIScreen mainScreen].applicationFrame.size.height;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    progressView = [[DACircularProgressView alloc]initWithFrame:CGRectMake(140.0, (screenHeight - 40)/2, 40.0, 40.0)];
    [self.view addSubview:progressView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.view.hidden = YES;
}

+ (void)initImageBox:(UIViewController *)appController
{
    imageBox = (BigImageBox *)[appController.view viewWithTag:TAG_BIGIMAGEBOX];
    if (imageBox == nil) {
        imageBox = [[BigImageBox alloc]initWithNibName:@"BigImageBox"bundle:nil];
        imageBox.view.tag = TAG_BIGIMAGEBOX;
        [appController.view addSubview:imageBox.view];
    }
}

+ (void)show:(NSString *)server path:(NSString *)path
{
    [imageBox loadImageData:server path:path];
}

- (void)loadImageData:(NSString *)server path:(NSString *)path
{
    self.view.hidden = NO;
    progressView.hidden = NO;
    progressView.progress = 0.0;
    self.imageView.hidden = YES;
    NSString *imageUrl = [ImageUtils getImageUrl:server path:path];
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    [manager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        float totalSize = receivedSize + expectedSize;
        float currentSize = receivedSize;
        progressView.progress = (currentSize/totalSize);
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        progressView.hidden = YES;
        self.imageView.hidden = NO;
        [self renderImageView:image];
    }];
}
- (void)renderImageView:(UIImage *)image
{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    CGFloat imageHeight = 320*height/width;
    CGFloat imageY = imageHeight>screenHeight?0:(screenHeight-imageHeight)/2;
    
    [self.imageView setFrame:CGRectMake(0, imageY, 320, imageHeight)];
    [self.imageView setImage:image];
}

+ (void)hide
{
    imageBox.view.hidden = YES;
}

- (IBAction)hideBtnClick:(id)sender
{
    self.view.hidden = YES;
}

@end
