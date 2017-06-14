//
//  XHMenuController.m
//  XHMenuController
//
//  Created by zxh on 14-3-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//  THE SOFTWARE.
//

#import "XHMenuController.h"
#import "TDFMediator+SettingModule.h"
#define kMenuFullWidth SCREEN_WIDTH
#define kMenuDisplayedWidth SCREEN_WIDTH*2/3
#define kMenuOverlayWidth (self.view.bounds.size.width - kMenuDisplayedWidth)
#define kMenuDisplayedLeftWidth SCREEN_WIDTH*2/3
#define kMenuOverlayLeftWidth (self.view.bounds.size.width - kMenuDisplayedLeftWidth)
#define kMenuBounceOffset 10.0f
#define kMenuBounceDuration .3f
#define kMenuSlideDuration .3f
@interface XHMenuController ()
@property (nonatomic, strong)UIView *attentionView;
@end

@implementation XHMenuController

- (UIView *)attentionView
{
    if (!_attentionView) {
        _attentionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _attentionView;
}

- (UIButton *)shadowButton
{
    if (!_shadowButton) {
        _shadowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _shadowButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (id)initWithRootViewController:(UIViewController*)controller
{
    if ((self = [self init])) {
        self.rootController = controller;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setRootViewController:self.rootController];
    [self.view addSubview:self.shadowButton];
    [self.shadowButton addTarget:self action:@selector(showRootController) forControlEvents:UIControlEventTouchUpInside];
    self.shadowButton.hidden = YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (void)showShadow:(BOOL)value
{
    if (self.rootController!=nil) {
        self.rootController.view.layer.shadowOpacity = (value ? 0.8f : 0.0f);
        if (value) {
            self.rootController.view.layer.cornerRadius = 4.0f;
            self.rootController.view.layer.shadowOffset = CGSizeZero;
            self.rootController.view.layer.shadowRadius = 4.0f;
            self.rootController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
        }
    }
}

- (void)showRootController
{
    self.rootController.view.userInteractionEnabled = YES;
    _shadowButton.hidden = YES;
    CGRect frame = self.rootController.view.frame;
    frame.origin.x = 0.0f;
    
    [UIView animateWithDuration:.3 animations:^{
        self.rootController.view.frame = frame;
    } completion:^(BOOL finished) {
        if (self.leftController && self.leftController.view.superview) {
            [self.leftController.view removeFromSuperview];
        }
        if (self.rightController && self.rightController.view.superview) {
            [self.rightController.view removeFromSuperview];
        }
        showingLeftView = NO;
        showingRightView = NO;
        [self showShadow:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notification_back_navigateView" object:nil];
    }];
}

- (void)showLeftController
{
    if (self.leftController!=nil) {
        showingRightView = NO;
    }
    NSString *str =[[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLancunes"];
    if (![str isEqualToString:@"11"] && ![[Platform Instance] isChain]) { // 单店才显示引导图
        [self configAttentionView];
        [[NSUserDefaults standardUserDefaults]setObject:@"11" forKey:@"FirstLancunes"];
    }
    //[self.navigateMenu loadInfoData];
    _shadowButton.hidden = NO;
    _shadowButton.frame = CGRectMake(kMenuDisplayedWidth, 0, SCREEN_WIDTH - kMenuDisplayedWidth, SCREEN_HEIGHT);
    showingLeftView = YES;
    [self showShadow:YES];
    UIView *view = self.leftController.view;
    [self.view insertSubview:view atIndex:0];
    [self.leftController viewWillAppear:YES];
    
	CGRect frame = self.view.bounds;
    frame = self.rootController.view.frame;
    frame.origin.x = CGRectGetMaxX(view.frame) - (kMenuFullWidth - kMenuDisplayedLeftWidth);
    self.rootController.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:.15 animations:^{
        self.rootController.view.frame = frame;
    } completion:^(BOOL finished) {
      
    }];

}

- (void)showRightController
{
    if (self.leftController) {
        showingLeftView = NO;
    }
    showingRightView = YES;
    [self showShadow:YES];
    _shadowButton.hidden = NO;
    _shadowButton.frame = CGRectMake(0, 0, SCREEN_WIDTH - kMenuDisplayedWidth, SCREEN_HEIGHT);
    UIView *view = self.rightController.view;
    [self.view insertSubview:view atIndex:0];
    [self.rightController viewWillAppear:YES];
    
    CGRect frame = self.view.bounds;
    frame = self.rootController.view.frame;
    frame.origin.x = -(frame.size.width - kMenuOverlayWidth);
    self.rootController.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.rootController.view.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    UIViewController *tempRoot = self.rootController;
    self.rootController = rootViewController;
    if (self.rootController) {
        if (tempRoot) {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
        UIView *view = self.rootController.view;
        view.frame = self.view.bounds;
        [self.view addSubview:view];
    } else {
        if (tempRoot) {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
    }
}

- (void)setRightViewController:(UIViewController *)rightController
{
    self.rightController = rightController;
}

- (void)setLeftViewController:(UIViewController *)leftController
{
    self.leftController = leftController;
}

#pragma mark --第一次进入时显示
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.attentionView) {
        [self.attentionView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults]setObject:@"11" forKey:@"FirstLancun"];
    }
}

- (void)configAttentionView {
    self.attentionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.attentionView];
    UIImageView *attentionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_color_guidewelocme.png"]];
    attentionImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.attentionView addSubview:attentionImageView];
    UIControl *controll = [[UIControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, 130, 49)];
    [controll addTarget:self action:@selector(switchFunctionView) forControlEvents:UIControlEventTouchUpInside];
    [self.attentionView addSubview:controll];
    UIView *contentView = [UIView new];
    contentView.userInteractionEnabled = NO;
    [controll addSubview:contentView];
    [attentionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(controll.mas_top);
        make.left.equalTo(self.attentionView.mas_left);
        make.right.equalTo(self.attentionView.mas_right).offset(-(SCREEN_WIDTH-260));
        make.height.equalTo(@158);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@18);
        make.centerX.equalTo(controll.mas_centerX);
        make.centerY.equalTo(controll.mas_centerY);
    }];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_nav_fa.png"]];
    [contentView addSubview:imageView];
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.text = NSLocalizedString(@"功能大全", nil);
    [contentView addSubview:label];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView.mas_centerY);
        make.left.equalTo(contentView.mas_left);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView.mas_centerY);
        make.left.equalTo(imageView.mas_right).offset(4);
        make.right.equalTo(contentView.mas_right);
    }];
    
}


- (void)switchFunctionView
{
    [self.attentionView removeFromSuperview];
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_tdfFunctionViewController];
    [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:viewController animated:YES];
}

@end
