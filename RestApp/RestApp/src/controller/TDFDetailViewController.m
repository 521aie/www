//
//  TDFDetailViewController.m
//  RestApp
//
//  Created by Octree on 6/9/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFDetailViewController.h"
#import <Masonry/Masonry.h>

@interface TDFDetailViewController ()

@property (copy, nonatomic) NSString *content;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation TDFDetailViewController

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content {

    if (self = [super init]) {
    
        self.title = NSLocalizedString(@"详情", nil);
        self.content = content;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configViews];
    
    UIImage *cancelImage = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_back.png"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(.0, .0, 60, 40)];
    [cancelButton setTitle:NSLocalizedString(@"返回", nil) forState: UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton setImage:cancelImage forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 4);
    cancelButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
}

- (void)configViews {

    [self.view addSubview:self.contentLabel];
    __weak __typeof(self) wslef = self;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(wslef.view.mas_top).with.offset(10);
        make.left.equalTo(wslef.view.mas_left).with.offset(10);
        make.right.equalTo(wslef.view.mas_right).with.offset(-10);
    }];
}

- (void)dismiss {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UILabel *)contentLabel {

    if (!_contentLabel) {
    
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.text = self.content;
    }
    
    return _contentLabel;
}

@end
