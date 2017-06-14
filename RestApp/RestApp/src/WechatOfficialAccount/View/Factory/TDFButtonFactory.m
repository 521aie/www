//
//  TDFButtonFactory.m
//  RestApp
//
//  Created by Octree on 3/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFButtonFactory.h"
#import "UIColor+Hex.h"

@implementation TDFButtonFactory

- (UIButton *)buttonWithType:(TDFButtonType)type {
    
    switch (type) {
        case TDFButtonTypeSave:
            return [self saveButton];
            
        case TDFButtonTypeDetail:
            return [self detailButton];
            
        case TDFButtonTypeNavigationSave:
            return [self navigationSaveButton];
            
        case TDFButtonTypeNavigationClose:
            return [self navigationCloseButton];
            
        case TDFButtonTypeNavigationCancel:
            return [self navigationCancelButton];
        case TDFButtonTypeBottomAdd:
            return [self bottomAddButton];
    }
}

- (UIButton *)bottomAddButton {

    UIButton *button = [self generateBottonCircleButton];
    [button setTitle:NSLocalizedString(@"添加", nil) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"wxoa_bottom_add"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithHeX:0x07AD1F];
    return button;
}

- (UIButton *)generateBottonCircleButton {

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGFloat totalHeight = 20 + 12 + 5;    //  image  title margin
    button.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - 20), 4, 0.0f, - 20);
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0f, - 20, - (totalHeight - 11), 0.0f);
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 28;
    return button;
}

- (UIButton *)saveButton {

    UIButton *button = [[UIButton alloc] init];
    button  = [[UIButton alloc] init];
    button.backgroundColor = [UIColor colorWithHeX:0xCC0000];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    return button;
}


- (UIButton *)detailButton {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor colorWithHeX:0x0088CC] forState:UIControlStateNormal];
    button.tintColor = [UIColor colorWithHeX:0x0088CC];
    button.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    button.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    button.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [button setImage:[UIImage imageNamed:@"WXOA_disclosure_indicator_blue"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    return button;
}

- (UIButton *)navigationCancelButton {

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 60.0f, 40.0f);
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    UIImage *backIcon = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_back"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    [backButton setImage:backIcon forState:UIControlStateNormal];
    [backButton setTitle:NSLocalizedString(@"返回", nil) forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return backButton;
}

- (UIButton *)navigationSaveButton {

    UIImage *okImage = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_ok"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(.0, .0, 60, 40)];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveButton setTitle:NSLocalizedString(@"保存", nil) forState: UIControlStateNormal];
    [saveButton setImage:okImage forState:UIControlStateNormal];
    saveButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 4);
    saveButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    return saveButton;
}

- (UIButton *)navigationCloseButton {
    
    UIImage *cancelImage = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_cancel"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(.0, .0, 60, 40)];
    [cancelButton setTitle:NSLocalizedString(@"取消", nil) forState: UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton setImage:cancelImage forState:UIControlStateNormal];
    cancelButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 4);
    cancelButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    return cancelButton;
}

@end
