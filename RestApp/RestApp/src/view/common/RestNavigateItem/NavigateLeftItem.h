//
//  RestNavigateItem.h
//  RestApp
//
//  Created by zxh on 14-3-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestNavigateAction.h"

@interface NavigateLeftItem : UIView

@property (nonatomic, strong) IBOutlet UIImageView *img;
@property (nonatomic, strong) IBOutlet UIButton *btn;
@property (nonatomic, strong) id<RestNavigateAction> delegate;
@property (nonatomic) BOOL isRight;

+ (NavigateLeftItem *)Instance;

- (IBAction)onClick:(id)sender;

- (void)initWithDelegate:(id<RestNavigateAction>)delegate;

@end
