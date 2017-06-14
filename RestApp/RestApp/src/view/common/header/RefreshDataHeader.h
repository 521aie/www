//
//  RefreshDataBanner.h
//  CardApp
//
//  Created by 邵建青 on 14-2-12.
//  Copyright (c) 2014年 ZMSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshDataHeader : UIView

@property (nonatomic, retain) IBOutlet UILabel *suggestLbl;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

- (void)initView;

- (void)startAnimating;

- (void)stopAnimating;

- (void)show;

- (void)hide;

@end
